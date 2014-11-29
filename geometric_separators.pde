import java.util.*;

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
// Input lists
ArrayList<PVector> input = new ArrayList<PVector>();
ArrayList<Float> inputX, inputY;
// Misc
Comparator pointComparator;
// Setup
void setup() {
  background(255);
  size(500,500,P2D);
  // Create buttons
  reset = createShape(RECT, reset_x, reset_y, reset_w, reset_h);
  calculate = createShape(RECT, calc_x, calc_y, calc_w, calc_h);
  noLoop();
  // Define new comparator
	pointComparator = new Comparator<Float>() {
		public int compare(Float p1, Float p2) {
			if (p1 < p2) {
				return -1;
			}
			else if (p2 < p1) {
				return 1;
			}
			else {
				return 0;
			}
		}
	};
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
  else if ((mouseX >= calc_x && mouseX <= (calc_x + calc_w)) &&
	(mouseY >= calc_y && mouseY <= (calc_y + calc_h))) {
		// Build component lists
		inputX = new ArrayList<Float>();
		inputY = new ArrayList<Float>();
		for (PVector point : input) {
			inputX.add(point.x);
			inputY.add(point.y);
	}
	// Sort lists
	Collections.sort(inputX, pointComparator);
	Collections.sort(inputY, pointComparator);
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
  	// Do nothing
  }
}

// Estimate the geometric median - dynamic programming
void geomMedian() {
  // Memoization hash tables
  HashMap<Integer, Float> xMemoize = new HashMap<Integer, Float>();
  HashMap<Integer, Float> yMemoize = new HashMap<Integer, Float>();
  // Calculate for x-axis
  // For each point
	for (int i = 0; i < inputX.size(); i++) {
		float currentPoint = inputX.get(i);
	  ArrayList<Double> leftSquares = new ArrayList<Double>();
	  ArrayList<Double> rightSquares = new ArrayList<Double>();
	  ArrayList<Double> upSquares = new ArrayList<Double>();
	  ArrayList<Double> downSquares = new ArrayList<Double>();
	  // Get distance to every previous point
	}
}

// Calculate the distance with the input, memoization
void calcDist(float point, ArrayList<Float> input, HashMap<Integer, Float> memoize) {
	if (memoize.contains(currentPoint)) {
		// Reuse solution
		return memoize.get(currentPoint);
	}
	else {
		int dist = point - prevPoint;
		for (int j = 0; j < i; j++) {
			float prevPoint = input.get(j);
			sum += currentPoint - prevPoint;
		}
		memoize.put(currentPoint, sum);
		return sum;
	}
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
