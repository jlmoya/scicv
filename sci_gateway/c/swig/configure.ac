AC_INIT([OPENCV_GATEWAY], [1.0])

# Arguments
AC_ARG_WITH(swig, [  --with-swig=path        location of Swig executable], [WITH_SWIG="$withval"], [WITH_SWIG="no"])
AC_ARG_WITH(opencv, [  --with-opencv=path      location of OpenCV], [WITH_OPENCV="$withval"], [WITH_OPENCV="no"])

SWIG=
SWIG_LIB=
OPENCV=
OPENCV_INC=

# Check for compilers and standard includes
AC_PROG_CC
AC_PROG_CXX

# Check for SWIG
if test "x$WITH_SWIG" = xno; then
  AC_CHECK_PROGS(SWIG, swig)
else
  AC_MSG_CHECKING(for swig)
  if test -f "$WITH_SWIG"; then
    AC_MSG_RESULT($WITH_SWIG)
    SWIG="$WITH_SWIG"
  else
    AC_MSG_ERROR(Swig not found)
  fi
fi

# Check for SWIG Lib
AC_MSG_CHECKING(for SWIG Lib)
SWIG_PATH="`dirname \"$SWIG\"`"
SWIG_PATH="`(cd \"$SWIG_PATH\" && pwd)`"
if test -r $SWIG_PATH/Lib; then
  SWIG_LIB=$SWIG_PATH/Lib
  AC_MSG_RESULT($SWIG_LIB)
else
  AC_MSG_ERROR($SWIG_PATH/Lib not found)
fi

# Check for OpenCV
if test "x$WITH_OPENCV" = xno; then
  AC_CHECK_HEADERS(OPENCV_INC, opencv2/opencv.hpp)
# TODO: search for OpenCV libs when path not specified 
else
  AC_MSG_CHECKING(for OpenCV include)
  if test -f "$WITH_OPENCV/include/opencv2/opencv.hpp"; then
    OPENCV_INC=$WITH_OPENCV/include
    AC_MSG_RESULT($OPENCV_INC)
  else
    AC_MSG_ERROR($WITH_OPENCV/include/opencv2 not found)
  fi
fi

# Set SWIG variables
AC_SUBST(SWIG)
AC_SUBST(SWIG_LIB)
AC_SUBST(OPENCV_INC)

# Generate files
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
