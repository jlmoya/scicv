// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%inline %{

void cvGetPtList(PtLists& ptListsIn, int index, PtList* ptList) {
    *ptList = ptListsIn.at(index);
}

int cvGetPtListsSize(PtLists& ptListsIn) {
    return ptListsIn.size();
}

void cvPtListExtract(PtList& ptListIn, PtList* ptListOut) {
    *ptListOut = ptListIn;
}

%}

%inline %{

// scicv calcHist — keeps the toolbox's historical calling convention
//   hist = calcHist(image, channel, mask, dims, histSize, ranges)
// on top of the modern vector-based cv::calcHist (the raw cv:: overloads are
// ignored; see opencv_imgproc.i). ranges is a plain double matrix ([lo hi] per
// dim), converted through the standard InputArray typemap.
void calcHist(cv::InputArray image, int channel, cv::InputArray mask, cv::OutputArray hist,
              int dims, int histSize, cv::InputArray ranges) {
    int nd = dims > 0 ? dims : 1;
    std::vector<cv::Mat> images;
    images.push_back(image.getMat());
    std::vector<int> channels(1, channel);
    std::vector<int> histSizes(nd, histSize);
    cv::Mat rd;
    ranges.getMat().reshape(1, 1).convertTo(rd, CV_32F);
    std::vector<float> rv((float*)rd.datastart, (float*)rd.dataend);
    cv::Mat h;
    cv::calcHist(images, channels, mask, h, histSizes, rv);
    if (nd == 1 && h.rows == 1 && h.cols > 1) {
        h = h.t();   // historical scicv shape: histSize x 1 column
    }
    hist.assign(h);
}

%}
