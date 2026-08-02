// Scilab Computer Vision Module
//
// scicv_opencv_version() — the OpenCV version this gateway was BUILT against.
//
// Read from the wrapped CV_VERSION_* constants, so it can never drift: they
// come from the headers libscicv compiled against. Deliberately not read from
// thirdparty/versions.sce, which pins the bundled Windows/Linux prebuilt
// payload and says nothing about a macOS build (where buildflags.sci resolves
// OpenCV through pkg-config).

function v = scicv_opencv_version()
    v = msprintf("%d.%d.%d", CV_VERSION_MAJOR, CV_VERSION_MINOR, CV_VERSION_REVISION);
endfunction
