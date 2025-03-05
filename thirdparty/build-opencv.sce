// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

exec("versions.sce", -1);

os = getos();
[_, opts] = getversion();
arch = opts(2);

// Start from scratch
rmdir(OPENCV_VERSION, "s");
mkdir(OPENCV_VERSION)

// Install directory
THIRDPARTY = fullfile(pwd(), OPENCV_VERSION, os, arch);

// Create install folder manually as FFmpeg and OpenH264 are downloaded and not built/installed
if os == "Windows" then
    mkdir(fullfile(THIRDPARTY, "bin"));
end

cd(OPENCV_VERSION);
mkdir("build/");
cd("build/");

// Build OpenH264
if os <> "Windows" then
    [result, status] = http_get("https://github.com/cisco/openh264/archive/refs/tags/v" + OPENH264_VERSION + ".tar.gz", "openh264.tar.gz", follow=%T);
    decompress("openh264.tar.gz");
    cd("openh264-" + OPENH264_VERSION);
    unix("make ARCH=$(uname -m) PREFIX=""" + THIRDPARTY +""" install");
    cd("..");
else
    [result, status] = http_get("http://ciscobinary.openh264.org/openh264-1.8.0-win64.dll.bz2", "openh264-1.8.0-win64.dll.bz2", follow=%T);
    unix("7z x -o" + THIRDPARTY + "\bin\ openh264-1.8.0-win64.dll.bz2");
end

// Build FFmpeg
if os <> "Windows" then
    [result, status] = http_get("https://ffmpeg.org/releases/ffmpeg-" + FFMPEG_VERSION + ".tar.gz", "ffmpeg.tar.gz", follow=%T);
    decompress("ffmpeg.tar.gz");
    cd("ffmpeg-" + FFMPEG_VERSION);
    if os == "Linux" then
        unix("PKG_CONFIG_PATH=""" + THIRDPARTY +"/lib/pkgconfig"" ./configure --enable-shared --enable-rpath --disable-static --disable-programs --disable-x86asm --enable-libopenh264 --prefix=""" + THIRDPARTY + """");
    else
        unix("PKG_CONFIG_PATH=""" + THIRDPARTY +"/lib/pkgconfig"" ./configure --enable-shared --enable-rpath --disable-static --disable-programs --disable-x86asm --enable-libopenh264 --prefix=""" + THIRDPARTY + """ --extra-cflags=""-Wno-error=incompatible-function-pointer-types -Wno-int-conversion""");
    end
    unix("make -j4");
    unix("make install");
    cd("..");
end

// Build OpenCV
[result, status] = http_get("https://github.com/opencv/opencv/archive/refs/tags/" + OPENCV_VERSION + ".tar.gz", "opencv.tar.gz", follow=%T);
decompress("opencv.tar.gz");
[result, status] = http_get("https://github.com/opencv/opencv_contrib/archive/refs/tags/" + OPENCV_VERSION + ".tar.gz", "opencv_contrib.tgz", follow=%T);
decompress("opencv_contrib.tgz");
cd("opencv-" + OPENCV_VERSION);
mkdir("build"); // Needed because In-source builds are not allowed.
cd("build");

cmakeCmd = [];

if os <> "Windows" then
    cmakeCmd($+1) = "PKG_CONFIG_PATH=""$PKG_CONFIG_PATH:" + THIRDPARTY + "/lib/pkgconfig""";
end

cmakeCmd($+1) = "cmake";
cmakeCmd($+1) = "-DCMAKE_INSTALL_PREFIX=""" + THIRDPARTY + """";
cmakeCmd($+1) = "-DWITH_OPENJPEG=OFF";
cmakeCmd($+1) = "-DBUILD_opencv_apps=OFF";
cmakeCmd($+1) = "-DBUILD_opencv_hdf=OFF";
cmakeCmd($+1) = "-DBUILD_opencv_freetype=OFF";
cmakeCmd($+1) = "-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON";
cmakeCmd($+1) = "-DBUILD_PERF_TESTS:BOOL=OFF";
cmakeCmd($+1) = "-DBUILD_TESTS:BOOL=OFF";
cmakeCmd($+1) = "-DBUILD_DOCS:BOOL=OFF";
cmakeCmd($+1) = "-DBUILD_EXAMPLES:BOOL=OFF";
cmakeCmd($+1) = "-DOPENCV_SKIP_VISIBILITY_HIDDEN=ON";
cmakeCmd($+1) = "-DBUILD_opencv_world:BOOL=ON";
cmakeCmd($+1) = "-DBUILD_opencv_python2=OFF";

if os == "Windows" then
    cmakeCmd($+1) = "-DOPENCV_EXTRA_MODULES_PATH=..\..\opencv_contrib-" + OPENCV_VERSION + "\modules";
    cmakeCmd($+1) = "-DCMAKE_CXX_FLAGS=""/D _SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS=1"""
    cmakeCmd($+1) = "-DCMAKE_CXX_LINK_FLAGS=""synchronization.lib"""
    cmakeCmd($+1) = "-DCMAKE_C_LINK_FLAGS=""synchronization.lib"""
