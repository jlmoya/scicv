// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/photo/photo.hpp"
#include "opencv2/photo/photo_c.h"
%}

%ignore cvInpaint;

%include "opencv2/photo/photo.hpp"
%include "opencv2/photo/photo_c.h"
