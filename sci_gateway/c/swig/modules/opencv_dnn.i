// Scilab Computer Vision Module
// dnn — neural-network inference (readNet, blobFromImage, Net, Model).
//
// libscicv already LINKS libopencv_dnn (and dnn_objdetect, dnn_superres); only
// this interface was missing, so nothing about the build changes here.
//
// NOTE for OpenCV 5: the Darknet and Caffe importers are GONE. Only
// readNetFromTensorflow, readNetFromTFLite, readNetFromONNX and the OpenVINO
// path survive, with readNet dispatching by extension. Any recipe built on
// .cfg/.weights or .prototxt/.caffemodel will not work on this build.

%{
#include "opencv2/dnn.hpp"
using namespace cv::dnn;
%}

// OpenCV wraps every dnn declaration in a VERSIONED inline namespace --
// cv::dnn::dnn5_v20260605 -- through the CV__DNN_INLINE_NS_BEGIN/END macros in
// opencv2/dnn/version.hpp. SWIG does not follow #include, so it never sees
// those macros and would choke on the bare identifiers. Defining them empty
// here (for SWIG's preprocessor only, not inside %{ %}) flattens the namespace
// to cv::dnn, which is also how user code spells it: version.hpp emits
// `using namespace CV__DNN_INLINE_NS;` so cv::dnn::readNet resolves in the
// generated C++ regardless. Defining them empty ALSO keeps the wrapped names
// stable across OpenCV point releases -- otherwise every bump to
// OPENCV_DNN_API_VERSION would rename every symbol.
#define CV__DNN_INLINE_NS_BEGIN
#define CV__DNN_INLINE_NS_END

%include modules/opencv_dnn_ignore.i

// Before this block, no .i file anywhere in scicv installed a %exception
// handler (confirmed: zero hits for "%exception" across the whole swig/ tree
// before this addition), so a thrown cv::Exception -- e.g. readNet() on a
// path that doesn't exist -- propagated out of the gateway function
// uncaught and called std::terminate(), aborting the whole Scilab process,
// not just the current statement. That is a real, observed crash (verified
// directly: readNet on a missing file killed the interpreter with
// "libc++abi: terminating due to uncaught exception of type cv::Exception"),
// and dnn is the first module whose everyday, documented failure mode (a bad
// model path) routes through it. Guard just this module's declarations --
// the fix stays scoped to what this task adds; retrofitting every
// pre-existing module's C++-exception safety is a separate concern.
//
// MUST be SWIG_exception_fail, not SWIG_exception: in this project's
// generated code, SWIG_exception expands to bare SWIG_Scilab_Error(code,msg)
// -- it does NOT return. SWIG_exception_fail additionally does SWIG_fail
// (return SWIG_ERROR), which is what actually stops the wrapper. Using plain
// SWIG_exception here was tried first and made things WORSE, not better: it
// let the code fall through into the normal success path with a result that
// was never assigned. For a function returning by value that is a leaked,
// silently-wrong "empty" object; for one returning by reference/pointer to a
// local (Net::argName -> std::string*, TextRecognitionModel::getDecodeType,
// ...) the fall-through dereferences a null result pointer -- a SIGSEGV,
// i.e. this block would have turned an abort() into a segfault for those.
// Verified directly (dev-tree scilab-cli): Net_argName(n, Arg(99999)) on a
// freshly constructed, argument-less Net crashed the whole interpreter with
// "Signal: Segmentation fault: 11 ... Failing at address: 0x17" inside
// _wrap_Net_argName, using the bare-SWIG_exception version of this file.
// SWIG_exception_fail on the same call instead returns a clean, catchable
// Scilab error with the process alive and OpenCV's own message in
// lasterror() -- see tests/unit_tests/dnn.tst's by-reference assertion.
%exception {
  try {
    $action
  }
  catch (const cv::Exception& e) {
    SWIG_exception_fail(SWIG_RuntimeError, e.what());
  }
  catch (const std::exception& e) {
    SWIG_exception_fail(SWIG_RuntimeError, e.what());
  }
}

// dnn/dnn.hpp, not the opencv2/dnn.hpp umbrella: the umbrella is a one-line
// forwarder, and %include does not recurse.
%include "opencv2/dnn/dnn.hpp"

// Scope the guard to this file: clear it back to SWIG's default so a future
// module %included after this one in scicv.i is not silently affected.
%exception;
