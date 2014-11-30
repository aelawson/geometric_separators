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
	// Nothing yet
}

// Calculate the distance with the input, memoization
float calcDist(float point, ArrayList<Float> input) {
		int dist = point - prevPoint;
		// For each point before i, calculate distance to i
		for (int j = 0; j < i; j++) {
			float prevPoint = input.get(j);
			sum += currentPoint - prevPoint;
		}
		return sum;
}

// Calculate last sum and its distance from i
float calcLastSum(int i, ArrayList<Float> input, HashMap<Integer, Float> memoize) {
	// Calculate for squares
	float sum;
	// If possible, reuse solution
	if (memoize.contains(i)) {
		sum = memoize.get(i);
	}
	// Otherwise, calculate
	else {
		sum = calcDist(currentPoint, input);
	}
	float currentPoint = input.get(i);
	float nextPoint = input.get(i + 1);
	float dist = nextPoint - currentPoint;
	return sum, dist;
}

// Get sums and sums of squares of distances for an input
float getSums(ArrayList<Float> input) {
  // Memoization hash tables
  HashMap<Integer, Float> sumMemoize = new HashMap<Integer, Float>();
  HashMap<Integer, Float> sumSquaresMemoize = new HashMap<Integer, Float>();
	for (int i = 0; i < input.size() - 1; i++) {
		float sum, dist;
		// Calculate sum
		sum, dist = calcLastSum(i, input, sumMemoize);
		sumMemoize.put(i + 1, sum + (i * dist));
		// Calculate sum of squares
		sum, dist = calcLastSum(i, input, sumSquaresMemoize);
		sumSquaresMemoize.put(i + 1, sum + (i * Math.pow(d, 2)) + (2 * i * dist));
	}
	// Sum results for input
	float sum = 0;
	float sumSquares = 0;
	for (int i = 0; i < input.size(); i++) {
		sum += sumMemoize.get(i);
		sumSquares += sumSquaresMemoize.get(i);
	}
	return sum, sumSquares;
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
