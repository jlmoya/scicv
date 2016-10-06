// <-- CLI SHELL MODE -->
scicv_Init();

img = imread("data/images/blobs.jpg");

detector = new_SimpleBlobDetector();

keyPoints = FeatureDetector_detect(detector, img);

// TODO fix extract operator KeyPoints(:)
assert_checkfalse(isempty(cvGetKeyPoints(keyPoints)));

delete_SimpleBlobDetector(detector);
