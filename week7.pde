float theta;           // 旋转角度
float a;               // 控制分支长度的变量
float col;             // 控制颜色的变量
int numBranches = 7;   // 分支数量

void setup() {
  size(600, 600);
  frameRate(30);  // 设置合理的帧率
}

void draw() {
  pulsatingBackground();  // 创建脉动的背景
  translate(width/2, height/2);
  
  // 根据正弦函数随时间变化调整角度 theta
  theta = map(sin(millis()/1000.0), -1, 1, 0, PI/6);

  // Draw multiple branches in a circular pattern
  for (int i = 0; i < numBranches; i++) {
    a = 350;
    rotate(TWO_PI/numBranches);
    branch(mouseX/2);
  }

  interactiveControls();  // 增加互动控制
  dynamicEffect();        // 增加基于鼠标移动的动态效果
}

void branch(float len) {
  // 根据分支长度映射颜色
  col = map(len, 0, 90, 150, 255);
  fill(col, 0, 74);
  
  // 根据分支长度变化设置线条粗细
  float weight = map(len, 0, 350, 1, 5);
  strokeWeight(weight);
  stroke(252, 198, 103);
  
  // 绘制表示分支的线
  line(0, 0, 0, -len);
  
  // 在分支末端绘制一个小椭圆
  ellipse(0, -len, 3, 3);
  len *= 0.7;

  // 递归绘制更小的分支
  if (len > 30) {
    pushMatrix(); 
    translate(0, -30);
    rotate(theta);
    branch(len); 
    popMatrix();

    pushMatrix();
    translate(0, -30);
    rotate(-theta);
    branch(len); 
    popMatrix();
  }
}

void pulsatingBackground() {
  // 创建脉动效果，通过改变背景颜色
  float pulse = sin(millis() / 1000.0) * 100 + 0;
  background(pulse, 128,130);
}

void interactiveControls() {
  // 通过鼠标滚轮改变分支数量
  numBranches = int(map(mouseY, 0, height, 2, 12));
}

void dynamicEffect() {
  // 根据鼠标位置改变分支长度
  float dynamicLen = map(mouseX, 0, width, 50, 250);
  branch(dynamicLen);
}
