// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// Check that all symbols (variable & functions) wrapped in sciCV 0.6.2 (OpenCV 2.4.13) are still mapped

scicv_Init();

// OpenCV 5 removed the legacy C API (IplImage/CvMat/cv* functions), so the
// pre-5 surface inventories cannot be fully mapped anymore by design. The
// current surface is tracked by symbols-5.0.0.tst.
if exists("cvIplImage") == 0 then
    mprintf("Skipped: pre-5 surface test (legacy C API absent, OpenCV >= 5).\n");
    return
end


// Functions
exec(fullfile(get_scicv_path(), "tests", "unit_tests", "functions-0.6.2.txt"), -1);
scicvFunctions = table;
clear table

ignored = [
    "__add_assign__", "__sub_assign__", "__mul_assign__", "__div_assign__", ..  // Renamed in operators.i
    "scalarToRawData", .. // Private now: https://github.com/opencv/opencv/blob/4.8.1/modules/core/src/copy.cpp
    "Mat_cv_CvMat", .. // No more exists
    "Mat_refcount_set", "Mat_refcount_get", .. // refcount attribute no more exists for class Mat()
    "getConvertFunc", "getConvertScaleFunc", "getCopyMaskFunc", .. // No more exists
    "getConvertElem", "getConvertScaleElem", .. // static functions in modules/core/src/matrix_sparse.cpp
    "TLSDataContainer_createDataInstance", "TLSDataContainer_deleteDataInstance", "TLSDataContainer_getData", .. // Switched from public to protected
    "pointCloudShow", .. // No more exists
    "getKernelType", "getLinearRowFilter", "getLinearColumnFilter", "getLinearFilter", .. // No more exported, see: modules/imgproc/src/filterengine.hpp
    "createSeparableLinearFilter", "createLinearFilter", "createGaussianFilter", "createDerivFilter", ..  // No more exported, see: modules/imgproc/src/filterengine.hpp
    "getRowSumFilter", "getColumnSumFilter", "createBoxFilter", "getMorphologyRowFilter", "getMorphologyColumnFilter", "getMorphologyFilter", "createMorphologyFilter", "adaptiveBilateralFilter", .. // No more exported, see: modules/imgproc/src/filterengine.hpp
    "eigen2x2", .. // static function in modules/imgproc/src/corner.cpp
    "GeneralizedHough_create", "GeneralizedHough_release", .. // Method no more exists, see opencv2/imgproc.hpp
    "phaseCorrelateRes", .. // No more exists
    "cvLoadHaarClassifierCascade", "cvReleaseHaarClassifierCascade", "cvHaarDetectObjects", "cvSetImagesForHaarClassifierCascade", "cvRunHaarClassifierCascade", "cvHaarDetectObjectsForROC", .. // No more exists
    "CascadeClassifier_setImage", "CascadeClassifier_setFaceDetectionMaskGenerator", .. // No more exists
    "findDataMatrix", "drawDataMatrixCodes", "cvFindDataMatrix", .. // No more exists
    "initModule_video", .. // No more exists
    "cvCalcOpticalFlowPyrLK", "cvCalcAffineFlowPyrLK", "cvCreateKalman", "cvReleaseKalman", "cvKalmanPredict", "cvKalmanCorrect", .. // No more exists
    "BackgrdSub___funcall__", "new_BackgrdSub", .. // No more exists
    "new_BackgrdSubMOG", "BackgrdSubMOG_update", "BackgrdSubMOG_initialize", "BackgrdSubMOG_info", .. // No more exists
    "new_BackgrdSubMOG2", "BackgrdSubMOG2_update", "BackgrdSubMOG2_getBackgroundImage", "BackgrdSubMOG2_initialize", "BackgrdSubMOG2_info", .. // No more exists
    "new_BackgrdSubGMG", "BackgrdSubGMG_info", "BackgrdSubGMG_initialize", "BackgrdSubGMG_update", "BackgrdSubGMG_release", "BackgrdSubGMG_maxFeatures_set", "BackgrdSubGMG_maxFeatures_get", "BackgrdSubGMG_learningRate_set", "BackgrdSubGMG_learningRate_get", "BackgrdSubGMG_numInitializationFrames_set", "BackgrdSubGMG_numInitializationFrames_get", "BackgrdSubGMG_quantizationLevels_set", "BackgrdSubGMG_quantizationLevels_get", "BackgrdSubGMG_backgroundPrior_set", "BackgrdSubGMG_backgroundPrior_get", "BackgrdSubGMG_decisionThreshold_set", "BackgrdSubGMG_decisionThreshold_get", "BackgrdSubGMG_smoothingRadius_set", "BackgrdSubGMG_smoothingRadius_get", "BackgrdSubGMG_updateBackgroundModel_set", "BackgrdSubGMG_updateBackgroundModel_get", .. // No more exists
    "initModule_features2d", "delete_FeatureDetector", "FeatureDetector_detect", "FeatureDetector_empty", "FeatureDetector_create", .. // No more exists
    "delete_DescriptorExtractor", "DescriptorExtractor_compute", "DescriptorExtractor_descriptorSize", "DescriptorExtractor_descriptorType", "DescriptorExtractor_empty", "DescriptorExtractor_create", .. // No more exists
    "Feature2D___funcall__", "Feature2D_create", ..
    "BRISK_descriptorSize", "BRISK_descriptorType", "BRISK___funcall__", "BRISK_info", "new_BRISK", "BRISK_generateKernel", .. // No more exists
    "new_ORB", "ORB_descriptorSize", "ORB_descriptorType", "ORB___funcall__", "ORB_info", .. // No more exists
    "new_MSER", "MSER___funcall__", "MSER_info", .. // No more exists
    "new_StarDetector", "StarDetector___funcall__", "StarDetector_info", .. // No more exists
    "FASTX", .. // No more exists
    "new_FastFeatureDetector", "FastFeatureDetector_info", .. // No more exists
    "new_GFTTDetector", "GFTTDetector_info", .. // No more exists
    "new_SimpleBlobDetector", "SimpleBlobDetector_read", "SimpleBlobDetector_write", .. // No more exists
    "new_DenseFeatureDetector", "DenseFeatureDetector_info", "delete_DenseFeatureDetector", .. // No more exists
    "new_GridAdaptedFeatureDetector", "GridAdaptedFeatureDetector_empty", "GridAdaptedFeatureDetector_info", "delete_GridAdaptedFeatureDetector", .. // No more exists
    "new_PyramidAdaptedFeatureDetector", "PyramidAdaptedFeatureDetector_empty", "delete_PyramidAdaptedFeatureDetector", .. // No more exists
    "delete_AdjusterAdapter", "AdjusterAdapter_tooFew", "AdjusterAdapter_tooMany", "AdjusterAdapter_good", "AdjusterAdapter_clone", "AdjusterAdapter_create", .. // No  more exists
    "new_DynamicAdaptedFeatureDetector", "DynamicAdaptedFeatureDetector_empty", "delete_DynamicAdaptedFeatureDetector", .. // No more exists
    "new_FastAdjuster", "FastAdjuster_tooFew", "FastAdjuster_tooMany", "FastAdjuster_good", "FastAdjuster_clone", "delete_FastAdjuster", .. // No more exists
    "new_StarAdjuster", "StarAdjuster_tooFew", "StarAdjuster_tooMany", "StarAdjuster_good", "StarAdjuster_clone", "delete_StarAdjuster", .. // No more exists
    "new_SurfAdjuster", "SurfAdjuster_tooFew", "SurfAdjuster_tooMany", "SurfAdjuster_good", "SurfAdjuster_clone", "delete_SurfAdjuster", .. // No more exists
    "windowedMatchingMask", "new_OpponentColorDescriptorExtractor", "OpponentColorDescriptorExtractor_read", "OpponentColorDescriptorExtractor_write", "OpponentColorDescriptorExtractor_descriptorSize", "OpponentColorDescriptorExtractor_descriptorType", "OpponentColorDescriptorExtractor_empty", "delete_OpponentColorDescriptorExtractor", .. // No more exists
    "BFMatcher_info", ..
    "new_DrawMatchesFlags", "delete_DrawMatchesFlags", "evaluateGenericDescriptorMatcher", ..
    "FeatureEvaluator_clone", "FeatureEvaluator_getFeatureType", "FeatureEvaluator_setWindow"
];

