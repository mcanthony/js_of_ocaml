
include ../Makefile.conf
-include ../Makefile.filelist

OCAMLBUILD := ocamlbuild -use-ocamlfind -package bytes

all:
	$(OCAMLBUILD) $(OCAMLBUILD_IMPL)

clean:
	$(OCAMLBUILD) -clean
