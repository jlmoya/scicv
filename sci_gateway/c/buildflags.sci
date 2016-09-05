function cflags = getCompilationFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    cflags = "-I" + fullpath(fullfile("../../thirdparty", os, arch, "include"));
    if os <> "Windows" then
        cflags = cflags + " -g";
    end
endfunction


function ldflags = getLinkFlags()
    os = getos();
    [version, opts] = getversion();
    arch = opts(2);
    thirdparty_lib = fullpath(fullfile("../../thirdparty", os, arch, "lib"));
    if getos() == "Windows" then
        if findmsvccompiler() <> "unknown" then
            // Visual Studio
            //ldflags = ldflags + " " + fullfile(thirdparty_lib, "");
        else
            // MinGW
            ldflags = ldflags + " " + msprintf("-L%s -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_contrib -lopencv_objdetect -lopencv_photo -lopencv_video -lopencv_features2d", thirdparty_lib);
        end
    else
        ldflags = ldflags + msprintf("-L%s -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_contrib -lopencv_objdetect -lopencv_photo -lopencv_video -lopencv_features2d", thirdparty_lib);
    end
endfunction

