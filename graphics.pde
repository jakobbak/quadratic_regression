float x1, x2, y0, y1, y2;
float xwidth, yheight;

void draw_coordinate_system() {
  xwidth = width / (float)num_references;
  yheight = height / 2 / max_value;
  x1 = 0;
  x2 = width;
  y0 = height/2;
  y1 = y0;
  y2 = y0;
  stroke(128);
  line(x1, y1, x2, y2);
}

void draw_graphs() {
  for(int i=0; i < num_references; i++) {
    int j = (i + 1)%num_references;
    x1 = i * xwidth;
    x2 = x1 + xwidth;
    draw_data(modl, i, j, 255);
    draw_data(filt, i, j, 64);
    draw_data(regr, i, j, 128);
    draw_diff(i, j, 128);
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
