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

//ignore some classes
%ignore Point3_;
%ignore Complex;
%ignore GlBuffer;
%ignore GlTexture;
%ignore GlArrays;
%ignore GlCamera;
%ignore GpuMat;
%ignore  MatConstIterator;
%ignore SparseMatConstIterator;
%ignore Ptr;
%ignore REAL;
%ignore Rhs;
%ignore RNG;
%ignore Algorithm;
%ignore AlgorithmInfo;
%ignore AlgorithmInfoData;
%ignore FileNode;
%ignore FileNodeIterator;
%ignore FileStorage;
%ignore SparseMatIterator;
%ignore Allocator;
%ignore CvLineIterator;
%ignore CvPluginFuncInfo;
%ignore _IplConvKernel;
%ignore _IplConvKernelFP;
%ignore CvSparseMatIterator;
%ignore MatExpr;
%ignore _InputArray;
%ignore _OutputArray;
%ignore MatIterator_;

// ignore some structures
%ignore Param;
%rename(Param) ::Param();
%ignore Mat::MStep;
%rename(MStepe) Mat::MStep;

//rename some method, variables or operators
%rename (cv_double) operator double;
%rename (cv_int) operator int;
%rename (cv_string) operator string;
%rename (cv_float) operator float;
%rename (cv_CvMat) operator CvMat;
%rename (cv_rhs) rhs;
%rename (CV_REAL) REAL;
%ignore  LineIterator;

%ignore  NAryMatIterator;
%rename  (DEPTH_MASK_A_BUT_8S) DEPTH_MASK_ALL_BUT_8S;
%ignore   _OutputArray_getOGlBufferRef;

%ignore Cv32suf_i;
%ignore Cv32suf_i;
%ignore Cv32suf_u;
%ignore Cv32suf_u;
%ignore Cv32suf_f;
%ignore Cv32suf_f;
%ignore Cv64suf_i;
%ignore Cv64suf_i;
%ignore Cv64suf_u;
%ignore Cv64suf_u;
%ignore Cv64suf_f;
%ignore Cv64suf_f;
%ignore cvRound;
%ignore cvFloor;
%ignore cvCeil;
%ignore cvIsNaN;
%ignore cvIsInf;
%ignore cvRNG;
%ignore cvRandInt;
%ignore cvRandReal;
%ignore _IplImage;
%ignore _IplTileInfo;
%ignore CvMat;
%ignore cvMat;
%ignore cvmGet;
%ignore cvmSet;
%ignore cvIplDepth;
%ignore CvMatNDtype;
%ignore CvSparseMat;
%ignore CvSparseNode;
%ignore CvHistogram;
%ignore CvRect;
%ignore cvRectToROI;
%ignore cvROIToRect;
%ignore cvTermCriteria;
%ignore CvPoint_x;
%ignore CvPoint_x;
%ignore CvPoint_y;
%ignore CvPoint_y;
%ignore cvPoint;
%ignore cvPoint2D32f;
%ignore cvPointTo32f;
%ignore cvPointFrom32f;
%ignore CvPoint3D32fx;
%ignore CvPoint3D32fz;
%ignore CvPoint3D32fz;
%ignore cvPoint3D32f;
%ignore CvPoint2D64f;
%ignore cvPoint3D64f;
%ignore CvSize;
%ignore cvSize2D32f;
%ignore CvBox2D;
%ignore cvSlice;
%ignore cvScalar;
%ignore cvRealScalar;
%ignore cvScalarAll;
%ignore CvMemBlock;
%ignore CvMemStorage;
%ignore CvSeqBlock;
%ignore CvSeq;
%ignore CvSetElem;
%ignore CvSet;
%ignore CvSet;
%ignore CvGraphEdge;
%ignore CvGraphVtx;
%ignore CvGraphVtx2D;
%ignore CvGraph;
%ignore CvChain;
%ignore CvContour;
%ignore CvSeqWriter;
%ignore CvSeqReader;
%ignore cvAttrList;
%ignore CvString;
%ignore CvStringHashNode;
%ignore CvFileNode;
%ignore CvTypeInfo;
%ignore CvModuleInfo;
%ignore CV_ENABLE_UNROLLED;
%ignore Cv32suf;
%ignore CV_StsOk;
%ignore CV_StsBackTrace;
%ignore CV_StsError;
%ignore CV_StsInternal;
%ignore CV_StsNoMem;
%ignore CV_StsBadArg;
%ignore CV_StsBadFunc;
%ignore CV_StsNoConv;
%ignore CV_StsAutoTrace;
%ignore CV_HeaderIsNull;
%ignore CV_BadImageSize;
%ignore CV_BadOffset;
%ignore CV_BadDataPtr;
%ignore CV_BadStep;
%ignore CV_BadModelOrChSeq;
%ignore CV_BadNumChannels;
%ignore CV_BadNumChannel1U;
%ignore CV_BadDepth;
%ignore CV_BadAlphaChannel;
%ignore CV_BadOrder;
%ignore CV_BadOrigin;
%ignore CV_BadAlign;
%ignore CV_BadCallBack;
%ignore CV_BadTileSize;
%ignore CV_BadCOI;
%ignore CV_BadROISize;
%ignore CV_MaskIsTiled;
%ignore CV_StsNullPtr;
%ignore CV_StsVecLengthErr;
%ignore CV_StsFilterStructCo;
%ignore CV_StsKernelStructCo;
%ignore CV_StsFilterOffsetEr;
%ignore CV_StsBadSize;
%ignore CV_StsDivByZero;
%ignore CV_StsInplaceNotSupp;
%ignore CV_StsObjectNotFound;
%ignore CV_StsUnmatchedForma;
%ignore CV_StsBadFlag;
%ignore CV_StsBadPoint;
%ignore CV_StsBadMask;
%ignore CV_StsUnmatchedSizes;
%ignore CV_StsUnsupportedFor;
%ignore CV_StsOutOfRange;
%ignore CV_StsParseError;
%ignore CV_StsNotImplemented;
%ignore CV_StsBadMemBlock;
%ignore CV_StsAssert;
%ignore CV_GpuNotSupported;
%ignore CV_GpuApiCallError;
%ignore CV_OpenGlNotSupporte;
%ignore CV_OpenGlApiCallErro;
%ignore CV_OpenCLDoubleNotSu;
%ignore CV_OpenCLInitError;
%ignore _IplROI;
%ignore Range;
%ignore cvMat;
%ignore CvMatND_type;
%ignore CvMatND_type;
%ignore CvMatND_dims;
%ignore CvMatND_dims;
%ignore CvMatND_refcount;
%ignore CvMatND_refcount;
%ignore CvMatND_hdr_refcount;
%ignore CvMatND_hdr_refcount;
%ignore cvRect;
%ignore CvTermCriteria;
%ignore CvPoint;
%ignore CvPoint2D32f;
%ignore cvPoint2D64f;
%ignore cvSize;
%ignore CvSize2D32f;
%ignore CvSlice;
%ignore CvMemStoragePos;
%ignore CvAttrList;
%ignore MatOp;
%ignore CV_Func;
%ignore RNG_MT19937_seed;
%ignore TermCriteria;
%ignore LineItr;
%ignore NAryMatIter;
%ignore SparseMat;
%ignore KDTree;
%ignore CommandLineParser;
%ignore ParallelLoopBody;
%ignore parallel_for;
%ignore Mutex_affect;
%ignore AutoLock;
%ignore WriteStructContext;
%ignore VecWriterProxy;
%ignore VecReaderProxy;
%ignore LessThan;
%ignore GreaterEq;
%ignore LessThanIdx;
%ignore GreaterEqIdx;
%ignore Formatter;
%ignore CvPoint3D32f;
%ignore CvPoint3D64f;
%ignore RNG_MT19937;
%ignore PCA;
%ignore Subdiv2D;
%ignore CvMatND;
%ignore Cv64suf;
%ignore Matx_AddOp;
%ignore Matx_SubOp;
%ignore Matx_ScaleOp;
%ignore Matx_MulOp;
%ignore Matx_MatMulOp;
%ignore Matx_TOp;
%ignore CvHaarClassifier;


