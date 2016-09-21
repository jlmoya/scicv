%module scicv

%scilabconst(1);

%include <std_map.i>
%include <std_common.i>
%include <std_string.i>
%include <stl.i>
%include <std_vector.i>

%include operators.i

%include modules/opencv_core.i

%include typemaps/opencv_typemaps.i

%include modules/opencv_highgui.i
%include modules/opencv_imgproc.i
%include modules/opencv_contrib.i
%include modules/opencv_objectdetect.i
%include modules/opencv_photo.i
%include modules/opencv_video.i
%include modules/opencv_features2d.i

%inline %{
void cvMatExtract(cv::Mat& matIn, cv::Mat* matOut) {
    *matOut = matIn.clone();
}

std::string getImageType(cv::Mat& matIn) {
    std::string strImgType;
    switch (matIn.type() % 8) {
        case 0:
            strImgType = "8U";
            break;
        case 1:
            strImgType = "8S";
            break;
        case 2:
            strImgType = "16U";
            break;
        case 3:
            strImgType = "16S";
            break;
        case 4:
            strImgType = "32S";
            break;
        case 5:
            strImgType = "32F";
            break;
        case 6:
            strImgType = "64F";
            break;
        default:
            break;
    }
    std::stringstream ssType;
    ssType << "CV_"<< strImgType << "C" << matIn.channels();
    return ssType.str();
}
%}
