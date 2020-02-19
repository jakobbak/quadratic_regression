float x1, x2, y0, y1, y2;
float xwidth, yheight, zoomwidth, zoomheight;
int xb, xe;
int num_samples;
boolean roll_inspection_point;
boolean mouse_inspection_point;

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
      draw_data(modl, i, j, 255);
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
      draw_data(filt, i, j, 64);
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
  if(use_measurement) {
    draw_zoom(meas, 64);    
  } else {
    draw_zoom(nois, 64);
  }
}


void draw_diff(int i, int j, int alpha) {
  y1 = height/2 - diff[i]*posm * yheight * diffm;
  y2 = height/2 - diff[j]*posm * yheight * diffm;
  stroke(192, 000, 192, alpha);
  line(x1, y1, x2, y2);
}

void draw_data(float data[][], int i, int j, int alpha) {
  y1 = height/2 - data[0][i]*posm * yheight;
  y2 = height/2 - data[0][j]*posm * yheight;
  stroke(255, 000, 000, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - data[1][i]*velm * yheight;
  y2 = height/2 - data[1][j]*velm * yheight;
  stroke(000, 255, 000, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - data[2][i]*accm * yheight;
  y2 = height/2 - data[2][j]*accm * yheight;
  stroke(000, 128, 255, alpha);
  line(x1, y1, x2, y2);  
}


void draw_points(float data[][], int i, int k, int alpha) {
  y1 = height/2 - data[k][i]*posm * yheight;
  stroke(255, 000, 000, alpha);
  ellipse(x1, y1, 5, 5);
}

void draw_zoom(float data[][], float alpha) {
  fill(255, 255, 255, 32);
  noStroke();
  rect(0, height/1.0, width/1.0, height/1.0);
  int ip = inspection_point;
  int rs = regression_samples;
  float ymin = zoom[0];
  float ymax = zoom[1];
  float yrange = abs(ymax - ymin);
  if(yrange <= 0.1) yrange = 0.1;
  float xrange = regression_samples + 1;
  zoomwidth = width/1.0/xrange;
  zoomheight = height/1.0/yrange;
  for(int i = 0; i <= rs; i++) {
    int k = i + ip - rs;
    if(k < 0) continue;
    float zx = i * zoomwidth;
    float zy = height - (data[0][k] - ymin) * zoomheight;
    noFill();
    stroke(255, 000, 000, alpha);
    ellipse(zx, zy, 5, 5);
    
    double a0, v0, p0;
    a0 = 0;
    v0 = 0;
    p0 = 0;
    try {
      a0 = coef[2][ip];
      v0 = coef[1][ip];
      p0 = coef[0][ip];
    } catch (ArrayIndexOutOfBoundsException e) {
    }
    //int k = i - j + regression_samples;
    //k = sample - inspection_point + regression_samples
    
    double t = (double)(i) * dt;
    //float acc1 = (float)                     (a0);
    //float vel1 = (float)              (a0*t + v0);
    float pos1 = (float) (0.5*a0*t*t + v0*t + p0);
    t = (double)(i+1) * dt;
    //float acc2 = (float)                     (a0);
    //float vel2 = (float)              (a0*t + v0);
    float pos2 = (float) (0.5*a0*t*t + v0*t + p0);
  
    //alpha = (int)max((float)alpha-(float)abs(j-i)*0.5, 0.0);
    float zx2 = (i+1) * zoomwidth;
    float zy1 = height - (pos1 - ymin) * zoomheight;
    float zy2 = height - (pos2 - ymin) * zoomheight;
    //y1 = height/2 - pos1*posm * yheight;
    //y2 = height/2 - pos2*posm * yheight;
    stroke(255, 128, 128, alpha);
    line(zx, zy1, zx2, zy2);
    
  }
}


void draw_curve_from_quadratic_regression_point(int i, int j, int alpha) {
  int k = i - j + regression_samples;
  //float t = (float)(k) * dt;
  //float acc1 =                                                   (float)coef[2][j];
  //float vel1 =                             (float)coef[2][j]*t + (float)coef[1][j];
  //float pos1 = (float)0.5*coef[2][j]*t*t + (float)coef[1][j]*t + (float)coef[0][j];
  //t = (float)(k+1) * dt;
  //float acc2 =                                                   (float)coef[2][j];
  //float vel2 =                             (float)coef[2][j]*t + (float)coef[1][j];
  //float pos2 = (float)0.5*coef[2][j]*t*t + (float)coef[1][j]*t + (float)coef[0][j];

  double a0, v0, p0;
  a0 = 0;
  v0 = 0;
  p0 = 0;
  try {
    a0 = coef[2][j];
    v0 = coef[1][j];
    p0 = coef[0][j];
  } catch (ArrayIndexOutOfBoundsException e) {
    inspection_point = regression_samples;
  }
  double t = (double)(k) * dt;
  float acc1 = (float)                     (a0);
  float vel1 = (float)              (a0*t + v0);
  float pos1 = (float) (0.5*a0*t*t + v0*t + p0);
  t = (float)(k+1) * dt;
  float acc2 = (float)                     (a0);
  float vel2 = (float)              (a0*t + v0);
  float pos2 = (float) (0.5*a0*t*t + v0*t + p0);

  alpha = (int)max((float)alpha-(float)abs(j-i)*0.5, 0.0);

  y1 = height/2 - pos1*posm * yheight;
  y2 = height/2 - pos2*posm * yheight;
  stroke(255, 128, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - vel1*velm * yheight;
  y2 = height/2 - vel2*velm * yheight;
  stroke(128, 255, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - acc1*accm * yheight;
  y2 = height/2 - acc2*accm * yheight;
  stroke(64, 128, 255, alpha);
  line(x1, y1, x2, y2);  
  
  if(i == inspection_point) {
    y1 = 0;
    y2 = height;
    float xback = -regression_samples * xwidth;
    noStroke();
    fill(255, 255, 255, 32);
    rect(x1, y1, xback, y2);
    noFill();
    stroke(255, 255, 255, 128);
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
    inspection_point = regression_samples;
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

  y1 = height/2 - pos1*posm * yheight;
  y2 = height/2 - pos2*posm * yheight;
  stroke(255, 128, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - vel1*velm * yheight;
  y2 = height/2 - vel2*velm * yheight;
  stroke(128, 255, 128, alpha);
  line(x1, y1, x2, y2);
  
  y1 = height/2 - acc1*accm * yheight;
  y2 = height/2 - acc2*accm * yheight;
  stroke(64, 128, 255, alpha);
  line(x1, y1, x2, y2);  
  
  if(i == inspection_point) {
    y1 = 0;
    y2 = height;
    float xback = -regression_samples * xwidth;
    noStroke();
    fill(255, 255, 255, 32);
    rect(x1, y1, xback, y2);
    noFill();
    stroke(255, 255, 255, 128);
    line(x1, y1, x1, y2);
  }
}
