import controlP5.*;

ControlP5 cp5;
float incr;
float y;
float h;
int count;
float strt;
float 鼠标速度因子 = 0.1;
float 色调偏移 = 0;
float 亮度因子 = 1;
float 大小因子 = 1;
float 扩散因子 = 1;
float 收敛因子 = 1;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  frameRate(150);
  y = -3;
  incr = .004;
  strt = random(80, 360);
  
  cp5 = new ControlP5(this,createFont("微软雅黑", 10));
  cp5.addSlider("鼠标速度因子").setPosition(10, 10).setRange(0, 1).setValue(鼠标速度因子);
  cp5.addSlider("色调偏移").setPosition(10, 30).setRange(0, 360).setValue(色调偏移);
  cp5.addSlider("亮度因子").setPosition(10, 50).setRange(0, 2).setValue(亮度因子);
  cp5.addSlider("大小因子").setPosition(10, 70).setRange(0, 2).setValue(大小因子);
  cp5.addSlider("扩散因子").setPosition(10, 90).setRange(0, 2).setValue(扩散因子);
  cp5.addSlider("收敛因子").setPosition(10, 110).setRange(0, 2).setValue(收敛因子);
}

void draw() {
  if (y < 3) {
    for (float x = -3; x <= 3; x += incr) {
      float 鼠标X偏移 = map(mouseX, 0, width, -0.5, 0.5) * 鼠标速度因子;
      drawWing(x + 鼠标X偏移, y);
    }
    y += incr;
  }
  
  if (y >= 60) {
    noLoop();
  }
}

void drawWing(float xin, float yin) {
  float x = xin * cos(sin(4.0 * yin));
  float y = yin * cos(sin(1.0 * xin));
  float x2 = map(x, -3, 3, 20, width-20);
  float y2 = map(y, -3, 3, 20, height-20);
  count++;
  h = map(count, 0, 1948816, strt, strt-80);

  float spread = map(count, 0, 1948816, 1, 扩散因子);
  float convergence = map(count, 0, 1948816, 1, 收敛因子);
  x2 += random(-spread, spread);
  y2 += random(-spread, spread);
  x2 = lerp(x2, width/2, convergence);
  y2 = lerp(y2, height/2, convergence);
  
  stroke((h + 色调偏移) % 360, random(100), 100 * 亮度因子, 8);
  strokeWeight(random(.5, 2) * 大小因子);
  point(x2, y2);
}

void mousePressed() {
  background(0);
  y = -3;
  count = 0;
  strt = random(80, 360);
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("鼠标速度因子") || theEvent.isFrom("色调偏移") || 
      theEvent.isFrom("亮度因子") || theEvent.isFrom("大小因子") || 
      theEvent.isFrom("扩散因子") || theEvent.isFrom("收敛因子")) {
    redraw(); 
  }
}   
