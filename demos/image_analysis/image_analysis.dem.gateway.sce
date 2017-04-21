// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("image_analysis.dem.gateway.sce");

subdemolist = [ ..
_("Canny"), "canny.dem.sce"; ..
_("Sobel"), "sobel.dem.sce"; ..
_("Contour extraction"), "contour_extraction.dem.sce"; ..
_("Watershed"), "watershed.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
