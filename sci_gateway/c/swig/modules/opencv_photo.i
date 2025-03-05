// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/photo.hpp"
#include "opencv2/photo/legacy/constants_c.h"
%}

%ignore cvInpaint;

%include "opencv2/photo.hpp" // fastNlMeansDenoising
%include "opencv2/photo/legacy/constants_c.h" // CV_INPAINT_NS, ...
