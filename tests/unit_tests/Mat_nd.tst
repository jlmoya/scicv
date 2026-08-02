// Scilab Computer Vision Module

// N-D (Mat::dims > 2) -> Scilab hypermatrix conversion (cvMatExtract, backed
// by SWIG_SciHypermat_FromMat in typemaps/Mat_sciHypermat.swg).
//
// Before this fix, any Mat with more than 2 dimensions -- any dnn blob or
// output tensor, or an N-D Mat generally -- silently extracted as a single,
// uninitialised element and no error: OpenCV freezes Mat::rows/cols at -1
// once dims > 2 (documented behaviour), and the old code unconditionally
// read size = width*height = (-1)*(-1) = 1 from those. The 2-D path (any
// plain image) is untouched by the fix and is covered by Mat.tst; this file
// is the N-D regression guard.

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

scicv_Init();

imgpath = getSampleImage("baboon.png");

// --- 2-D sanity pin (this file's slice of the regression guard; the full
// before/after comparison lives in the task's verification record, not
// here) -- first value of baboon.png's RGB-ordered, column-major-flattened
// pixel data. If this ever changes, either the sample image changed or the
// untouched 2-D path broke.
img = imread(imgpath);
img2d = cvMatExtract(img);
assert_checkequal(size(img2d), [512, 512, 3]);
assert_checkequal(double(img2d(1, 1, 1)), 164);

// --- 4-D: blobFromImage's NCHW blob extracts with the right shape AND the
// right values (not just plausibly-shaped garbage from a transposed copy).
// The blob's spatial size is kept equal to the source image's so
// blobFromImage never resizes -- every output value is then exactly
// predictable from the source pixels, with no interpolation to account for.
// img2d (the 2-D path, untouched by this fix) is the independent ground
// truth: blobFromImage's swapRB=%t and the 2-D path's own BGR->RGB flip put
// both in the same R,G,B channel order, so blob channel c IS img2d channel
// c, just rescaled by 1/255.
blob = blobFromImage(img, 1.0 / 255.0, [512, 512], [0, 0, 0, 0], %t, %f);
assert_checkequal(MatShape_str(Mat_shape(blob)), "[1 x 3 x 512 x 512]");

nd = cvMatExtract(blob);
assert_checkequal(size(nd), [1, 3, 512, 512]);

// Deliberately asymmetric (channel, row, col) triples: distinct row/col
// values catch a H/W transposition, and all 3 channels catch a
// channel/spatial-axis mixup.
checks = [1 1 1; 2 1 1; 3 1 1; 1 512 512; 2 256 300; 3 100 400; 1 300 1; 2 1 500];
for k = 1:size(checks, 1)
    c = checks(k, 1); h = checks(k, 2); w = checks(k, 3);
    expected = double(img2d(h, w, c)) / 255.0;
    assert_checkalmostequal(nd(1, c, h, w), expected, 1e-6);
end

delete_Mat(blob);

// --- a genuinely 3-D, non-image-shaped tensor: reshape a 512x512 grayscale
// Mat's data (unchanged bytes -- reshape is a pure header/metadata change,
// see Mat_reshape's 4-arg int*-array overload) into [8 x 64 x 512], then
// extract. No axis here is a trailing/leading singleton, which also rules
// out the fix silently depending on Scilab's hypermat squeezing a size-1
// axis to happen to look right.
gimg = imread(imgpath, CV_LOAD_IMAGE_GRAYSCALE);
grows = Mat_rows_get(gimg);
gcols = Mat_cols_get(gimg);
g2d = cvMatExtract(gimg);

gnd = Mat_reshape(gimg, 0, 3, [8, grows / 8, gcols]);
assert_checkequal(MatShape_str(Mat_shape(gnd)), "[8 x 64 x 512]");

nd3 = cvMatExtract(gnd);
assert_checkequal(size(nd3), [8, 64, 512]);

// Ground truth: reshape moves no bytes, so element (i0,i1,i2) of the
// reshaped array is exactly the original element at
// row = (i0-1)*64 + i1, col = i2 (all 1-based) -- an exact match is
// expected (no arithmetic on the pixel values, unlike the blob check above).
per = grows / 8;
checks3 = [1 1 1; 1 1 2; 2 1 1; 8 per gcols; 4 30 200; 5 12 7];
for k = 1:size(checks3, 1)
    i0 = checks3(k, 1); i1 = checks3(k, 2); i2 = checks3(k, 3);
    row = (i0 - 1)*per + i1;
    col = i2;
    assert_checkequal(nd3(i0, i1, i2), g2d(row, col));
end

delete_Mat(gnd);
delete_Mat(gimg);
delete_Mat(img);
