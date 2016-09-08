// <-- CLI SHELL MODE -->
scicv_Init();

m=imread("Data/images/lena.jpg");
m_rows=Mat_rows_get(m);
m_cols=Mat_cols_get(m);

assert_checkequal(m_rows,225);
assert_checkequal(m_cols,225);
