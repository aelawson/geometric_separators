
// Reset Button
int reset_x = 100;
int reset_y = 400;
int reset_w = 100;
int reset_h = 50;
// Button Shapes
PShape reset;
PShape calculate;
// Input list
ArrayList<PShape> input = new ArrayList<PShape>();

// Setup
void setup() {
  background(0);
  size(500,500,P2D);
  // Create reset button
  reset = createShape(RECT, reset_x, reset_y, reset_w, reset_h);
  
  noLoop();
}

// On mouse press
void mousePressed() {
  if ((mouseX >= reset_x && mouseX <= (reset_x + reset_w)) &&
    (mouseY >= reset_y && mouseY <= (reset_y + reset_h))) {
    // Reset input and background
    input.clear();
  }
  else {
    PShape new_ellipse = createShape(ELLIPSE, mouseX, mouseY, 50, 50);
    input.add(new_ellipse);
  }
  redraw();
} 

// Draw
void draw() {
  background(0);
  shape(reset);
  for (PShape ellipse : input) {
    shape(ellipse);
  }
}
