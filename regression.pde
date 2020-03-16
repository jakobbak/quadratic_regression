

void check_integer_stability_of_regression_calculation() {
  for (int i = 0; i < 1024; i++) {
    long n = i;
    long n2 = n*n;
    long n3 = n*n*n;
    long n4 = n*n*n*n;
    long n5 = n*n*n*n*n;
    long n6 = n*n*n*n*n*n;
    long n7 = n*n*n*n*n*n*n;

    // the equations we are trying to calculate with integer math
    //T1 = (                                           n2 + n ) /  2 == m1 /  2
    //T2 = (                                 2*n3 +  3*n2 + n ) /  6 == m2 /  6
    //T3 = (                           n4 +  2*n3 +    n2     ) /  4 == m3 /  4
    //T4 = (                 6*n5 + 15*n4 + 10*n3         - n ) / 30 == m4 / 30
    //T5 = (         2*n6 +  6*n5 +  5*n4         -    n2     ) / 12 == m5 / 12
    //T6 = ( 6*n7 + 21*n6 + 21*n5         -  7*n3         + n ) / 42 == m6 / 42

    // calculate the numerator
    long m1 = ( n2 + n );
    long m2 = ( 2*n3 + 3*n2 + n );
    long m3 = ( n4 + 2*n3 + n2 );
    long m4 = ( 6*n5 + 15*n4 + 10*n3 - n );
    long m5 = ( 2*n6 + 6*n5 +5*n4 - n2 );
    long m6 = ( 6*n7 + 21*n6 + 21*n5 - 7*n3 + n );

    // check the result of division with denominator as integer if there is a reminder
    long mod1 = m1 % 2;
    long mod2 = m2 % 6;
    long mod3 = m3 % 4;
    long mod4 = m4 % 30;
    long mod5 = m5 % 12;
    long mod6 = m6 % 42;

    println( i + "," + mod1 + "," + mod2 + "," + mod3 + "," + mod4 + "," + mod5 + "," + mod6 + "," + m6);
    if (mod1 != 0 || mod2 != 0 || mod3 != 0 || mod4 != 0 || mod5 != 0 || mod6 != 0) break;
  }
}


void compute_regression_matrix_quadratic(int frequency, int rs) {

  double f  = (double)frequency;
  //println("frequency = " + f);
  double f1 = f;
  double f2 = f*f;
  double f3 = f*f*f;
  double f4 = f*f*f*f;
  
  for(int i=0; i < regression_samples; i++) {
     int j = i+1;
     xi_quad[0][i] = j/f1;
     xi_quad[1][i] = j*j/f2;
  }

  double n =  (double)rs;
  double n2 = n*n;
  double n3 = n*n*n;
  double n4 = n*n*n*n;
  double n5 = n*n*n*n*n;
  
  double t1 = (                                           n2 + n ) / 2;
  double t2 = (                                 2*n3 +  3*n2 + n ) / 6;
  double t3 = (                           n4 +  2*n3 +    n2     ) / 4;
  double t4 = (                 6*n5 + 15*n4 + 10*n3         - n ) / 30;

  double x1 = t1 / f1;
  double x2 = t2 / f2;
  double x3 = t3 / f3;
  double x4 = t4 / f4;
  
  double x_values_quad[][] = {{n, x1, x2},{x1, x2, x3},{x2, x3, x4}};

  Matrix X_quad = new Matrix(3, 3, x_values_quad);
  printMatrix(X_quad);  
  
  long N  = (long)rs;
  long N2 = N*N;
  long N3 = N*N*N;
  long N4 = N*N*N*N;

  long N00 = 3*(3*N2 + 3*N + 2);
  long N11 = 12*(16*N2 + 30*N + 11);
  long N22 = 180;
  
  long N01 = -(36*N + 18);
  long N02 = 30;
  long N12 = -180;
  
  long DA  = N*(N2 - 3*N + 2);
  long DB  = N*(N4 - 5*N2 + 4);
  long DC  = N*(N3 - N2 - 4*N + 4);
  
  double n00 = (double)N00;
  double n11 = (double)N11;
  double n22 = (double)N22;
  
  double n01 = (double)N01;
  double n02 = (double)N02;
  double n12 = (double)N12;
  
  double da = (double)DA;
  double db = (double)DB;
  double dc = (double)DC;
  
  double xi00 = n00      / da;
  double xi11 = n11 * f2 / db;
  double xi22 = n22 * f4 / db;
  
  double xi01 = n01 * f  / da;
  double xi02 = n02 * f2 / da;
  double xi12 = n12 * f3 / dc;
  
  double xi10 = xi01;
  double xi20 = xi02;
  double xi21 = xi12;
  
  double xi_values_quad[][] = {{xi00, xi01, xi02},{xi10, xi11, xi12},{xi20, xi21, xi22}};

  Xinv_quad = new Matrix(3, 3, xi_values_quad);
  printMatrix(Xinv_quad);
  C = MatrixMultiply(X_quad, Xinv_quad, 3, 3, 3);
  printMatrix(C);
}


