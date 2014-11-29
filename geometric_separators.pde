// Reset Button
int reset_x = 100;
int reset_y = 450;
int reset_w = 100;
int reset_h = 25;
// Calculate Button
int calc_x = 250;
int calc_y = 450;
int calc_w = 100;
int calc_h = 25;
// Button Shapes
PShape reset;
PShape calculate;
// Input list
ArrayList<PShape> input = new ArrayList<PShape>();

// Setup
void setup() {
  background(255);
  size(500,500,P2D);
  // Create buttons
  reset = createShape(RECT, reset_x, reset_y, reset_w, reset_h);
  calculate = createShape(RECT, calc_x, calc_y, calc_w, calc_h);
  noLoop();
}

// On mouse press
void mousePressed() {
  // If mouse presses reset button
  if ((mouseX >= reset_x && mouseX <= (reset_x + reset_w)) &&
    (mouseY >= reset_y && mouseY <= (reset_y + reset_h))) {
    // Reset input and background
    input.clear();
  }
  // If mouse presses calculate button
  else if ((mouseX >= reset_x && mouseX <= (reset_x + reset_w)) &&
    (mouseY >= reset_y && mouseY <= (reset_y + reset_h))) {
    // Get sorted input points
  }
  else {
    PShape new_ellipse = createShape(ELLIPSE, mouseX - 12.5, mouseY - 12.5, 25, 25);
    input.add(new_ellipse);
  }
  redraw();
}

// Estimate centerpoint
void approxCenter(ArrayList<PShape> input) {
  if (input.size() == 1) {
    return ArrayList.get(0);
  }
  else {
    // Sample points
    
  }
}

// Estimate the geometric median - dynamic programming
void geomMedian() {
  // Memoization hash tables
  HashMap<Double> left = new HashMap<Double>():
  HashMap<Double> right = new HashMap<Double>():
  HashMap<Double> up = new HashMap<Double>():
  HashMap<Double> down = new HashMap<Double>():
  // Sum of squares values
  ArrayList<Double> leftSq = new ArrayList<Double>();
  ArrayList<Double> rightSq = new ArrayList<Double>();
  for (PShape circle : inputSorted) {
    
  } 
}

// Draw
void draw() {
  background(255);
  shape(reset);
  shape(calculate);
  text("Reset.", reset_x + 25, reset_y - 10);
  text("Calculate.", calc_x + 25, calc_y - 10);
  for (PShape ellipse : input) {
    shape(ellipse);
    fill(255);
  }
}
