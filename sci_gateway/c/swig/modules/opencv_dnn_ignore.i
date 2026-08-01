// Scilab Computer Vision Module
// dnn: a surface trim, NOT a parse fix.
//
// MEASURED: SWIG regenerates cleanly with this file EMPTY (exit 0, 0 errors)
// -- 4698 gateway table entries without it, 4562 with it (regen.sh's own
// count). Most of these names are unreachable or unusable from a Scilab
// script regardless (a wrapped-but-broken entry is worse than an absent one:
// it looks callable and then misbehaves); the six added below the original
// nine -- DNN_BACKEND_INFERENCE_ENGINE_NGRAPH, _NN_BUILDER_2019,
// Graph::append, BackendNode, Net::argType, and
// Image2BlobParams::blobRectsToImageRects -- are load-bearing: the gateway
// does not compile, or does not dlopen, without them. See each one's own
// comment for the specific failure.
//
// So: if any line here ever causes trouble, first re-read its own comment --
// some are cosmetic trims (safe to delete), others are the only thing
// standing between this file and a compile or dlopen failure.

// Layer authoring/registration is a C++ extension point: LayerFactory takes a
// std::function constructor, LayerParams is a Dict of heterogeneous values.
// No Scilab script can implement a layer.
%ignore cv::dnn::LayerFactory;
%ignore cv::dnn::LayerParams;
%ignore cv::dnn::Dict;
%ignore cv::dnn::DictValue;
%ignore cv::dnn::Layer;

// Async inference hands back an AsyncArray whose get() blocks on an internal
// promise -- a threading model Scilab's single interpreter cannot drive.
%ignore cv::dnn::Net::forwardAsync;

// Buffer overloads take (const char*, size_t): a raw pointer plus a length a
// Scilab caller has no way to produce. The path-taking overloads cover the use.
%ignore cv::dnn::readNetFromONNX(const char *, size_t, int);
%ignore cv::dnn::readNetFromTensorflow(const char *, size_t, int);
%ignore cv::dnn::readNetFromTFLite(const char *, size_t, int);

// dnn.hpp's Backend enum guards these two behind
// `#if defined(__OPENCV_BUILD) || defined(BUILD_PLUGIN)` -- and scicv.i
// unconditionally #defines __OPENCV_BUILD for SWIG's preprocessor (other
// modules need it to route compatibility headers), so SWIG sees and wraps
// them even though buildflags.sci's real compile never defines
// __OPENCV_BUILD. The header's own comment marks both "internal -- use
// DNN_BACKEND_INFERENCE_ENGINE + setInferenceEngineBackendType()", so this is
// a real absence, not a guard mismatch to paper over generally: without the
// ignore, the generated wrapper references cv::dnn::DNN_BACKEND_INFERENCE_ENGINE_NGRAPH
// and cv::dnn::DNN_BACKEND_INFERENCE_ENGINE_NN_BUILDER_2019, which do not
// exist in the namespace the real compiler builds -- a hard compile error,
// not a warning.
%ignore cv::dnn::DNN_BACKEND_INFERENCE_ENGINE_NGRAPH;
%ignore cv::dnn::DNN_BACKEND_INFERENCE_ENGINE_NN_BUILDER_2019;

// Graph::append is graph-AUTHORING surface (building a custom op graph node by
// node), the same "no Scilab script can implement this" category as
// LayerFactory/Layer above -- readNet/Net_forward never touch it. It also
// will not compile if wrapped: both overloads default their 2nd parameter
// (a vector<string> on one, a string on the other), so a single-argument
// call is genuinely ambiguous C++, and SWIG's default-argument handling
// generates exactly that 1-arg call for each overload.
%ignore cv::dnn::Graph::append;

// BackendNode is the base class a CUSTOM dnn backend (OpenVINO/CUDA/WebNN/...)
// subclasses to represent one graph node in ITS OWN representation -- another
// "no Scilab script can implement this" extension point, same category as
// Layer/LayerFactory. It also will not link: libopencv_dnn.dylib does not
// export BackendNode::BackendNode(int) or its destructor at all (confirmed
// via `nm -gU` against the actual installed dylib), so wrapping it produces
// a dlopen-time "symbol not found in flat namespace" failure, not a compile
// error -- SWIG has no way to catch this at regen time.
%ignore cv::dnn::BackendNode;

// Net::argType(Arg) const is declared in dnn.hpp (alongside argData/argKind/
// argName/argTensor, which DO link fine) but is not defined anywhere in this
// Homebrew opencv5 5.0.0 build -- confirmed absent via `nm -gU` on
// libopencv_dnn.dylib while its four Arg-introspection siblings are present.
// An upstream/packaging gap in the .dylib itself, unrelated to this
// interface; wrapping it is another dlopen-time "symbol not found".
%ignore cv::dnn::Net::argType;

// blobRectsToImageRects takes a const vector<Rect>& INPUT (rBlob) alongside
// a CV_OUT vector<Rect>& output (rImg); the project's shared
// VectorRect_typemaps.i only has an argout-shaped rule for vector<Rect>&, so
// it fires for BOTH parameters regardless of const, which (a) never reads
// rBlob's actual data -- silently operating on an empty vector -- and (b)
// emits its sciErr/piListAddr/nbElements/iVarOut locals twice in one
// function body, a hard redefinition error. The sibling singular overload,
// blobRectToImageRect (Rect, not vector<Rect>), does not use this typemap
// and is unaffected. Fixing the shared typemap is out of scope here; a
// silently-wrong wrapper would be worse than an absent one regardless.
%ignore cv::dnn::Image2BlobParams::blobRectsToImageRects;
