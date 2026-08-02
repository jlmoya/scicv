#!/usr/bin/env bash
# Fetch the YOLOX ONNX detector + 80 COCO class names + a pinned multi-object
# test image for detect_image.sce / camera_detect.sce / camera_lab's
# lab6/lab7.
#
# Same shape as demos/camera_classify/fetch-model.sh: pinned URLs,
# sha256-verified, idempotent. Downloads are NOT committed -- they are
# binary payload that does not belong in git.
#
# Model: object_detection_yolox_2022nov.onnx from OpenCV Zoo. Chosen over
# ssd_mobilenet_v1_10.onnx and object_detection_nanodet_2022nov.onnx after a
# spike (see
# ../../.superpowers/sdd/2026-08-01-camera-and-opencv-dnn/detection-spike-report.md
# in the scilab engine repo) found YOLOX is the only one of the three with a
# single clean [1x8400x85] output and no dtype/layout fight with
# blobFromImage -- the other two either need a fused DetectionOutput layer
# OpenCV 5's ONNX importer does not produce, or need 6 separate named
# tensors decoded through a DFL head.
#
#   ./fetch-model.sh          # fetch + verify
#   ./fetch-model.sh --print  # print the sha256 of what is on disk and exit
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SUMS="$HERE/models.sha256"

MODEL_URL="https://media.githubusercontent.com/media/opencv/opencv_zoo/main/models/object_detection_yolox/object_detection_yolox_2022nov.onnx"
# bus.jpg (ultralytics/yolov5's standard multi-object test image: one bus,
# several people) -- used by detect_image.sce and lab6_detect_still.sce to
# verify the decode against known ground truth. Deliberately NOT one of
# scicv's own data/images/ samples (baboon.png, peppers.png, ...): those are
# single-subject textures with no COCO-class content, so they cannot exercise
# multi-object detection or a class-name check.
IMAGE_URL="https://raw.githubusercontent.com/ultralytics/yolov5/master/data/images/bus.jpg"

fetch() {  # <url> <dest>
    # Progress goes to stderr, not stdout: --print's stdout is the payload
    # (shasum's own output, meant to be redirected straight into
    # models.sha256), so mixing the two corrupts the checksum file with
    # "fetching …" lines on a cold run when stdout is redirected.
    if [ -f "$2" ]; then
        echo "have $(basename "$2")" >&2
        return
    fi
    echo "fetching $(basename "$2")…" >&2
    curl -fsSL --retry 3 -o "$2.part" "$1"
    mv "$2.part" "$2"
}

fetch "$MODEL_URL" "$HERE/object_detection_yolox_2022nov.onnx"
fetch "$IMAGE_URL" "$HERE/bus.jpg"

# The 80 COCO class names, in the exact order this model's 85-value output
# uses them (index 6..85 of each detection row) -- transcribed verbatim from
# opencv_zoo's own demo.py for this model
# (models/object_detection_yolox/demo.py, `classes = (...)` tuple) and
# cross-checked against the per-class AP table in that same directory's
# README.md, which lists the identical order. Not a network fetch (OpenCV
# Zoo ships this list as Python source, not a standalone labels file) but
# still written here, once, and sha256-pinned below like the other two
# assets, so a change to it is as visible as a changed model or image would
# be.
CLASSES="$HERE/coco_classes.txt"
if [ -f "$CLASSES" ]; then
    echo "have $(basename "$CLASSES")" >&2
else
    echo "writing $(basename "$CLASSES")…" >&2
    cat > "$CLASSES.part" <<'EOF'
person
bicycle
car
motorcycle
airplane
bus
train
truck
boat
traffic light
fire hydrant
stop sign
parking meter
bench
bird
cat
dog
horse
sheep
cow
elephant
bear
zebra
giraffe
backpack
umbrella
handbag
tie
suitcase
frisbee
skis
snowboard
sports ball
kite
baseball bat
baseball glove
skateboard
surfboard
tennis racket
bottle
wine glass
cup
fork
knife
spoon
bowl
banana
apple
sandwich
orange
broccoli
carrot
hot dog
pizza
donut
cake
chair
couch
potted plant
bed
dining table
toilet
tv
laptop
mouse
remote
keyboard
cell phone
microwave
oven
toaster
sink
refrigerator
book
clock
vase
scissors
teddy bear
hair drier
toothbrush
EOF
    mv "$CLASSES.part" "$CLASSES"
fi

if [ "${1:-}" = "--print" ]; then
    ( cd "$HERE" && shasum -a 256 object_detection_yolox_2022nov.onnx bus.jpg coco_classes.txt )
    exit 0
fi

if [ ! -f "$SUMS" ]; then
    echo "ERROR: $SUMS missing. Record the pins with:  ./fetch-model.sh --print > models.sha256" >&2
    exit 1
fi

( cd "$HERE" && shasum -a 256 -c models.sha256 )
echo "OK — model, test image, and labels verified."
