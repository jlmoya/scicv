// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("image_conversion.dem.gateway.sce");

subdemolist = [ ..
_("Thresholding"), "thresholding.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