ignoredPatterns = [
"BaseRowFilter", "BaseColumnFilter", "BaseFilter", .. // No more exported, see: modules/imgproc/src/filterengine.hpp
"CvHaarFeature", "HaarStgClsf", "HaarClsfrCasd", "CvAvgComp", "LSVMFilterPos", "LSVMFilterObj", "LatentSvmDet", .. // No more exists
"FeatureEvaluator" // CvFeatureEvaluator & CvFeatureParams
];

renamedFunctions = [];
// OpenCV 2.4.13: defined in opencv2/core/core.hpp
// OpenCV 4.8.1: defined in opencv2/core.hpp
renamedFunctions = [renamedFunctions;
                    "Mahalonobis", "Mahalanobis";
                    "randShuffle_", "randShuffle";
                    "PCAComputeVar", "PCACompute"];

missing = 0;
for iFunc=1:size(scicvFunctions, 1)
    funcName = scicvFunctions(iFunc, 1);
    if or(ignored == funcName) then
        [flag, errmsg] = assert_checkequal(exists(funcName), 0);
        if ~flag then
            error("Function listed as ignored but exists: " + funcName);
        end
        continue
    end
    found = %F;
    for pattern = ignoredPatterns
        if strindex(funcName, pattern)<>[] then
            found = %T;
            break
        end
    end
    if found then
        [flag, errmsg] = assert_checkequal(exists(funcName), 0);
        if ~flag then
            error("Function listed as ignored pattern but exists: " + funcName);
        end
        continue
    end

    if or(renamedFunctions(:,1) == funcName) then
        [flag, errmsg] = assert_checkequal(exists(funcName), 0);
        if ~flag then
            error("Function listed as renamed but exists: " + funcName);
        end
        funcName = renamedFunctions(renamedFunctions(:,1) == funcName, 2);
    end 

    [flag, errmsg] = assert_checkequal(exists(funcName), 1);
    if ~flag then
        disp(funcName);
        missing = missing + 1;
    end
