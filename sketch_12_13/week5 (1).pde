import peasy.*;
import controlP5.*;

float dia = 50.0;
float sw = 1;

PVector[][] vp;
int layer = 20;
int section = 36;
float[] layerRadiiX;  // Array to store X radii for each layer
float[] layerRadiiY;  // Array to store Y radii for each layer
float cyHigth = 20;

PeasyCam cam;
ControlP5 cp;

void setup() {
  size(800, 800, P3D);
  background(0);
  cam = new PeasyCam(this, 400);
  UI();

  // Set up layerRadii with default values
  layerRadiiX = new float[layer];
  layerRadiiY = new float[layer];
  for (int i = 0; i < layer; i++) {
    layerRadiiX[i] = 200; // Default X radius for each layer
    layerRadiiY[i] = 120;  // Default Y radius for each layer
  }

  buildCylinder();
}

void draw() {
  background(0);
  buildCylinder();
  displayCylinder();

  cam.beginHUD();
  cp.draw();
  cam.endHUD();

  if (mouseX < 300 && mouseY < 300) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}

void buildCylinder() {
  vp = new PVector[layer][section];
  float angle = TWO_PI / section;

  for (int i = 0; i < layer; i++) {
    for (int j = 0; j < section; j++) {
      vp[i][j] = new PVector(layerRadiiX[i] * cos(angle * j), layerRadiiY[i] * sin(angle * j), cyHigth * i);
    }
  }
}

void displayCylinder() {
  strokeWeight(1);
  stroke(255);
  float c = 255 / vp.length;

  for (int i = 0; i < vp.length - 1; i++) {
    fill(i * c);
    for (int j = 0; j < vp[0].length; j++) {
      fill(lerpColor(color(255, 0, 0), color(0, 0, 255), i / (float)(vp.length - 1)));
        
      beginShape(TRIANGLES);
      vertex(vp[i][j].x, vp[i][j].y, vp[i][j].z);
      vertex(vp[i + 1][j].x, vp[i + 1][j].y, vp[i + 1][j].z);
      vertex(vp[i][(j + 1) % vp[0].length].x, vp[i][(j + 1) % vp[0].length].y, vp[i][(j + 1) % vp[0].length].z);

      vertex(vp[i][(j + 1) % vp[0].length].x, vp[i][(j + 1) % vp[0].length].y, vp[i][(j + 1) % vp[0].length].z);
      vertex(vp[i + 1][j].x, vp[i + 1][j].y, vp[i + 1][j].z);
      vertex(vp[i + 1][(j + 1) % vp[0].length].x, vp[i + 1][(j + 1) % vp[0].length].y, vp[i + 1][(j + 1) % vp[0].length].z);
      endShape();
    }
  }

  for (int i = 0; i < vp.length; i++) {
    for (int j = 0; j < vp[0].length; j++) {
      strokeWeight(5);
      stroke(255);
      point(vp[i][j].x, vp[i][j].y, vp[i][j].z);
    }
  }
}
