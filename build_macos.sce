// ----------------------------------------------------------------------------
// scicv (Scilab Computer Vision / OpenCV) — macOS arm64 / Scilab 2027 build.
//
// Prerequisites:  brew install opencv gettext
//
// The bundled thirdparty OpenCV is Windows/2.4-era; on macOS we link Homebrew OpenCV 4.x
// (see sci_gateway/c/buildflags.sci, redirected via `pkg-config opencv4`). The stock
// builder.sce downloads OpenCV and runs install_name_tool on a bundled lib — neither is
// needed with Homebrew — so build the gateway directly. If the gateway step reports ierr<>0
// with a configure "C compiler cannot create executables", just re-run (intermittent).
//
//   scilab-cli -nb -f build_macos.sce
// ----------------------------------------------------------------------------
ilib_verbose(1);
setenv("CPATH", "/opt/homebrew/opt/gettext/include");
// LIBRARY_PATH: gettext + the CURRENT Homebrew gcc runtime dirs. Resolve the
// versioned gcc subdir at build time — hardcoding it (".../darwin25/16") broke
// on every gcc major bump, the same stale-path class as the old OpenCV flags.
gcc_libdir = unix_g("ls -d /opt/homebrew/lib/gcc/current/gcc/*/[0-9]* 2>/dev/null | tail -1");
lp = "/opt/homebrew/opt/gettext/lib";
if gcc_libdir <> [] & gcc_libdir(1) <> "" then
    lp = lp + ":" + gcc_libdir(1) + ":/opt/homebrew/lib/gcc/current";
end
setenv("LIBRARY_PATH", lp);
clear gcc_libdir lp;

root = get_absolute_file_path("build_macos.sce");

// Report the OpenCV actually resolved, so a Homebrew major bump is visible in
// the build log instead of being discovered later from a linker error.
exec(fullfile(root, "sci_gateway", "c", "buildflags.sci"), -1);
mprintf("[0/3] OpenCV resolved via pkg-config: %s\n", getOpenCVVersion());

ie = execstr("exec(fullfile(root, ""sci_gateway"", ""c"", ""builder_gateway_c.sce""), -1)", "errcatch");
mprintf("[1/3] sci_gateway/c (libscicv, links Homebrew OpenCV)  ierr=%d\n", ie);
if ie <> 0 then mprintf("      (configure can flake — re-run this script if so)\n"); end
// tbx_builder_gateway would normally emit this intermediate loader; write it ourselves.
mputl([ "sci_gateway_dir = get_absolute_file_path(""loader_gateway.sce"");" ; ..
        "exec(fullfile(sci_gateway_dir, ""c"", ""loader.sce""), -1);" ; "clear sci_gateway_dir;" ], ..
      fullfile(root, "sci_gateway", "loader_gateway.sce"));
ie = execstr("tbx_build_macros(""scicv"", fullfile(root, ""macros""))", "errcatch");
mprintf("[2/3] macros                                            ierr=%d\n", ie);
ie = execstr("tbx_build_loader(""scicv"", root)", "errcatch");
mprintf("[3/3] loader                                            ierr=%d\n", ie);

// Without this, `scilab-cli -f build_macos.sce` finishes the build and then sits
// at an interactive prompt forever (the recurring "stalled build" symptom).
quit
