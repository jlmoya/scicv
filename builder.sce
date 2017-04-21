// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

mode(-1);
lines(0);

function main_builder()

    TOOLBOX_NAME  = "scicv";
    TOOLBOX_TITLE = "Scilab Computer Vision Module";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================

    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.5 or more is required."));
    end

    if v(1) < 5 & v(2) < 5 then
        // new API in scilab 5.5
        error(gettext("Scilab 5.5 or more is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

    if ~isdef("tbx_build_loader") then
        error(msprintf(gettext("%s module not installed."), "modules_manager"));
    end

    tbx_builder_macros(toolbox_dir);
    tbx_builder_gateway(toolbox_dir);

	// manually load dependencies with link() does not work on Mac
	// by default, OpenCV libs need to be in same folder as scicv lib
	// -> change the path of dependecies in scicv lib (with install_name_tool) to look up in thirdparty folder
	// Notice: relative paths must not be too long !!! otherwise error occurs suggesting use headerpad_max_install_names option, but it is ignored by libtool...)
    scicv_dir = get_absolute_file_path("builder.sce");
    if getos() == "Darwin" then
        opencv_libs = "libopencv_" + ["core"; "imgproc"; "highgui"; "photo"; "video"; "objdetect"; "flann"; "features2d"; "contrib"];
        for opencv_lib = opencv_libs'
            unix_g(sprintf("install_name_tool -change %s.2.4.dylib @loader_path/../../thirdparty/Mac/lib/%s.dylib %s/sci_gateway/c/libscicv.dylib", opencv_lib, opencv_lib, scicv_dir));
        end
    end

    if (getscilabmode() == 'STD') | (getscilabmode() == 'NW') then
      tbx_builder_help(toolbox_dir);
    end

    tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
    tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

endfunction

// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


