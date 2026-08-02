// Scilab Computer Vision Module
//
// detect_common.sce -- YOLOX loading + decode + NMS + draw, shared by
// detect_image.sce (still image, fully self-verifiable) and
// camera_detect.sce (live camera loop), and reused as-is (via exec, not
// copied) by camera_lab's lab6_detect_still.sce / lab7_detect_realtime.sce.
// This is the ONLY place the preprocessing, the anchor-grid decode math,
// and NMS are written down, so none of the four callers can silently drift
// from whatever detect_image.sce verified.
//
// Not a runnable entry point: no exit() at top level, no exit() reachable
// except from inside a function, and callers exec() it, they do not run it
// with -f. Function definitions only below.
//
// --- Route, and why (see detection-spike-report.md for the full spike) ----
// OpenCV's DetectionModel/DetectionModel_detect is a dead end here:
// new_DetectionModel() throws a getLayer assertion at construction for
// every ONNX detector tried (ssd_mobilenet_v1_10, nanodet, yolox) -- OpenCV
// 5's ONNX importer never produces the fused Caffe-style DetectionOutput
// layer that class expects, so this is architectural, not a missing
// typemap. NMSBoxes is separately unusable: its `bboxes` INPUT is bound by
// the exact same shared typemap rule written for DetectionModel::detect's
// `boxes` OUTPUT (no const/name scoping), so the typemap treats it as
// numinputs=0 and silently discards whatever the caller passes -- confirmed
// in the wrapper source, not inferred. Hence this file writes both the
// decode and NMS by hand in Scilab, driven off Net_forward's raw tensor:
//   readNet -> blobFromImage -> Net_setInput -> Net_forward -> cvMatExtract
//   -> decode (this file) -> NMS (this file) -> draw (this file)
//
// Model: object_detection_yolox_2022nov.onnx (OpenCV Zoo). Anchor-free,
// single clean [1 x 8400 x 85] output, confirmed by both Net_dump and a
// real Net_forward call in the spike -- the only one of three ONNX
// detectors tried with no dtype/layout fight against blobFromImage.
// 8400 = 80x80 (stride 8) + 40x40 (stride 16) + 20x20 (stride 32), the
// three YOLOX FPN levels concatenated in that order; 85 = 4 box
// deltas + 1 objectness + 80 COCO class scores.
//
// N-D extraction (cvMatExtract on this [1x8400x85] tensor) needed its own
// fix first (nd-mat-fix-report.md, commit 0131e0457dd) -- cvMatExtract used
// to silently return zero real bytes for any Mat with dims>2 because
// OpenCV reports rows/cols as -1/-1 for such Mats. Without that fix nothing
// below would have real numbers to decode.
//
// --- Preprocessing: confirmed from OpenCV Zoo's own demo, not assumed ----
// Fetched and read models/object_detection_yolox/{yolox.py,demo.py} from
// https://github.com/opencv/opencv_zoo (main, 2026-08-02) rather than
// guessing. Two things worth stating plainly because they are easy to get
// wrong by analogy with classify_common.sce's MobileNetV2 preprocessing:
//   - Color order is RGB, not BGR. demo.py does
//     `cv.cvtColor(image, cv.COLOR_BGR2RGB)` before feeding the model --
//     yolox.py's preprocess() itself is just an HWC->CHW transpose, it does
//     no color conversion of its own. Scilab Mats from imread/
//     VideoCapture_read are BGR (OpenCV''s own convention), so this needs
//     swapRB=%t on blobFromImage, exactly like classify_common.sce''s
//     MobileNetV2 call -- verified empirically (scratchpad probe) that
//     swapRB=%t on a BGR source Mat gives a blob whose channel 0 matches
//     the source''s R value and channel 2 matches its B value.
//   - No mean subtraction, no scaling: yolox.py''s preprocess() is
//     `np.transpose(img, (2,0,1))[np.newaxis]` and nothing else -- the
//     self.mean/self.std fields it defines are DEAD CODE, never read
//     anywhere in preprocess() or infer(). So scalefactor=1.0, mean=0.
//   - Resize is letterbox (aspect-ratio-preserving resize + pad with grey
//     114 on the bottom/right only), NOT blobFromImage''s own stretch
//     resize: demo.py''s letterbox() computes
//     ratio = min(640/h, 640/w), resizes to (h*ratio, w*ratio), and pastes
//     into a 640x640 canvas pre-filled with 114 at the top-left corner
//     (padding added only on the bottom and right). A plain
//     blobFromImage(img, ..., [640,640], ...) stretch-resize would distort
//     non-square images (bus.jpg is 1080x810) and the grid math below is
//     only correct in the letterboxed 640x640 coordinate space, so this
//     file reproduces the letterbox by hand with resize()+copyMakeBorder()
//     before ever calling blobFromImage. Because padding is bottom/right
//     only, undoing it back to original-image pixel coordinates is a
//     single division by `ratio` -- no offset subtraction needed.
//
// --- Two more traps confirmed against the generated wrapper, not the docs -
//   - resize()''s `size` argument is [height, width], THE SAME as
//     blobFromImage''s, even though resize.xml''s own docstring claims
//     [width, height] -- checked the actual typemap
//     (Size_typemaps.i: `size->height = piValues[0]`), which is shared,
//     unscoped, by every cv::Size parameter in this codebase. The doc is
//     stale; the typemap is what runs. Confirmed by resize()ing bus.jpg
//     ([1080,810]) with size=[640,480] and getting back a 640-row,
//     480-col Mat.
//   - Rect and Point, unlike Size, are NOT flipped: both are plain
//     [x, y, ...] in normal image (column, row) order (Rect_typemaps.i /
//     Point_SciDouble.swg: `rect->x = piValues[0]`). So the boxes this file
//     decodes ([x, y, w, h], already in that order) pass straight into
//     rectangle() with no coordinate juggling.
//
// --- YOLOX decode math, confirmed against opencv_zoo''s yolox.py
//     generateAnchors()/postprocess(), not just the task brief''s paraphrase:
//   cx = (dx + grid_x) * stride
//   cy = (dy + grid_y) * stride
//   w  = exp(dw) * stride
//   h  = exp(dh) * stride
//   score = objectness * max(class_scores)
// grid_x/grid_y walk each stride''s feature map in row-major order (x/column
// fastest) -- yolox_grid() below builds exactly that pattern with
// repmat/kron, hand-verified against a small 2x2 case before trusting it on
// the real 8400-row tensor.

