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
setenv("LIBRARY_PATH", "/opt/homebrew/opt/gettext/lib:/opt/homebrew/lib/gcc/current/gcc/aarch64-apple-darwin25/16:/opt/homebrew/lib/gcc/current");

root = get_absolute_file_path("build_macos.sce");

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
