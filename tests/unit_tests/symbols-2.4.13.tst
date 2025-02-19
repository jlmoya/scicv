// Scilab Computer Vision Module
// Copyright (C) 2024 - 3DS

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// Check that all symbols (variable & functions) wrapped in sciCV 2.4.13 (OpenCV 2.4.13.6) are still mapped

scicv_Init();

// Functions
exec(fullfile(get_scicv_path(), "tests", "unit_tests", "functions-2.4.13.txt"), -1);
scicvFunctions = table;
clear table

ignored = [];
ignoredPatterns = [];
renamedFunctions = [];

missing = 0;
for iFunc=1:size(scicvFunctions, 1)
    funcName = scicvFunctions(iFunc, 1);
    if or(ignored == funcName) then
        continue
    end
    found = %F;
    for pattern = ignoredPatterns
        if strindex(funcName, pattern)<>[] then
            found = %T;
            break
        end
    end
    if found then
        continue;
    end

    if or(renamedFunctions(:,1) == funcName) then
        funcName = renamedFunctions(renamedFunctions(:,1) == funcName, 2);
    end 


    [flag, errmsg] = assert_checkequal(exists(funcName), 1);
    if ~flag then
        disp(funcName);
        missing = missing + 1;
    end
end
assert_checkequal(missing, 0);

// Variables
exec(fullfile(get_scicv_path(), "tests", "unit_tests", "variables-2.4.13.txt"), -1);

ignoredVariables = [];
removedVariables = [];
renamedVariables = [];

missing = 0;
for iVar=1:size(scicvVariables, "*")
    varName = scicvVariables(iVar);
    if or(ignoredVariables == varName) then
        continue
    end
    if or(removedVariables == varName) then
        continue
    end

    if or(renamedVariables(:,1) == varName) then
        varName = renamedVariables(renamedVariables(:,1) == varName, 2);
    end 

    [flag, errmsg] = assert_checkequal(exists(varName), 1);
    if ~flag then
        disp(varName);
        missing = missing + 1;
    end
end
assert_checkequal(missing, 0);
