// scaling parameters
float max_value = PI;//0.02;
float accm = 0.01;
float velm = 0.1;
float posm = 1.00;
float diffm = 50.0; // per phase//velm*10;//

// data set parameters
int num_references = 0;
int[] viewport = {0, 1000};
float dt = 0.00020;
int inspection_point = 0;
boolean use_measurement = true;

//model parameters
float p0 = 0;
float v0 = 0;
float a0 = 200;
float j0 = 0;
float s0 = 0;
float c0 = 0;
float tt = 1000 * dt;
float pt = 1.5*PI/2;//PI/2;//
float vt = 14;
float at = 0;

// noise parameters
float lsb = 1.0 * PI / pow(2, 14); // lsb of 14 bit rotary encoder
float an = 0;
float vn = 0;
float pn = 4.0 * lsb;

// filter parameters
float am = 0.02;
float vm = 0.10;
float pm = 1.0;
int average_samples = 0;

// regression parameters
boolean use_cubic_regression = false;
float cubic_multiplier = 2;
int regression_samples = 64;
int direction = 0;

void setup() {
  size(1680, 1050, P2D);
  frameRate(24);
  background(0);
  pixelDensity(displayDensity());
  compute_once();
  //noLoop();
}


void draw() {
  background(0);
  compute_samples();
  set_viewport(viewport);
  draw_coordinate_system();
  draw_graphs();
  if(roll_inspection_point) {
    inspection_point++;    
  } else {
    if(mouse_inspection_point) {
      inspection_point = (int)(mouseX / xwidth);
    }
  }    
}

void keyPressed() {
   roll_inspection_point = false;
   mouse_inspection_point = false;
   if(key == ' ') {
     roll_inspection_point = true;
   }
   if(keyCode == LEFT) {
     inspection_point--;
   }
   if(keyCode == RIGHT) {
     inspection_point++;
   }
}

void mousePressed() {
  roll_inspection_point = false;
  mouse_inspection_point = true;
  inspection_point = (int)(mouseX / xwidth);
}