// yolox_load_net -- load the ONNX detector from <here>/object_detection_yolox_2022nov.onnx.
// FAILs (prints a reason and exit(1), never returns) if the model is
// missing or readNet comes back empty -- same contract as
// mobilenetv2_load_net in demos/camera_classify/classify_common.sce.
function net = yolox_load_net(here)
    model_path = fullfile(here, "object_detection_yolox_2022nov.onnx");
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

// yolox_load_classes -- load the 80 COCO class names from
// <here>/coco_classes.txt, in the exact order this model''s 85-value output
// uses them (index 6..85 of each row).
function classes = yolox_load_classes(here)
    labels_path = fullfile(here, "coco_classes.txt");
    if ~isfile(labels_path) then
        mprintf("FAIL: labels missing. Run %s first.\n", fullfile(here, "fetch-model.sh"));
        exit(1);
    end
    classes = mgetl(labels_path);
    if size(classes, "*") <> 80 then
        mprintf("FAIL: %s holds %d labels, expected 80\n", labels_path, size(classes, "*"));
        exit(1);
    end
endfunction

// yolox_stride_layout -- purely descriptive: [stride, feature-map side,
// row count] for the three FPN levels YOLOX concatenates into its 8400
// output rows, in the order they are concatenated. Exists so callers (in
// particular camera_lab''s lab6, which wants the grid structure visible
// rather than magic) do not have to hand-recompute 640/stride themselves.
function layout = yolox_stride_layout()
    layout = [8, 80, 6400; 16, 40, 1600; 32, 20, 400];
endfunction

// yolox_grid -- per-row (grid_x, grid_y, stride) for all 8400 anchor rows,
// in the SAME order Net_forward emits them: stride-8 block first, then
// stride-16, then stride-32; within a block, row-major over the feature
// map (column/x index cycles fastest). Recomputed on every call rather
// than cached -- it is three tiny vectorized repmat/kron calls (no
// 8400-iteration loop), cheap enough that a persistent cache would only add
// state to reason about for no measurable benefit.
//
// The repmat/kron pattern was hand-verified on a small 2x2 case before
// trusting it here (scratchpad probe): for a fsize x fsize block, flat
// index k (0-based) must decode to grid_x = mod(k,fsize) (fastest-varying),
// grid_y = floor(k/fsize) (slowest-varying) -- repmat(cols,1,fsize) walks
// 0..fsize-1 repeatedly (matches grid_x), kron(cols,ones(1,fsize)) repeats
// each of 0..fsize-1 contiguously fsize times (matches grid_y).
function [gx, gy, st] = yolox_grid()
    layout = yolox_stride_layout();
    gx = []; gy = []; st = [];
    for i = 1:3
        s = layout(i, 1);
        fsize = layout(i, 2);
        cols = 0:(fsize - 1);
        gxb = repmat(cols, 1, fsize)';
        gyb = kron(cols, ones(1, fsize))';
        gx = [gx; gxb];
        gy = [gy; gyb];
        st = [st; s * ones(fsize * fsize, 1)];
    end
