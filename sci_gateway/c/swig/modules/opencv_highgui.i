%{
#undef SKIP_INCLUDES
#include "opencv2/highgui/highgui.hpp"
using namespace cv;
%}

%ignore   cvLoadWindowParameters();
%import  "opencv2/core/types_c.h"
%include "opencv2/highgui/highgui.hpp"
%include "opencv2/highgui/highgui_c.h"


