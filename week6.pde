PImage img;
ArrayList<Dust> dust = new ArrayList<Dust>();
PGraphics fprint;
float scl;
boolean scatter = false;
int num = 30000;

color deepPurple = color(238,58,140);  // 深蓝紫色
color lightBlue = color(152,251,152);  // 浅蓝色

void setup() {
  size(550 , 547);
  selectInput("Select an image file:", "imageSelected");
  scl = height / 600.0;
  fprint = createGraphics(width, height);
  fprint.beginDraw();
  fprint.background(0);
  fprint.endDraw();
  imageMode(CENTER);
}

void draw() {
  if (img != null) {
    makeDust();
    background(0);
    pushMatrix();
    translate(width / 2, height / 2);
    
    // 将图像调整为适应绘图区域
    float imgAspect = (float)img.width / img.height;
    if (width > height) {
      image(img, 0, 0, height * imgAspect, height);
    } else {
      image(img, 0, 0, width, width / imgAspect);
    }

    image(fprint, 0, 0);
    scale(scl);
    for (Dust d : dust) {
      if (d.pos != null && d.tpos != null) {
        float brightnessValue = 0;
        if (img.width > 0 && img.height > 0) {
          brightnessValue = brightness(img.get(int(d.pos.x + img.width / 2), int(d.pos.y + img.height / 2)));
        }

        // 使用 lerpColor 进行颜色渐变
        color particleColor = lerpColor(deepPurple, lightBlue, map(brightnessValue, 0, 255, 0, 1));

        stroke(particleColor);
        strokeWeight(2);  // 增加边缘大小
        point(d.pos.x, d.pos.y);
        if (frameCount > d.id) {
          d.pos.lerp(d.tpos, 0.1);
        }
      }
    }
    popMatrix();
  }
}

void makeDust() {
  if (dust.size() > num) return;
  for (int i = 0; i < 200; i++) {
    PVector pos = PVector.random2D().mult(random((height / scl) / PI));
    if (img != null) {
      color c = img.get(int(pos.x + img.width / 2), int(pos.y + img.height / 2));
      if (brightness(c) < 60 && pos.x < img.width / 2 && pos.x > -img.width / 2 && pos.y < img.height / 2 && pos.y > -img.height / 2) {
        fprint.stroke(255);
        fprint.pushMatrix();
        fprint.translate(width / 2, height / 2);
        fprint.scale(scl);
        fprint.strokeWeight(2);
        fprint.point(pos.x, pos.y);
        fprint.popMatrix();
      } else {
        float d = abs(pos.mag());
        pos.x += random(-d / 20, d / 20);  // 减小初始随机范围
        pos.y += random(-d / 20, d / 20);

        Dust newDust = new Dust(pos.x, pos.y, pos.x, pos.y, random(60));
        dust.add(newDust);
      }
    }
  }
}

void mousePressed() {
  scatter = !scatter;
  frameCount = 0;
  if (scatter) {
    for (Dust d : dust) {
      PVector pos = PVector.fromAngle(random(TWO_PI));
      pos.mult(random(height / (3 * scl), height / scl));
      d.tpos.x = d.opos.x + pos.x;
      d.tpos.y = d.opos.y + pos.y;
    }
  } else {
    for (Dust d : dust) {
      if (d.tpos != null) {
        d.tpos.x = d.opos.x;
        d.tpos.y = d.opos.y;
      }
    }
  }
}

void mouseMoved() {
  for (Dust d : dust) {
    if (d.pos != null && d.tpos != null) {
      PVector mpos = new PVector(mouseX - (width / 2), mouseY - (height / 2));
      PVector delta = mpos.sub(d.pos);
      float farness = delta.mag();
      if (farness < 50 * scl) {
        PVector move = new PVector(pmouseX - mouseX, pmouseY - mouseY + random(-25, 25)).mult(10 / max(2, farness));
        d.tpos.add(move);
      }
    }
  }
}

void imageSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());
    img.resize(width, height);  // 调整图片大小适应绘图区域
  }
}

class Dust {
  PVector pos, tpos, opos;
  float id;

  Dust(float x, float y, float tx, float ty, float _id) {
    pos = new PVector(x, y);
    tpos = new PVector(tx, ty);
    opos = new PVector(x, y);
    id = _id;
  }
}
