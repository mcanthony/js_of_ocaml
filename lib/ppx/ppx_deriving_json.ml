(* Js_of_ocaml
 * http://www.ocsigen.org
 * Copyright Vasilis Papavasileiou 2015
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

let deriver = "json"

(* Copied (and adapted) this from ppx_deriving repo (commit
   e2079fa8f3460055bf990461f295c6c4b391fafc) ; we get an empty set of
   let bindings with ppx_deriving 3.0 *)
let sanitize expr = [%expr
  (let open! Ppx_deriving_runtime in [%e expr]) [@ocaml.warning "-A"]]

let var_ptuple l =
  List.map Ast_convenience.pvar l |> Ast_helper.Pat.tuple

let map_loc f {Location.txt; loc} =
  {Location.txt = f txt; loc}

let suffix_lid lid ~suffix =
  map_loc (Ppx_deriving.mangle_lid (`Suffix suffix)) lid |>
  Ast_helper.Exp.ident

let suffix_decl d ~suffix =
  Ppx_deriving.mangle_type_decl (`Suffix suffix) d |>
  Ast_convenience.evar

let rec fresh_vars ?(acc = []) n =
  if n <= 0 then
    List.rev acc
  else
    let acc = Ppx_deriving.fresh_var acc :: acc in
    fresh_vars ~acc (n - 1)

let unreachable_case () =
  Ast_helper.Exp.case [%pat? _ ] [%expr assert false]

let label_of_constructor = map_loc (fun c -> Longident.Lident c)

let wrap_write r ~pattern = [%expr fun buf [%p pattern] -> [%e r]]

let buf_expand r = [%expr fun buf -> [%e r]]

let seqlist = function
  | h :: l ->
    let f acc e = [%expr [%e acc]; [%e e]] in
    List.fold_left f h l
  | [] ->
    [%expr ()]

let check_record_fields =
  (function
    | {Parsetree.pld_mutable = Mutable} ->
      Location.raise_errorf
        "%s cannot be derived for mutable records" deriver
    | {pld_type = {ptyp_desc = Ptyp_poly _}} ->
      Location.raise_errorf
        "%s cannot be derived for polymorphic records" deriver
    | _ ->
      ()) |> List.iter

let maybe_tuple_type = function
  | [y] -> y
  | l -> Ast_helper.Typ.tuple l

let rec write_tuple_contents l ly tag ~poly =
  let e =
    let f v y =
      let arg = Ast_convenience.evar v in
      let e = write_body_of_type y ~arg ~poly in
      [%expr Buffer.add_string buf ","; [%e e]]
    in
    List.map2 f l ly |> seqlist
  and s = Ast_convenience.str ("[" ^ string_of_int tag) in [%expr
    Buffer.add_string buf [%e s];
    [%e e];
    Buffer.add_string buf "]"]

and write_body_of_tuple_type l ~arg ~poly ~tag =
  let n = List.length l in
  let vars = fresh_vars n in
  let e = write_tuple_contents vars l tag ~poly
  and p = var_ptuple vars in
  [%expr let [%p p] = [%e arg] in [%e e]]

and write_poly_case r ~arg ~poly =
  match r with
  | Parsetree.Rtag (label, _, _, l) ->
    let i = Ppx_deriving.hash_variant label
    and n = List.length l in
    let v = Ppx_deriving.fresh_var [] in
    let lhs =
      (if n = 0 then None else Some (Ast_convenience.pvar v)) |>
      Ast_helper.Pat.variant label
    and rhs =
      match l with
      | [] ->
        let e = Ast_convenience.int i in
        [%expr Deriving_Json.Json_int.write buf [%e e]]
      | _ ->
        let l = [[%type: int]; maybe_tuple_type l]
        and arg = Ast_helper.Exp.tuple Ast_convenience.[int i; evar v] in
        write_body_of_tuple_type l ~arg ~poly ~tag:0
    in
    Ast_helper.Exp.case lhs rhs
  | Rinherit ({ptyp_desc = (Ptyp_constr (lid, _) as c)} as y) ->
    Ast_helper.Exp.case (Ast_helper.Pat.type_ lid)
      (write_body_of_type y ~arg ~poly)

and write_body_of_type y ~arg ~poly =
  match y with
  | [%type: unit] ->
    [%expr Deriving_Json.Json_unit.write buf [%e arg]]
  | [%type: int] ->
    [%expr Deriving_Json.Json_int.write buf [%e arg]]
  | [%type: int32] | [%type: Int32.t] ->
    [%expr Deriving_Json.Json_int32.write buf [%e arg]]
  | [%type: int64] | [%type: Int64.t] ->
    [%expr Deriving_Json.Json_int64.write buf [%e arg]]
  | [%type: nativeint] | [%type: Nativeint.t] ->
    [%expr Deriving_Json.Json_nativeint.write buf [%e arg]]
  | [%type: float] ->
    [%expr Deriving_Json.Json_float.write buf [%e arg]]
  | [%type: bool] ->
    [%expr Deriving_Json.Json_bool.write buf [%e arg]]
  | [%type: char] ->
    [%expr Deriving_Json.Json_char.write buf [%e arg]]
  | [%type: string] ->
    [%expr Deriving_Json.Json_string.write buf [%e arg]]
  | [%type: bytes] ->
    [%expr Deriving_Json.Json_bytes.write buf [%e arg]]
  | [%type: [%t? y] list] ->
    let e = write_of_type y ~poly in
    [%expr Deriving_Json.write_list [%e e] buf [%e arg]]
  | [%type: [%t? y] ref] ->
    let e = write_of_type y ~poly in
    [%expr Deriving_Json.write_ref [%e e] buf [%e arg]]
  | [%type: [%t? y] option] ->
    let e = write_of_type y ~poly in
    [%expr Deriving_Json.write_option [%e e] buf [%e arg]]
  | [%type: [%t? y] array] ->
    let e = write_of_type y ~poly in
    [%expr Deriving_Json.write_array [%e e] buf [%e arg]]
  | { Parsetree.ptyp_desc = Ptyp_var v } when poly ->
    [%expr [%e Ast_convenience.evar ("poly_" ^ v)] buf [%e arg]]
  | { Parsetree.ptyp_desc = Ptyp_tuple l } ->
    write_body_of_tuple_type l ~arg ~poly ~tag:0
  | { Parsetree.ptyp_desc = Ptyp_variant (l, _, _); ptyp_loc = loc } ->
    List.map (write_poly_case ~arg ~poly) l @ [unreachable_case ()] |>
    Ast_helper.Exp.match_ arg
  | { Parsetree.ptyp_desc = Ptyp_constr (lid, l) } ->
    let e = suffix_lid lid ~suffix:"to_json"
    and l = List.map (write_of_type ~poly) l in
    [%expr [%e Ast_convenience.app e l] buf [%e arg]]
  | { Parsetree.ptyp_loc } ->
    Location.raise_errorf ~loc:ptyp_loc
      "%s_write cannot be derived for %s"
      deriver (Ppx_deriving.string_of_core_type y)

and write_of_type y ~poly =
  let v = "a" in
  let arg = Ast_convenience.evar v
  and pattern = Ast_convenience.pvar v in
  wrap_write (write_body_of_type y ~arg ~poly) ~pattern

and write_of_record d l =
  let pattern =
    let l =
      let f {Parsetree.pld_name} =
        label_of_constructor pld_name,
        Ast_helper.Pat.var pld_name
      in
      List.map f l
    in
    (* CHECKME: what is the closed_flag for? *)
    Ast_helper.Pat.record l Asttypes.Closed
  and e =
    let l =
      let f {Parsetree.pld_name = {txt}} = txt in
      List.map f l
    and ly =
      let f {Parsetree.pld_type} = pld_type in
      List.map f l
    in
    write_tuple_contents l ly 0 ~poly:true
  in
  wrap_write e ~pattern

let recognize_case_of_constructor i l =
  let lhs =
    match l with
    | [] -> [%pat? `Cst  [%p Ast_convenience.pint i]]
    | _  -> [%pat? `NCst [%p Ast_convenience.pint i]]
  in
  Ast_helper.Exp.case lhs [%expr true]

let recognize_body_of_poly_variant l ~loc =
  let l =
    let f = function
      | Parsetree.Rtag (label, _, _, l) ->
        let i = Ppx_deriving.hash_variant label
        and f = Ast_helper.Exp.variant label in
        recognize_case_of_constructor i l
      | Rinherit {ptyp_desc = Ptyp_constr (lid, _)} ->
        let guard = [%expr [%e suffix_lid lid ~suffix:"recognize"] x] in
        Ast_helper.Exp.case ~guard [%pat? x] [%expr true]
      | _ ->
        Location.raise_errorf ~loc
          "%s_recognize cannot be derived" deriver
    and default = Ast_helper.Exp.case [%pat? _] [%expr false] in
    List.map f l @ [default]
  in
  Ast_helper.Exp.function_ l

let tag_error_case ?(typename="") () =
  let y = Ast_convenience.str typename in
  Ast_helper.Exp.case
    [%pat? _]
    [%expr Deriving_Json_lexer.tag_error ~typename:[%e y] buf]

let maybe_tuple_type = function
  | [y] -> y
  | l -> Ast_helper.Typ.tuple l

let rec read_poly_case ?decl y = function
  | Parsetree.Rtag (label, _, _, l) ->
    let i = Ppx_deriving.hash_variant label |> Ast_convenience.pint in
    (match l with
     | [] ->
       Ast_helper.Exp.case [%pat? `Cst [%p i]]
         (Ast_helper.Exp.variant label None)
     | l ->
       Ast_helper.Exp.case [%pat? `NCst [%p i]] [%expr
         Deriving_Json_lexer.read_comma buf;
         let v = [%e read_body_of_type ?decl (maybe_tuple_type l)] in
         Deriving_Json_lexer.read_rbracket buf;
         [%e Ast_helper.Exp.variant label (Some [%expr v])]])
  | Rinherit ({ptyp_desc = Ptyp_constr (lid, l)} as y') ->
    let guard = [%expr [%e suffix_lid lid ~suffix:"recognize"] x]
    and e =
      let e = suffix_lid lid ~suffix:"of_json_with_tag"
      and l = List.map (read_of_type ?decl) l in
      [%expr ([%e Ast_convenience.app e l] buf x :> [%t y])]
    in
    Ast_helper.Exp.case ~guard [%pat? x] e

and read_of_poly_variant ?decl l y ~loc =
  List.map (read_poly_case ?decl y) l @ [tag_error_case ()] |>
  Ast_helper.Exp.function_ |>
  buf_expand

and read_tuple_contents ?decl l ~f =
  let n = List.length l in
  let lv = fresh_vars n in
  let f v y acc =
    let e = read_body_of_type ?decl y in [%expr
      Deriving_Json_lexer.read_comma buf;
      let [%p Ast_convenience.pvar v] = [%e e] in
      [%e acc]]
  and acc = List.map Ast_convenience.evar lv |> f in
  let acc = [%expr Deriving_Json_lexer.read_rbracket buf; [%e acc]] in
  List.fold_right2 f lv l acc

and read_body_of_tuple_type ?decl l = [%expr
  Deriving_Json_lexer.read_lbracket buf;
  ignore (Deriving_Json_lexer.read_tag_1 0 buf);
  [%e read_tuple_contents ?decl l ~f:Ast_helper.Exp.tuple]]

and read_of_record decl l =
  let e =
    let f =
      let f {Parsetree.pld_name} e = label_of_constructor pld_name, e in
      fun l' -> Ast_helper.Exp.record (List.map2 f l l') None
    and l =
      let f {Parsetree.pld_type} = pld_type in
      List.map f l
    in
    read_tuple_contents l ~decl ~f
  in [%expr
    Deriving_Json_lexer.read_lbracket buf;
    ignore (Deriving_Json_lexer.read_tag_2 0 254 buf);
    [%e e]] |> buf_expand

and read_body_of_type ?decl y =
  let poly = match decl with Some _ -> true | _ -> false in
  match y with
  | [%type: unit] ->
    [%expr Deriving_Json.Json_unit.read buf]
  | [%type: int] ->
    [%expr Deriving_Json.Json_int.read buf]
  | [%type: int32] | [%type: Int32.t] ->
    [%expr Deriving_Json.Json_int32.read buf]
  | [%type: int64] | [%type: Int64.t] ->
    [%expr Deriving_Json.Json_int64.read buf]
  | [%type: nativeint] | [%type: Nativeint.t] ->
    [%expr Deriving_Json.Json_nativeint.read buf]
  | [%type: float] ->
    [%expr Deriving_Json.Json_float.read buf]
  | [%type: bool] ->
    [%expr Deriving_Json.Json_bool.read buf]
  | [%type: char] ->
    [%expr Deriving_Json.Json_char.read buf]
  | [%type: string] ->
    [%expr Deriving_Json.Json_string.read buf]
  | [%type: bytes] ->
    [%expr Deriving_Json.Json_bytes.read buf]
  | [%type: [%t? y] list] ->
    [%expr Deriving_Json.read_list [%e read_of_type ?decl y] buf]
  | [%type: [%t? y] ref] ->
    [%expr Deriving_Json.read_ref [%e read_of_type ?decl y] buf]
  | [%type: [%t? y] option] ->
    [%expr Deriving_Json.read_option [%e read_of_type ?decl y] buf]
  | [%type: [%t? y] array] ->
    [%expr Deriving_Json.read_array [%e read_of_type ?decl y] buf]
  | { Parsetree.ptyp_desc = Ptyp_tuple l } ->
    read_body_of_tuple_type l ?decl
  | { Parsetree.ptyp_desc = Ptyp_variant (l, _, _); ptyp_loc = loc } ->
    let e =
      (match decl with
       | Some decl ->
         let e = suffix_decl decl ~suffix:"of_json_with_tag"
         and l =
           let {Parsetree.ptype_params = l} = decl
           and f (y, _) = read_of_type y ~decl in
           List.map f l
         in
         Ast_convenience.app e l
       | None ->
         read_of_poly_variant l y ~loc)
    and tag = [%expr Deriving_Json_lexer.read_vcase buf] in
    [%expr [%e e] buf [%e tag]]
  | { Parsetree.ptyp_desc = Ptyp_var v } when poly ->
    [%expr [%e Ast_convenience.evar ("poly_" ^ v)] buf]
  | { Parsetree.ptyp_desc = Ptyp_constr (lid, l) } ->
    let e = suffix_lid lid ~suffix:"of_json"
    and l = List.map (read_of_type ?decl) l in
    [%expr [%e Ast_convenience.app e l] buf]
  | { Parsetree.ptyp_loc } ->
    Location.raise_errorf ~loc:ptyp_loc
      "%s_read cannot be derived for %s" deriver
      (Ppx_deriving.string_of_core_type y)

and read_of_type ?decl y =
  read_body_of_type ?decl y |> buf_expand

let json_of_type ?decl y =
  let read = read_of_type ?decl y
  and write =
    let poly = match decl with Some _ -> true | _ -> false in
    write_of_type y ~poly in
  [%expr Deriving_Json.make [%e write] [%e read]]

let fun_str_wrap d e y ~f ~suffix =
  let e = Ppx_deriving.poly_fun_of_type_decl d e |> sanitize
  and v =
    Ppx_deriving.mangle_type_decl (`Suffix suffix) d |>
    Ast_convenience.pvar
  and y = Ppx_deriving.poly_arrow_of_type_decl f d y in
  Ast_helper.(Vb.mk (Pat.constraint_ v y) e)

let read_str_wrap d e =
  let f y = [%type: Deriving_Json_lexer.lexbuf -> [%t y]]
  and suffix = "of_json" in
  let y = f (Ppx_deriving.core_type_of_type_decl d)in
  fun_str_wrap d e y ~f ~suffix

let read_tag_str_wrap d e =
  let f y = [%type: Deriving_Json_lexer.lexbuf -> [%t y]]
  and suffix = "of_json_with_tag"
  and y =
    let y = Ppx_deriving.core_type_of_type_decl d in
    [%type: Deriving_Json_lexer.lexbuf ->
          [`NCst of int | `Cst of int] -> [%t y]]
  in
  fun_str_wrap d e y ~f ~suffix

let write_str_wrap d e =
  let f y = [%type: Buffer.t -> [%t y] -> unit]
  and suffix = "to_json" in
  let y =
    let y = Ppx_deriving.core_type_of_type_decl d in
    (match d with
     | {ptype_manifest =
          Some {ptyp_desc = Parsetree.Ptyp_variant (_, _, _)}} ->
       [%type: [> [%t y]]]
     | _ ->
       y) |> f
  in
  fun_str_wrap d e y ~f ~suffix

let recognize_str_wrap d e =
  let v =
    Ppx_deriving.mangle_type_decl (`Suffix "recognize") d |>
    Ast_convenience.pvar
  and y = [%type: [`NCst of int | `Cst of int] -> bool] in
  Ast_helper.(Vb.mk (Pat.constraint_ v y) e)

let json_poly_type d =
  let f y = [%type: [%t y] Deriving_Json.t] in
  let y = f (Ppx_deriving.core_type_of_type_decl d) in
  Ppx_deriving.poly_arrow_of_type_decl f d y

let json_str_wrap d e =
  let v =
    Ppx_deriving.mangle_type_decl (`Suffix "json") d |>
    Ast_convenience.pvar
  and e = Ppx_deriving.(poly_fun_of_type_decl d e)
  and y = json_poly_type d in
  Ast_helper.(Vb.mk (Pat.constraint_ v y) e)

let json_str d =
  let write =
    let f acc id =
      let poly = Ast_convenience.evar ("poly_" ^ id) in
      [%expr [%e acc] (Deriving_Json.write [%e poly])]
    and acc = suffix_decl d ~suffix:"to_json" in
    Ppx_deriving.fold_left_type_decl f acc d
  and read =
    let f acc id =
      let poly = Ast_convenience.evar ("poly_" ^ id) in
      [%expr [%e acc] (Deriving_Json.read [%e poly])]
    and acc = suffix_decl d ~suffix:"of_json" in
    Ppx_deriving.fold_left_type_decl f acc d
  in
  [%expr Deriving_Json.make [%e write] [%e read]] |>
  json_str_wrap d

let write_decl_of_type d y =
  (let e =
     let arg = Ast_convenience.evar "a" in
     write_body_of_type y ~arg ~poly:true
   in
   [%expr fun buf a -> [%e e]]) |> write_str_wrap d

let read_decl_of_type decl y =
  read_body_of_type y ~decl |> buf_expand |> read_str_wrap decl

let json_decls_of_type decl y =
  let recognize, read_tag =
    match y with
    | { Parsetree.ptyp_desc = Ptyp_variant (l, _, _);
        ptyp_loc = loc } ->
      Some (recognize_body_of_poly_variant l ~loc |>
            recognize_str_wrap decl),
      Some (read_of_poly_variant l y ~decl ~loc |>
            read_tag_str_wrap decl)
    | _ ->
      None, None
  in
  write_decl_of_type decl y,
  read_decl_of_type decl y,
  json_str decl,
  recognize, read_tag

let write_case (i, i', l) {Parsetree.pcd_name; pcd_args; pcd_loc} =
  let n = List.length pcd_args in
  let vars = fresh_vars n in
  let i, i', lhs, rhs =
    match vars with
    | [] ->
      i + 1,
      i',
      None,
      [%expr Deriving_Json.Json_int.write buf
               [%e Ast_convenience.int i]]
    | [v] ->
      i,
      i' + 1,
      Some (Ast_convenience.pvar v),
      write_tuple_contents vars pcd_args i' ~poly:true
    | _ ->
      i,
      i' + 1,
      Some (var_ptuple vars),
      write_tuple_contents vars pcd_args i' ~poly:true
  in
  i, i',
  Ast_helper.
    (Exp.case (Pat.construct (label_of_constructor pcd_name) lhs)
       rhs) :: l

let write_decl_of_variant d l =
  (let _, _, l = List.fold_left write_case (0, 0, []) l in
   Ast_helper.Exp.function_ l) |> buf_expand |>
  write_str_wrap d

let read_case ?decl (i, i', l)
    {Parsetree.pcd_name; pcd_args; pcd_loc} =
  match pcd_args with
  | [] ->
    i + 1, i',
    Ast_helper.Exp.case
      [%pat? `Cst [%p Ast_convenience.pint i]]
      (Ast_helper.Exp.construct (label_of_constructor pcd_name) None)
    :: l
  | _ ->
    i, i' + 1,
    ((let f l =
        (match l with
         | [] ->  None
         | [e] -> Some e
         | l ->   Some (Ast_helper.Exp.tuple l)) |>
        Ast_helper.Exp.construct (label_of_constructor pcd_name)
      in
      read_tuple_contents ?decl pcd_args ~f) |>
     Ast_helper.Exp.case [%pat? `NCst [%p Ast_convenience.pint i']])
    :: l

let read_decl_of_variant decl l =
  (let _, _, l = List.fold_left (read_case ~decl) (0, 0, []) l
   and e = [%expr Deriving_Json_lexer.read_case buf] in
   Ast_helper.Exp.match_ e (l @ [tag_error_case ()])) |>
  buf_expand |>
  read_str_wrap decl

let json_decls_of_variant d l =
  write_decl_of_variant d l, read_decl_of_variant d l, json_str d,
  None, None

let write_decl_of_record d l =
  write_of_record d l |> write_str_wrap d

let read_decl_of_record d l =
  read_of_record d l |> read_str_wrap d

let json_decls_of_record d l =
  check_record_fields l;
  write_decl_of_record d l, read_decl_of_record d l, json_str d,
  None, None

let json_str_of_decl ({Parsetree.ptype_loc} as d) =
  let f () =
    match d with
    | { Parsetree.ptype_manifest = Some y } ->
      json_decls_of_type d y
    | { ptype_kind = Ptype_variant l } ->
      json_decls_of_variant d l
    | { ptype_kind = Ptype_record l } ->
      json_decls_of_record d l
    | _ ->
      Location.raise_errorf "%s cannot be derived" deriver
  in
  Ast_helper.with_default_loc ptype_loc f

let register_for_expr s f =
  let core_type ({Parsetree.ptyp_loc} as y) =
    let f () = f y |> sanitize in
    Ast_helper.with_default_loc ptyp_loc f
  in
  Ppx_deriving.(create s ~core_type () |> register)

let _ =
  register_for_expr "of_json" (fun y ->
    [%expr
      fun s ->
        [%e read_of_type y]
          (Deriving_Json_lexer.init_lexer (Lexing.from_string s))])

let _ =
  register_for_expr "to_json" (fun y ->
    [%expr
      fun x ->
        let buf = Buffer.create 50 in
        [%e write_of_type y ~poly:false] buf x;
        Buffer.contents buf])

let _ =
  let core_type y = json_of_type y |> sanitize
  and type_decl_str ~options ~path l =
    let lw, lr, lj, lp, lrv =
      let f d (lw, lr, lj, lp, lrv) =
        let w, r, j, p, rv = json_str_of_decl d in
        w :: lw, r :: lr, j :: lj,
        (match p with Some p -> p :: lp | None -> lp),
        (match rv with Some rv -> rv :: lrv | None -> lrv)
      and acc = [], [], [], [], [] in
      List.fold_right f l acc
    and f = Ast_helper.Str.value Asttypes.Recursive
    and f' = Ast_helper.Str.value Asttypes.Nonrecursive in
    let l = [f (lrv @ lr); f lw; f' lj] in
    match lp with [] -> l | _ -> f lp :: l
  in
  Ppx_deriving.(create "json" ~core_type ~type_decl_str () |> register)
