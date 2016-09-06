
mode(-1);
lines(0);

function main_builder()

    TOOLBOX_NAME  = "scicv";
    TOOLBOX_TITLE = "Scilab Computer Vision";
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


