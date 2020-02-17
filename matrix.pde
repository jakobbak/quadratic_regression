Matrix A, B, C, D;

class Matrix {
  int r, c;
  double matrix[][];
  Matrix(int rows, int columns) {
    r = rows;
    c = columns;
    matrix = new double[rows][columns];
  }
  Matrix(int rows, int columns, double m[][]) {
    r = rows;
    c = columns;
    matrix = new double[rows][columns];
    for(int i=0; i<r; i++) {
      for(int j=0; j<c; j++) {
        try {
          matrix[i][j] = m[i][j];
        } catch(IndexOutOfBoundsException e) {
          matrix[i][j] = 0.0;
        }
      }
    }
  }
  void set(double m[][]) {
    for(int i=0; i<r; i++) {
      for(int j=0; j<c; j++) {
        try {
          matrix[i][j] = m[i][j];
        } catch(IndexOutOfBoundsException e) {
          matrix[i][j] = 0.0;
        }
      }
    }
  }
  int[] getSize() {
    int[] size = new int[2];
    size[0] = r;
    size[1] = c;
    return size;
  }
}


Matrix MatrixAddition(Matrix A, Matrix B, int m, int n) {
  // A = input matrix (m x n)
  // B = input matrix (m x n)
  // m = number of rows in A = number of rows in B
  // n = number of columns in A = number of columns in B
  // C = output matrix = A+B (m x n)
  if(!canAddMatrices(A,B,m,n)) {
    println("MATRIX_ADDITION: Input matrices not compatible with size arguments");
    return null;
  }

  Matrix C = new Matrix(m, n);
  int i, j;
  for (i=0; i<m; i++) {
    for(j=0; j<n; j++) {
      C.matrix[i][j] = A.matrix[i][j] + B.matrix[i][j];
      // C[n*i+j]=A[n*i+j]+B[n*i+j];
    }
  }
  return C;
}


// Matrix Subtraction Routine
Matrix MatrixSubtraction(Matrix A, Matrix B, int m, int n) {
  // A = input matrix (m x n)
  // B = input matrix (m x n)
  // m = number of rows in A = number of rows in B
  // n = number of columns in A = number of columns in B
  // C = output matrix = A-B (m x n)
  if(!canAddMatrices(A,B,m,n)) {
    println("MATRIX_SUBTRACTION:  Input matrices not compatible with size arguments");
    return null;
  }

  Matrix C = new Matrix(m, n);
  int i, j;
  for (i=0; i<m; i++) {
    for(j=0; j<n; j++) {
      C.matrix[i][j] = A.matrix[i][j] - B.matrix[i][j];
      // C[n*i+j]=A[n*i+j]-B[n*i+j];
    }
  }
  return C;
}


Matrix MatrixMultiply(Matrix A, Matrix B, int m, int p, int n) {
  // A = input matrix (m x p)
  // B = input matrix (p x n)
  // m = number of rows in A
  // p = number of columns in A = number of rows in B
  // n = number of columns in B
  // C = output matrix = A*B (m x n)

  if(!canMultiplyMatrices(A,B,m,p,n)) {
    println("MATRIX_MULTIPLY:  Input matrices not compatible with size arguments");
    return null;
  }
  // if(A.getSize()[0] != m) return false; // is the number of rows in A equal to m
  // if(A.getSize()[1] != p) return false; // is the number of columns in A equal to p
  // if(B.getSize()[0] != p) return false; // is the number of rows in B equal to p
  // if(B.getSize()[1] != n) return false; // is the number of columns in B equal n

  Matrix C = new Matrix(m, n);
  int i, j, k;
  for (i=0;i<m;i++) {
    for(j=0;j<n;j++) {
      C.matrix[i][j]=0.0;
      for (k=0;k<p;k++) {
        C.matrix[i][j] += A.matrix[i][k] * B.matrix[k][j];
        // C[n*i+j]= C[n*i+j]+A[p*i+k]*B[n*k+j];
      }
    }
  }
  return C;
}


Matrix MatrixScalarMultiply(Matrix A, int m, int n, double scalar) {
  // A = input matrix (m x n)
  // m = number of rows in A
  // n = number of columns in A
  // scalar = scalar to be multiplied with the matrix
  // C = output matrix = the transpose of A (n x m)
  if(!checkMatrixSize(A, m, n)) {
    println("MATRIX_TRANSPOSE:  Input matrix not compatible with size arguments");
    return null;
  }

  Matrix C = new Matrix(m, n);
  int i, j;
  for(i=0; i<m; i++) {
    for(j=0; j<n; j++) {
      C.matrix[i][j] = A.matrix[i][j] * scalar;
    }
  }
  return C;
}


