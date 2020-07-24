# Bounding Spheres and Circles
The problem of finding minimum bounding spheres (aka minimum enclosing spheres) is frequently encountered in a 
number of applications, including computer graphics and patter recognition. While a number of relatively simple 
algorithms exist for finding such spheres, there are no robust implementations of these algorithms in Matlab 
that can be readily found on-line. Functions contained in this submission are meant to fill this void.

Exact minimum bounding spheres and circles can be computed using the functions titled `ExactMinBoundSphere3D.m` 
and `ExactMinBoundCircle.m`, both implementing Wezlz’s algorithm [**[1]**]. Approximate minimum bounding 
spheres in any dimension can be computed using `ApproxMinBoundSphereND.m` function, which implements Ritter’s 
algorithm [**[2]**].

For convenience, I also included functions `VisualizeBoundSphere.m` and `VisualizeBoundCircle.m` that allow you to 
visualize input point clouds (or meshes) with their respective minimum bounding sphere/circle (see demo pic).

For demonstration on how to use the functions, add this repository to your Matlab path and enter `MinBoundSphereDemo` into
command window.

## References
[**[1]**] Welzl, E. (1991), 'Smallest enclosing disks (balls and ellipsoids)', Lecture Notes in Computer Science, Vol. 555, pp. 359-370  
[**[2]**] Ritter, J. (1990), 'An efficient bounding sphere', in Graphics Gems, A. Glassner, Ed. Academic Press, pp.301-303

## License
[MIT] © 2019 Anton Semechko 
a.semechko@gmail.com

[1]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.46.1450
[2]: https://dl.acm.org/citation.cfm?id=90836
[MIT]: https://github.com/AntonSemechko/Bounding-Spheres-And-Circles/blob/master/LICENSE.md