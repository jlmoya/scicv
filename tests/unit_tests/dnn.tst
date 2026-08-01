// Scilab Computer Vision Module
// dnn module bindings — the wrapper surface, with no model file needed.

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

scicv_Init();

// --- the entry points exist -------------------------------------------------
assert_checkequal(exists("readNet"), 1);
assert_checkequal(exists("readNetFromONNX"), 1);
assert_checkequal(exists("blobFromImage"), 1);
assert_checkequal(exists("Net_setInput"), 1);
assert_checkequal(exists("Net_forward"), 1);
assert_checkequal(exists("Net_empty"), 1);
assert_checkequal(exists("delete_Net"), 1);
assert_checkequal(exists("new_ClassificationModel"), 1);

// --- blobFromImage produces the NCHW blob shape -----------------------------
// A 40x60 BGR image -> a 1x3x10x20 blob when resized to width=20,height=10.
// Mat/Size/Scalar are not their own callables here: cv::Mat's constructor is
// new_Mat (typeof/exists("Mat") is nothing -- confirmed against the generated
// table), and cv::Size/cv::Scalar are consumed straight from plain Scilab
// vectors via typemap (typemaps/Size_typemaps.i, Scalar_typemaps.i) rather
// than a wrapped class -- also confirmed empirically: the Size typemap reads
// a 2-vector as [height, width], not OpenCV's own (width, height) argument
// order, so [10, 20] is the height=10/width=20 this comment's target size.
img = new_Mat(40, 60, CV_8UC3);
blob = blobFromImage(img, 1.0 / 255.0, [10, 20], [0, 0, 0, 0], %t, %f);
// Mat has no bare "size" accessor for N-D shapes; OpenCV 5's Mat::shape()
// (wrapped as Mat_shape) returns a MatShape object whose MatShape_str is the
// simplest route to a value Scilab can assert_checkequal against directly.
assert_checkequal(MatShape_str(Mat_shape(blob)), "[1 x 3 x 10 x 20]");
delete_Mat(blob);
delete_Mat(img);

// --- readNet on a missing file fails loudly rather than returning a bad Net --
// readNet returns cv::dnn::Net BY VALUE: on a thrown cv::Exception the local
// "result" is still a validly-default-constructed object (declared before
// the try/catch runs), so this path is benign even under a %exception bug
// that fails to stop the wrapper -- it only leaks, it does not crash. It is
// not, on its own, evidence that %exception actually aborts on failure; see
// the by-reference check below for that.
ierr = execstr("bad = readNet(TMPDIR + ""/scicv-no-such-model.onnx"");", "errcatch");
assert_checktrue(ierr <> 0);

// --- a by-reference-returning wrapper also fails loudly, not just by-value --
// Net_argName returns "const std::string&", marshaled through a local
// "std::string *result = 0" that is only assigned inside the try. If
// %exception's catch block does not itself stop the wrapper (SWIG_exception
// alone does not, in this project's generated code -- it expands to bare
// SWIG_Scilab_Error with no return; only SWIG_exception_fail adds the
// SWIG_fail/return that actually aborts), execution falls through to
// `*result` on that still-null pointer: a SIGSEGV that takes the whole
// Scilab process down, not just this statement. Verified directly: with a
// bare-SWIG_exception build this call crashed the interpreter
// (Segmentation fault: 11 inside _wrap_Net_argName); with SWIG_exception_fail
// it does not.
//
// idx=99999 is a real, correctly-typed Arg -- Scilab's own argument
// typecheck accepts it, so any failure here is necessarily raised from
// inside OpenCV itself, not a call rejected before OpenCV ever ran. Assert
// on lasterror() content, not just ierr <> 0, so this test cannot pass for
// that wrong reason.
n2 = new_Net();
badArg = new_Arg(99999);
ierr = execstr("bad_name = Net_argName(n2, badArg);", "errcatch");
assert_checktrue(ierr <> 0);
assert_checktrue(strindex(lasterror(), "OpenCV") <> []);
delete_Net(n2);

// --- an empty Net reports itself empty --------------------------------------
n = new_Net();
assert_checkequal(Net_empty(n), %t);
delete_Net(n);