Matrix MatrixTranspose(Matrix A, int m, int n) {
  // A = input matrix (m x n)
  // m = number of rows in A
  // n = number of columns in A
  // C = output matrix = the transpose of A (n x m)
  if(!checkMatrixSize(A, m, n)) {
    println("MATRIX_TRANSPOSE:  Input matrix not compatible with size arguments");
    return null;
  }

  Matrix C = new Matrix(n, m);
  int i, j;
  for(i=0; i<m; i++) {
    for(j=0; j<n; j++) {
      C.matrix[j][i]=A.matrix[i][j];
    }
  }
  return C;
}


Matrix Matrix2x2Inversion(Matrix A) {
  // A = input matrix (2 x 2)
  // C = output matrix (2 x 2)
  if(!checkMatrixSize(A, 2, 2)) {
    println("MATRIX_2x2_INVERSION: matrix is not 2x2");
    return null;
  }
  double a = A.matrix[0][0];
  double b = A.matrix[0][1];
  double c = A.matrix[1][0];
  double d = A.matrix[1][1];
  double determinant = a * d - b * c;
  if(determinant == 0.0) {
    println("MATRIX_2x2_INVERSION: determinant is zero. Matrix non-invertable");
    return null;
  }
  Matrix C = new Matrix(2,2);
  C.matrix[0][0] = d / determinant;
  C.matrix[0][1] = -b / determinant;
  C.matrix[1][0] = -c / determinant;
  C.matrix[1][1] = a / determinant;
  return C;
}


Matrix Matrix3x3Inversion(Matrix A) {
  // A = input matrix (2 x 2)
  // C = output matrix (2 x 2)
  if(!checkMatrixSize(A, 3, 3)) {
    println("MATRIX_3x3_INVERSION: matrix is not 3x3");
    return null;
  }
  double a00 = A.matrix[0][0];
  double a01 = A.matrix[0][1];
  double a02 = A.matrix[0][2];
  double a10 = A.matrix[1][0];
  double a11 = A.matrix[1][1];
  double a12 = A.matrix[1][2];
  double a20 = A.matrix[2][0];
  double a21 = A.matrix[2][1];
  double a22 = A.matrix[2][2];
  
  double determinant = +a00 * ( a11 * a22 - a12 * a21) -a01 * ( a10 * a22 - a12 * a20) +a02 * ( a10 * a21 - a11 * a20);
  if (determinant == 0.0) {
    println("MATRIX_3x3_INVERSION: determinant is zero. Matrix non-invertable");
    return null;
  } else {
    //println("MATRIX_3x3_INVERSION determinant is " + determinant);
  }
  
  Matrix C = MatrixTranspose(A, 3, 3);  
  
  double c00 = C.matrix[0][0];
  double c01 = C.matrix[0][1];
  double c02 = C.matrix[0][2];
  double c10 = C.matrix[1][0];
  double c11 = C.matrix[1][1];
  double c12 = C.matrix[1][2];
  double c20 = C.matrix[2][0];
  double c21 = C.matrix[2][1];
  double c22 = C.matrix[2][2];

  double d00 = + ( c11 * c22 - c12 * c21 );
  double d01 = - ( c10 * c22 - c12 * c20 );
  double d02 = + ( c10 * c21 - c11 * c20 );
  double d10 = - ( c01 * c22 - c02 * c21 );
  double d11 = + ( c00 * c22 - c02 * c20 );
  double d12 = - ( c00 * c21 - c01 * c20 );
  double d20 = + ( c01 * c12 - c02 * c11 );
  double d21 = - ( c00 * c12 - c02 * c10 );
  double d22 = + ( c00 * c11 - c01 * c10 );
  
  double inv_determinant = 1.0 / determinant;
  Matrix D = new Matrix(3,3);
  D.matrix[0][0] = d00 * inv_determinant;
  D.matrix[0][1] = d01 * inv_determinant;
  D.matrix[0][2] = d02 * inv_determinant;
  D.matrix[1][0] = d10 * inv_determinant;
  D.matrix[1][1] = d11 * inv_determinant;
  D.matrix[1][2] = d12 * inv_determinant;
  D.matrix[2][0] = d20 * inv_determinant;
  D.matrix[2][1] = d21 * inv_determinant;
  D.matrix[2][2] = d22 * inv_determinant;
  
  return D;
}


