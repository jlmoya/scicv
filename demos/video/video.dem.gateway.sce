// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("video.dem.gateway.sce");

subdemolist = [ ..
_("Video capture"), "video_capture.dem.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
