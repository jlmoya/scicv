// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#undef REAL
#undef Rhs
#undef round
#include  "opencv2/core/types_c.h"
#include "opencv2/core/core.hpp"
#include "opencv2/core/gpumat.hpp"
#include "opencv2/core/mat.hpp"
#include "opencv2/core/opengl_interop_deprecated.hpp"
#include "opencv2/core/opengl_interop.hpp"
using namespace std;
using namespace cv;
using namespace ogl;
using namespace cv::gpu;
using namespace cv::ogl;
%}

%include opencv_core_ignore.i

%include ../typemaps/opencv_typemaps.i

%apply double *OUTPUT { double *minVal };
%apply double *OUTPUT { double *maxVal };

using std::vector;

%include "opencv2/core/types_c.h"
%include "opencv2/core/mat.hpp"
%import "opencv2/core/opengl_interop_deprecated.hpp"
%include "opencv2/core/core.hpp"
%import "opencv2/core/operations.hpp"

%template() cv::Point_<int>;
%template() cv::Point_<float>;
%template() cv::Size_<int>;
%template() cv::Rect_<int>;
%template() cv::Scalar_<double>;

%include carrays.i

%array_functions( double, double_array )
%array_functions( float, float_array )
%array_functions( int, int_array )

%include cpointer.i

%pointer_functions(int, intp);

%include opencv_core_helpers.i
