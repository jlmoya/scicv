// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%module scicv

// Force C++11 to avoid "OpenCV 4.x+ requires enabled C++11 support" error
// See opencv2/core/cvdef.h
#undef __cplusplus
#define __cplusplus 201103

// Needed to detect compatibility headers such as opencv2/core/core.hpp
#define __OPENCV_BUILD

// Force definition of types defined in mat.hpp as 'typedef of typedef'
// Else generated code will not build (missing cast when calling methods with these types as input)
namespace cv {
    %typedef const _InputArray& InputArrayOfArrays;
    %typedef const _OutputArray& OutputArrayOfArrays;
    %typedef const _InputOutputArray& InputOutputArrayOfArrays;
}

// Needed for enum struct DrawMatchesFlags (error: cannot convert 'cv::DrawMatchesFlags' to 'double')
%typemap(scilabconstcode, fragment=SWIG_CreateScilabVariable_frag(double)) double 
%{
if (SWIG_CreateScilabVariable_double(pvApiCtx, "$result", (double)$value) != SWIG_OK)
    return SWIG_ERROR;
%}

%scilabconst(1);

%include <std_map.i>
%include <std_common.i>
%include <std_string.i>
%include <stl.i>
%include <std_vector.i>

%include operators.i

%include modules/opencv_core.i

%include scicv_datatypes.i

%include typemaps/opencv_typemaps.i

%include modules/opencv_highgui.i
%include modules/opencv_imgproc.i
%include modules/opencv_contrib.i
%include modules/opencv_objectdetect.i
%include modules/opencv_photo.i
%include modules/opencv_video.i
%include modules/opencv_features2d.i

// Classic OpenCV C-API constant names (CV_*), generated from the installed
// modern enums by generate_legacy_compat.sh — OpenCV 5 removed the legacy
// headers that used to provide them. Included last so every referenced enum
// is already in the wrap's include set.
%include scicv_legacy_constants.i

