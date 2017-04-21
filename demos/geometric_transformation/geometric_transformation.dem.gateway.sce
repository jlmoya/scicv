// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

demopath = get_absolute_file_path("geometric_transformation.dem.gateway.sce");

subdemolist = [ ..
_("Image rotation"), "image_rotation.dem.sce"; ..
_("Pyramid"), "pyramid.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
