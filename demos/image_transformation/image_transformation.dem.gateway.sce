// Copyright (C) 2016 - Scilab Enterprises -

demopath = get_absolute_file_path("image_transformation.dem.gateway.sce");

subdemolist = [ ..
_("Image rotation"), "image_rotation.dem.sce"; ..
_("Pyramid"), "pyramid.dem.sce"; ..
];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