end
assert_checkequal(missing, 0);

// Variables
exec(fullfile(get_scicv_path(), "tests", "unit_tests", "variables-0.6.2.txt"), -1);

ignoredVariables = [];

removedVariables = [];
// OpenCV 2.4.13: enum defined inside cv namespace in opencv2/imgproc/imgproc.hpp
// OpenCV 4.8.1: enum defined inside cv namespace in modules/imgproc/src/filterengine.hpp (sources only)
removedVariables = [removedVariables;
                    "KERNEL_GENERAL"; "KERNEL_SYMMETRICAL"; "KERNEL_ASYMMETRICAL"; "KERNEL_SMOOTH"; "KERNEL_INTEGER"];
// OpenCV 2.4.13: enum defined inside cv namespace in opencv2/imgproc/imgproc.hpp
removedVariables = [removedVariables;
                    "GHT_POSITION"; "GHT_ROTATION"; "GHT_SCALE"];
// OpenCV 2.4.13: enum defined inside cv namespace in opencv2/core/core.hpp
// OpenCV 4.8.1: enum defined inside cv::_OutputArray class in opencv2/core/core.hpp (but this class is ignored)
removedVariables = [removedVariables;
                    "DEPTH_MASK_8U"; "DEPTH_MASK_8S"; "DEPTH_MASK_16U"; "DEPTH_MASK_16S"; "DEPTH_MASK_32S"; "DEPTH_MASK_32F"; "DEPTH_MASK_64F"; "DEPTH_MASK_ALL"; "DEPTH_MASK_A_BUT_8S"; "DEPTH_MASK_FLT"];
