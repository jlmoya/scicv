// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("video.dem.gateway.sce");

subdemolist = [ ..
_("Video capture"), "video_capture.dem.sce"; ..
_("Video capture - built-in GUI"), "video_capture_built-in_gui.dem.sce"; ..
_("Video reading"), "video_reading.dem.sce"; ..
_("Video reading - built-in GUI"), "video_reading_built-in_gui.dem.sce"; ..
_("Video analysis - background substraction"), "video_analysis_background_substraction.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
