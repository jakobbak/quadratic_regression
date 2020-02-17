float x1, x2, y0, y1, y2;
float xwidth, yheight;
int xb, xe;
int num_samples;

void set_viewport(int[] viewport) {
  xb = viewport[0];
  xe = viewport[1];
  if(xb < 0) xb = 0;
  if(xe > num_references) xe = num_references;
  num_samples = xe - xb;
  //xwidth = width / (float)num_references;
  xwidth = width / (float)num_samples;
  yheight = height / 2 / max_value;
}  
  

void draw_coordinate_system() {
  x1 = 0;
  x2 = width;
  y0 = height/2;
  y1 = y0;
  y2 = y0;
  stroke(128);
  line(x1, y1, x2, y2);
}

void draw_graphs() {
  for(int i=xb; i < num_samples+xb; i++) {
    int j = (i + 1)%num_references;
    x1 = (i - xb)* xwidth;
    x2 = x1 + xwidth;
    noFill();
    if(use_measurement) {
      draw_data(meas, i, j, 255);
      draw_data(filt, i, j, 64);
      draw_data(regr, i, j, 128);
      draw_diff(i, j, 128);
      if(use_cubic_regression) {      
        draw_curve_from_cubic_regression_point(i, inspection_point, 255);
      } else {
        draw_curve_from_quadratic_regression_point(i, inspection_point, 255);
      }
      //draw_points(nois, i, 0, 255);
    
    } else {
      draw_data(modl, i, j, 255);
      //draw_data(filt, i, j, 64);
      draw_data(regr, i, j, 128);
      draw_diff(i, j, 128);
      if(use_cubic_regression) {      
        draw_curve_from_cubic_regression_point(i, inspection_point, 255);
      } else {
        draw_curve_from_quadratic_regression_point(i, inspection_point, 255);
      }
      //draw_points(nois, i, 0, 255);
    }
  }  
}


void draw_diff(int i, int j, int alpha) {
  y1 = height/2 - diff[i]*posm * yheight * diffm * zoom;
  y2 = height/2 - diff[j]*posm * yheight * diffm * zoom;
  stroke(192, 000, 192, alpha);
  line(x1, y1, x2, y2);
}

void draw_data(float data[][], int i, int j, int alpha) {
  y1 = height/2 - data[0][i]*posm * yheight * zoom;
  y2 = height/2 - data[0][j]*posm * yheight * zoom;
  stroke(255, 000, 000, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - data[1][i]*velm * yheight * zoom;
  y2 = height/2 - data[1][j]*velm * yheight * zoom;
  stroke(000, 255, 000, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - data[2][i]*accm * yheight * zoom;
  y2 = height/2 - data[2][j]*accm * yheight * zoom;
  stroke(000, 128, 255, alpha);
  line(x1, y1, x2, y2);  
}


void draw_points(float data[][], int i, int k, int alpha) {
  y1 = height/2 - data[k][i]*posm * yheight * zoom;
  stroke(255, 000, 000, alpha);
  ellipse(x1, y1, 5, 5);
}


void draw_curve_from_quadratic_regression_point(int i, int j, int alpha) {
  int k = i - j + regression_samples;
  float t = (float)(k) * dt;
  float acc1 =                                                   (float)coef[2][j];
  float vel1 =                             (float)coef[2][j]*t + (float)coef[1][j];
  float pos1 = (float)0.5*coef[2][j]*t*t + (float)coef[1][j]*t + (float)coef[0][j];
  t = (float)(k+1) * dt;
  float acc2 =                                                   (float)coef[2][j];
  float vel2 =                             (float)coef[2][j]*t + (float)coef[1][j];
  float pos2 = (float)0.5*coef[2][j]*t*t + (float)coef[1][j]*t + (float)coef[0][j];

  alpha = (int)max((float)alpha-(float)abs(j-i)*0.5, 0.0);

  y1 = height/2 - pos1*posm * yheight * zoom;
  y2 = height/2 - pos2*posm * yheight * zoom;
  stroke(255, 128, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - vel1*velm * yheight * zoom;
  y2 = height/2 - vel2*velm * yheight * zoom;
  stroke(128, 255, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - acc1*accm * yheight * zoom;
  y2 = height/2 - acc2*accm * yheight * zoom;
  stroke(64, 128, 255, alpha);
  line(x1, y1, x2, y2);  
  
  y1 = 0;
  y2 = height;
  stroke(255, 255, 255, 64);
  if(i == inspection_point) {
    line(x1, y1, x1, y2);
  }
}


void draw_curve_from_cubic_regression_point(int i, int j, int alpha) {
  int k = i - j + regression_samples;
  double j0, a0, v0, p0;
  j0 = 0;
  a0 = 0;
  v0 = 0;
  p0 = 0;
  try {
    j0 = coef[3][j];
    a0 = coef[2][j];
    v0 = coef[1][j];
    p0 = coef[0][j];
  } catch (ArrayIndexOutOfBoundsException e) {
  }
  double t = (double)(k) * dt;
  float acc1 = (float)                                 (j0*t + a0);
  float vel1 = (float)                    (0.5*j0*t*t + a0*t + v0);
  float pos1 = (float) (1.0/6.0*j0*t*t*t + 0.5*a0*t*t + v0*t + p0);
  t = (float)(k+1) * dt;
  float acc2 = (float)                                 (j0*t + a0);
  float vel2 = (float)                    (0.5*j0*t*t + a0*t + v0);
  float pos2 = (float) (1.0/6.0*j0*t*t*t + 0.5*a0*t*t + v0*t + p0);

  alpha = (int)max((float)alpha-(float)abs(j-i)*0.5, 0.0);

  y1 = height/2 - pos1*posm * yheight * zoom;
  y2 = height/2 - pos2*posm * yheight * zoom;
  stroke(255, 128, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - vel1*velm * yheight * zoom;
  y2 = height/2 - vel2*velm * yheight * zoom;
  stroke(128, 255, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - acc1*accm * yheight * zoom;
  y2 = height/2 - acc2*accm * yheight * zoom;
  stroke(64, 128, 255, alpha);
  line(x1, y1, x2, y2);  
  
  y1 = 0;
  y2 = height;
  stroke(255, 255, 255, 64);
  if(i == inspection_point) {
    line(x1, y1, x1, y2);
  }
}
