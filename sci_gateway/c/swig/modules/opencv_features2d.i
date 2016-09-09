%{
#undef SKIP_INCLUDES
#include "opencv2/features2d/features2d.hpp"
using namespace cv;
%}


%ignore FlannBasedMatcher;
%ignore HammingMultilevel;
%ignore BOWTrainer;
%ignore BOWImgDescriptorExtractor;
%ignore BOWImgDescriptorExtractor;
%ignore GenericDescriptorMatcher;
%ignore VectorDescriptorMatcher;
%ignore FREAK;


%include "opencv2/features2d/features2d.hpp"
