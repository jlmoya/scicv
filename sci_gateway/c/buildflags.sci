// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// macOS: resolve the Homebrew OpenCV pkg-config name at build time (opencv5.pc,
// opencv4.pc, ... — Homebrew renames the .pc on every major), so a `brew upgrade
// opencv` major bump keeps building instead of pointing at dead hardcoded paths.
function pc = opencv_pkgconfig_name()
    pcbin = "/opt/homebrew/bin/pkg-config";
    if ~isfile(pcbin) then pcbin = "pkg-config"; end
    names = ["opencv6" "opencv5" "opencv4" "opencv"];
    for k = 1:size(names, "*")
        if unix(pcbin + " --exists " + names(k) + " 2>/dev/null") == 0 then
            pc = names(k);
            return;
        end
    end
    error("scicv: pkg-config found no OpenCV (.pc). Install it: brew install opencv");
endfunction

function out = opencv_pkgconfig(args)
    pcbin = "/opt/homebrew/bin/pkg-config";
    if ~isfile(pcbin) then pcbin = "pkg-config"; end
    out = unix_g(pcbin + " " + args + " " + opencv_pkgconfig_name());
    out = out(1);
endfunction

// The version of the OpenCV that opencv_pkgconfig_name() resolved. This is the
// truth for a macOS build; OPENCV_VERSION in thirdparty/versions.sce pins the
// bundled Windows/Linux prebuilt instead.
function v = getOpenCVVersion()
    v = opencv_pkgconfig("--modversion");
endfunction

function cflags = getCompilationFlags()
    os = getos();
    if os == "Darwin" then
        // macOS arm64: compile the SWIG wrapper against Homebrew OpenCV headers
        // (the bundled thirdparty/<os> prebuilt is Windows/2.4-era).
        cflags = opencv_pkgconfig("--cflags") + " -std=c++17 -Wno-narrowing -D_GLIBCXX_USE_CXX11_ABI=1";
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
        // macOS arm64: link Homebrew OpenCV (whatever module set the installed major
        // ships — resolved via pkg-config, so removed/merged modules never go stale)
        // + an rpath on its libdir.
        ldflags = opencv_pkgconfig("--libs") + " -Wl,-rpath," + opencv_pkgconfig("--variable=libdir");
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

