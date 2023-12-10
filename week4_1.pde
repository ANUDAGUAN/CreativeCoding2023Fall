class PController {
  ArrayList<PartiDot> partiDots;
  int initialRandMag = 5;

  PController() {
    partiDots = new ArrayList<PartiDot>();
  }

  void addParticles(int amt, PVector mouseLoc, PVector mouseVel) {
    for (int i = 0; i < amt; i++) {
      float randRadiansLoc = random(2 * PI);
      PVector initLocOffset = new PVector(cos(randRadiansLoc) * 5, sin(randRadiansLoc) * 5);
      float randRadiansVel = random(2 * PI);
      float randMagVel = random(1, 5);
      PVector initVelOffset = new PVector(cos(randRadiansLoc) * randMagVel, sin(randRadiansLoc) * randMagVel);

      PVector initLoc = PVector.add(initLocOffset, mouseLoc);
      PVector initVel = PVector.add(initVelOffset, mouseVel);

      PartiDot additionalParticle = new PartiDot(initLoc, initVel);
      partiDots.add(additionalParticle);
    }
  }

  void repulse() {
    for (int i = 0; i < partiDots.size(); i++) {
      PartiDot targetParticle1 = partiDots.get(i);
      for (int j = i + 1; j < partiDots.size(); j++) {
        PartiDot targetParticle2 = partiDots.get(j);
        PVector dir = PVector.sub(targetParticle1.loc, targetParticle2.loc);
        float thres = (targetParticle1.r + targetParticle2.r) * 3.5;
        if (dir.x > -thres && dir.x < thres && dir.y > -thres && dir.y < thres) {
          float magnitude = dir.mag();
          float distSqrd = pow(magnitude, 3);
          if (distSqrd > 0) {
            float pushingForce = 1 / distSqrd;
            dir.normalize();
            dir.mult(pushingForce);
            PVector accOffset1 = PVector.div(dir, targetParticle1.mass);
            PVector accOffset2 = PVector.div(dir, targetParticle2.mass);
            targetParticle1.acc.add(accOffset1);
            targetParticle2.acc.sub(accOffset2);
          }
        }
      }
    }
  }

  void update(PImage pattern) {
    for (int i = 0; i < partiDots.size(); i++) {
      PartiDot targetPartiDot = partiDots.get(i);
      targetPartiDot.update(pattern);
    }
  }

  void displayRECT() {
    for (int i = 0; i < partiDots.size(); i++) {
      PartiDot targetParticle = partiDots.get(i);
      targetParticle.displayRECT();
    }
  }
}

class PartiDot {
  PVector loc;
  PVector vel;
  PVector acc;

  float mass;
  float decay;
  float r;
  float rDest;
  color pcColor;

  boolean defaultRenderingMode = true;

  PartiDot(PVector initLoc, PVector initVel) {
    loc = initLoc;
    vel = initVel;
    acc = new PVector(0, 0);

    decay = random(0.9, 0.95);
    rDest = 5;
    r = 3;
    mass = sq(r) * 0.0001 + 0.01;
  }

  float getGrayValue(color c) {
    return brightness(c) / 255.0;
  }

  void update(PImage pattern) {
    vel.add(acc);

    float maxVel = r + 0.0025;
    float velLength = sq(vel.mag()) + 0.1;
    if (velLength > sq(maxVel)) {
      vel.normalize();
      vel.mult(maxVel);
    }

    loc.add(vel);
    vel.mult(decay);
    acc.set(0, 0, 0);

    if (loc.x > 0 && loc.x < width - 1 && loc.y > 0 && loc.y < height - 1) {
      int index = floor(loc.x) + floor(loc.y) * pattern.width;
      pcColor = color(pattern.pixels[index]);
      rDest = brightness(pattern.pixels[index]) / float(255) * 3 + 0.5;
    } else {
      rDest = 0.1;
    }

    r = lerp(r, rDest, 0.1);
    mass = sq(r) * 0.0001 + 0.01;
  }

  void displayRECT() {
    float grayValue = getGrayValue(pcColor);
    fill(grayValue * 255);
    noStroke();
    rectMode(CENTER);
    rect(loc.x, loc.y, r * 5, r * 5);
  }
}

String selectedFile;

PController pc;
boolean mouseDown;
PVector mouseLoc, mousePLoc, mouseVel;
PImage origionImg;
PFont font;

int tintIndex = 0;

void setup() {
  selectInput("Select a file to process:", "loadFile");
  size(1280, 720, OPENGL);
  imageMode(CENTER);
  font = createFont("微软雅黑", 18, true);
  smooth();

  stroke(255);
  ellipseMode(RADIUS);

  pc = new PController();
  mouseLoc = new PVector(0, 0, 0);
  mousePLoc = new PVector(0, 0, 0);
  mouseVel = new PVector(0, 0, 0);
}

void draw() {
  background(0);

  if (mouseDown) pc.addParticles(10, mouseLoc, mouseVel);
  pc.repulse();
  pc.update(origionImg);
  pc.displayRECT();
  textFont(font);
  fill(200);
}

void mouseDragged() {
  mouseMoved();
}

void mousePressed() {
  mouseDown = true;
}

void mouseReleased() {
  mouseDown = false;
}

void mouseMoved() {
  mousePLoc.set(pmouseX, pmouseY, 0);
  mouseLoc.set(mouseX, mouseY, 0);
  mouseVel = PVector.sub(mouseLoc, mousePLoc);
}

void loadFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    selectedFile = selection.getAbsolutePath();
    origionImg = loadImage(selectedFile);
  }
}
