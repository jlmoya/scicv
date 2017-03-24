// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// <-- CLI SHELL MODE -->

scicv_Init();

cap = new_VideoCapture(getSampleVideo("video.mpg"));

assert_checktrue(VideoCapture_isOpened(cap));

fps_video = VideoCapture_get(cap, CV_CAP_PROP_FPS);
assert_checkequal(fps_video, 25);

delete_VideoCapture(cap);
