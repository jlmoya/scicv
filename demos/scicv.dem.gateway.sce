// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("scicv.dem.gateway.sce");

add_demo(_("Computer vision"), fullfile(demopath, "scicv.dem.gateway.sce"));

subdemolist = [ ..
_("Image enhancement"), "image_enhancement/image_enhancement.dem.gateway.sce"; ..
_("Image conversion"), "image_conversion/image_conversion.dem.gateway.sce"; ..
_("Histograms"), "histograms/histograms.dem.gateway.sce"; ..
_("Geometric transformation"), "geometric_transformation/geometric_transformation.dem.gateway.sce"; ..
_("Image analysis"), "image_analysis/image_analysis.dem.gateway.sce"; ..
_("Object detection"), "object_detection/object_detection.dem.gateway.sce"; ..
_("Video"), "video/video.dem.gateway.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);

clear demopath;
