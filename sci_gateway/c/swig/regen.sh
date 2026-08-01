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
OPENCV_INC="$("$PC" --cflags "$OPENCV_PC" | tr ' ' '\n' | sed -n 's/^-I//p' | head -1)"
echo "OpenCV: $("$PC" --modversion "$OPENCV_PC") ($OPENCV_PC) at $OPENCV_INC"

# Refresh the shadow from the installed headers. The target line is found by
# CONTENT, not by number: Makefile.in hardcoded 45 and 479, and the 479 one had
# already rotted silently.
mkdir -p include/opencv2/core
src="$OPENCV_INC/opencv2/core/cvstd_wrapper.hpp"
line="$(grep -n 'has_parenthesis_operator_check(typename std::is_same' "$src" | cut -d: -f1 | head -1)"
if [ -z "$line" ]; then
    echo "ERROR: cvstd_wrapper.hpp no longer contains the SFINAE declaration SWIG chokes on." >&2
    echo "       Try regenerating without the shadow; if SWIG now parses it, delete include/." >&2
    exit 1
fi
sed "${line}s|^|// SWIG-parse workaround: |" "$src" > include/opencv2/core/cvstd_wrapper.hpp
echo "patched cvstd_wrapper.hpp line $line"

swig -scilab -c++ -builder -I./include -I"$OPENCV_INC" \
     -builderflagscript buildflags.sci -builderverbositylevel 2 scicv.i

# SWIG names its output builder.sce; the toolbox expects builder_gateway_c.sce.
sed 's/builder/builder_gateway_c/' < builder.sce > builder_gateway_c.sce
rm -f builder.sce
mv -f builder_gateway_c.sce ..
mv -f scicv_wrap.cxx ..

echo "regenerated ../scicv_wrap.cxx and ../builder_gateway_c.sce"
echo "gateway table entries: $(grep -c '\.\.$' ../builder_gateway_c.sce)"
