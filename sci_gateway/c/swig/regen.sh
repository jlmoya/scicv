#!/usr/bin/env bash
# Regenerate ../scicv_wrap.cxx and ../builder_gateway_c.sce from scicv.i.
#
# WHY A SCRIPT AND NOT `make`
# ---------------------------
# Makefile.in's patch: target was GNU-sed-only -- macOS BSD sed rejects
# `sed '45{s/^/\/\//}'` with "bad flag in substitute command: '}'", and because
# the shell truncates the redirect target first, it left an EMPTY header behind.
# SWIG then "succeeded" against nothing. It also patched cvdef.h line 479, which
# in OpenCV 5.0.0 is `#  endif` -- the edit stopped landing years ago.
#
# THE SHADOW INCLUDE DIRECTORY
# ----------------------------
# SWIG cannot parse cvstd_wrapper.hpp:45 (a variadic-template SFINAE
# declaration) and dies with "Syntax error in input(3)". include/ holds a copy
# with that one line commented out, and -I./include puts it AHEAD of the real
# OpenCV headers. That directory is tracked, so a fresh clone can regenerate;
# it used to exist only on whichever machine had last built here.
#
# WHY -DCV_VERSION_MAJOR / -DCV_VERSION_MINOR
# --------------------------------------------
# No .i file %includes opencv2/core/version.hpp -- a real compile picks up
# CV_VERSION_MAJOR/MINOR transitively through core.hpp, but SWIG's own
# preprocessor does not recurse into a plain #include, so without these
# flags it sees both macros as undefined (=0). videoio.hpp gates two
# deprecated pre-5.x aliases (CAP_PROP_GIGA_FRAME_HEIGH_MAX and
# _SENS_HEIGH) behind `#if CV_VERSION_MAJOR <= 4`; with the macro undefined
# that guard reads true, so SWIG wraps two `cv::` names that don't exist in
# the OpenCV 5 namespace and the generated wrapper fails to compile.
# Defining both from the pkg-config-reported version makes SWIG evaluate the
# guard the same way the real compiler will. (Task 5's job, not this one, to
# make the guard visible more generally by %including version.hpp itself.)
#
#   ./regen.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

PC=/opt/homebrew/bin/pkg-config; command -v "$PC" >/dev/null || PC=pkg-config
OPENCV_PC=""
for n in opencv6 opencv5 opencv4 opencv; do
    if "$PC" --exists "$n" 2>/dev/null; then OPENCV_PC="$n"; break; fi
done
[ -n "$OPENCV_PC" ] || { echo "ERROR: pkg-config found no OpenCV" >&2; exit 1; }
OPENCV_VERSION="$("$PC" --modversion "$OPENCV_PC")"
CV_VERSION_MAJOR="$(echo "$OPENCV_VERSION" | cut -d. -f1)"
CV_VERSION_MINOR="$(echo "$OPENCV_VERSION" | cut -d. -f2)"

# Honour Makefile.in's configure-detected SWIG/OPENCV_INC when the caller
# supplies them (`make build`/`make patch` pass both through as env vars so
# regen.sh doesn't silently fall back to whatever `swig` is first on PATH);
# fall back to our own pkg-config lookup so `./regen.sh` still works
# standalone -- Task 4b calls it directly, not through make.
: "${SWIG:=swig}"
: "${OPENCV_INC:=$("$PC" --cflags "$OPENCV_PC" | tr ' ' '\n' | sed -n 's/^-I//p' | head -1)}"
echo "OpenCV: $OPENCV_VERSION ($OPENCV_PC) at $OPENCV_INC"
echo "SWIG: $SWIG"

# Refresh the shadow from the installed headers. The target line is found by
# CONTENT, not by number: Makefile.in hardcoded 45 and 479, and the 479 one had
# already rotted silently.
mkdir -p include/opencv2/core
src="$OPENCV_INC/opencv2/core/cvstd_wrapper.hpp"
line="$(grep -n 'has_parenthesis_operator_check(typename std::is_same' "$src" | cut -d: -f1 | head -1 || true)"
if [ -z "$line" ]; then
    echo "ERROR: cvstd_wrapper.hpp no longer contains the SFINAE declaration SWIG chokes on." >&2
    echo "       Try regenerating without the shadow; if SWIG now parses it, delete include/." >&2
    exit 1
fi
sed "${line}s|^|// SWIG-parse workaround: |" "$src" > include/opencv2/core/cvstd_wrapper.hpp
echo "patched cvstd_wrapper.hpp line $line"

"$SWIG" -scilab -c++ -builder -I./include -I"$OPENCV_INC" \
     -DCV_VERSION_MAJOR="$CV_VERSION_MAJOR" -DCV_VERSION_MINOR="$CV_VERSION_MINOR" \
     -builderflagscript buildflags.sci -builderverbositylevel 2 scicv.i

# SWIG names its output builder.sce; the toolbox expects builder_gateway_c.sce.
sed 's/builder/builder_gateway_c/' < builder.sce > builder_gateway_c.sce
rm -f builder.sce
mv -f builder_gateway_c.sce ..
mv -f scicv_wrap.cxx ..

echo "regenerated ../scicv_wrap.cxx and ../builder_gateway_c.sce"
echo "gateway table entries: $(grep -c '\.\.$' ../builder_gateway_c.sce)"
