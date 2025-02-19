// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

OPENCV_VERSION = "2.4.13.6" // Latest 2.x version

FFMPEG_VERSION = "3.4.9"    // Linux: Install fails with 3.4.13 / Compilation fails wih 4.x versions
os = getos();
if os == "Windows" then
    FFMPEG_VERSION = "4.2.3"
end

OPENH264_VERSION = "1.7.0"  // Version imposed by FFmpeg 

