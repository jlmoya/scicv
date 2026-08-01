#!/usr/bin/env bash
# Fetch the MobileNetV2 ONNX classifier + ImageNet labels for
# classify_image.sce / camera_classify.sce.
#
# Same shape as the engine's fetch-thirdparty.sh: pinned URLs, sha256-verified,
# idempotent. Downloads are NOT committed -- they are ~14 MB of binary that does
# not belong in git.
#
# OpenCV 5 removed the Darknet and Caffe importers, so an ONNX model is not a
# preference here, it is the only option that loads.
#
#   ./fetch-model.sh          # fetch + verify
#   ./fetch-model.sh --print  # print the sha256 of what is on disk and exit
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SUMS="$HERE/models.sha256"

MODEL_URL="https://github.com/onnx/models/raw/main/validated/vision/classification/mobilenet/model/mobilenetv2-12.onnx"
LABEL_URL="https://raw.githubusercontent.com/onnx/models/main/validated/vision/classification/synset.txt"

fetch() {  # <url> <dest>
    # Progress goes to stderr, not stdout: --print's stdout is the payload
    # (shasum's own output, meant to be redirected straight into
    # models.sha256), and fetch-thirdparty.sh's fetch() keeps the same split
    # for the same reason -- mixing the two corrupts the checksum file with
    # "fetching …" lines on a cold run when stdout is redirected.
    if [ -f "$2" ]; then
        echo "have $(basename "$2")" >&2
        return
    fi
    echo "fetching $(basename "$2")…" >&2
    curl -fsSL --retry 3 -o "$2.part" "$1"
    mv "$2.part" "$2"
}

fetch "$MODEL_URL" "$HERE/mobilenetv2-12.onnx"
fetch "$LABEL_URL" "$HERE/synset.txt"

if [ "${1:-}" = "--print" ]; then
    ( cd "$HERE" && shasum -a 256 mobilenetv2-12.onnx synset.txt )
    exit 0
fi

if [ ! -f "$SUMS" ]; then
    echo "ERROR: $SUMS missing. Record the pins with:  ./fetch-model.sh --print > models.sha256" >&2
    exit 1
fi

( cd "$HERE" && shasum -a 256 -c models.sha256 )
echo "OK — model and labels verified."
