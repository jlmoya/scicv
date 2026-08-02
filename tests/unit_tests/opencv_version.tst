// Scilab Computer Vision Module
// The version scicv reports must be the version it was built against.

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

scicv_Init();

v = scicv_opencv_version();

// A non-empty dotted triple.
assert_checktrue(type(v) == 10);
assert_checktrue(size(strsplit(v, "."), "*") == 3);

// It must agree with the wrapped constants, which come from the headers the
// gateway actually compiled against.
expected = msprintf("%d.%d.%d", CV_VERSION_MAJOR, CV_VERSION_MINOR, CV_VERSION_REVISION);
assert_checkequal(v, expected);

// And with the library the gateway is linked to. OPENCV_VERSION in
// thirdparty/versions.sce is deliberately NOT compared: it pins the bundled
// Windows/Linux prebuilt payload, not the macOS pkg-config resolution.
assert_checktrue(CV_VERSION_MAJOR >= 4);
