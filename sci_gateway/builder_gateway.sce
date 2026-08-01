// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

function builder_gateway()

    sci_gateway_dir = get_absolute_file_path("builder_gateway.sce");
    // "c": SWIG-generated OpenCV bindings (sci_gateway/c/, scicv.i).
    // "cpp": hand-written camera-authorization gateway (sci_gateway/cpp/,
    // NOT part of scicv.i -- it wraps zero cv:: symbols, only Apple's
    // AVFoundation; see sci_gateway/cpp/builder_gateway_cpp.sce).
    languages = ["c", "cpp"];

    tbx_builder_gateway_lang(languages, sci_gateway_dir);
    tbx_build_gateway_loader(languages, sci_gateway_dir);
    tbx_build_gateway_clean(languages, sci_gateway_dir);

endfunction

builder_gateway()
clear builder_gateway; // remove builder_gateway on stack
