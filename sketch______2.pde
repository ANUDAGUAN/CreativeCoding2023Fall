float step=TWO_PI/6;
float t=0;

void setup(){
  size(800,800);
  background(0);
  frameRate(10);
}

void draw(){
  fill(0,10);
  noStroke();
  rect(0,0,width,height);
  
  int cycleLength=800;
  float n=t%cycleLength;
  if (n>cycleLength/3){
    n=cycleLength-n;
  }
      float m=n/60+1;
      noFill();
      for(int i=0;i<20;i++){
        stroke(255-m*120,20+i*10,m*120);
        strokeWeight(3+i/5);
        waveCircle(100-i*5,250-i*5,m*(i+1)/8);
   }
   t++;
}

void waveCircle(int size,int twist,float t){
  beginShape();
  for (float theta=0;theta<=TWO_PI+3*step; theta+=step){
    float r1, r2;
    r1=cos(theta)+155;
    r2=sin(theta)+155;
    float r=size+noise(r1,r2,t)*twist;
    float x=width/2+r*cos(theta);
    float y=height/2+r*sin(theta);
    curveVertex(x,y);
  }
  endShape();
  saveFrame();
}
