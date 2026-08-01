// Scilab Computer Vision Module
//
// classify_common.sce -- MobileNetV2 loading + inference shared by both
// classify_image.sce (still image, fully self-verifiable) and
// camera_classify.sce (live camera loop). This is the ONLY place the
// preprocessing constants and the load->forward->argmax sequence are
// written down; both demos call these functions rather than each keeping
// their own copy, so the live loop cannot silently drift from whatever
// classify_image.sce verified.
//
// Not a runnable entry point: no exit() at top level, no exit() reachable
// except from inside a function, and callers exec() it, they do not run it
// with -f. Function definitions only below.

// mobilenetv2_load_net -- load the ONNX classifier from <here>/mobilenetv2-12.onnx.
//
// FAILs (prints a reason and exit(1), never returns) if the model is
// missing or readNet comes back empty. exit() here ends the whole process
// immediately, which is exactly what both callers want: neither has a
// meaningful way to continue without a net.
function net = mobilenetv2_load_net(here)
    model_path = fullfile(here, "mobilenetv2-12.onnx");
    if ~isfile(model_path) then
        mprintf("FAIL: model missing. Run %s first.\n", fullfile(here, "fetch-model.sh"));
        exit(1);
    end
    net = readNet(model_path);
    if Net_empty(net) then
        mprintf("FAIL: readNet returned an empty Net for %s\n", model_path);
        exit(1);
    end
endfunction

// mobilenetv2_load_labels -- load the 1000 ImageNet synset labels from
// <here>/synset.txt, in the same order the model's output columns use.
function classes = mobilenetv2_load_labels(here)
    labels_path = fullfile(here, "synset.txt");
    if ~isfile(labels_path) then
        mprintf("FAIL: labels missing. Run %s first.\n", fullfile(here, "fetch-model.sh"));
        exit(1);
    end
    classes = mgetl(labels_path);
    if size(classes, "*") < 1000 then
        mprintf("FAIL: %s holds %d labels, expected 1000\n", labels_path, size(classes, "*"));
        exit(1);
    end
endfunction

// mobilenetv2_classify -- run one BGR frame (from imread OR
// VideoCapture_read, both hand back the same kind of cv::Mat) through the
// net and return the top-1 index/score plus the full 1x1000 score row so a
// caller can also report a top-5.
//
// MobileNetV2 expects 224x224 RGB with per-channel ImageNet normalization:
//     out = (pixel/255 - mean_c) / std_c
// with mean = (0.485, 0.456, 0.406) and std = (0.229, 0.224, 0.225), in RGB
// order because swapRB is on. Rearranged for blobFromImage's
// (pixel - MEAN) * scalefactor:
//     MEAN  = 255 * mean_c            -> exact, blobFromImage takes a Scalar
//     SCALE = 1 / (255 * std_c)       -> per channel, and blobFromImage takes
//                                        only ONE scalefactor for all three
//
// There is no way to apply the per-channel scale afterwards: scicv exposes
// no Mat * Scalar (no Mat___mul__; Mat_mul is cv::Mat::mul against another
// Mat, not a scalar) and Mat_convertTo's alpha is a single scalar too.
// ClassificationModel's setInputScale(Scalar) would do it exactly, but its
// classify() returns through CV_OUT int&/float& out-params and
// typemaps/opencv_typemaps.i has no OUT typemap for those, so the results
// never reach Scilab (confirmed: ClassificationModel_classify is unusable
// from Scilab for this reason).
//
// So use one scale built from the mean of the three stds, 0.226:
//     1 / (255 * 0.226) = 1/57.63
// The three stds span 0.224..0.229, so the per-channel gain error is at most
// 1.3% -- far below what changes a top-1 argmax, and the mean subtraction
// (which dominates) stays exact. OpenCV's own MobileNet samples do the same.
// classify_image.sce's PASS on data/images/baboon.png (top-1 "baboon" at a
// wide margin over the next-closest primate classes) is the check that this
// approximation does not, in fact, move the argmax.
//
// MEAN/SIDE are plain Scilab row vectors, not Scalar(...)/Size(...) calls:
// neither is a real gateway function (grep the generated table -- there is
// no "Scalar" or "Size" entry at all), because
// sci_gateway/c/swig/typemaps/Scalar_typemaps.i and Size_typemaps.i convert
// a 1x2..1x4 Scilab vector straight into a cv::Scalar/cv::Size with no
// wrapped constructor involved. Size is [height, width]
// (Size_typemaps.i:25-26: size->height = piValues[0]); it is written that
// way below even though 224x224 makes the order unobservable here.
function [idx, conf, scores] = mobilenetv2_classify(net, frame)
    MEAN  = [123.675, 116.28, 103.53];
    SCALE = 1.0 / 57.63;
    SIDE  = [224, 224];   // [height, width], NOT OpenCV's (width, height)

    // blobFromImage does resize + swapRB + (x - MEAN) * SCALE in one pass.
    blob = blobFromImage(frame, SCALE, SIDE, MEAN, %t, %f);

    Net_setInput(net, blob);
    out = Net_forward(net);           // 1 x 1000 scores, CV_32F
    // cvMatExtract is scicv's Mat -> Scilab-matrix converter (there is no
    // Mat_to_double); macros/%Mat_e.sci is built on it, so out(:,:) would
    // work too. Measured: for this 1x1000x1 Mat it comes back as a plain
    // 1x1000 double row (the trailing singleton channel dimension does not
    // survive as a hypermat axis), so max() below returns the linear index
    // directly with no reshape needed.
    scores = cvMatExtract(out);

    [conf, idx] = max(scores);

    delete_Mat(out);
    delete_Mat(blob);
endfunction