// OpenCV 2.4.13: defined in opencv2/core/types_c.h
// OpenCV 4.8.1: opencv2/core/hal/interface.h => #define CV_USRTYPE1 (void)"CV_USRTYPE1 support has been dropped in OpenCV 4.0"
removedVariables = [removedVariables;
                    "CV_USRTYPE1"];
// OpenCV 2.4.13: defined in opencv2/core/types_c.h
removedVariables = [removedVariables;
                    "CV_VFP";
                    "CV_SUBDIV2D_VIRTUAL_POINT_FLAG";
                    "CV_MAX_DIM_HEAP"];
// OpenCV 2.4.13: defined in opencv2/objdetect/objdetect.hpp
removedVariables = [removedVariables;
                    "CV_TYPE_NAME_HAAR";
                    "CV_HAAR_DO_CANNY_PRUNING"; "CV_HAAR_SCALE_IMAGE"; "CV_HAAR_FIND_BIGGEST_OBJECT"; "CV_HAAR_DO_ROUGH_SEARCH";
                    "CV_HAAR_MAGIC_VAL"];
// OpenCV 2.4.13: defined in opencv2/core/types_c.h
// OpenCV 4.8.1: defined in opencv2/core/types_c.h (commented out / inside #if 0)
removedVariables = [removedVariables;
                    "CV_STORAGE_READ"; "CV_STORAGE_WRITE"; "CV_STORAGE_WRITE_TEXT"; "CV_STORAGE_WRITE_BINARY"; "CV_STORAGE_APPEND"; "CV_STORAGE_MEMORY"; "CV_STORAGE_FORMAT_MASK"; "CV_STORAGE_FORMAT_AUTO"; "CV_STORAGE_FORMAT_XML"; "CV_STORAGE_FORMAT_YAML";
                    "CV_NODE_NONE"; "CV_NODE_INT"; "CV_NODE_INTEGER"; "CV_NODE_REAL"; "CV_NODE_FLOAT"; "CV_NODE_STR"; "CV_NODE_STRING"; "CV_NODE_REF"; "CV_NODE_SEQ"; "CV_NODE_MAP"; "CV_NODE_TYPE_MASK"; "CV_NODE_FLOW"; "CV_NODE_USER"; "CV_NODE_EMPTY"; "CV_NODE_NAMED"; "CV_NODE_SEQ_SIMPLE"];
