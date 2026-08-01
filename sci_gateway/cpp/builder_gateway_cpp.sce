// scicv - camera-authorization gateway builder (hand-written, not SWIG).
//
// Wires cvCameraAuthStatus()/cvRequestCameraAccess() -- see
// sci_cvCameraAuthStatus.cpp / sci_cvRequestCameraAccess.cpp and
// .superpowers/sdd/2026-08-01-camera-and-opencv-dnn/task-3b-report.md for
// why this exists: OpenCV's AVFoundation VideoCapture backend refuses to
// call requestAccessForMediaType: itself from the interpreter thread, so
// something else has to trigger the authorization prompt once, from inside
// a launched app bundle's own main run loop.
//
// This lives alongside scicv's SWIG-generated sci_gateway/c/ as a second,
// independent, hand-written gateway -- the same pattern sciTorch uses for
// its own sci_gateway/cpp/ (see that toolbox's builder_gateway_cpp.sce).
// Deliberately NOT folded into scicv.i / SWIG: it wraps zero OpenCV/cv::
// symbols, only Apple's AVFoundation.

function builder_gateway_cpp()

    gw_cpp_path = get_absolute_file_path('builder_gateway_cpp.sce');

    // sci_*.cpp filenames drive both the Scilab-facing verb name (filename
    // minus "sci_" and ".cpp") and the C++ function compiled from it -- e.g.
    // sci_cvCameraAuthStatus.cpp exposes cvCameraAuthStatus(). Same
    // file-naming convention sciTorch's builder_gateway_cpp.sce uses.
    gw_cpp_files = findfiles(gw_cpp_path, '*.cpp');
    scifunctions_name = gw_cpp_files(grep(gw_cpp_files, 'sci_'));
    scifunctions_name = strsubst(scifunctions_name, 'sci_', '');
    scifunctions_name = strsubst(scifunctions_name, '.cpp', '');

    cppfunctions_name = gw_cpp_files(grep(gw_cpp_files, 'sci_'));
    cppfunctions_name = strsubst(cppfunctions_name, '.cpp', '');

    gw_tables = [scifunctions_name, cppfunctions_name];
    gw_tables(:, 3) = repmat('csci', size(scifunctions_name, 1), 1);

    // gw_cpp_files (the compile list) is left as the full *.cpp glob on
    // purpose: it already includes libgw_scicv_camera.cpp (the dispatch
    // table below), which does not match the 'sci_' filter above and so is
    // correctly absent from gw_tables, but must still be compiled and
    // linked in.

    if getos() == 'Darwin' then
        // The verbs are genuine AVFoundation/Objective-C++ (message sends,
        // blocks, @autoreleasepool). ilib_build's underlying Makefile
        // (modules/dynamic_link/src/scripts/Makefile.in) only defines
        // .SUFFIXES for .c/.cpp/.cxx/.f/.f90 -- no .mm rule -- so the source
        // files stay named *.cpp and are compiled AS Objective-C++ by
        // forcing that mode on.
        //
        // MEASURED (1st issue): tbx_build_gateway's "cc" argument only ever
        // becomes Autotools' CC (gencompilationflags_unix.sci emits
        // CC="...", never CXX="..."), and AC_PROG_CXX in
        // modules/dynamic_link's configure.ac detects CXX independently of
        // CC -- so a "clang++ -x objective-c++" cc override (sciTorch's own
        // trick, which only ever forced the mode on sciTorch's C-compiler
        // PROBE, since that toolbox has zero .mm content to actually
        // compile) silently never reaches the real per-.cpp compile command
        // here. First attempt built clean but failed on "@class NSString,
        // Protocol; expected unqualified-id" -- proof the .cpp files were
        // compiled as plain C++, not Objective-C++. Fixed by putting
        // -x objective-c++ in cflags instead: gencompilationflags_unix.sci
        // sets BOTH CFLAGS="..." and CXXFLAGS="..." from this same cflags
        // string, and CXXFLAGS is what the .cpp.o: rule actually applies.
        inter_cflags  = " -std=c++17 -x objective-c++";
        // -lobjc is normally auto-linked by the clang++ driver whenever
        // Objective-C symbols are present, but it is pinned explicitly here
        // so linking does not depend on that default surviving a future
        // toolchain change.
        inter_ldflags = " -framework AVFoundation -framework Foundation -lobjc";
        // MEASURED (2nd issue, only visible once the 1st was fixed): CXX
        // itself is ALSO never influenced by "cc" -- AC_PROG_CXX free-
        // searches PATH regardless and picked "g++" on this machine, which
        // resolves to Apple clang under a GCC-flavoured name (`g++
        // --version` -> "Apple clang version..."). Compiling under that
        // name still worked, but LINKING under it made clang go looking for
        // a "sibling" GCC toolchain for ABI purposes, found the real
        // Homebrew GCC installed for the unrelated FOSSEE/Ipopt toolbox
        // work, and tried to borrow its runtime: "ld: library 'emutls_w'
        // not found" plus warnings about missing
        // /opt/homebrew/Cellar/gcc/.../lib/gcc search paths. Reproduced by
        // dumping the generated Makefile/libtool directly (CXX = g++).
        // Autoconf's AC_PROG_CC/AC_PROG_CXX both skip their own candidate
        // search when the variable is already set in the environment on
        // entry, so exporting CXX/CC as real (unaliased) compiler names
        // sidesteps the "g++" persona entirely; saved and restored so this
        // does not leak into a later step of a larger build session (e.g. a
        // full toolbox rebuild that also builds the SWIG "c" gateway in the
        // same process).
        prev_CXX = getenv("CXX", "");
        prev_CC  = getenv("CC", "");
        setenv("CXX", "clang++");
        setenv("CC", "clang");
        // Leave tbx_build_gateway's own "cc" argument empty: autoconf gives
        // a command-line CC="..." override HIGHER precedence than an
        // already-exported CC environment variable, so passing one here
        // (even the same value) would fight the setenv above for no
        // benefit -- CXX has no such argument at all, so the environment is
        // the only lever for it regardless.
        inter_cc = "";
    else
        // No camera-authorization gate exists off Darwin; every sci_cv*.cpp
        // verb takes its #else branch and reports "authorized"
        // unconditionally, compiled here as plain C++ -- see
        // buildflags.sci's identical getos() == "Darwin" branching for the
        // SWIG side.
        inter_cflags  = " -std=c++17";
        inter_ldflags = "";
        inter_cc      = "clang++ -x c++";
    end

    // No extra libs to pre-link()/preload: this gateway does not call into
    // scicv's own SWIG gateway (libscicv) or any other toolbox's gateway --
    // confirmed there is nothing in these sources but Apple frameworks and
    // the Scilab classic stack API. See sciTorch's sci_gateway/cpp/
    // builder_gateway_cpp.sce for why an all_libs entry here would be
    // dangerous (ABI-coupled loader.sce link() of another toolbox's dylib).
    all_libs = [];

    // try/catch so the CXX/CC environment restore below always runs, build
    // failure or not, then the original error (if any) is re-raised.
    build_err = "";
    try
        tbx_build_gateway('gw_scicv_camera', ..
        gw_tables, ..
        gw_cpp_files, ..
        gw_cpp_path, ..
        all_libs, ..
        inter_ldflags, ..
        inter_cflags, ..
        "", ..
        inter_cc);
    catch
        build_err = lasterror();
    end

    if getos() == 'Darwin' then
        setenv("CXX", prev_CXX);
        setenv("CC", prev_CC);
    end

    if build_err <> "" then
        error(build_err);
    end

    // macOS: re-sign the freshly linked gateway with a fresh ad-hoc
    // signature. The linker's own ad-hoc ("linker-signed") signature on a
    // freshly built dylib passes `codesign --verify` yet can be rejected by
    // AMFI at load time (CODESIGNING "Invalid Page" fault, SIGKILL) -- see
    // sciTorch's builder_gateway_cpp.sce for the measured original case.
    // No-op on a dylib that was already fine, so safe unconditionally.
    if getos() == 'Darwin' then
        gw_dylib = fullpath(gw_cpp_path + "/libgw_scicv_camera" + getdynlibext());
        if isfile(gw_dylib) then
            // host(), not the deprecated unix_g() (sciTorch's own script
            // still uses unix_g -- flagged there as a pre-existing issue,
            // not repeated here since Scilab 2027.0.0, this codebase's own
            // target version, is exactly where unix_g is removed).
            [ierr, msg, errmsg] = host("codesign --remove-signature " + """" + gw_dylib + """" + " 2>/dev/null; " + ..
                   "codesign --force --sign - --timestamp=none " + """" + gw_dylib + """");
        end
    end

endfunction
// ====================================================================
builder_gateway_cpp();
clear builder_gateway_cpp;
// ====================================================================