Matrix Matrix4x4Inversion(Matrix A) {
  // A = input matrix (2 x 2)
  // C = output matrix (2 x 2)
  if(!checkMatrixSize(A, 4, 4)) {
    println("MATRIX_4x4_INVERSION: matrix is not 4x4");
    return null;
  }
  double a00 = A.matrix[0][0];
  double a01 = A.matrix[0][1];
  double a02 = A.matrix[0][2];
  double a03 = A.matrix[0][3];
  double a10 = A.matrix[1][0];
  double a11 = A.matrix[1][1];
  double a12 = A.matrix[1][2];
  double a13 = A.matrix[1][3];
  double a20 = A.matrix[2][0];
  double a21 = A.matrix[2][1];
  double a22 = A.matrix[2][2];
  double a23 = A.matrix[2][3];
  double a30 = A.matrix[3][0];
  double a31 = A.matrix[3][1];
  double a32 = A.matrix[3][2];
  double a33 = A.matrix[3][3];

  double determinant =  + a03*a12*a21*a30 - a02*a13*a21*a30 - a03*a11*a22*a30 + a01*a13*a22*a30
                        + a02*a11*a23*a30 - a01*a12*a23*a30 - a03*a12*a20*a31 + a02*a13*a20*a31
                        + a03*a10*a22*a31 - a00*a13*a22*a31 - a02*a10*a23*a31 + a00*a12*a23*a31
                        + a03*a11*a20*a32 - a01*a13*a20*a32 - a03*a10*a21*a32 + a00*a13*a21*a32
                        + a01*a10*a23*a32 - a00*a11*a23*a32 - a02*a11*a20*a33 + a01*a12*a20*a33
                        + a02*a10*a21*a33 - a00*a12*a21*a33 - a01*a10*a22*a33 + a00*a11*a22*a33;

  if (determinant == 0.0) {
    println("MATRIX_4x4_INVERSION: determinant is zero. Matrix non-invertable");
    return null;
  } else {
    //println("MATRIX_3x3_INVERSION determinant is " + determinant);
  }
  
  double j00 = a12*a23*a31 - a13*a22*a31 + a13*a21*a32 - a11*a23*a32 - a12*a21*a33 + a11*a22*a33;
  double j01 = a03*a22*a31 - a02*a23*a31 - a03*a21*a32 + a01*a23*a32 + a02*a21*a33 - a01*a22*a33;
  double j02 = a02*a13*a31 - a03*a12*a31 + a03*a11*a32 - a01*a13*a32 - a02*a11*a33 + a01*a12*a33;
  double j03 = a03*a12*a21 - a02*a13*a21 - a03*a11*a22 + a01*a13*a22 + a02*a11*a23 - a01*a12*a23;
  double j10 = a13*a22*a30 - a12*a23*a30 - a13*a20*a32 + a10*a23*a32 + a12*a20*a33 - a10*a22*a33;
  double j11 = a02*a23*a30 - a03*a22*a30 + a03*a20*a32 - a00*a23*a32 - a02*a20*a33 + a00*a22*a33;
  double j12 = a03*a12*a30 - a02*a13*a30 - a03*a10*a32 + a00*a13*a32 + a02*a10*a33 - a00*a12*a33;
  double j13 = a02*a13*a20 - a03*a12*a20 + a03*a10*a22 - a00*a13*a22 - a02*a10*a23 + a00*a12*a23;
  double j20 = a11*a23*a30 - a13*a21*a30 + a13*a20*a31 - a10*a23*a31 - a11*a20*a33 + a10*a21*a33;
  double j21 = a03*a21*a30 - a01*a23*a30 - a03*a20*a31 + a00*a23*a31 + a01*a20*a33 - a00*a21*a33;
  double j22 = a01*a13*a30 - a03*a11*a30 + a03*a10*a31 - a00*a13*a31 - a01*a10*a33 + a00*a11*a33;
  double j23 = a03*a11*a20 - a01*a13*a20 - a03*a10*a21 + a00*a13*a21 + a01*a10*a23 - a00*a11*a23;
  double j30 = a12*a21*a30 - a11*a22*a30 - a12*a20*a31 + a10*a22*a31 + a11*a20*a32 - a10*a21*a32;
  double j31 = a01*a22*a30 - a02*a21*a30 + a02*a20*a31 - a00*a22*a31 - a01*a20*a32 + a00*a21*a32;
  double j32 = a02*a11*a30 - a01*a12*a30 - a02*a10*a31 + a00*a12*a31 + a01*a10*a32 - a00*a11*a32;
  double j33 = a01*a12*a20 - a02*a11*a20 + a02*a10*a21 - a00*a12*a21 - a01*a10*a22 + a00*a11*a22;


  double inv_determinant = 1.0 / determinant;
  Matrix D = new Matrix(4,4);
  D.matrix[0][0] = j00 * inv_determinant;
  D.matrix[0][1] = j01 * inv_determinant;
  D.matrix[0][2] = j02 * inv_determinant;
  D.matrix[0][3] = j03 * inv_determinant;
  D.matrix[1][0] = j10 * inv_determinant;
  D.matrix[1][1] = j11 * inv_determinant;
  D.matrix[1][2] = j12 * inv_determinant;
  D.matrix[1][3] = j13 * inv_determinant;
  D.matrix[2][0] = j20 * inv_determinant;
  D.matrix[2][1] = j21 * inv_determinant;
  D.matrix[2][2] = j22 * inv_determinant;
  D.matrix[2][3] = j23 * inv_determinant;
  D.matrix[3][0] = j30 * inv_determinant;
  D.matrix[3][1] = j31 * inv_determinant;
  D.matrix[3][2] = j32 * inv_determinant;
  D.matrix[3][3] = j33 * inv_determinant;
  
  return D;
}

