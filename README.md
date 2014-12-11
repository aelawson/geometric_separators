Geometric Separators
====================

[Imgur](http://i.imgur.com/e5PkQ4a.png)

This program is based off the paper [Geometric Separators and the Parabolic Lift](http://donsheehy.net/research/sheehy13geometric.pdf) by Don Sheehy. It implements a new algorithm to calculate a geometric separator for a set of 2D input points.


About:
------

This Processing program will allow you to input a number of 2D points and determine a geometric separator for the input set. It will graphically show the centerpoint and the spherical separator projected down to the 2D plane.

How it works:
-------------

The points input by the user will be lifted to a paraboloid in 3D. Then, we approximate a centerpoint from sets of 5 points by using [Iterated Radon Points](http://dl.acm.org/citation.cfm?id=161004). To find a Radon point from a set of 5 points, there are two cases we must test for: 1) if a ray intersects a triangle and 2) if a point is inside a tetrahedron. The intersection point or contained point, respectively, is then the Radon point. These Radon points are reduced down to a single point - our estimated centerpoint. A sphere is then calculated and projected down to the original 2D plane along with the centerpoint.

Usage:
------

There are three buttons on the application window: **Calculate**, **Reset**, and **Randomize**.
You can click anywhere on the canvas to add input points. Then, use the **Calculate** button, which will show the centerpoint in *red* (if it can) and the separator projected down to the 2D plane as a *gray* ellipse. If you don't have specific points, you can use the **Randomize** button to add 25 random points to the canvas. To remove added points, just click **Reset**.

Note: The centerpoint is estimated using Radon Points - according to Radon's Theorem, we can only find a partition for sets of 5 points, so we must only have powers of 5 for our input set.

References:
----------

http://donsheehy.net/research/sheehy13geometric.pdf

http://dl.acm.org/citation.cfm?id=161004

http://steve.hollasch.net/cgindex/geometry/ptintet.html

http://geomalgorithms.com/a06-_intersect-2.html