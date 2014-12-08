import java.util.*;
import java.util.Map.*;
import java.lang.Boolean;
import java.util.Random;
import org.jblas.*;
import org.apache.commons.math3.linear.*;
import org.apache.commons.math3.linear.SingularValueDecomposition;

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
    	rawInput.clear();
    	centerPoint = null;
        sphere = null;
    }
    // If mouse presses calculate button
    else if ((mouseX >= calc_x && mouseX <= (calc_x + calc_w)) &&
        (mouseY >= calc_y && mouseY <= (calc_y + calc_h))) {
        CenterAndSphere returnVals = getSeparator(rawInput);
        sphere = returnVals.sphere;
        centerPoint = returnVals.center;
    }
    // Otherwise add input to list
    else {
        // Create new 2D point from mouse coordinates
    	PVector point = new PVector(mouseX, mouseY, 0);
        PVector pointLifted = new PVector(point.x, point.y, (float)Math.pow(point.mag(), 2));
    	rawInput.add(pointLifted);
    }
    redraw();
}

// Get Radon point
PVector getRadonPoint(ArrayList<PVector> input) {
    // Set a to equal our points
    double[][] aData = new double[4][input.size()];
    for (int i = 0; i < input.size(); i++) {
        for (int j = 0; j < 4; j++) {
            switch(j) {
                case 0: aData[j][i] = (double)input.get(i).x;
                    break;
                case 1: aData[j][i] = (double)input.get(i).y;
                    break;
                case 2: aData[j][i] = (double)input.get(i).z;
                    break;
                case 3: aData[j][i] = 1;
                    break;
            }
        }
    }
    RealMatrix coefficients = new Array2DRowRealMatrix(aData, false);
    RealVector constants = new ArrayRealVector(new double[] {0, 0, 0, 0}, false);
    DecompositionSolver solver = new SingularValueDecomposition(coefficients).getSolver();
    RealVector solution = solver.solve(constants);
    for (double x : solution.toArray()) {
        System.out.println(x);
    }
    return new PVector(0,0);
}

// Get geometric separator
CenterAndSphere getSeparator(ArrayList<PVector> input) {
    PVector centerPoint = approxCenterpoint(input);
    PVector unitVector = PVector.random3D();
    unitVector.x = Math.abs(unitVector.x);
    unitVector.y = Math.abs(unitVector.y);
    unitVector.z = Math.abs(unitVector.z);
    float radius = getRadius(centerPoint, unitVector);
    float[] sphereAttributes = getSphereAttr(centerPoint, unitVector, radius);
    PShape separator = createShape(ELLIPSE, sphereAttributes);
    CenterAndSphere returnVals = new CenterAndSphere(centerPoint, separator);
    return returnVals;
}

// Get radius for our separator
float getRadius(PVector centerPoint, PVector unitVector) {
    PVector centerPoint2D = new PVector(centerPoint.x, centerPoint.y);
    float numerator = (float)Math.sqrt(Math.abs(centerPoint.z - Math.pow(centerPoint2D.mag(), 2)));
    return numerator / Math.abs(unitVector.z);
}

// Get the attributes for the sphere separators
float[] getSphereAttr(PVector centerPoint, PVector unitVector, float radius) {
    unitVector.mult(radius);
    centerPoint.sub(unitVector);
    float[] attributes = {centerPoint.x, centerPoint.y, 2 * radius, 2 * radius};
    return attributes;
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
		while (input.size() > 1) {
			ArrayList<ArrayList<PVector>> setList = samplePoints(input);
			ArrayList<PVector> radonList = new ArrayList<PVector>();
			for (ArrayList<PVector> list : setList) {
				PVector radonPoint = getRadonPoint(list);
				radonList.add(radonPoint);
			}
			input = radonList;
		}
		return input.get(0);
	}
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
        strokeWeight(8);
        point(point.x, point.y);
        strokeWeight(2);
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
