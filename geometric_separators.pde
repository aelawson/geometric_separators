// Reset button coordinates
int reset_x = 140;
int reset_y = 460;
int reset_w = 100;
int reset_h = 25;
// Calculate button coordinates
int calc_x = 250;
int calc_y = 460;
int calc_w = 100;
int calc_h = 25;
// Button Shapes
PShape reset;
PShape calculate;
// Input list
ArrayList<PVector> input = new ArrayList<PVector>();

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
    PVector new_point = new PVector(mouseX, mouseY);
    input.add(new_point);
  }
  redraw();
}

// Estimate centerpoint
void approxCenter(ArrayList<PShape> input) {
  if (input.size() == 1) {
    // Do nothing
  }
  else {
    // Sample points
    
  }
}

// Estimate the geometric median - dynamic programming
void geomMedian() {
  // Memoization hash tables
  HashMap<String, Double> left = new HashMap<String, Double>();
  HashMap<String, Double> right = new HashMap<String, Double>();
  HashMap<String, Double> up = new HashMap<String, Double>();
  HashMap<String, Double> down = new HashMap<String, Double>();
  // Sum of squares values
  ArrayList<Double> leftSq = new ArrayList<Double>();
  ArrayList<Double> rightSq = new ArrayList<Double>();
  ArrayList<Double> upSq = new ArrayList<Double>();
  ArrayList<Double> downSq = new ArrayList<Double>();
}

// Draw
void draw() {
  background(255);
  shape(reset);
  shape(calculate);
  fill(50);
  text("Reset.", reset_x + 30, reset_y + 15);
  text("Calculate.", calc_x + 25, calc_y + 15);
  for (PVector point : input) {
    strokeWeight(4);
    point(point.x, point.y);
  }
}
