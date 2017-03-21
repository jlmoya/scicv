// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("image_analysis.dem.gateway.sce");

subdemolist = [ ..
_("Canny"), "canny.dem.sce"; ..
_("Sobel"), "sobel.dem.sce"; ..
_("Contour extraction"), "contour_extraction.dem.sce"; ..
_("Watershed"), "watershed.dem.sce"; ..
_("Histogram"), "histogram.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