else    
    cmakeCmd($+1) = "-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-" + OPENCV_VERSION + "/modules";
    cmakeCmd($+1) = "-DCMAKE_SHARED_LINKER_FLAGS=""-Wl,-rpath," + THIRDPARTY + "/lib""";
    cmakeCmd($+1) = "-DCMAKE_INSTALL_RPATH=""" + THIRDPARTY + "/lib""";
    // Under Linux, if libjpeg-dev and libpng-dev packages are installed
    // then they are used and compiled libopencv_highgui.so (and some others) depends on libjpeg.so and libpng.so
    // So we force the use of 3rdparty/ libraries with -DBUILD_JPEG=TRUE & -DBUILD_PNG=TRUE
    cmakeCmd($+1) = "-DBUILD_JPEG=TRUE";
    cmakeCmd($+1) = "-DBUILD_PNG=TRUE";
end

if os == "Darwin" then
    cmakeCmd($+1) = "-DCMAKE_MACOSX_RPATH=ON";
    cmakeCmd($+1) = "-DCMAKE_OSX_SYSROOT=$SDKROOT"
end

cmakeCmd($+1) = "..";

unix(strcat(cmakeCmd, " "));

if os == "Windows" then
    unix("cmake --build . --config Release");
    unix("cmake --install .")
else
    unix("make -j4");
    unix("make install");
end

cd("../../..");

// Cleanup/Reorganization
if os == "Windows" then
    rmdir(fullfile(os, arch, "etc"), "s");

    mdelete(fullfile(os, arch, "LICENSE"));
    mdelete(fullfile(os, arch, "OpenCVConfig-version.cmake"));
    mdelete(fullfile(os, arch, "OpenCVConfig.cmake"));
    mdelete(fullfile(os, arch, "setup_vars_opencv4.cmd"));

    copyfile(fullfile(os, arch, "x64", "vc17", "bin"), fullfile(os, arch, "bin"));

    mkdir(fullfile(os, arch, "lib"));
    copyfile(fullfile(os, arch, "x64", "vc17", "lib"), fullfile(os, arch, "lib"));
    mdelete(fullfile(os, arch, "lib", "OpenCVConfig.cmake"));
    mdelete(fullfile(os, arch, "lib", "OpenCVConfig-version.cmake"));
    mdelete(fullfile(os, arch, "lib", "OpenCVModules-release.cmake"));
    mdelete(fullfile(os, arch, "lib", "OpenCVModules.cmake"));
    
    rmdir(fullfile(os, arch, "x64"), "s");
else
    unix("mv -R " + THIRDPARTY + "/include/opencv4/opencv2 " + THIRDPARTY + "/include/");
    rmdir(fullfile(os, arch, "include", "opencv4"), "s");
    rmdir(fullfile(os, arch, "bin"), "s");
    rmdir(fullfile(os, arch, "lib", "cmake"), "s");
    rmdir(fullfile(os, arch, "lib", "pkgconfig"), "s");
    rmdir(fullfile(os, arch, "lib", "python*"), "s");
    rmdir(fullfile(os, arch, "share"), "s");
end

// Create archive
if os == "Windows" then
    compress("opencv-" + OPENCV_VERSION + "-" + os + "-" + arch + ".tar.gz", os);
else
    compress("opencv-" + OPENCV_VERSION + "-ffmpeg-" + FFMPEG_VERSION + "-" + os + "-" + arch + ".tar.gz", os);
end

// Check error status (sometimes useful under macOS)
[str, n, line, func] = lasterror();
if n <> 0 then
    disp(str, n, line, func);
end
