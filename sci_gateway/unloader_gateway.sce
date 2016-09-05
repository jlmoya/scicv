function unloader_gateway()
    [bOK, ilib] = c_link("libscinetcdf");
    if bOK then
       ulink(ilib);
    end
endfunction

unloader_gateway();
clear unloader_gateway;
