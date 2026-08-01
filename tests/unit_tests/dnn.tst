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
ierr = execstr("bad = readNet(TMPDIR + ""/scicv-no-such-model.onnx"");", "errcatch");
assert_checktrue(ierr <> 0);

// --- an empty Net reports itself empty --------------------------------------
n = new_Net();
assert_checkequal(Net_empty(n), %t);
delete_Net(n);
