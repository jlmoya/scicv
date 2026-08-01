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
//
// KNOWN, ACCEPTED GAP: catching the exception does not run this function's
// argument cleanup, because SWIG_fail is a bare `return SWIG_ERROR;` with no
// goto/cleanup label anywhere in the generated file, and several dnn
// wrappers place their freearg cleanup (releasing a temporary cv::_InputArray
// view, and the temporary cv::Mat it wraps when the caller passed a raw
// numeric array rather than an existing Mat object) AFTER $action, in the
// success tail only. On a caught exception that cleanup is skipped -- a
// leak, not a crash and not a double-free (the freed objects are always
// non-owning views or temporaries this wrapper allocated itself before the
// try, never anything the OpenCV call being caught could have already freed;
// re-verified for blobFromImage, Net_setInput, and Model_predict before
// concluding this).
//
// SWIG's documented fix for exactly this is the $cleanup special variable in
// %exception (it is supposed to expand to the same freearg code emitted in
// the success tail). It DOES NOT WORK in this SWIG/Scilab combination: using
// `$cleanup;` here regenerates as the literal, unexpanded 9-character token
// "$cleanup;" at all ~714 catch sites in the generated file -- not empty,
// not the freearg code, the raw special-variable text passed through
// unsubstituted -- and fails to compile with `error: use of undeclared
// identifier '$cleanup'` at every one of them. Confirmed this is a
// -scilab-backend gap and not a misuse: SWIG's own docs describe $cleanup as
// core, language-independent machinery with no documented placement
// restriction, and grepping the entire installed Scilab SWIG library tree
// (swig/4.4.1/scilab/) for "cleanup" -- any case -- returns zero hits.
//
// Measured cost of leaving this open: RSS climbed 48 KB -> 42,512 -> 43,984
// -> 102,656 -> 240,880 KB (roughly linear, ~120 KB/call) over 2000
// iterations of blobFromImage(rawNumericArray, ..., Size(-1,-1), ...) --
// a call built specifically to throw a genuine OpenCV assertion
// (resize.cpp: "inv_scale_x > 0", not a Scilab-side argument rejection) on
// every iteration, with the image passed as a raw array each time so the
// temporary-Mat-allocation path is exercised, not skipped. Controller-ruled
// (2026-08-01) accepted rather than worked around: the failure mode here is
// strictly better than what came before it on this same call path (process
// abort -> segfault with published garbage results -> clean catchable error
// with a leak bounded to the error path), the leak cannot accumulate in a
// loop that does not throw, and the two alternatives are both worse --
// hand-writing release/delete in each of ~200 %exception-guarded wrappers is
// a lot of bespoke, easy-to-drift code that still would not resolve the
// second gap below, and fixing it silently with no record risks it becoming
// a mystery leak years from now instead of a documented, bounded one today.
//
// A second, smaller, related gap: blobFromImage's overloads that take an
// explicit output cv::OutputArray parameter (7..13-arg forms) arginit-
// allocate a fresh cv::Mat before the try and only hand it to Scilab
// (transferring ownership) in the success-path argout step; freearg for
// that typemap (typemaps/OutputArray_typemaps.i:69-71) deletes only the
// _OutputArray view, never the Mat, by design -- deleting it there too
// would double-free it on the SUCCESS path once Scilab already owns it. So
// even a working $cleanup could not have closed this one: it needs the
// typemap to behave differently depending on whether argout already ran,
// which %exception's single $cleanup expansion has no way to express. Not
// reachable through this task's required surface (plain blobFromImage
// returns its Mat by value, no output parameter), so left alongside the
// first gap rather than chased further.
//
// The real fix for both, for whoever picks this up: RAII in the typemaps --
// hold the temporary _InputArray/Mat (and the arginit-allocated output Mat,
// released only if argout never ran) in a guard object whose destructor
// does the release/delete, so `return SWIG_ERROR` unwinds it automatically
// with no cleanup hook needed at all. That fixes every module that ever
// gains a %exception block, not just this one, and is the only mechanism
// that composes with SWIG's generated control flow here. Typemap-layer
// change, out of scope for this task.
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
