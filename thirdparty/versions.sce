// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// SCOPE: these constants pin the BUNDLED THIRD-PARTY PAYLOAD that builder.sce
// downloads for Windows and Linux. They are NOT the version scicv is built
// against on macOS: sci_gateway/c/buildflags.sci resolves the installed OpenCV
// through pkg-config (probing opencv6, opencv5, opencv4, opencv in that order)
// so a `brew upgrade opencv` major bump keeps building. That is why this file
// still said 4.8.1 while the macOS gateway was linking 5.0.0.
//
// To see the version actually in use: build_macos.sce prints it, and
// scicv_opencv_version() returns it at runtime from the wrapped CV_VERSION_*
// constants.
//
// Do not "fix" the drift by bumping OPENCV_VERSION to match a macOS build --
// that would change which prebuilt the Windows/Linux path downloads, from a
// URL nobody has verified for the new value.

OPENCV_VERSION = "4.8.1"

FFMPEG_VERSION = "7.1" // Latest version

OPENH264_VERSION = "1.8.0"  // Version imposed by FFmpeg