endfunction

// yolox_decode -- run one BGR frame (from imread OR VideoCapture_read)
// through the net and return every candidate box that clears
// score_thresh, BEFORE NMS. Boxes are [x, y, w, h] in ORIGINAL image pixel
// coordinates (already unletterboxed and clipped to the image bounds), one
// row per surviving candidate; scores/classids/strides are column vectors
// of the same length. classids are 1-based, directly usable as
// classes(classids(i)). Does not modify or delete `frame` -- caller owns
// it, same convention as mobilenetv2_classify.
function [boxes, scores, classids, strides] = yolox_decode(net, frame, score_thresh)
    TARGET = 640;

    sz = size(frame);           // [rows, cols] == [height, width]
    imgH = sz(1); imgW = sz(2);

    // Letterbox: aspect-ratio-preserving resize, then pad to 640x640 with
    // grey (114,114,114) on the bottom/right only -- see the file header
    // for why this, and not blobFromImage''s own stretch-resize.
    ratio = min(TARGET / imgH, TARGET / imgW);
    newH = int(imgH * ratio);
    newW = int(imgW * ratio);
    resized = resize(frame, [newH, newW]);
    padded = copyMakeBorder(resized, 0, TARGET - newH, 0, TARGET - newW, ..
        BORDER_CONSTANT, [114, 114, 114]);

    // scale=1.0, mean=0: YOLOX''s own preprocess() does neither (see file
    // header). swapRB=%t: source Mat is BGR, YOLOX wants RGB.
    blob = blobFromImage(padded, 1.0, [TARGET, TARGET], [0, 0, 0, 0], %t, %f);

    Net_setInput(net, blob);
    out = Net_forward(net);            // [1 x 8400 x 85], CV_32F

    // matrix() reshape on the extracted hypermat: for a [1,N,M] tensor this
    // is a straight reinterpretation (dim-1 contributes nothing to the
    // column-major offset), hand-verified against known-good per-element
    // values from nd-mat-fix-report.md''s own yolox_check.sce run before
    // being trusted here.
    raw = matrix(cvMatExtract(out), 8400, 85);

    delete_Mat(out);
    delete_Mat(blob);
    delete_Mat(padded);
    delete_Mat(resized);

    dx = raw(:, 1); dy = raw(:, 2); dw = raw(:, 3); dh = raw(:, 4);
    obj = raw(:, 5);
    clsScores = raw(:, 6:85);
    // max(A,"c") reduces ACROSS columns, i.e. one result per ROW -- exactly
    // the per-anchor class argmax wanted here. ("r" would reduce down
    // columns instead; verified both directions empirically before use.)
    [clsMax, clsIdx] = max(clsScores, "c");

    [gx, gy, st] = yolox_grid();

    cx = (dx + gx) .* st;
    cy = (dy + gy) .* st;
    bw = exp(dw) .* st;
    bh = exp(dh) .* st;

    // Unletterbox: divide by ratio. No offset subtraction -- the letterbox
    // padding above was added only on the bottom/right, so the top-left
    // origin is shared between the padded-640 space and the original image.
    cx = cx / ratio; cy = cy / ratio; bw = bw / ratio; bh = bh / ratio;

    x = cx - bw / 2;
    y = cy - bh / 2;
    score = obj .* clsMax;

    mask = score >= score_thresh;
    x = x(mask); y = y(mask); bw = bw(mask); bh = bh(mask);
    scores = score(mask); classids = clsIdx(mask); strides = st(mask);

    // A live camera frame routinely clears NO box above threshold (dark,
    // out of focus, nothing recognizable in view) -- unlike bus.jpg, which
    // always has candidates. max()/min() against an empty matrix errors in
    // Scilab ("null matrix (argument #1)") rather than returning an empty
    // result, so this has to be its own early return, not just a filter
    // that happens to produce zero rows further down. Confirmed reproducing
    // live: camera_detect.sce's first run hit exactly this on a frame with
    // zero candidates before this guard was added.
    if isempty(x) then
        boxes = zeros(0, 4);
        scores = []; classids = []; strides = [];
        return;
    end

    // Clip to image bounds. A grid-order or unletterbox bug tends to
    // produce boxes that are off-image or absurdly sized -- clipping here
    // does not hide that (a badly wrong box still ends up degenerate or
    // pinned to an edge, visible in the printed list) but it does guarantee
    // every SURVIVING box is a legitimate sub-rectangle of the image, which
    // is what detect_image.sce asserts.
    x1 = max(x, 0); y1 = max(y, 0);
    x2 = min(x + bw, imgW); y2 = min(y + bh, imgH);
    bw = x2 - x1; bh = y2 - y1;
    x = x1; y = y1;

    valid = (bw > 0) & (bh > 0);
    x = x(valid); y = y(valid); bw = bw(valid); bh = bh(valid);
    scores = scores(valid); classids = classids(valid); strides = strides(valid);

    boxes = [x, y, bw, bh];
