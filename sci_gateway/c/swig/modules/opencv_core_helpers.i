// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%inline %{
void cvMatExtract(cv::Mat& matIn, cv::Mat* hypermatOut) {
    *hypermatOut = matIn;
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