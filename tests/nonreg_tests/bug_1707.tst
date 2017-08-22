// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

filename = fullfile(TMPDIR, "foo");
mdelete(filename);

expected = [13 3];
write(filename, expected);

result = read(filename, size(expected, 'r'), size(expected, 'c'));
assert_checkequal(result, expected);
