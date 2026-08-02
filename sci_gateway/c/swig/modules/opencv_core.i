// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#undef REAL
#undef Rhs
#undef round
// OpenCV 5 removed the legacy C API (core/types_c.h, core_c.h, imgcodecs/legacy);
// the classic CV_* constant names are provided by scicv_legacy_constants.i instead.
#include "opencv2/core.hpp"
#include "opencv2/core/cuda.hpp" // cv::cuda::GpuMat
#include "opencv2/core/mat.hpp"
#include "opencv2/imgcodecs.hpp"
using namespace std;
using namespace cv;
using namespace ogl;
using namespace cv::ogl;
%}

%include opencv_core_ignore.i

%include ../typemaps/opencv_typemaps.i

%apply double *OUTPUT { double *minVal };
%apply double *OUTPUT { double *maxVal };

using std::vector;

#define OPENCV_FORCE_UNSAFE_XADD // Avoid error about CV_XADD macro definition
%include "opencv2/core/hal/interface.h" // CV_8UC3, CV_16S, CV_CN_MAX, ... definition
%include "opencv2/core/cvdef.h" // CV_INLINE definition

// CV_VERSION_MAJOR / _MINOR / _REVISION. Not pulled in transitively: SWIG does not
// recurse into #include, so without this the constants are invisible to Scilab AND
// version-gated blocks in other headers evaluate against an undefined (=0) major.
// regen.sh also passes -DCV_VERSION_MAJOR/-DCV_VERSION_MINOR for the guard case; this
// %include is what makes the values reachable from Scilab code.
%include "opencv2/core/version.hpp" // CV_VERSION_MAJOR, CV_VERSION_MINOR, CV_VERSION_REVISION
%import "opencv2/core/cvstd.hpp" // cv::String (Needed to map cv::String as Scilab string)
%include "opencv2/core/types.hpp" // Point_, Size_, Rect, Scalar_, ...

%include "opencv2/core/mat.hpp"
%include "opencv2/core.hpp"
%include "opencv2/core/base.hpp" // cubeRoot, ...
%include "opencv2/core/utility.hpp" // getCPUTickCount, ...
%import "opencv2/core/operations.hpp"

%template() cv::Point_<int>;
%template() cv::Point_<float>;
%template() cv::Size_<int>;
%template() cv::Rect_<int>;
%template() cv::Scalar_<double>;

// New in OpenCV 5, not part of scicv's surface, and no typemaps exist for their
// vector<int>& metadata / InputArrayOfArrays parameters.
%ignore cv::imreadWithMetadata;
%ignore cv::imwriteWithMetadata;
%ignore cv::imdecodeWithMetadata;
%ignore cv::imencodeWithMetadata;
%include "opencv2/imgcodecs.hpp" // imread, ...

%include carrays.i

%array_functions( double, double_array )
%array_functions( float, float_array )
%array_functions( int, int_array )

%include cpointer.i

%pointer_functions(int, intp);

%include opencv_core_helpers.i
