// <-- CLI SHELL MODE -->
scicv_Init();

m=imread("Data/images/lena.jpg");
ksize=3;
ksize2=1;

out=medianBlur(m,ksize);
assert_checktrue(ksize > 1);

//out2=medianBlur(m,ksize2);
//msg = "Error with medianBlur";
//assert_checkerror("out2=medianBlur(m,ksize2)", msg);

