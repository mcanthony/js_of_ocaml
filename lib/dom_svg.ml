
open Js



let xmlns = "http://www.w3.org/2000/svg"

(* module svg { *)

(* exception SVGException { *)
(*   unsigned short code; *)
(* }; *)

type svg_error =
  | SVG_WRONG_TYPE_ERR
  | SVG_INVALID_VALUE_ERR
  | SVG_MATRIX_NOT_INVERTABLE



type lengthUnitType =
  | SVG_LENGTHTYPE_UNKNOWN
  | SVG_LENGTHTYPE_NUMBER
  | SVG_LENGTHTYPE_PERCENTAGE
  | SVG_LENGTHTYPE_EMS
  | SVG_LENGTHTYPE_EXS
  | SVG_LENGTHTYPE_PX
  | SVG_LENGTHTYPE_CM
  | SVG_LENGTHTYPE_MM
  | SVG_LENGTHTYPE_IN
  | SVG_LENGTHTYPE_PT
  | SVG_LENGTHTYPE_PC

(*   // Angle Unit Types *)
type angleUnitType =
  | SVG_ANGLETYPE_UNKNOWN
  | SVG_ANGLETYPE_UNSPECIFIED
  | SVG_ANGLETYPE_DEG
  | SVG_ANGLETYPE_RAD
  | SVG_ANGLETYPE_GRAD

(*   // Color Types *)
type colorType =
  | SVG_COLORTYPE_UNKNOWN
  | SVG_COLORTYPE_RGBCOLOR
  | SVG_COLORTYPE_RGBCOLOR_ICCCOLOR
  | SVG_COLORTYPE_CURRENTCOLOR

(* interface SVGUnitTypes { *)
type unitType =
  | SVG_UNIT_TYPE_UNKNOWN
  | SVG_UNIT_TYPE_USERSPACEONUSE
  | SVG_UNIT_TYPE_OBJECTBOUNDINGBOX

class type ['a] svgAnimated = object
  method baseVal : 'a prop
  method animVal : 'a prop
end


(* interface SVGElement : Element { *)
class type element = object
  inherit Dom.element
  method id : js_string t prop
  method xmlbase : js_string t prop
  method ownerSVGElement : svgElement t readonly_prop
  method viewportElement : element t readonly_prop
end

(* interface SVGAnimatedBoolean { *)
(* interface SVGAnimatedString { *)

and svgAnimatedString = [js_string t] svgAnimated
and svgAnimatedBool = [bool t] svgAnimated
(* interface SVGStringList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   DOMString initialize(in DOMString newItem) raises(DOMException); *)
(*   DOMString getItem(in unsigned long index) raises(DOMException); *)
(*   DOMString insertItemBefore(in DOMString newItem, in unsigned long index) raises(DOMException); *)
(*   DOMString replaceItem(in DOMString newItem, in unsigned long index) raises(DOMException); *)
(*   DOMString removeItem(in unsigned long index) raises(DOMException); *)
(*   DOMString appendItem(in DOMString newItem) raises(DOMException); *)
(* }; *)

(* interface SVGAnimatedEnumeration { *)
(*            attribute unsigned short baseVal setraises(DOMException); *)
(*   readonly attribute unsigned short animVal; *)
(* }; *)

(* interface SVGAnimatedInteger { *)
(*            attribute long baseVal setraises(DOMException); *)
(*   readonly attribute long animVal; *)
(* }; *)

(* interface SVGNumber { *)
(*   attribute float value setraises(DOMException); *)
(* }; *)

(* interface SVGAnimatedNumber { *)
(*            attribute float baseVal setraises(DOMException); *)
(*   readonly attribute float animVal; *)
(* }; *)

(* interface SVGNumberList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   SVGNumber initialize(in SVGNumber newItem) raises(DOMException); *)
(*   SVGNumber getItem(in unsigned long index) raises(DOMException); *)
(*   SVGNumber insertItemBefore(in SVGNumber newItem, in unsigned long index) raises(DOMException); *)
(*   SVGNumber replaceItem(in SVGNumber newItem, in unsigned long index) raises(DOMException); *)
(*   SVGNumber removeItem(in unsigned long index) raises(DOMException); *)
(*   SVGNumber appendItem(in SVGNumber newItem) raises(DOMException); *)
(* }; *)

(* interface SVGAnimatedNumberList { *)
(*   readonly attribute SVGNumberList baseVal; *)
(*   readonly attribute SVGNumberList animVal; *)
(* }; *)

(* interface SVGLength { *)
and svgLength = object
  method unitType : lengthUnitType readonly_prop
  method value : float prop
  method valueInSpecifiedUnits : float prop
  method valueAsString : js_string t prop
  method newValueSpecifiedUnits : lengthUnitType -> float -> unit meth
  method convertToSpecifiedUnits : lengthUnitType -> unit meth
end
(* interface SVGAnimatedLength { *)
and animatedLength = object
  inherit [svgLength] svgAnimated
end

(* interface SVGLengthList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   SVGLength initialize(in SVGLength newItem) raises(DOMException); *)
(*   SVGLength getItem(in unsigned long index) raises(DOMException); *)
(*   SVGLength insertItemBefore(in SVGLength newItem, in unsigned long index) raises(DOMException); *)
(*   SVGLength replaceItem(in SVGLength newItem, in unsigned long index) raises(DOMException); *)
(*   SVGLength removeItem(in unsigned long index) raises(DOMException); *)
(*   SVGLength appendItem(in SVGLength newItem) raises(DOMException); *)
(* }; *)

(* interface SVGAnimatedLengthList { *)
(*   readonly attribute SVGLengthList baseVal; *)
(*   readonly attribute SVGLengthList animVal; *)
(* }; *)

(* interface SVGAngle { *)
and angle = object
  method unitType : angleUnitType readonly_prop
  method value : float prop
  method valueInSpecifiedUnits : float prop
  method valueAsString : js_string t prop
  method newValueSpecifiedUnits : angleUnitType -> float -> unit meth
  method convertToSpecifiedUnits : angleUnitType -> unit meth
end

(* interface SVGAnimatedAngle { *)
(*   readonly attribute SVGAngle baseVal; *)
(*   readonly attribute SVGAngle animVal; *)
(* }; *)

(* interface SVGColor : CSSValue { *)
and color = object
  method colorType : colorType readonly_prop
(*   readonly attribute RGBColor rgbColor; *)
(*   readonly attribute SVGICCColor iccColor; *)

(*   void setRGBColor(in DOMString rgbColor) raises(SVGException); *)
(*   void setRGBColorICCColor(in DOMString rgbColor, in DOMString iccColor) raises(SVGException); *)
(*   void setColor(in unsigned short colorType, in DOMString rgbColor, in DOMString iccColor) raises(SVGException); *)
  (* }; *)
end

(* interface SVGICCColor { *)
(*            attribute DOMString colorProfile setraises(DOMException); *)
(*   readonly attribute SVGNumberList colors; *)
(* }; *)

(* interface SVGRect { *)
and rect = object
  method x : float prop
  method y : float prop
  method width : float prop
  method height : float prop
end

(* interface SVGAnimatedRect { *)
(*   readonly attribute SVGRect baseVal; *)
(*   readonly attribute SVGRect animVal; *)
(* }; *)

(* interface SVGStylable { *)
and stylable = object
  method className : svgAnimatedString readonly_prop
  method style : Dom_html.cssStyleDeclaration t readonly_prop
  (*   CSSValue getPresentationAttribute(in DOMString name); *)
end

(* interface SVGLocatable { *)

(*   readonly attribute SVGElement nearestViewportElement; *)
(*   readonly attribute SVGElement farthestViewportElement; *)

(*   SVGRect getBBox(); *)
(*   SVGMatrix getCTM(); *)
(*   SVGMatrix getScreenCTM(); *)
(*   SVGMatrix getTransformToElement(in SVGElement element) raises(SVGException); *)
(* }; *)

(* interface SVGTransformable : SVGLocatable { *)
(*   readonly attribute SVGAnimatedTransformList transform; *)
(* }; *)

(* interface SVGTests { *)

(*   readonly attribute SVGStringList requiredFeatures; *)
(*   readonly attribute SVGStringList requiredExtensions; *)
(*   readonly attribute SVGStringList systemLanguage; *)

(*   boolean hasExtension(in DOMString extension); *)
(* }; *)

(* interface SVGLangSpace { *)
and langSpace = object
  method xmllang : js_string t prop
  method xmlspace : js_string t prop
end

(* interface SVGExternalResourcesRequired { *)
(*   readonly attribute SVGAnimatedBoolean externalResourcesRequired; *)
(* }; *)

(* interface SVGFitToViewBox { *)
(*   readonly attribute SVGAnimatedRect viewBox; *)
(*   readonly attribute SVGAnimatedPreserveAspectRatio preserveAspectRatio; *)
(* }; *)

(* interface SVGZoomAndPan { *)

(*   // Zoom and Pan Types *)
(*   const unsigned short SVG_ZOOMANDPAN_UNKNOWN = 0; *)
(*   const unsigned short SVG_ZOOMANDPAN_DISABLE = 1; *)
(*   const unsigned short SVG_ZOOMANDPAN_MAGNIFY = 2; *)

(*   attribute unsigned short zoomAndPan setraises(DOMException); *)
(* }; *)

(* interface SVGViewSpec : SVGZoomAndPan, *)
(*                         SVGFitToViewBox { *)
(*   readonly attribute SVGTransformList transform; *)
(*   readonly attribute SVGElement viewTarget; *)
(*   readonly attribute DOMString viewBoxString; *)
(*   readonly attribute DOMString preserveAspectRatioString; *)
(*   readonly attribute DOMString transformString; *)
(*   readonly attribute DOMString viewTargetString; *)
(* }; *)

(* interface SVGURIReference { *)
(*   readonly attribute SVGAnimatedString href; *)
(* }; *)

(* interface SVGCSSRule : CSSRule { *)
(*   const unsigned short COLOR_PROFILE_RULE = 7; *)
(* }; *)

(* interface SVGRenderingIntent { *)
(*   // Rendering Intent Types *)
(*   const unsigned short RENDERING_INTENT_UNKNOWN = 0; *)
(*   const unsigned short RENDERING_INTENT_AUTO = 1; *)
(*   const unsigned short RENDERING_INTENT_PERCEPTUAL = 2; *)
(*   const unsigned short RENDERING_INTENT_RELATIVE_COLORIMETRIC = 3; *)
(*   const unsigned short RENDERING_INTENT_SATURATION = 4; *)
(*   const unsigned short RENDERING_INTENT_ABSOLUTE_COLORIMETRIC = 5; *)
(* }; *)

(* interface SVGDocument : Document, *)
(*                         DocumentEvent { *)
and document = object
  inherit [element] Dom.document

  method title : js_string t prop
  method referrer : js_string t readonly_prop
  method domain : js_string t prop
  method _URL : js_string t readonly_prop
  method rootElement : svgElement  t readonly_prop
end

(* interface SVGSVGElement : SVGElement, *)
(*                           SVGTests, *)
(*                           SVGLangSpace, *)
(*                           SVGExternalResourcesRequired, *)
(*                           SVGStylable, *)
(*                           SVGLocatable, *)
(*                           SVGFitToViewBox, *)
(*                           SVGZoomAndPan, *)
(*                           DocumentEvent, *)
(*                           ViewCSS, *)
(*                           DocumentCSS { *)
and svgElement = object
  inherit element
  inherit langSpace
  method x : animatedLength t readonly_prop
  method y : animatedLength t readonly_prop
  method width : animatedLength t readonly_prop
  method height : animatedLength t readonly_prop

  method contentScriptType : js_string t prop
  method contentStyleType : js_string t prop
  method viewport : rect t readonly_prop
  method pixelUnitToMillimeterX : float readonly_prop
  method pixelUnitToMillimeterY : float readonly_prop
  method screenPixelUnitToMillimeterX : float readonly_prop
  method screenPixelUnitToMillimeterY : float readonly_prop
end
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*            attribute DOMString contentScriptType setraises(DOMException); *)
(*            attribute DOMString contentStyleType setraises(DOMException); *)
(*   readonly attribute SVGRect viewport; *)
(*   readonly attribute float pixelUnitToMillimeterX; *)
(*   readonly attribute float pixelUnitToMillimeterY; *)
(*   readonly attribute float screenPixelToMillimeterX; *)
(*   readonly attribute float screenPixelToMillimeterY; *)
(*   readonly attribute boolean useCurrentView; *)
(*   readonly attribute SVGViewSpec currentView; *)
(*            attribute float currentScale; *)
(*   readonly attribute SVGPoint currentTranslate; *)

(*   unsigned long suspendRedraw(in unsigned long maxWaitMilliseconds); *)
(*   void unsuspendRedraw(in unsigned long suspendHandleID); *)
(*   void unsuspendRedrawAll(); *)
(*   void forceRedraw(); *)
(*   void pauseAnimations(); *)
(*   void unpauseAnimations(); *)
(*   boolean animationsPaused(); *)
(*   float getCurrentTime(); *)
(*   void setCurrentTime(in float seconds); *)
(*   NodeList getIntersectionList(in SVGRect rect, in SVGElement referenceElement); *)
(*   NodeList getEnclosureList(in SVGRect rect, in SVGElement referenceElement); *)
(*   boolean checkIntersection(in SVGElement element, in SVGRect rect); *)
(*   boolean checkEnclosure(in SVGElement element, in SVGRect rect); *)
(*   void deselectAll(); *)
(*   SVGNumber createSVGNumber(); *)
(*   SVGLength createSVGLength(); *)
(*   SVGAngle createSVGAngle(); *)
(*   SVGPoint createSVGPoint(); *)
(*   SVGMatrix createSVGMatrix(); *)
(*   SVGRect createSVGRect(); *)
(*   SVGTransform createSVGTransform(); *)
(*   SVGTransform createSVGTransformFromMatrix(in SVGMatrix matrix); *)
(*   Element getElementById(in DOMString elementId); *)
(* }; *)

(* interface SVGGElement : SVGElement, *)
(*                         SVGTests, *)
(*                         SVGLangSpace, *)
(*                         SVGExternalResourcesRequired, *)
(*                         SVGStylable, *)
(*                         SVGTransformable { *)
and gElement = object
  inherit element
  inherit stylable
end

(* interface SVGDefsElement : SVGElement, *)
(*                            SVGTests, *)
(*                            SVGLangSpace, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable, *)
(*                            SVGTransformable { *)
(* }; *)

(* interface SVGDescElement : SVGElement, *)
(*                            SVGLangSpace, *)
(*                            SVGStylable { *)
(* }; *)

(* interface SVGTitleElement : SVGElement, *)
and titleElement = object
  inherit element
  inherit langSpace
  inherit stylable
end

(* interface SVGSymbolElement : SVGElement, *)
and symbolElement = object
  inherit element
  inherit langSpace
  inherit stylable
end

(*                              SVGLangSpace, *)
(*                              SVGExternalResourcesRequired, *)
(*                              SVGStylable, *)
(*                              SVGFitToViewBox { *)
(* }; *)

(* interface SVGUseElement : SVGElement, *)
(*                           SVGURIReference, *)
(*                           SVGTests, *)
(*                           SVGLangSpace, *)
(*                           SVGExternalResourcesRequired, *)
(*                           SVGStylable, *)
(*                           SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*   readonly attribute SVGElementInstance instanceRoot; *)
(*   readonly attribute SVGElementInstance animatedInstanceRoot; *)
(* }; *)

(* interface SVGElementInstance : EventTarget { *)
(*   readonly attribute SVGElement correspondingElement; *)
(*   readonly attribute SVGUseElement correspondingUseElement; *)
(*   readonly attribute SVGElementInstance parentNode; *)
(*   readonly attribute SVGElementInstanceList childNodes; *)
(*   readonly attribute SVGElementInstance firstChild; *)
(*   readonly attribute SVGElementInstance lastChild; *)
(*   readonly attribute SVGElementInstance previousSibling; *)
(*   readonly attribute SVGElementInstance nextSibling; *)
(* }; *)

(* interface SVGElementInstanceList { *)

(*   readonly attribute unsigned long length; *)

(*   SVGElementInstance item(in unsigned long index); *)
(* }; *)

(* interface SVGImageElement : SVGElement, *)
(*                             SVGURIReference, *)
(*                             SVGTests, *)
(*                             SVGLangSpace, *)
(*                             SVGExternalResourcesRequired, *)
(*                             SVGStylable, *)
(*                             SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*   readonly attribute SVGAnimatedPreserveAspectRatio preserveAspectRatio; *)
(* }; *)

(* interface SVGSwitchElement : SVGElement, *)
(*                              SVGTests, *)
(*                              SVGLangSpace, *)
(*                              SVGExternalResourcesRequired, *)
(*                              SVGStylable, *)
(*                              SVGTransformable { *)
(* }; *)

(* interface GetSVGDocument { *)
(*   SVGDocument getSVGDocument(); *)
(* }; *)

(* interface SVGStyleElement : SVGElement, *)
(*                             SVGLangSpace { *)
(*   attribute DOMString type setraises(DOMException); *)
(*   attribute DOMString media setraises(DOMException); *)
(*   attribute DOMString title setraises(DOMException); *)
(* }; *)

(* interface SVGPoint { *)

(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)

(*   SVGPoint matrixTransform(in SVGMatrix matrix); *)
(* }; *)

(* interface SVGPointList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   SVGPoint initialize(in SVGPoint newItem) raises(DOMException); *)
(*   SVGPoint getItem(in unsigned long index) raises(DOMException); *)
(*   SVGPoint insertItemBefore(in SVGPoint newItem, in unsigned long index) raises(DOMException); *)
(*   SVGPoint replaceItem(in SVGPoint newItem, in unsigned long index) raises(DOMException); *)
(*   SVGPoint removeItem(in unsigned long index) raises(DOMException); *)
(*   SVGPoint appendItem(in SVGPoint newItem) raises(DOMException); *)
(* }; *)

(* interface SVGMatrix { *)

(*   attribute float a setraises(DOMException); *)
(*   attribute float b setraises(DOMException); *)
(*   attribute float c setraises(DOMException); *)
(*   attribute float d setraises(DOMException); *)
(*   attribute float e setraises(DOMException); *)
(*   attribute float f setraises(DOMException); *)

(*   SVGMatrix multiply(in SVGMatrix secondMatrix); *)
(*   SVGMatrix inverse() raises(SVGException); *)
(*   SVGMatrix translate(in float x, in float y); *)
(*   SVGMatrix scale(in float scaleFactor); *)
(*   SVGMatrix scaleNonUniform(in float scaleFactorX, in float scaleFactorY); *)
(*   SVGMatrix rotate(in float angle); *)
(*   SVGMatrix rotateFromVector(in float x, in float y) raises(SVGException); *)
(*   SVGMatrix flipX(); *)
(*   SVGMatrix flipY(); *)
(*   SVGMatrix skewX(in float angle); *)
(*   SVGMatrix skewY(in float angle); *)
(* }; *)

(* interface SVGTransform { *)

(*   // Transform Types *)
(*   const unsigned short SVG_TRANSFORM_UNKNOWN = 0; *)
(*   const unsigned short SVG_TRANSFORM_MATRIX = 1; *)
(*   const unsigned short SVG_TRANSFORM_TRANSLATE = 2; *)
(*   const unsigned short SVG_TRANSFORM_SCALE = 3; *)
(*   const unsigned short SVG_TRANSFORM_ROTATE = 4; *)
(*   const unsigned short SVG_TRANSFORM_SKEWX = 5; *)
(*   const unsigned short SVG_TRANSFORM_SKEWY = 6; *)

(*   readonly attribute unsigned short type; *)
(*   readonly attribute SVGMatrix matrix; *)
(*   readonly attribute float angle; *)

(*   void setMatrix(in SVGMatrix matrix) raises(DOMException); *)
(*   void setTranslate(in float tx, in float ty) raises(DOMException); *)
(*   void setScale(in float sx, in float sy) raises(DOMException); *)
(*   void setRotate(in float angle, in float cx, in float cy) raises(DOMException); *)
(*   void setSkewX(in float angle) raises(DOMException); *)
(*   void setSkewY(in float angle) raises(DOMException); *)
(* }; *)

(* interface SVGTransformList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   SVGTransform initialize(in SVGTransform newItem) raises(DOMException); *)
(*   SVGTransform getItem(in unsigned long index) raises(DOMException); *)
(*   SVGTransform insertItemBefore(in SVGTransform newItem, in unsigned long index) raises(DOMException); *)
(*   SVGTransform replaceItem(in SVGTransform newItem, in unsigned long index) raises(DOMException); *)
(*   SVGTransform removeItem(in unsigned long index) raises(DOMException); *)
(*   SVGTransform appendItem(in SVGTransform newItem) raises(DOMException); *)
(*   SVGTransform createSVGTransformFromMatrix(in SVGMatrix matrix); *)
(*   SVGTransform consolidate() raises(DOMException); *)
(* }; *)

(* interface SVGAnimatedTransformList { *)
(*   readonly attribute SVGTransformList baseVal; *)
(*   readonly attribute SVGTransformList animVal; *)
(* }; *)

(* interface SVGPreserveAspectRatio { *)

(*   // Alignment Types *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_UNKNOWN = 0; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_NONE = 1; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMINYMIN = 2; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMIDYMIN = 3; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMAXYMIN = 4; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMINYMID = 5; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMIDYMID = 6; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMAXYMID = 7; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMINYMAX = 8; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMIDYMAX = 9; *)
(*   const unsigned short SVG_PRESERVEASPECTRATIO_XMAXYMAX = 10; *)

(*   // Meet-or-slice Types *)
(*   const unsigned short SVG_MEETORSLICE_UNKNOWN = 0; *)
(*   const unsigned short SVG_MEETORSLICE_MEET = 1; *)
(*   const unsigned short SVG_MEETORSLICE_SLICE = 2; *)

(*   attribute unsigned short align setraises(DOMException); *)
(*   attribute unsigned short meetOrSlice setraises(DOMException); *)
(* }; *)

(* interface SVGAnimatedPreserveAspectRatio { *)
(*   readonly attribute SVGPreserveAspectRatio baseVal; *)
(*   readonly attribute SVGPreserveAspectRatio animVal; *)
(* }; *)

(* interface SVGPathSeg { *)

(*   // Path Segment Types *)
(*   const unsigned short PATHSEG_UNKNOWN = 0; *)
(*   const unsigned short PATHSEG_CLOSEPATH = 1; *)
(*   const unsigned short PATHSEG_MOVETO_ABS = 2; *)
(*   const unsigned short PATHSEG_MOVETO_REL = 3; *)
(*   const unsigned short PATHSEG_LINETO_ABS = 4; *)
(*   const unsigned short PATHSEG_LINETO_REL = 5; *)
(*   const unsigned short PATHSEG_CURVETO_CUBIC_ABS = 6; *)
(*   const unsigned short PATHSEG_CURVETO_CUBIC_REL = 7; *)
(*   const unsigned short PATHSEG_CURVETO_QUADRATIC_ABS = 8; *)
(*   const unsigned short PATHSEG_CURVETO_QUADRATIC_REL = 9; *)
(*   const unsigned short PATHSEG_ARC_ABS = 10; *)
(*   const unsigned short PATHSEG_ARC_REL = 11; *)
(*   const unsigned short PATHSEG_LINETO_HORIZONTAL_ABS = 12; *)
(*   const unsigned short PATHSEG_LINETO_HORIZONTAL_REL = 13; *)
(*   const unsigned short PATHSEG_LINETO_VERTICAL_ABS = 14; *)
(*   const unsigned short PATHSEG_LINETO_VERTICAL_REL = 15; *)
(*   const unsigned short PATHSEG_CURVETO_CUBIC_SMOOTH_ABS = 16; *)
(*   const unsigned short PATHSEG_CURVETO_CUBIC_SMOOTH_REL = 17; *)
(*   const unsigned short PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS = 18; *)
(*   const unsigned short PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL = 19; *)

(*   readonly attribute unsigned short pathSegType; *)
(*   readonly attribute DOMString pathSegTypeAsLetter; *)
(* }; *)

(* interface SVGPathSegClosePath : SVGPathSeg { *)
(* }; *)

(* interface SVGPathSegMovetoAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegMovetoRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoCubicAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x1 setraises(DOMException); *)
(*   attribute float y1 setraises(DOMException); *)
(*   attribute float x2 setraises(DOMException); *)
(*   attribute float y2 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoCubicRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x1 setraises(DOMException); *)
(*   attribute float y1 setraises(DOMException); *)
(*   attribute float x2 setraises(DOMException); *)
(*   attribute float y2 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoQuadraticAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x1 setraises(DOMException); *)
(*   attribute float y1 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoQuadraticRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x1 setraises(DOMException); *)
(*   attribute float y1 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegArcAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float r1 setraises(DOMException); *)
(*   attribute float r2 setraises(DOMException); *)
(*   attribute float angle setraises(DOMException); *)
(*   attribute boolean largeArcFlag setraises(DOMException); *)
(*   attribute boolean sweepFlag setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegArcRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float r1 setraises(DOMException); *)
(*   attribute float r2 setraises(DOMException); *)
(*   attribute float angle setraises(DOMException); *)
(*   attribute boolean largeArcFlag setraises(DOMException); *)
(*   attribute boolean sweepFlag setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoHorizontalAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoHorizontalRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoVerticalAbs : SVGPathSeg { *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegLinetoVerticalRel : SVGPathSeg { *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoCubicSmoothAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x2 setraises(DOMException); *)
(*   attribute float y2 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoCubicSmoothRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float x2 setraises(DOMException); *)
(*   attribute float y2 setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoQuadraticSmoothAbs : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegCurvetoQuadraticSmoothRel : SVGPathSeg { *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(* }; *)

(* interface SVGPathSegList { *)

(*   readonly attribute unsigned long numberOfItems; *)

(*   void clear() raises(DOMException); *)
(*   SVGPathSeg initialize(in SVGPathSeg newItem) raises(DOMException); *)
(*   SVGPathSeg getItem(in unsigned long index) raises(DOMException); *)
(*   SVGPathSeg insertItemBefore(in SVGPathSeg newItem, in unsigned long index) raises(DOMException); *)
(*   SVGPathSeg replaceItem(in SVGPathSeg newItem, in unsigned long index) raises(DOMException); *)
(*   SVGPathSeg removeItem(in unsigned long index) raises(DOMException); *)
(*   SVGPathSeg appendItem(in SVGPathSeg newItem) raises(DOMException); *)
(* }; *)

(* interface SVGAnimatedPathData { *)
(*   readonly attribute SVGPathSegList pathSegList; *)
(*   readonly attribute SVGPathSegList normalizedPathSegList; *)
(*   readonly attribute SVGPathSegList animatedPathSegList; *)
(*   readonly attribute SVGPathSegList animatedNormalizedPathSegList; *)
(* }; *)

(* interface SVGPathElement : SVGElement, *)
(*                            SVGTests, *)
(*                            SVGLangSpace, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable, *)
(*                            SVGTransformable, *)
(*                            SVGAnimatedPathData { *)

(*   readonly attribute SVGAnimatedNumber pathLength; *)

(*   float getTotalLength(); *)
(*   SVGPoint getPointAtLength(in float distance); *)
(*   unsigned long getPathSegAtLength(in float distance); *)
(*   SVGPathSegClosePath createSVGPathSegClosePath(); *)
(*   SVGPathSegMovetoAbs createSVGPathSegMovetoAbs(in float x, in float y); *)
(*   SVGPathSegMovetoRel createSVGPathSegMovetoRel(in float x, in float y); *)
(*   SVGPathSegLinetoAbs createSVGPathSegLinetoAbs(in float x, in float y); *)
(*   SVGPathSegLinetoRel createSVGPathSegLinetoRel(in float x, in float y); *)
(*   SVGPathSegCurvetoCubicAbs createSVGPathSegCurvetoCubicAbs(in float x, in float y, in float x1, in float y1, in float x2, in float y2); *)
(*   SVGPathSegCurvetoCubicRel createSVGPathSegCurvetoCubicRel(in float x, in float y, in float x1, in float y1, in float x2, in float y2); *)
(*   SVGPathSegCurvetoQuadraticAbs createSVGPathSegCurvetoQuadraticAbs(in float x, in float y, in float x1, in float y1); *)
(*   SVGPathSegCurvetoQuadraticRel createSVGPathSegCurvetoQuadraticRel(in float x, in float y, in float x1, in float y1); *)
(*   SVGPathSegArcAbs createSVGPathSegArcAbs(in float x, in float y, in float r1, in float r2, in float angle, in boolean largeArcFlag, in boolean sweepFlag); *)
(*   SVGPathSegArcRel createSVGPathSegArcRel(in float x, in float y, in float r1, in float r2, in float angle, in boolean largeArcFlag, in boolean sweepFlag); *)
(*   SVGPathSegLinetoHorizontalAbs createSVGPathSegLinetoHorizontalAbs(in float x); *)
(*   SVGPathSegLinetoHorizontalRel createSVGPathSegLinetoHorizontalRel(in float x); *)
(*   SVGPathSegLinetoVerticalAbs createSVGPathSegLinetoVerticalAbs(in float y); *)
(*   SVGPathSegLinetoVerticalRel createSVGPathSegLinetoVerticalRel(in float y); *)
(*   SVGPathSegCurvetoCubicSmoothAbs createSVGPathSegCurvetoCubicSmoothAbs(in float x, in float y, in float x2, in float y2); *)
(*   SVGPathSegCurvetoCubicSmoothRel createSVGPathSegCurvetoCubicSmoothRel(in float x, in float y, in float x2, in float y2); *)
(*   SVGPathSegCurvetoQuadraticSmoothAbs createSVGPathSegCurvetoQuadraticSmoothAbs(in float x, in float y); *)
(*   SVGPathSegCurvetoQuadraticSmoothRel createSVGPathSegCurvetoQuadraticSmoothRel(in float x, in float y); *)
(* }; *)

(* interface SVGRectElement : SVGElement, *)
(*                            SVGTests, *)
(*                            SVGLangSpace, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable, *)
(*                            SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*   readonly attribute SVGAnimatedLength rx; *)
(*   readonly attribute SVGAnimatedLength ry; *)
(* }; *)

(* interface SVGCircleElement : SVGElement, *)
(*                              SVGTests, *)
(*                              SVGLangSpace, *)
(*                              SVGExternalResourcesRequired, *)
(*                              SVGStylable, *)
(*                              SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength cx; *)
(*   readonly attribute SVGAnimatedLength cy; *)
(*   readonly attribute SVGAnimatedLength r; *)
(* }; *)

(* interface SVGEllipseElement : SVGElement, *)
(*                               SVGTests, *)
(*                               SVGLangSpace, *)
(*                               SVGExternalResourcesRequired, *)
(*                               SVGStylable, *)
(*                               SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength cx; *)
(*   readonly attribute SVGAnimatedLength cy; *)
(*   readonly attribute SVGAnimatedLength rx; *)
(*   readonly attribute SVGAnimatedLength ry; *)
(* }; *)

(* interface SVGLineElement : SVGElement, *)
(*                            SVGTests, *)
(*                            SVGLangSpace, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable, *)
(*                            SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength x1; *)
(*   readonly attribute SVGAnimatedLength y1; *)
(*   readonly attribute SVGAnimatedLength x2; *)
(*   readonly attribute SVGAnimatedLength y2; *)
(* }; *)

(* interface SVGAnimatedPoints { *)
(*   readonly attribute SVGPointList points; *)
(*   readonly attribute SVGPointList animatedPoints; *)
(* }; *)

(* interface SVGPolylineElement : SVGElement, *)
(*                                SVGTests, *)
(*                                SVGLangSpace, *)
(*                                SVGExternalResourcesRequired, *)
(*                                SVGStylable, *)
(*                                SVGTransformable, *)
(*                                SVGAnimatedPoints { *)
(* }; *)

(* interface SVGPolygonElement : SVGElement, *)
(*                               SVGTests, *)
(*                               SVGLangSpace, *)
(*                               SVGExternalResourcesRequired, *)
(*                               SVGStylable, *)
(*                               SVGTransformable, *)
(*                               SVGAnimatedPoints { *)
(* }; *)

(* interface SVGTextContentElement : SVGElement, *)
(*                                   SVGTests, *)
(*                                   SVGLangSpace, *)
(*                                   SVGExternalResourcesRequired, *)
(*                                   SVGStylable { *)

(*   // lengthAdjust Types *)
(*   const unsigned short LENGTHADJUST_UNKNOWN = 0; *)
(*   const unsigned short LENGTHADJUST_SPACING = 1; *)
(*   const unsigned short LENGTHADJUST_SPACINGANDGLYPHS = 2; *)

(*   readonly attribute SVGAnimatedLength textLength; *)
(*   readonly attribute SVGAnimatedEnumeration lengthAdjust; *)

(*   long getNumberOfChars(); *)
(*   float getComputedTextLength(); *)
(*   float getSubStringLength(in unsigned long charnum, in unsigned long nchars) raises(DOMException); *)
(*   SVGPoint getStartPositionOfChar(in unsigned long charnum) raises(DOMException); *)
(*   SVGPoint getEndPositionOfChar(in unsigned long charnum) raises(DOMException); *)
(*   SVGRect getExtentOfChar(in unsigned long charnum) raises(DOMException); *)
(*   float getRotationOfChar(in unsigned long charnum) raises(DOMException); *)
(*   long getCharNumAtPosition(in SVGPoint point); *)
(*   void selectSubString(in unsigned long charnum, in unsigned long nchars) raises(DOMException); *)
(* }; *)

(* interface SVGTextPositioningElement : SVGTextContentElement { *)
(*   readonly attribute SVGAnimatedLengthList x; *)
(*   readonly attribute SVGAnimatedLengthList y; *)
(*   readonly attribute SVGAnimatedLengthList dx; *)
(*   readonly attribute SVGAnimatedLengthList dy; *)
(*   readonly attribute SVGAnimatedNumberList rotate; *)
(* }; *)

(* interface SVGTextElement : SVGTextPositioningElement, *)
(*                            SVGTransformable { *)
(* }; *)

(* interface SVGTSpanElement : SVGTextPositioningElement { *)
(* }; *)

(* interface SVGTRefElement : SVGTextPositioningElement, *)
(*                            SVGURIReference { *)
(* }; *)

(* interface SVGTextPathElement : SVGTextContentElement, *)
(*                                SVGURIReference { *)

(*   // textPath Method Types *)
(*   const unsigned short TEXTPATH_METHODTYPE_UNKNOWN = 0; *)
(*   const unsigned short TEXTPATH_METHODTYPE_ALIGN = 1; *)
(*   const unsigned short TEXTPATH_METHODTYPE_STRETCH = 2; *)

(*   // textPath Spacing Types *)
(*   const unsigned short TEXTPATH_SPACINGTYPE_UNKNOWN = 0; *)
(*   const unsigned short TEXTPATH_SPACINGTYPE_AUTO = 1; *)
(*   const unsigned short TEXTPATH_SPACINGTYPE_EXACT = 2; *)

(*   readonly attribute SVGAnimatedLength startOffset; *)
(*   readonly attribute SVGAnimatedEnumeration method; *)
(*   readonly attribute SVGAnimatedEnumeration spacing; *)
(* }; *)

(* interface SVGAltGlyphElement : SVGTextPositioningElement, *)
(*                                SVGURIReference { *)
(*   attribute DOMString glyphRef setraises(DOMException); *)
(*   attribute DOMString format setraises(DOMException); *)
(* }; *)

(* interface SVGAltGlyphDefElement : SVGElement { *)
(* }; *)

(* interface SVGAltGlyphItemElement : SVGElement { *)
(* }; *)

(* interface SVGGlyphRefElement : SVGElement, *)
(*                                SVGURIReference, *)
(*                                SVGStylable { *)
(*   attribute DOMString glyphRef setraises(DOMException); *)
(*   attribute DOMString format setraises(DOMException); *)
(*   attribute float x setraises(DOMException); *)
(*   attribute float y setraises(DOMException); *)
(*   attribute float dx setraises(DOMException); *)
(*   attribute float dy setraises(DOMException); *)
(* }; *)

(* interface SVGPaint : SVGColor { *)

(*   // Paint Types *)
(*   const unsigned short SVG_PAINTTYPE_UNKNOWN = 0; *)
(*   const unsigned short SVG_PAINTTYPE_RGBCOLOR = 1; *)
(*   const unsigned short SVG_PAINTTYPE_RGBCOLOR_ICCCOLOR = 2; *)
(*   const unsigned short SVG_PAINTTYPE_NONE = 101; *)
(*   const unsigned short SVG_PAINTTYPE_CURRENTCOLOR = 102; *)
(*   const unsigned short SVG_PAINTTYPE_URI_NONE = 103; *)
(*   const unsigned short SVG_PAINTTYPE_URI_CURRENTCOLOR = 104; *)
(*   const unsigned short SVG_PAINTTYPE_URI_RGBCOLOR = 105; *)
(*   const unsigned short SVG_PAINTTYPE_URI_RGBCOLOR_ICCCOLOR = 106; *)
(*   const unsigned short SVG_PAINTTYPE_URI = 107; *)

(*   readonly attribute unsigned short paintType; *)
(*   readonly attribute DOMString uri; *)

(*   void setUri(in DOMString uri); *)
(*   void setPaint(in unsigned short paintType, in DOMString uri, in DOMString rgbColor, in DOMString iccColor) raises(SVGException); *)
(* }; *)

(* interface SVGMarkerElement : SVGElement, *)
(*                              SVGLangSpace, *)
(*                              SVGExternalResourcesRequired, *)
(*                              SVGStylable, *)
(*                              SVGFitToViewBox { *)

(*   // Marker Unit Types *)
(*   const unsigned short SVG_MARKERUNITS_UNKNOWN = 0; *)
(*   const unsigned short SVG_MARKERUNITS_USERSPACEONUSE = 1; *)
(*   const unsigned short SVG_MARKERUNITS_STROKEWIDTH = 2; *)

(*   // Marker Orientation Types *)
(*   const unsigned short SVG_MARKER_ORIENT_UNKNOWN = 0; *)
(*   const unsigned short SVG_MARKER_ORIENT_AUTO = 1; *)
(*   const unsigned short SVG_MARKER_ORIENT_ANGLE = 2; *)

(*   readonly attribute SVGAnimatedLength refX; *)
(*   readonly attribute SVGAnimatedLength refY; *)
(*   readonly attribute SVGAnimatedEnumeration markerUnits; *)
(*   readonly attribute SVGAnimatedLength markerWidth; *)
(*   readonly attribute SVGAnimatedLength markerHeight; *)
(*   readonly attribute SVGAnimatedEnumeration orientType; *)
(*   readonly attribute SVGAnimatedAngle orientAngle; *)

(*   void setOrientToAuto() raises(DOMException); *)
(*   void setOrientToAngle(in SVGAngle angle) raises(DOMException); *)
(* }; *)

(* interface SVGColorProfileElement : SVGElement, *)
(*                                    SVGURIReference, *)
(*                                    SVGRenderingIntent { *)
(*   attribute DOMString local; *)
(*   attribute DOMString name; *)
(*   attribute unsigned short renderingIntent; *)
(* }; *)

(* interface SVGColorProfileRule : SVGCSSRule, *)
(*                                 SVGRenderingIntent { *)
(*   attribute DOMString src setraises(DOMException); *)
(*   attribute DOMString name setraises(DOMException); *)
(*   attribute unsigned short renderingIntent setraises(DOMException); *)
(* }; *)

(* interface SVGGradientElement : SVGElement, *)
(*                                SVGURIReference, *)
(*                                SVGExternalResourcesRequired, *)
(*                                SVGStylable, *)
(*                                SVGUnitTypes { *)

(*   // Spread Method Types *)
(*   const unsigned short SVG_SPREADMETHOD_UNKNOWN = 0; *)
(*   const unsigned short SVG_SPREADMETHOD_PAD = 1; *)
(*   const unsigned short SVG_SPREADMETHOD_REFLECT = 2; *)
(*   const unsigned short SVG_SPREADMETHOD_REPEAT = 3; *)

(*   readonly attribute SVGAnimatedEnumeration gradientUnits; *)
(*   readonly attribute SVGAnimatedTransformList gradientTransform; *)
(*   readonly attribute SVGAnimatedEnumeration spreadMethod; *)
(* }; *)

(* interface SVGLinearGradientElement : SVGGradientElement { *)
(*   readonly attribute SVGAnimatedLength x1; *)
(*   readonly attribute SVGAnimatedLength y1; *)
(*   readonly attribute SVGAnimatedLength x2; *)
(*   readonly attribute SVGAnimatedLength y2; *)
(* }; *)

(* interface SVGRadialGradientElement : SVGGradientElement { *)
(*   readonly attribute SVGAnimatedLength cx; *)
(*   readonly attribute SVGAnimatedLength cy; *)
(*   readonly attribute SVGAnimatedLength r; *)
(*   readonly attribute SVGAnimatedLength fx; *)
(*   readonly attribute SVGAnimatedLength fy; *)
(* }; *)

(* interface SVGStopElement : SVGElement, *)
(*                            SVGStylable { *)
(*   readonly attribute SVGAnimatedNumber offset; *)
(* }; *)

(* interface SVGPatternElement : SVGElement, *)
(*                               SVGURIReference, *)
(*                               SVGTests, *)
(*                               SVGLangSpace, *)
(*                               SVGExternalResourcesRequired, *)
(*                               SVGStylable, *)
(*                               SVGFitToViewBox, *)
(*                               SVGUnitTypes { *)
(*   readonly attribute SVGAnimatedEnumeration patternUnits; *)
(*   readonly attribute SVGAnimatedEnumeration patternContentUnits; *)
(*   readonly attribute SVGAnimatedTransformList patternTransform; *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(* }; *)

(* interface SVGClipPathElement : SVGElement, *)
(*                                SVGTests, *)
(*                                SVGLangSpace, *)
(*                                SVGExternalResourcesRequired, *)
(*                                SVGStylable, *)
(*                                SVGTransformable, *)
(*                                SVGUnitTypes { *)
(*   readonly attribute SVGAnimatedEnumeration clipPathUnits; *)
(* }; *)

(* interface SVGMaskElement : SVGElement, *)
(*                            SVGTests, *)
(*                            SVGLangSpace, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable, *)
(*                            SVGUnitTypes { *)
(*   readonly attribute SVGAnimatedEnumeration maskUnits; *)
(*   readonly attribute SVGAnimatedEnumeration maskContentUnits; *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(* }; *)

(* interface SVGFilterElement : SVGElement, *)
(*                              SVGURIReference, *)
(*                              SVGLangSpace, *)
(*                              SVGExternalResourcesRequired, *)
(*                              SVGStylable, *)
(*                              SVGUnitTypes { *)

(*   readonly attribute SVGAnimatedEnumeration filterUnits; *)
(*   readonly attribute SVGAnimatedEnumeration primitiveUnits; *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*   readonly attribute SVGAnimatedInteger filterResX; *)
(*   readonly attribute SVGAnimatedInteger filterResY; *)

(*   void setFilterRes(in unsigned long filterResX, in unsigned long filterResY) raises(DOMException); *)
(* }; *)

(* interface SVGFilterPrimitiveStandardAttributes : SVGStylable { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(*   readonly attribute SVGAnimatedString result; *)
(* }; *)

(* interface SVGFEBlendElement : SVGElement, *)
(*                               SVGFilterPrimitiveStandardAttributes { *)

(*   // Blend Mode Types *)
(*   const unsigned short SVG_FEBLEND_MODE_UNKNOWN = 0; *)
(*   const unsigned short SVG_FEBLEND_MODE_NORMAL = 1; *)
(*   const unsigned short SVG_FEBLEND_MODE_MULTIPLY = 2; *)
(*   const unsigned short SVG_FEBLEND_MODE_SCREEN = 3; *)
(*   const unsigned short SVG_FEBLEND_MODE_DARKEN = 4; *)
(*   const unsigned short SVG_FEBLEND_MODE_LIGHTEN = 5; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedString in2; *)
(*   readonly attribute SVGAnimatedEnumeration mode; *)
(* }; *)

(* interface SVGFEColorMatrixElement : SVGElement, *)
(*                                     SVGFilterPrimitiveStandardAttributes { *)

(*   // Color Matrix Types *)
(*   const unsigned short SVG_FECOLORMATRIX_TYPE_UNKNOWN = 0; *)
(*   const unsigned short SVG_FECOLORMATRIX_TYPE_MATRIX = 1; *)
(*   const unsigned short SVG_FECOLORMATRIX_TYPE_SATURATE = 2; *)
(*   const unsigned short SVG_FECOLORMATRIX_TYPE_HUEROTATE = 3; *)
(*   const unsigned short SVG_FECOLORMATRIX_TYPE_LUMINANCETOALPHA = 4; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedEnumeration type; *)
(*   readonly attribute SVGAnimatedNumberList values; *)
(* }; *)

(* interface SVGFEComponentTransferElement : SVGElement, *)
(*                                           SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedString in1; *)
(* }; *)

(* interface SVGComponentTransferFunctionElement : SVGElement { *)

(*   // Component Transfer Types *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_UNKNOWN = 0; *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_IDENTITY = 1; *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_TABLE = 2; *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_DISCRETE = 3; *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_LINEAR = 4; *)
(*   const unsigned short SVG_FECOMPONENTTRANSFER_TYPE_GAMMA = 5; *)

(*   readonly attribute SVGAnimatedEnumeration type; *)
(*   readonly attribute SVGAnimatedNumberList tableValues; *)
(*   readonly attribute SVGAnimatedNumber slope; *)
(*   readonly attribute SVGAnimatedNumber intercept; *)
(*   readonly attribute SVGAnimatedNumber amplitude; *)
(*   readonly attribute SVGAnimatedNumber exponent; *)
(*   readonly attribute SVGAnimatedNumber offset; *)
(* }; *)

(* interface SVGFEFuncRElement : SVGComponentTransferFunctionElement { *)
(* }; *)

(* interface SVGFEFuncGElement : SVGComponentTransferFunctionElement { *)
(* }; *)

(* interface SVGFEFuncBElement : SVGComponentTransferFunctionElement { *)
(* }; *)

(* interface SVGFEFuncAElement : SVGComponentTransferFunctionElement { *)
(* }; *)

(* interface SVGFECompositeElement : SVGElement, *)
(*                                   SVGFilterPrimitiveStandardAttributes { *)

(*   // Composite Operators *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_UNKNOWN = 0; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_OVER = 1; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_IN = 2; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_OUT = 3; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_ATOP = 4; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_XOR = 5; *)
(*   const unsigned short SVG_FECOMPOSITE_OPERATOR_ARITHMETIC = 6; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedString in2; *)
(*   readonly attribute SVGAnimatedEnumeration operator; *)
(*   readonly attribute SVGAnimatedNumber k1; *)
(*   readonly attribute SVGAnimatedNumber k2; *)
(*   readonly attribute SVGAnimatedNumber k3; *)
(*   readonly attribute SVGAnimatedNumber k4; *)
(* }; *)

(* interface SVGFEConvolveMatrixElement : SVGElement, *)
(*                                        SVGFilterPrimitiveStandardAttributes { *)

(*   // Edge Mode Values *)
(*   const unsigned short SVG_EDGEMODE_UNKNOWN = 0; *)
(*   const unsigned short SVG_EDGEMODE_DUPLICATE = 1; *)
(*   const unsigned short SVG_EDGEMODE_WRAP = 2; *)
(*   const unsigned short SVG_EDGEMODE_NONE = 3; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedInteger orderX; *)
(*   readonly attribute SVGAnimatedInteger orderY; *)
(*   readonly attribute SVGAnimatedNumberList kernelMatrix; *)
(*   readonly attribute SVGAnimatedNumber divisor; *)
(*   readonly attribute SVGAnimatedNumber bias; *)
(*   readonly attribute SVGAnimatedInteger targetX; *)
(*   readonly attribute SVGAnimatedInteger targetY; *)
(*   readonly attribute SVGAnimatedEnumeration edgeMode; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthX; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthY; *)
(*   readonly attribute SVGAnimatedBoolean preserveAlpha; *)
(* }; *)

(* interface SVGFEDiffuseLightingElement : SVGElement, *)
(*                                         SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedNumber surfaceScale; *)
(*   readonly attribute SVGAnimatedNumber diffuseConstant; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthX; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthY; *)
(* }; *)

(* interface SVGFEDistantLightElement : SVGElement { *)
(*   readonly attribute SVGAnimatedNumber azimuth; *)
(*   readonly attribute SVGAnimatedNumber elevation; *)
(* }; *)

(* interface SVGFEPointLightElement : SVGElement { *)
(*   readonly attribute SVGAnimatedNumber x; *)
(*   readonly attribute SVGAnimatedNumber y; *)
(*   readonly attribute SVGAnimatedNumber z; *)
(* }; *)

(* interface SVGFESpotLightElement : SVGElement { *)
(*   readonly attribute SVGAnimatedNumber x; *)
(*   readonly attribute SVGAnimatedNumber y; *)
(*   readonly attribute SVGAnimatedNumber z; *)
(*   readonly attribute SVGAnimatedNumber pointsAtX; *)
(*   readonly attribute SVGAnimatedNumber pointsAtY; *)
(*   readonly attribute SVGAnimatedNumber pointsAtZ; *)
(*   readonly attribute SVGAnimatedNumber specularExponent; *)
(*   readonly attribute SVGAnimatedNumber limitingConeAngle; *)
(* }; *)

(* interface SVGFEDisplacementMapElement : SVGElement, *)
(*                                         SVGFilterPrimitiveStandardAttributes { *)

(*   // Channel Selectors *)
(*   const unsigned short SVG_CHANNEL_UNKNOWN = 0; *)
(*   const unsigned short SVG_CHANNEL_R = 1; *)
(*   const unsigned short SVG_CHANNEL_G = 2; *)
(*   const unsigned short SVG_CHANNEL_B = 3; *)
(*   const unsigned short SVG_CHANNEL_A = 4; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedString in2; *)
(*   readonly attribute SVGAnimatedNumber scale; *)
(*   readonly attribute SVGAnimatedEnumeration xChannelSelector; *)
(*   readonly attribute SVGAnimatedEnumeration yChannelSelector; *)
(* }; *)

(* interface SVGFEFloodElement : SVGElement, *)
(*                               SVGFilterPrimitiveStandardAttributes { *)
(* }; *)

(* interface SVGFEGaussianBlurElement : SVGElement, *)
(*                                      SVGFilterPrimitiveStandardAttributes { *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedNumber stdDeviationX; *)
(*   readonly attribute SVGAnimatedNumber stdDeviationY; *)

(*   void setStdDeviation(in float stdDeviationX, in float stdDeviationY) raises(DOMException); *)
(* }; *)

(* interface SVGFEImageElement : SVGElement, *)
(*                               SVGURIReference, *)
(*                               SVGLangSpace, *)
(*                               SVGExternalResourcesRequired, *)
(*                               SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedPreserveAspectRatio preserveAspectRatio; *)
(* }; *)

(* interface SVGFEMergeElement : SVGElement, *)
(*                               SVGFilterPrimitiveStandardAttributes { *)
(* }; *)

(* interface SVGFEMergeNodeElement : SVGElement { *)
(*   readonly attribute SVGAnimatedString in1; *)
(* }; *)

(* interface SVGFEMorphologyElement : SVGElement, *)
(*                                    SVGFilterPrimitiveStandardAttributes { *)

(*   // Morphology Operators *)
(*   const unsigned short SVG_MORPHOLOGY_OPERATOR_UNKNOWN = 0; *)
(*   const unsigned short SVG_MORPHOLOGY_OPERATOR_ERODE = 1; *)
(*   const unsigned short SVG_MORPHOLOGY_OPERATOR_DILATE = 2; *)

(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedEnumeration operator; *)
(*   readonly attribute SVGAnimatedNumber radiusX; *)
(*   readonly attribute SVGAnimatedNumber radiusY; *)
(* }; *)

(* interface SVGFEOffsetElement : SVGElement, *)
(*                                SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedNumber dx; *)
(*   readonly attribute SVGAnimatedNumber dy; *)
(* }; *)

(* interface SVGFESpecularLightingElement : SVGElement, *)
(*                                          SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedString in1; *)
(*   readonly attribute SVGAnimatedNumber surfaceScale; *)
(*   readonly attribute SVGAnimatedNumber specularConstant; *)
(*   readonly attribute SVGAnimatedNumber specularExponent; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthX; *)
(*   readonly attribute SVGAnimatedNumber kernelUnitLengthY; *)
(* }; *)

(* interface SVGFETileElement : SVGElement, *)
(*                              SVGFilterPrimitiveStandardAttributes { *)
(*   readonly attribute SVGAnimatedString in1; *)
(* }; *)

(* interface SVGFETurbulenceElement : SVGElement, *)
(*                                    SVGFilterPrimitiveStandardAttributes { *)

(*   // Turbulence Types *)
(*   const unsigned short SVG_TURBULENCE_TYPE_UNKNOWN = 0; *)
(*   const unsigned short SVG_TURBULENCE_TYPE_FRACTALNOISE = 1; *)
(*   const unsigned short SVG_TURBULENCE_TYPE_TURBULENCE = 2; *)

(*   // Stitch Options *)
(*   const unsigned short SVG_STITCHTYPE_UNKNOWN = 0; *)
(*   const unsigned short SVG_STITCHTYPE_STITCH = 1; *)
(*   const unsigned short SVG_STITCHTYPE_NOSTITCH = 2; *)

(*   readonly attribute SVGAnimatedNumber baseFrequencyX; *)
(*   readonly attribute SVGAnimatedNumber baseFrequencyY; *)
(*   readonly attribute SVGAnimatedInteger numOctaves; *)
(*   readonly attribute SVGAnimatedNumber seed; *)
(*   readonly attribute SVGAnimatedEnumeration stitchTiles; *)
(*   readonly attribute SVGAnimatedEnumeration type; *)
(* }; *)

(* interface SVGCursorElement : SVGElement, *)
(*                              SVGURIReference, *)
(*                              SVGTests, *)
(*                              SVGExternalResourcesRequired { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(* }; *)

(* interface SVGAElement : SVGElement, *)
(*                         SVGURIReference, *)
(*                         SVGTests, *)
(*                         SVGLangSpace, *)
(*                         SVGExternalResourcesRequired, *)
(*                         SVGStylable, *)
(*                         SVGTransformable { *)
(*   readonly attribute SVGAnimatedString target; *)
(* }; *)

(* interface SVGViewElement : SVGElement, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGFitToViewBox, *)
(*                            SVGZoomAndPan { *)
(*   readonly attribute SVGStringList viewTarget; *)
(* }; *)

(* interface SVGScriptElement : SVGElement, *)
(*                              SVGURIReference, *)
(*                              SVGExternalResourcesRequired { *)
(*   attribute DOMString type setraises(DOMException); *)
(* }; *)

(* interface SVGZoomEvent : UIEvent { *)
(*   readonly attribute SVGRect zoomRectScreen; *)
(*   readonly attribute float previousScale; *)
(*   readonly attribute SVGPoint previousTranslate; *)
(*   readonly attribute float newScale; *)
(*   readonly attribute SVGPoint newTranslate; *)
(* }; *)

(* interface SVGAnimationElement : SVGElement, *)
(*                                 SVGTests, *)
(*                                 SVGExternalResourcesRequired, *)
(*                                 ElementTimeControl { *)

(*   readonly attribute SVGElement targetElement; *)

(*   float getStartTime() raises(DOMException); *)
(*   float getCurrentTime(); *)
(*   float getSimpleDuration() raises(DOMException); *)
(* }; *)

(* interface SVGAnimateElement : SVGAnimationElement, *)
(*                               SVGStylable { *)
(* }; *)

(* interface SVGSetElement : SVGAnimationElement { *)
(* }; *)

(* interface SVGAnimateMotionElement : SVGAnimationElement { *)
(* }; *)

(* interface SVGMPathElement : SVGElement, *)
(*                             SVGURIReference, *)
(*                             SVGExternalResourcesRequired { *)

(* interface SVGAnimateColorElement : SVGAnimationElement, *)
(*                                    SVGStylable { *)

(* interface SVGAnimateTransformElement : SVGAnimationElement { *)

(* interface SVGFontElement : SVGElement, *)
(*                            SVGExternalResourcesRequired, *)
(*                            SVGStylable { *)

(* interface SVGGlyphElement : SVGElement, *)
(*                             SVGStylable { *)

(* interface SVGMissingGlyphElement : SVGElement, *)
(*                                    SVGStylable { *)

(* interface SVGHKernElement : SVGElement { *)
(* interface SVGVKernElement : SVGElement { *)

(* interface SVGFontFaceElement : SVGElement { *)
class type fontFaceElement = element
(* interface SVGFontFaceSrcElement : SVGElement { *)
class type fontFaceSrcElement = element
(* interface SVGFontFaceUriElement : SVGElement { *)
class type fontFaceUriElement = element
(* interface SVGFontFaceFormatElement : SVGElement { *)
class type fontFaceFormatElement = element
(* interface SVGFontFaceNameElement : SVGElement { *)
class type fontFaceNameElement = element
(* interface SVGMetadataElement : SVGElement { *)
class type metadataElement = element

(* interface SVGForeignObjectElement : SVGElement, *)
(*                                     SVGTests, *)
(*                                     SVGLangSpace, *)
(*                                     SVGExternalResourcesRequired, *)
(*                                     SVGStylable, *)
(*                                     SVGTransformable { *)
(*   readonly attribute SVGAnimatedLength x; *)
(*   readonly attribute SVGAnimatedLength y; *)
(*   readonly attribute SVGAnimatedLength width; *)
(*   readonly attribute SVGAnimatedLength height; *)
(* }; *)

(* }; *)

let createElement (doc : document t) name = doc##createElementNS(Js.string xmlns,Js.string name)
let unsafeCreateElement doc name = Js.Unsafe.coerce (createElement doc name)

let createSvg doc : svgElement t = unsafeCreateElement doc "svg"
let createG doc : element t = unsafeCreateElement doc "g"
