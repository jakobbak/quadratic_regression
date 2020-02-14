Matrix A, B, C, D;

class Matrix {
  int r, c;
  float matrix[][];
  Matrix(int rows, int columns) {
    r = rows;
    c = columns;
    matrix = new float[rows][columns];
  }
  Matrix(int rows, int columns, float m[][]) {
    r = rows;
    c = columns;
    matrix = new float[rows][columns];
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
  void set(float m[][]) {
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


Matrix MatrixScalarMultiply(Matrix A, int m, int n, float scalar) {
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
  float a = A.matrix[0][0];
  float b = A.matrix[0][1];
  float c = A.matrix[1][0];
  float d = A.matrix[1][1];
  float determinant = a * d - b * c;
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
        print("\t" + m.matrix[i][j]);
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
  float[][] m = {
                  {1,2},
                  {3,4}
                };
  float[][] n = {
                  {5,6},
                  {7,8}
                };

  A = new Matrix(2, 2, m);
  B = new Matrix(2, 2, n);
  float scalar = 2;

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
}