endfunction

// yolox_iou -- IoU of box b1 (1x4 [x,y,w,h]) against every row of b2 (Nx4).
// Returns an Nx1 column. Standard axis-aligned intersection-over-union; the
// +1e-9 guards a divide-by-zero for two degenerate zero-area boxes, which
// should not occur after yolox_decode''s bw>0/bh>0 filter but costs nothing
// to guard anyway.
function v = yolox_iou(b1, b2)
    ix1 = max(b1(1), b2(:, 1));
    iy1 = max(b1(2), b2(:, 2));
    ix2 = min(b1(1) + b1(3), b2(:, 1) + b2(:, 3));
    iy2 = min(b1(2) + b1(4), b2(:, 2) + b2(:, 4));
    iw = max(ix2 - ix1, 0);
    ih = max(iy2 - iy1, 0);
    inter = iw .* ih;
    a1 = b1(3) * b1(4);
    a2 = b2(:, 3) .* b2(:, 4);
    v = inter ./ (a1 + a2 - inter + 1e-9);
endfunction

// yolox_nms -- greedy NMS, APPLIED PER CLASS (a box is only ever suppressed
// by another box of the SAME class): sort by score descending, keep the
// top box, drop every remaining box of that class whose IoU with it
// exceeds iou_thresh, repeat on what is left. Returns a ROW vector of
// indices into boxes/scores/classids/strides, sorted by score descending
// across all classes.
//
// NMSBoxes is not used here -- confirmed unusable from Scilab: its
// `bboxes` input is bound by the same shared, unscoped typemap rule
// written for DetectionModel::detect''s `boxes` OUTPUT, so the generated
// wrapper treats it as numinputs=0 and silently discards whatever the
// caller passes (see detection-spike-report.md). This is a plain,
// independent reimplementation, not a workaround built on top of it.
//
// Deliberately returns a ROW vector: Scilab''s `for i = V` iterates over
// the COLUMNS of V, so a column vector would iterate exactly ONCE with `i`
// bound to the whole column, not once per element -- confirmed empirically
// before relying on it. Every caller here iterates results via
// `for k = 1:size(keep,"*")` rather than `for i = keep` specifically to
// sidestep that trap regardless, but keep is kept row-shaped anyway so it
// behaves as expected if used the more obvious way too.
function keep = yolox_nms(boxes, scores, classids, iou_thresh)
    keep = [];
    ucls = unique(classids);
    for ci = 1:size(ucls, "*")
        c = ucls(ci);
        idx = find(classids == c);     // row vector of positions for this class
        b = boxes(idx, :);
        s = scores(idx);

        [sv, order] = gsort(s, "g", "d");
        active = order;
        localkeep = [];
        while ~isempty(active)
            i0 = active(1);
            localkeep = [localkeep, i0];
            if size(active, "*") == 1 then
                break;
            end
            rest = active(2:$);
            ious = yolox_iou(b(i0, :), b(rest, :));
            active = rest(ious <= iou_thresh);
        end
        keep = [keep, idx(localkeep)];
    end
    if ~isempty(keep) then
        [sv2, o] = gsort(scores(keep), "g", "d");
        keep = keep(o);
    end
    keep = matrix(keep, 1, -1);   // force row shape regardless of how it got built
endfunction

// yolox_draw -- draw a green box + "label score" text for each index in
// `keep`, directly into frame''s own pixel buffer (same convention as
// putText elsewhere in this codebase: it draws into the Mat, it does not
// return a new one or touch a window).
function yolox_draw(frame, boxes, scores, classids, classes, keep)
    for k = 1:size(keep, "*")
        i = keep(k);
        x = boxes(i, 1); y = boxes(i, 2); bw = boxes(i, 3); bh = boxes(i, 4);
        label = classes(classids(i));
        rectangle(frame, [x, y, bw, bh], [0, 255, 0], 2);
        txt = msprintf("%s %.2f", label, scores(i));
        putText(frame, txt, [x, max(y - 5, 0)], FONT_HERSHEY_PLAIN, 1.2, [0, 255, 0], 1);
    end
endfunction
