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

// No .i file anywhere in scicv installs a %exception handler (confirmed: zero
// hits for "%exception" across the whole swig/ tree), so a thrown cv::Exception
// -- e.g. readNet() on a path that doesn't exist -- propagates out of the
// gateway function uncaught and calls std::terminate(), aborting the whole
// Scilab process, not just the current statement. That is a real, observed
// crash (verified directly: readNet on a missing file kills the interpreter
// with "libc++abi: terminating due to uncaught exception of type
// cv::Exception"), and dnn is the first module whose everyday, documented
// failure mode (a bad model path) routes through it. Guard just this module's
// declarations -- the fix stays scoped to what this task adds; retrofitting
// every pre-existing module's C++-exception safety is a separate concern.
%exception {
  try {
    $action
  }
  catch (const cv::Exception& e) {
    SWIG_exception(SWIG_RuntimeError, e.what());
  }
  catch (const std::exception& e) {
    SWIG_exception(SWIG_RuntimeError, e.what());
  }
}

// dnn/dnn.hpp, not the opencv2/dnn.hpp umbrella: the umbrella is a one-line
// forwarder, and %include does not recurse.
%include "opencv2/dnn/dnn.hpp"

// Scope the guard to this file: clear it back to SWIG's default so a future
// module %included after this one in scicv.i is not silently affected.
%exception;
