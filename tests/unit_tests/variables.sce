// Scilab Computer Vision Module
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

clear
b = who("local"); // List symbols before loading sciCV
scicv_Init();
a = who("local"); // List symbols after loading sciCV
a(a=="b") = []; // Remove 'b' from the list

// Identify created symbols
new=[];
for i=1:size(a, "*")
    if ~or(a(i)==b) then
        new($+1)=a(i);
    end
end

mputl(sci2exp(new, 80), "variables.txt")
