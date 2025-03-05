// Scilab Computer Vision Module
// Copyright (C) 2020 - Scilab Enterprises

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- NO CHECK ERROR OUTPUT -->

// Do not check error output because:
// - Under Windows: "OpenH264 Video Codec provided by Cisco Systems, Inc." is displayed in error output by openh264-1.8.0-win64.dll when writeVideo(img, "X264"); is called

scicv_Init();

function writeVideo(img, fourcc)
    filename = fullfile(TMPDIR, "video_"+fourcc+".avi");
    
    videoWriter = new_VideoWriter(filename, CV_FOURCC(part(fourcc, 1), part(fourcc, 2), part(fourcc, 3), part(fourcc, 4)), 4, size(img));
    if ~VideoWriter_isOpened(videoWriter) then
        disp("Cannot create video file: " + filename);
    end
    
    VideoWriter_write(videoWriter, img);
    for x=1:2:60
        img_blur = blur(img, [x, x]);
        VideoWriter_write(videoWriter, img_blur);
        delete_Mat(img_blur);
    end
    delete_VideoWriter(videoWriter);
endfunction

img = imread(getSampleImage("lena.jpg"));
// supported everywhere format
writeVideo(img, "MP42");
writeVideo(img, "X264");

delete_Mat(img);

mp42 = fileinfo(fullfile(TMPDIR, "video_MP42.avi"));
assert_checktrue(mp42(1) > 0);
x264 = fileinfo(fullfile(TMPDIR, "video_X264.avi"));
assert_checktrue(x264(1) > 0);
assert_checktrue(x264(1) > mp42(1));