boolean canAddMatrices(Matrix A, Matrix B, int m, int n) {
  if(A == null) return false;
  if(B == null) return false;
  if(A.getSize()[0] != m) return false; // is the number of rows in A equal to m
  if(A.getSize()[1] != n) return false; // is the number of columns in A equal to n
  if(B.getSize()[0] != m) return false; // is the number of rows in B equal to m
  if(B.getSize()[1] != n) return false; // is the number of columns in B equal n
  return true;
}


boolean canMultiplyMatrices(Matrix A, Matrix B, int m, int p, int n) {
  if(A == null) return false;
  if(B == null) return false;
  if(A.getSize()[0] != m) return false; // is the number of rows in A equal to m
  if(A.getSize()[1] != p) return false; // is the number of columns in A equal to p
  if(B.getSize()[0] != p) return false; // is the number of rows in B equal to p
  if(B.getSize()[1] != n) return false; // is the number of columns in B equal n
  return true;
}


// boolean canTransposeMatrix(Matrix A, int m, int n) {
//   if(A == null) return false;
//   if(A.getSize()[0] != m) return false; // is the number of rows in A equal to m
//   if(A.getSize()[1] != n) return false; // is the number of columns in A equal to n
//   return true;
// }


// boolean canInvert2x2Matrix(Matrix A) {
//   if(A == null) return false;
//   if(A.getSize()[0] != 2) return false; // is the number of rows in A equal to m
//   if(A.getSize()[1] != 2) return false; // is the number of columns in A equal to n
//   return true;
// }

boolean checkMatrixSize(Matrix A, int m, int n) {
  if(A == null) return false;
  if(A.getSize()[0] != m) return false; // is the number of rows in A equal to m
  if(A.getSize()[1] != n) return false; // is the number of columns in A equal to n
  return true;
}


void printMatrix(Matrix m) {
  try {
    int size[] = m.getSize();
    // println();
    for(int i=0; i<size[0]; i++) {
      for(int j=0; j<size[1]; j++) {
        print("\t" + nf((float)m.matrix[i][j],1,2));
      }
      println();
    }
    println();
  } catch(NullPointerException e) {
    println("Matrix is null. Nothing to print");
    // e.printStackTrace();
  }
}


void testMatrixMath() {
  double[][] m = {
                  {1,2},
                  {3,4}
                };
  double[][] n = {
                  {5,6},
                  {7,8}
                };

  double[][] k = {
                  {1,6,3,4},
                  {5,6,7,8},
                  {2,6,3,4},
                  {5,6,9,8}
                };
                
  A = new Matrix(2, 2, m);
  B = new Matrix(2, 2, n);
  Matrix E = new Matrix(4, 4, k);
  
  double scalar = 2;

  println("scalar = " + scalar);
  println("Matrix A");
  printMatrix(A);
  println("Matrix B");
  printMatrix(B);
  println("C = A + B");
  C = MatrixAddition(A, B, 2, 2);
  printMatrix(C);
  println("C = A - B");
  C = MatrixSubtraction(A, B, 2, 2);
  printMatrix(C);
  println("C = A * scalar");
  C = MatrixScalarMultiply(A, 2, 2, scalar);
  printMatrix(C);
  println("C = A * B");
  C = MatrixMultiply(A, B, 2, 2, 2);
  printMatrix(C);
  println("D = C transposed");
  D = MatrixTranspose(C, 2, 2);
  printMatrix(D);
  println("D = A inverted");
  D = Matrix2x2Inversion(A);
  printMatrix(D);
  println("C = A * D");
  C = MatrixMultiply(A, D, 2, 2, 2);
  printMatrix(C);
  println("D = E inverted");
  D = Matrix4x4Inversion(E);
  printMatrix(D);
  println("Test E * D = I");
  Matrix I = MatrixMultiply(D, E, 4, 4, 4);
  printMatrix(I);
  println("Test D * E = I");
  I = MatrixMultiply(E, D, 4, 4, 4);
  printMatrix(I);
}
