// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("histograms.dem.gateway.sce");

subdemolist = [ ..
_("RBG histograms"), "RGB_histograms.dem.sce";
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
