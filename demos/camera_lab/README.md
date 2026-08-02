# Camera Lab

A guided, runnable path from "does Scilab even see my camera" to live
object *identification* from the camera feed, in five numbered files you
run one at a time. Each file teaches as it runs -- read its console output,
not just its source, to follow the lesson.

## What you will build

By the end of lab4 you will have a live window showing your camera feed
with a classification label (e.g. `coffee mug (0.87)`) drawn on top of it,
updating frame by frame. lab5 adds the top-5 candidate labels and a
measured frames-per-second number on top of that.

**What this is not:** object *detection* with boxes around several things
at once. Every lab in here uses an image *classifier* (MobileNetV2 /
ImageNet): it looks at the whole frame and produces one label for it, the
same way lab3 does for one still image. See lab3's and lab4's own output
for why, and what it would take to go further.

## Prerequisites

- scicv built and loaded (autoloaded already if you are running the
  packaged `scilab2027` app -- these labs assume that).
- A camera attached, on macOS (`cvCameraAuthStatus`/`cvRequestCameraAccess`
  are a macOS-only gateway; on any other OS they report "authorized"
  unconditionally and every camera lab below just works).
- The MobileNetV2 model and ImageNet labels, fetched once:
  ```bash
  cd demos/camera_classify
  ./fetch-model.sh
  ```
  lab3/lab4/lab5 load these through `classify_common.sce` in that same
  directory -- nothing under `camera_lab/` duplicates them.

## Running order

Run these from the scicv repo root, in order, one at a time. Each is a
standalone batch script -- it prints what it is doing, then exits (0 on
success, 1 on failure with a reason). Read a script's output before moving
to the next one; each one ends by telling you what to run next.

```bash
scilab2027 -nb -f demos/camera_lab/lab1_permission.sce   # permission
scilab2027 -nb -f demos/camera_lab/lab2_one_frame.sce    # capture lifecycle, no ML
scilab2027 -nb -f demos/camera_lab/lab3_classify_still.sce  # inference chain, no camera
scilab2027 -nb -f demos/camera_lab/lab4_realtime.sce     # the payoff: live label overlay
scilab2027 -nb -f demos/camera_lab/lab5_top5_fps.sce     # stretch: top-5 + fps
```

| File | Teaches | Needs camera? | Needs model? |
|---|---|:-:|:-:|
| `lab1_permission.sce` | `cvCameraAuthStatus`/`cvRequestCameraAccess`, and why the first grant must come from the GUI app | no | no |
| `lab2_one_frame.sce` | `new_VideoCapture` / `VideoCapture_read` / cleanup, on their own | yes | no |
| `lab3_classify_still.sce` | the classification chain (`imread` -> `blobFromImage` -> `Net_forward` -> label) on a file | no | yes |
| `lab4_realtime.sce` | the two chains combined: live label overlay on the camera feed | yes | yes |
| `lab5_top5_fps.sce` | top-5 ranking + measured per-frame fps on the live feed | yes | yes |

If you already know `cvCameraAuthStatus()` returns 3 on your machine, you
can skip straight to lab2 -- lab1 will just confirm it and exit 0.

Try lab3 on a different picture without editing anything:
```bash
scilab2027 -nb -e "imgpath=getSampleImage(\"peppers.png\"); expected=\"pepper\";" -f demos/camera_lab/lab3_classify_still.sce
```

## Traps this lab teaches, and where

Each of these is explained in the output of the file that first runs into
it -- this is an index to jump back to, not the lesson itself.

1. Constructors are `new_VideoCapture(...)`, never a bare `VideoCapture(...)` -- lab2.
2. `VideoCapture_read` is 1-in/2-out: `[ok, frame] = VideoCapture_read(cap)` -- lab2.
3. `Size` vectors are `[height, width]`, the opposite of OpenCV C++'s `(width, height)` -- lab3.
4. `imshow`/`namedWindow`/`waitKey` hard-crash Scilab on macOS; this lab uses `scf()`/`matplot()` instead -- lab2 (first display), lab4 (why there is no on-screen "press q").
5. Every native object needs its own destructor (`delete_Mat`, `delete_Net`, `delete_VideoCapture`); `clear` only drops the Scilab variable and leaks the native memory -- lab2 onward.
6. A camera left open stays open -- release on every path, including errors -- lab2 onward (`try`/`catch` around the capture, guaranteed cleanup after).
7. Batch `.sce` files end with `exit(0)`/`exit(1)`; `quit` ignores its argument -- every lab file.
8. The classifier answers "what is this whole frame", one label -- it is not detection. No boxes, no per-object locations -- lab3, restated in lab4.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `cvCameraAuthStatus()` stays 0 after `cvRequestCameraAccess()` | not running inside a LaunchServices-launched app bundle | launch the GUI app itself (Finder or `open -a Scilab-2027.0.0`), not `scilab2027` from a terminal; run lab1 from its console |
| `cvCameraAuthStatus()` returns 1 or 2 | restricted (MDM/parental controls) or denied | System Settings > Privacy & Security > Camera; a repeat request cannot fix either |
| `VideoCapture_isOpened(cap)` is false even though status is 3 | no camera attached, or held exclusively by another app | check System Settings > Privacy & Security > Camera for a Scilab entry, unplug/replug, close other apps using the camera |
| First `VideoCapture_read` calls return `ok = %f` or an empty frame | AVFoundation still settling exposure right after opening | expected -- every lab here retries a few times before giving up; do not treat one empty frame as failure |
| Scilab aborts with `NSInternalInconsistencyException` / "NSWindow should only be instantiated on the main thread" | `imshow`/`namedWindow`/`waitKey` called from `-nw` mode | do not use them; every lab here uses `scf()`/`matplot()`, which is confirmed to work under this invocation |
| A later run reports the camera is busy / will not open | a previous run did not release it (crash, forced kill, `clear` instead of `delete_VideoCapture`) | run `pgrep -fl scilab` and kill any leftover process; then re-run |
| `scilab2027 -nb -f ...` exits 0 even though the script printed FAIL | the script (not one of these five) called `quit` instead of `exit` | not applicable to this lab -- every file here uses `exit(0)`/`exit(1)`; if you copy one as a starting point, keep that convention |
| `FAIL: model missing` | `fetch-model.sh` was never run | `cd demos/camera_classify && ./fetch-model.sh` |
| Script dies instantly with a string-parsing error | an apostrophe inside a `"..."` string (a Scilab parser trap, not specific to this lab) | reword it, or double the quote (`it''s`) the way these lab files do |
