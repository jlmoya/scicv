// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

function cflags = getCompilationFlags()
    os = getos();
    if os == "Darwin" then
        // macOS arm64: compile the SWIG wrapper against Homebrew OpenCV 4.x headers
        // (the bundled thirdparty/<os> prebuilt is Windows/2.4-era). From `pkg-config --cflags opencv4`.
        cflags = "-I/opt/homebrew/opt/opencv/include/opencv4 -std=c++17 -Wno-narrowing -D_GLIBCXX_USE_CXX11_ABI=1";
        return;
    end
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_include = fullpath(fullfile("../../thirdparty", os, arch, "include"));

    cflags = ilib_include_flag(thirdparty_include);

    if os <> "Windows" then
        cflags = cflags + " -D_GLIBCXX_USE_CXX11_ABI=1" + " -Wno-narrowing";
    end
endfunction



function ldflags = getLinkFlags()
    os = getos();
    if os == "Darwin" then
        // macOS arm64: link Homebrew OpenCV 4.x (individual modules — no opencv_world) + rpath.
        // From `pkg-config --libs opencv4`.
        ldflags = "-L/opt/homebrew/opt/opencv/lib -lopencv_gapi -lopencv_stitching -lopencv_alphamat -lopencv_aruco -lopencv_bgsegm -lopencv_bioinspired -lopencv_ccalib -lopencv_dnn_objdetect -lopencv_dnn_superres -lopencv_dpm -lopencv_face -lopencv_freetype -lopencv_fuzzy -lopencv_hfs -lopencv_img_hash -lopencv_intensity_transform -lopencv_line_descriptor -lopencv_mcc -lopencv_quality -lopencv_rapid -lopencv_reg -lopencv_rgbd -lopencv_saliency -lopencv_sfm -lopencv_signal -lopencv_stereo -lopencv_structured_light -lopencv_phase_unwrapping -lopencv_superres -lopencv_optflow -lopencv_surface_matching -lopencv_tracking -lopencv_highgui -lopencv_datasets -lopencv_text -lopencv_plot -lopencv_videostab -lopencv_videoio -lopencv_viz -lopencv_wechat_qrcode -lopencv_xfeatures2d -lopencv_shape -lopencv_ml -lopencv_ximgproc -lopencv_video -lopencv_xobjdetect -lopencv_objdetect -lopencv_calib3d -lopencv_imgcodecs -lopencv_features2d -lopencv_dnn -lopencv_flann -lopencv_xphoto -lopencv_photo -lopencv_imgproc -lopencv_core -Wl,-rpath,/opt/homebrew/opt/opencv/lib";
        return;
    end
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_lib = fullpath(fullfile("../../thirdparty", os, arch, "lib"));

    libs = "opencv_world";

    if os == "Windows" then
        libs = [libs; "opencv_img_hash"];
        if findmsvccompiler() <> "unknown" then
            // Visual Studio
            ldflags = strcat(fullfile(thirdparty_lib, libs + "481.lib"), " ");
        else
            // MinGW
            ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
        end
    else
        libs = "opencv_world";
        ldflags = "-L" + thirdparty_lib + " -l" + strcat(libs, " -l");
    end
endfunction