// ignore functions that confict with Scilab
%ignore error;
%ignore abs;
%ignore sum;
%ignore mean;
%ignore trace;
%ignore dct;
%ignore idct;
%ignore norm;

%ignore read(const FileNode& fn);
%ignore read(const FileNode& node, int& value, int default_value);
%ignore read(const FileNode& node, bool& value, bool default_value);
%ignore read(const FileNode& node, uchar& value, uchar default_value);
%ignore read(const FileNode& node, schar& value, schar default_value);
%ignore read(const FileNode& node, ushort& value, ushort default_value);
%ignore read(const FileNode& node, short& value, short default_value);
%ignore read(const FileNode& node, float& value, float default_value);
%ignore read(const FileNode& node, double& value, double default_value);
%ignore read(const FileNode& node, string& value, const string& default_value);
%ignore read(const FileNode& node, Point_<_Tp>& value, const Point_<_Tp>& default_value);
%ignore read(const FileNode& node, Point3_<_Tp>& value, const Point3_<_Tp>& default_value);
%ignore read(const FileNode& node, Size_<_Tp>& value, const Size_<_Tp>& default_value);
%ignore read(const FileNode& node, Complex<_Tp>& value, const Complex<_Tp>& default_value);
%ignore read(const FileNode& node, Rect_<_Tp>& value, const Rect_<_Tp>& default_value);
%ignore read(const FileNode& node, Vec<_Tp, cn>& value, const Vec<_Tp, cn>& default_value);
%ignore read(const FileNode& node, Scalar_<_Tp>& value, const Scalar_<_Tp>& default_value);
%ignore read(const FileNode& node, Range& value, const Range& default_value);
%ignore read(const FileNode& node, Mat& mat, const Mat& default_mat=Mat());
%ignore read(const FileNode& node, SparseMat& mat, const SparseMat& default_mat=SparseMat());

%ignore write(FileStorage& fs, const string& name, int value);
%ignore write( FileStorage& fs, const string& name, float value );
%ignore write( FileStorage& fs, const string& name, double value );
%ignore write( FileStorage& fs, const string& name, const string& value );



// ignore low level functions & classes
%ignore setBreakOnError;
%ignore redirectError;
%ignore fastMalloc;
%ignore fastFree;
%ignore toUtf16;
%ignore fromUtf16;
%ignore glob;
%ignore tempfile;
%ignore alignSize;
%ignore Mutex;


%include "../typemaps/opencv_typemaps.i"

%apply double *OUTPUT { double *minVal };
%apply double *OUTPUT { double *maxVal };

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

//%template(vecOfRect) std::vector<cv::Rect_<int>>;

%include carrays.i

%array_functions( double, double_array )
%array_functions( float, float_array )
%array_functions( int, int_array )

%include cpointer.i

%pointer_functions(int, intp);

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