void compute_regression_matrix_cubic(int frequency, int rs) {

  double f  = (double)frequency;
  println("frequency = " + f);
  double f1 = f;
  double f2 = f*f;
  double f3 = f*f*f;
  double f4 = f*f*f*f;
  double f5 = f*f*f*f*f;
  double f6 = f*f*f*f*f*f;
  
  for(int i=0; i < regression_samples; i++) {
     int j = i+1;
     xi_cube[0][i] = j/f1;
     xi_cube[1][i] = j*j/f2;
     xi_cube[2][i] = j*j*j/f3;
  }

  double n =  (double)rs;
  double n2 = n*n;
  double n3 = n*n*n;
  double n4 = n*n*n*n;
  double n5 = n*n*n*n*n;
  double n6 = n*n*n*n*n*n;
  double n7 = n*n*n*n*n*n*n;
  
  double t1 = (                                           n2 + n ) / 2;
  double t2 = (                                 2*n3 +  3*n2 + n ) / 6;
  double t3 = (                           n4 +  2*n3 +    n2     ) / 4;
  double t4 = (                 6*n5 + 15*n4 + 10*n3         - n ) / 30;
  double t5 = (         2*n6 +  6*n5 +  5*n4         -    n2     ) / 12;
  double t6 = ( 6*n7 + 21*n6 + 21*n5         -  7*n3         + n ) / 42;

  double x1 = t1 / f1;
  double x2 = t2 / f2;
  double x3 = t3 / f3;
  double x4 = t4 / f4;
  double x5 = t5 / f5;
  double x6 = t6 / f6;
  
  double x_values_cube[][] = {{n, x1, x2, x3},{x1, x2, x3, x4},{x2, x3, x4, x5},{x3, x4, x5, x6}};

  Matrix X_cube = new Matrix(4, 4, x_values_cube);
  printMatrix(X_cube);  
  
  long N  = (long)rs;
  long N2 = N*N;
  long N3 = N*N*N;
  long N4 = N*N*N*N;
  long N5 = N*N*N*N*N;
  long N6 = N*N*N*N*N*N;  
  
  long N00 = 8*(2*N3 + 3*N2 + 7*N + 3);
  long N11 = 200*(6*N4 + 27*N3 + 42*N2 + 30*N + 11);
  long N22 = 360*(18*N2 + 35*N + 13);
  long N33 = 2800;
  
  long N01 = -(120*N2 + 120*N + 100);
  long N02 = 120*(2*N + 1);
  long N03 = -140;
  long N12 = -(2700*N2 + 6300*N + 3000);
  long N13 = 280*(6*N2 + 15*N + 11);
  long N23 = -4200;
  
  long DA  = N*(N3 - 6*N2 + 11*N - 6);
  long DB  = N*(N6 - 14*N4 + 49*N2 - 36);
  long DC  = N*(N5 - N4 - 13*N3 + 13*N2 + 36*N - 36);
  
  double n00 = (double)N00;
  double n11 = (double)N11;
  double n22 = (double)N22;
  double n33 = (double)N33;
  
  double n01 = (double)N01;
  double n02 = (double)N02;
  double n03 = (double)N03;
  double n12 = (double)N12;
  double n13 = (double)N13;
  double n23 = (double)N23;
  
  double da = (double)DA;
  double db = (double)DB;
  double dc = (double)DC;
  
  double xi00 = n00 / da;
  double xi11 = n11 / db * f2;
  double xi22 = n22 / db * f4;
  double xi33 = n33 / db * f6;
  
  double xi01 = (n01 * f) / da;
  double xi02 = (n02 * f2) / da;
  double xi03 = (n03 * f3) / da;
  double xi12 = (n12 / dc) * f3;
  double xi13 = (n13 / db) * f4;
  double xi23 = (n23 / dc) * f5;
  
  double xi10 = xi01;
  double xi20 = xi02;
  double xi21 = xi12;
  double xi30 = xi03;
  double xi31 = xi13;
  double xi32 = xi23;
  
  double xi_values_cube[][] = {{xi00, xi01, xi02, xi03},{xi10, xi11, xi12, xi13},{xi20, xi21, xi22, xi23},{xi30, xi31, xi32, xi33}};

  Xinv_cube = new Matrix(4, 4, xi_values_cube);
  printMatrix(Xinv_cube);
  C = MatrixMultiply(X_cube, Xinv_cube, 4, 4, 4);
  printMatrix(C);
}
