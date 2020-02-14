// scaling parameters
float max_value = PI;//0.02;
float accm = 0.01;
float velm = 0.1;
float posm = 1.00;
float diffm = velm*10;//50.0; // per phase

// data set parameters
int num_references = 0;
float dt = 0.000200;

//model parameters
float p0 = 0;
float v0 = 0;
float a0 = 0;
float j0 = 0;
float s0 = 0;
float c0 = 0;
float tt = 1000 * dt;
float pt = PI/4;
float vt = 0;
float at = 0;

// noise parameters
float lsb = 1.0 * PI / pow(2, 14); // lsb of 14 bit rotary encoder
float an = 0;
float vn = 0;
float pn = 2.0 * lsb;

// filter parameters
float am = 0.02;
float vm = 0.1;
float pm = 1.0;
int average_samples = 0;

// regression parameters
int regression_samples = 48;
int direction = 0;

void setup() {
  size(1600, 1000, P2D);
  frameRate(12);
  background(0);
  pixelDensity(displayDensity());
  noLoop();
  //testMatrixMath();
}


void draw() {
  background(0);
  compute_samples();
  draw_coordinate_system();
  draw_graphs();
  regression_samples += direction;
  if(regression_samples < 32) direction = 1;
  if(regression_samples > 128) direction = -1;
  println(regression_samples);
  //println(average_samples++);
  //pm *= 0.99;
  //println(pm);
}
