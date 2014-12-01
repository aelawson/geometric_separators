import java.util.*;
import java.util.Map.*;
import java.lang.Boolean;

int reset_x = 140;
int reset_y = 460;
int reset_w = 100;
int reset_h = 25;

int calc_x = 250;
int calc_y = 460;
int calc_w = 100;
int calc_h = 25;

PShape reset;
PShape calculate;
PShape sphere;
PVector centerPoint;
ArrayList<PVector> rawInput = new ArrayList<PVector>();
Comparator<PVector> compareX, compareXRev, compareY, compareYRev;

// Triple used for returning three items
private class ReturnTriple {
	public float sum;
	public float dist;
	public HashMap<PVector, Float> memoize;
	public ReturnTriple(float sum, float dist, HashMap<PVector, Float> memoize) {
		this.sum = sum;
		this.dist = dist;
		this.memoize = memoize;
	}
}

// Double used for returning centerpoint and sphere
private class CenterAndSphere {
    public PVector center;
    public PShape sphere;
    public CenterAndSphere(PVector center, PShape sphere) {
        this.center = center;
        this.sphere = sphere;
    }
}

// Setup
void setup() {
  background(255);
  size(500,500,P2D);
  // Create buttons
  reset = createShape(RECT, reset_x, reset_y, reset_w, reset_h);
  calculate = createShape(RECT, calc_x, calc_y, calc_w, calc_h);
  noLoop();
  compareX = new Comparator<PVector>() {
		public int compare(PVector p1, PVector p2) {
			if (p1.x < p2.x) {
				return -1;
			}
			else if (p2.x < p1.x) {
				return 1;
			}
			else {
				return 0;
			}
		}
	};
  compareXRev = new Comparator<PVector>() {
		public int compare(PVector p1, PVector p2) {
			if (p1.x > p2.x) {
				return -1;
			}
			else if (p2.x > p1.x) {
				return 1;
			}
			else {
				return 0;
			}
		}
	};
	compareY = new Comparator<PVector>() {
		public int compare(PVector p1, PVector p2) {
			if (p1.y < p2.y) {
				return -1;
			}
			else if (p2.y < p1.y) {
				return 1;
			}
			else {
				return 0;
			}
		}
	};
	compareYRev = new Comparator<PVector>() {
		public int compare(PVector p1, PVector p2) {
			if (p1.y > p2.y) {
				return -1;
			}
			else if (p2.y > p1.y) {
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
		rawInput.clear();
		centerPoint = null;
        sphere = null;
  }
  // If mouse presses calculate button
  else if ((mouseX >= calc_x && mouseX <= (calc_x + calc_w)) &&
	   (mouseY >= calc_y && mouseY <= (calc_y + calc_h))) {
    	// Run algorithm
        CenterAndSphere returnVals = getSeparator(rawInput);
        sphere = returnVals.sphere;
        centerPoint = returnVals.center;
  }
  else {
        // Create new 2D point from mouse coordinates
		PVector prelim_point = new PVector(mouseX, mouseY);
        // Lift to 3D with the squared magnitude of the original point
        PVector final_point = new PVector(prelim_point.x, prelim_point.y,
            (float)Math.pow(prelim_point.mag(), 2));
		rawInput.add(final_point);
  }
  redraw();
}

// Get geometric separator
CenterAndSphere getSeparator(ArrayList<PVector> input) {
    // Algorithm
    // 1. Get centerpoint
    PVector centerPoint = approxCenterpoint(input);
    // 2. Get random unit vector in 3D
    PVector unitVector = PVector.random3D();
    // 3. Get radius
    float radius = getRadius(centerPoint, unitVector);
    // 4. Output sphere separator
    float[] sphereAttributes = getSphereAttr(centerPoint, unitVector, radius);
    PShape separator = createShape(ELLIPSE, sphereAttributes);
    CenterAndSphere returnVals = new CenterAndSphere(centerPoint, separator);
    return returnVals;
}

// Get radius for our separator
float getRadius(PVector centerPoint, PVector unitVector) {
    float num = (float)Math.sqrt(centerPoint.z - centerPoint.mag());
    return num / Math.abs(unitVector.z);
}

// Get the attributes for the sphere separators
float[] getSphereAttr(PVector centerPoint, PVector unitVector, float radius) {
    PVector center = centerPoint.sub(unitVector.mult(radius));
    float x = center.x - radius;
    float y = center.y - radius;
    float z = center.z - radius;
    float[] attributes = {x, y, 2 * radius, 2 * radius};
    return attributes;
}

// Get geometric median
PVector getGeometricMedian(ArrayList<PVector> input) {
	if (input.size() == 0) {
		System.out.println("You don't have any input points!");
		return null;
	}
	else if (input.size() == 1) {
		return input.get(0);
	}
	else {
		// Get the point
        HashMap<PVector, Float> total = new HashMap<PVector, Float>();
		HashMap<PVector, Float> x = getAxisMin(input, false);
		HashMap<PVector, Float> y = getAxisMin(input, true);
        Set<PVector> keys = x.keySet();
        for (PVector key : keys) {
            total.put(key, x.get(key) + y.get(key));
        }
        ArrayList<Entry<PVector, Float>> sortedList = new ArrayList<Entry<PVector, Float>>(total.entrySet());
        Collections.sort(sortedList, new Comparator<Entry<PVector, Float>>() {
         public int compare(Entry<PVector, Float> entry1, Entry<PVector, Float> entry2) {
             return (int)(entry1.getValue() - entry2.getValue());
         }
        });
		return sortedList.get(0).getKey();
  }
}

// Sample input points into sets of 4
ArrayList<ArrayList<PVector>> samplePoints(ArrayList<PVector> input) {
    ArrayList<PVector> inputCopy = new ArrayList<PVector>(input);
	ArrayList<ArrayList<PVector>> setList = new ArrayList<ArrayList<PVector>>();
	ArrayList<PVector> pointList = new ArrayList<PVector>();
	// While there are still points, split into sets
	while (inputCopy.size() > 0) {
		double rnd = new Random().nextDouble();
		int index = (int)(rnd * 10) % inputCopy.size();
		// Add to set
		pointList.add(inputCopy.get(index));
		inputCopy.remove(index);
		// Create new set on max size
		if (pointList.size() == 4) {
			setList.add(pointList);
			pointList = new ArrayList<PVector>();
		}
	}
	// Add most recent unempty set to list
	if (pointList.size() > 0) {
		setList.add(pointList);
	}
	return setList;
}

// Approximate the centerpoint
PVector approxCenterpoint(ArrayList<PVector> input) {
	if (input.size() == 0) {
		System.out.println("You don't have any input points!");
		return null;
	}
	else {
		// Algorithm
		// Repeat 1 - 3 until one point remains and return that point
		while (input.size() > 1) {
			// 1. Sample points into groups of 4
			ArrayList<ArrayList<PVector>> setList = samplePoints(input);
			// 2. Compute radon point of each group (geometric median)
			ArrayList<PVector> radonList = new ArrayList<PVector>();
			for (ArrayList<PVector> list : setList) {
				PVector radonPoint = getGeometricMedian(list);
				radonList.add(radonPoint);
				// 3. Set input to be new radon points
			}
			input = radonList;
		}
		return input.get(0);
	}
}

// Calculate the distance with the input, memoization
float calcDist(int i, PVector currentPoint, ArrayList<PVector> input, boolean isY) {
	// For each point before i, calculate distance to i
	PVector prevPoint;
	float sum = 0;
	for (int j = 0; j < i; j++) {
		prevPoint = input.get(j);
		if (isY) {
			sum += currentPoint.y - prevPoint.y;
		}
		else {
			sum += currentPoint.x - prevPoint.x;
		}
	}
	return sum;
}

// Calculate prev sum (i - 1) and the point distance from i
ReturnTriple calcLastSum(int i, PVector currentPoint, PVector nextPoint, ArrayList<PVector> input, HashMap<PVector, Float> memoize, boolean isY) {
	// Calculate for squares
	float sum, dist;
	// If possible, reuse solution
	if (memoize.containsKey(currentPoint)) {
		sum = memoize.get(currentPoint);
	}
	// Otherwise, calculate
	else {
		sum = calcDist(i, currentPoint, input, isY);
		memoize.put(currentPoint, sum);
	}
	if (isY) {
		dist = nextPoint.y - currentPoint.y;
	}
	else {
		dist = nextPoint.x - currentPoint.x;
	}
	return new ReturnTriple(sum, dist, memoize);
}

// Get sums and sums of squares of distances for an input
HashMap<PVector, Float> getSums(ArrayList<PVector> input, boolean isY) {
  // Memoization hash tables
  HashMap<PVector, Float> sumSquaresMemoize = new HashMap<PVector, Float>();
  ReturnTriple returnTriple = new ReturnTriple(0, 0, null);
  PVector currentPoint, nextPoint;
	float sum, dist;
	for (int i = 0; i < input.size() - 1; i++) {
		currentPoint = input.get(i);
		nextPoint = input.get(i + 1);
		// Calculate sum of squares
		returnTriple = calcLastSum(i, currentPoint, nextPoint, input, sumSquaresMemoize, isY);
		sumSquaresMemoize = returnTriple.memoize;
		sumSquaresMemoize.put(nextPoint, returnTriple.sum + (float)(i * Math.pow(returnTriple.dist, 2)) + (2 * i * returnTriple.dist));
	}
	return sumSquaresMemoize;
}

// Get minimum point for given axis input
HashMap<PVector, Float> getAxisMin(ArrayList<PVector> input, boolean isY) {
	HashMap<PVector, Float> sumSquaresLeft, sumSquaresRight;
	HashMap<PVector, Float> totalSumSquares = new HashMap<PVector, Float>();
	// Get left distances
	if (isY) {
		Collections.sort(input, compareY);
	}
	else {
		Collections.sort(input, compareX);
	}
	sumSquaresLeft = getSums(input, isY);
	// Get right distances
	if (isY) {
		Collections.sort(input, compareYRev);
	}
	else {
		Collections.sort(input, compareXRev);
	}
	sumSquaresRight = getSums(input, isY);
	// Calculate total sum and store it
	for (int i = 0; i < sumSquaresLeft.size(); i++) {
		PVector point = input.get(i);
		totalSumSquares.put(point, sumSquaresLeft.get(point) + sumSquaresRight.get(point));
	}
    return totalSumSquares;
}

// Draw
void draw() {
  background(255);
  shape(reset);
  shape(calculate);
  fill(50);
  textSize(20);
  text("Geometric Separators", 140, 20);
  textSize(12);
  text("Reset.", reset_x + 30, reset_y + 15);
  text("Calculate.", calc_x + 25, calc_y + 15);
  // Draw input
  for (PVector point : rawInput) {
        strokeWeight(4);
        point(point.x, point.y);
  }
  // Draw center point
  if (centerPoint != null) {
        strokeWeight(6);
        point(centerPoint.x, centerPoint.y);
        System.out.println("x-coordinate: " + Float.toString(centerPoint.x));
        System.out.println("y-coordinate: " + Float.toString(centerPoint.y));
  }
  // Draw separator sphere projected to 2D
  if (sphere != null) {
        strokeWeight(6);
        shape(sphere);
  }
}
