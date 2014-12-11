import java.util.*;
import java.util.Map.*;
import java.lang.Boolean;
import java.util.Random;
import org.apache.commons.math3.linear.*;
import org.apache.commons.math3.linear.LUDecomposition;

int reset_x = 90;
int reset_y = 460;
int reset_w = 100;
int reset_h = 25;
int calc_x = 200;
int calc_y = 460;
int calc_w = 100;
int calc_h = 25;
int rand_x = 310;
int rand_y = 460;
int rand_w = 100;
int rand_h = 25;

PShape reset;
PShape calculate;
PShape sphere;
PShape random;
PVector centerPoint;
PVector sphereCenter;
float sphereRadius;
ArrayList<PVector> rawInput = new ArrayList<PVector>();

// Object used for returning centerpoint and sphere
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
    random = createShape(RECT, rand_x, rand_y, rand_w, rand_h);
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
        sphereCenter = null;
        sphereRadius = 0;
    }
    // If mouse presses random button
    else if ((mouseX >= rand_x && mouseX <= (rand_x + rand_w)) &&
    (mouseY >= rand_y && mouseY <= (rand_y + rand_h))) {
        for (int i = 0; i < 25; i++) {
            double rnd = new Random().nextDouble();
            int x = (int)(rnd * 500);
            rnd = new Random().nextDouble();
            int y = (int)(rnd * 500);
            // Create new 2D point from random generator
            PVector point = new PVector(x, y, 0);
            PVector pointLifted = new PVector(point.x, point.y, (float)Math.pow(point.mag(), 2));
            rawInput.add(pointLifted);
            System.out.println(rawInput.size());
        }
    }
    // If mouse presses calculate button
    else if ((mouseX >= calc_x && mouseX <= (calc_x + calc_w)) &&
        (mouseY >= calc_y && mouseY <= (calc_y + calc_h))) {
        if (rawInput.size() < 5) {
            System.out.println("You need at least 5 points!");
            return;
        }
        else if ((Math.log10((double)rawInput.size()) / Math.log10(5)) % 1 > 0.00000001) {
            System.out.println((Math.log10(rawInput.size()) / Math.log10(5) % 1));
            System.out.println("You don't have a power of 5!");
            return;
        }
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
PVector getRadonPoint(ArrayList<PVector> points) {
    PVector radonPoint = null;
    radonPoint = inTetrahedron(points);
    if (radonPoint == null) {
        System.out.println("TRIANGLE");
        radonPoint = intersectTri(points);
        return radonPoint;
    }
    else {
        System.out.println("TETRA");
        return radonPoint;
    }
}

// Tests if a point is within a tetrahedron
PVector inTetrahedron(ArrayList<PVector> points) {
    PVector radonPoint;
    for (int i = 0; i < points.size(); i++) {
        ArrayList<PVector> pointsCopy = new ArrayList<PVector>(points);
        PVector testPoint = pointsCopy.get(i);
        pointsCopy.remove(i);
        // Test if every determinant has the same sign
        RealMatrix d0Matrix = getDetMatrix(pointsCopy.get(0), pointsCopy.get(1), pointsCopy.get(2), pointsCopy.get(3));
        RealMatrix d1Matrix = getDetMatrix(testPoint, pointsCopy.get(1), pointsCopy.get(2), pointsCopy.get(3));
        RealMatrix d2Matrix = getDetMatrix(pointsCopy.get(0), testPoint, pointsCopy.get(2), pointsCopy.get(3));
        RealMatrix d3Matrix = getDetMatrix(pointsCopy.get(0), pointsCopy.get(1), testPoint, pointsCopy.get(3));
        RealMatrix d4Matrix = getDetMatrix(pointsCopy.get(0), pointsCopy.get(1), pointsCopy.get(2), testPoint);
        // Compute determinants
        ArrayList<Double> detList = new ArrayList<Double>();
        double d0 = new LUDecomposition(d0Matrix).getDeterminant();
        detList.add(d0);
        double d1 = new LUDecomposition(d1Matrix).getDeterminant();
        detList.add(d1);
        double d2 = new LUDecomposition(d2Matrix).getDeterminant();
        detList.add(d2);
        double d3 = new LUDecomposition(d3Matrix).getDeterminant();
        detList.add(d3);
        double d4 = new LUDecomposition(d4Matrix).getDeterminant();
        detList.add(d4);
        // If the sign test passes
        if (areSameSign(detList)) {
            radonPoint = testPoint;
            return radonPoint;
        }
    }
    return null;
}

// Tests if a ray intersects a triangle
PVector intersectTri(ArrayList<PVector> points) {
    PVector point;
    // Triangle of Points 1, 2, 3
    point = testIntersect(points.get(0), points.get(1), points.get(2), points.get(3), points.get(4));
    if (point != null) {
        return point;
    }
    // Triangle of Points 1, 2, 4
    point = testIntersect(points.get(0), points.get(1), points.get(3), points.get(2), points.get(4));
    if (point != null) {
        return point;
    }
    // Triangle of Points 1, 2, 5
    point = testIntersect(points.get(0), points.get(1), points.get(4), points.get(2), points.get(3));
    if (point != null) {
        return point;
    }
    // Triangle of Points 1, 3, 4
    point = testIntersect(points.get(0), points.get(2), points.get(3), points.get(1), points.get(4));
    if (point != null) {
        return point;
    }
    // Triangle of Points 1, 3, 5
    point = testIntersect(points.get(0), points.get(2), points.get(4), points.get(1), points.get(3));
    if (point != null) {
        return point;
    }
    // Triangle of Points 1, 4, 5
    point = testIntersect(points.get(0), points.get(3), points.get(4), points.get(1), points.get(2));
    if (point != null) {
        return point;
    }
    // Triangle of Points 2, 3, 4
    point = testIntersect(points.get(1), points.get(2), points.get(3), points.get(0), points.get(4));
    if (point != null) {
        return point;
    }
    // Triangle of Points 2, 3, 5
    point = testIntersect(points.get(1), points.get(2), points.get(4), points.get(0), points.get(3));
    if (point != null) {
        return point;
    }
    // Triangle of Points 2, 4, 5
    point = testIntersect(points.get(1), points.get(3), points.get(4), points.get(0), points.get(2));
    if (point != null) {
        return point;
    }
    // Triangle of Points 3, 4, 5
    point = testIntersect(points.get(2), points.get(3), points.get(4), points.get(0), points.get(1));
    if (point != null) {
        return point;
    }
    return null;
}

// Test ray triangle intersection
PVector testIntersect(PVector t1, PVector t2, PVector t3, PVector r1, PVector r2) {
    PVector a = new PVector(t2.x, t2.y, t2.z);
    a.sub(t1);
    PVector b = new PVector(t3.x, t3.y, t3.z);
    b.sub(t1);
    PVector crossProd = a.cross(b);
    // Get ray direction
    PVector rayDir = new PVector(r2.x, r2.y, r2.z);
    rayDir.sub(r1);
    PVector w0 = new PVector(r1.x, r1.y, r1.z);
    w0.sub(t1);
    float x = -1 * crossProd.dot(w0);
    float y = crossProd.dot(rayDir);
    // Get intersection point of the plane
    float r = x / y;
    // No intersection
    if (r < 0) {
        return null;
    }
    rayDir.mult(r);
    PVector point = new PVector(r1.x, r1.y, r1.z);
    point.add(rayDir);
    // Is the point inside of the triangle?
    float aDot = a.dot(a);
    float abDot = a.dot(b);
    float bDot = b.dot(b);
    PVector w = new PVector(point.x, point.y, point.z);
    w.sub(t1);
    float waDot = w.dot(a);
    float wbDot = w.dot(b);
    float d = (abDot * abDot) - (aDot * bDot);
    float s = ((abDot * wbDot) - (bDot * waDot)) / d;
    float t = ((abDot * waDot) - (aDot * wbDot)) / d;
    // Check if the point is outside
    if (s < 0 || s > 1) {
        return null;
    }
    else if (t < 0 || (s + t) > 1) {
        return null;
    }
    // Otherwise it's inside we can return it
    return point;
}

// Get the determinant matrix for a set of points
RealMatrix getDetMatrix(PVector p1, PVector p2, PVector p3, PVector p4) {
    float[][] matrixData = {{p1.x, p1.y, p1.z, 1}, {p2.x, p2.y, p2.z, 1},
        {p3.x, p3.y, p3.z, 1}, {p4.x, p4.y, p4.z, 1}};
    RealMatrix matrix = MatrixUtils.createRealMatrix(toDoubleArray(matrixData));
    return matrix;
}

// Checks if a list of doubles all have the same sign
boolean areSameSign(ArrayList<Double> detList) {
    int negDet = 0;
    for (double det : detList) {
        if (det < 0) {
            negDet++;
        }
    }
    if (negDet == 0 || negDet == detList.size()) {
        return true;
    }
    else {
        return false;
    }
}

// Convert float array to double array
double[][] toDoubleArray(float[][] array) {
    int numRows = array.length;
    int numCols = array[0].length;
    double[][] doubleArray = new double[numRows][numCols];
    for (int i = 0; i < array.length; i++) {
        for (int j = 0; j < array[i].length; j++) {
            doubleArray[i][j] = (double)array[i][j];
        }
    }
    return doubleArray;
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

// Get the attributes for the sphere separator
float[] getSphereAttr(PVector centerPoint, PVector unitVector, float radius) {
    unitVector.mult(radius);
    centerPoint.sub(unitVector);
    sphereCenter = new PVector(centerPoint.x, centerPoint.y, centerPoint.z);
    sphereRadius = radius;
    float[] attributes = {centerPoint.x, centerPoint.y, 2 * radius, 2 * radius};
    return attributes;
}

// Sample input points into sets of 5
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
        if (pointList.size() == 5) {
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

// Draw
void draw() {
    background(255);
    // Draw separator sphere projected to 2D
    if (sphere != null) {
        strokeWeight(8);
        stroke(255);
        shape(sphere);
    }
    // Draw center point
    if (centerPoint != null) {
        stroke(255, 0, 0);
        strokeWeight(8);
        point(centerPoint.x, centerPoint.y);
        stroke(0);
    }
    shape(reset);
    shape(calculate);
    shape(random);
    fill(50);
    textSize(20);
    text("Geometric Separators", 140, 20);
    textSize(12);
    text("Reset.", reset_x + 30, reset_y + 15);
    text("Calculate.", calc_x + 25, calc_y + 15);
    text("Random.", rand_x + 25, rand_y + 15);
    // Draw input
    for (PVector point : rawInput) {
        strokeWeight(8);
        stroke(0);
        if (sphereCenter != null) {
            float dx = Math.abs(point.x - (sphereCenter.x + sphereRadius));
            float dy = Math.abs(point.y - (sphereCenter.y + sphereRadius));
            if (Math.pow(dx, 2) + Math.pow(dy, 2) <= Math.pow(sphereRadius, 2)) {
                stroke(0, 255, 0);
                point(point.x, point.y);
            }
            else {
                stroke(0);
                point(point.x, point.y);
            }
        }
        else {
            point(point.x, point.y);
        }
    }
}