// OpenCV 2.4.13: defined in opencv2/highgui/highgui_c.h
removedVariables = [removedVariables;
                    "CV_CVTIMG_FLIP"; "CV_CVTIMG_SWAP_RB";
                    "CV_CAP_ANDROID_ANTIBANDING_50HZ"; "CV_CAP_ANDROID_ANTIBANDING_60HZ"; "CV_CAP_ANDROID_ANTIBANDING_AUTO"; "CV_CAP_ANDROID_ANTIBANDING_OFF";
                    "CV_CAP_ANDROID_COLOR_FRAME_BGR"; "CV_CAP_ANDROID_COLOR_FRAME"; "CV_CAP_ANDROID_GREY_FRAME"; "CV_CAP_ANDROID_COLOR_FRAME_RGB"; "CV_CAP_ANDROID_COLOR_FRAME_BGRA"; "CV_CAP_ANDROID_COLOR_FRAME_RGBA";
                    "CV_CAP_ANDROID_FLASH_MODE_AUTO"; "CV_CAP_ANDROID_FLASH_MODE_OFF"; "CV_CAP_ANDROID_FLASH_MODE_ON"; "CV_CAP_ANDROID_FLASH_MODE_RED_EYE"; "CV_CAP_ANDROID_FLASH_MODE_TORCH";
                    "CV_CAP_ANDROID_FOCUS_MODE_AUTO"; "CV_CAP_ANDROID_FOCUS_MODE_CONTINUOUS_PICTURE"; "CV_CAP_ANDROID_FOCUS_MODE_CONTINUOUS_VIDEO"; "CV_CAP_ANDROID_FOCUS_MODE_EDOF"; "CV_CAP_ANDROID_FOCUS_MODE_FIXED"; "CV_CAP_ANDROID_FOCUS_MODE_INFINITY"; "CV_CAP_ANDROID_FOCUS_MODE_MACRO";
                    "CV_CAP_ANDROID_WHITE_BALANCE_AUTO"; "CV_CAP_ANDROID_WHITE_BALANCE_CLOUDY_DAYLIGHT"; "CV_CAP_ANDROID_WHITE_BALANCE_DAYLIGHT"; "CV_CAP_ANDROID_WHITE_BALANCE_FLUORESCENT"; "CV_CAP_ANDROID_WHITE_BALANCE_INCANDESCENT"; "CV_CAP_ANDROID_WHITE_BALANCE_SHADE"; "CV_CAP_ANDROID_WHITE_BALANCE_TWILIGHT"; "CV_CAP_ANDROID_WHITE_BALANCE_WARM_FLUORESCENT";
                    "CV_CAP_PROP_MONOCROME"; "CV_CAP_PROP_WHITE_BALANCE_U"; "CV_CAP_PROP_WHITE_BALANCE_V"];
// OpenCV 2.4.13: defined in opencv2/objdetect/objdetect.hpp
removedVariables = [removedVariables;
                    "FeatureEvaluator_HAAR"; "FeatureEvaluator_HOG"; "FeatureEvaluator_LBP"; "CV_HAAR_FEATURE_MAX"];

renamedVariables = [];
// OpenCV 2.4.13: enum defined inside cv namespace in opencv2/core/mat.hpp
// OpenCV 4.8.1: enum defined inside cv::Mat class in opencv2/core/mat.hpp
renamedVariables = [renamedVariables;
                    "MAGIC_MASK", "Mat_MAGIC_MASK";
                    "TYPE_MASK", "Mat_TYPE_MASK";
                    "DEPTH_MASK", "Mat_DEPTH_MASK"];
// OpenCV 2.4.13: enum is defined inside cv namespace in opencv2/contrib/contrib.hpp
// OpenCV 4.8.1: enum is defined inside cv::Odometry class in opencv2/rgbd/depth.hpp
renamedVariables = [renamedVariables;
                    "ROTATION", "Odometry_ROTATION";
                    "TRANSLATION", "Odometry_TRANSLATION";
                    "RIGID_BODY_MOTION", "Odometry_RIGID_BODY_MOTION"];

missing = 0;
for iVar=1:size(scicvVariables, "*")
    varName = scicvVariables(iVar);
    if or(ignoredVariables == varName) then
        [flag, errmsg] = assert_checkequal(exists(varName), 0);
        if ~flag then
            error("Variable listed as ignored but exists: " + varName);
        end
        continue
    end
    if or(removedVariables == varName) then
        [flag, errmsg] = assert_checkequal(exists(varName), 0);
        if ~flag then
            error("Variable listed as removed but exists: " + varName);
        end
        continue
    end

    if or(renamedVariables(:,1) == varName) then
        [flag, errmsg] = assert_checkequal(exists(varName), 0);
        if ~flag then
            error("Variable listed as renamed but exists: " + varName);
        end
        varName = renamedVariables(renamedVariables(:,1) == varName, 2);
    end 

    [flag, errmsg] = assert_checkequal(exists(varName), 1);
    if ~flag then
        disp(varName);
        missing = missing + 1;
    end
end
assert_checkequal(missing, 0);
