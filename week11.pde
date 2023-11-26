int bgWidth = 500;
int bgHeight = 500;
float lineSize = 0;
float colSize = 0;

color[] colors = {#ffffff, #f9d7f9,#f9e3d7, #d7f2f9};
//Define the fill color

void mondrianStyle() {
  for(int line = 0; line < bgHeight; line += lineSize + 8) {
    lineSize = random(2, bgWidth/3);
    for(int col = 0; col < bgWidth; col += colSize +6
 ) {
      colSize = random(3, bgHeight/2);
 // Define the color block size  

      color rectColor = colors[int(random(colors.length))];
      fill(rectColor);
      rect(col, line, colSize, lineSize);
      //Drawing color blocks

      stroke(#000000);
      strokeWeight(3);
      float x = col+colSize;
      float y = line+lineSize;
      line(0, y, bgWidth, y);
      line(x, line, x, y);
      //Drawing Black lines
    }
  }
}

void setup() {
  size(500,500);
  background(#ffffff);
  mondrianStyle(); 
  //First run
}
