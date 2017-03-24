// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("image_enhancement.dem.gateway.sce");

subdemolist = [ ..
_("Blur"), "blur.dem.sce"; ..
_("Morphological filtering"), "morphological_filtering.dem.sce"; ..
_("Image reconstruction"), "image_reconstruction.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
