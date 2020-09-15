<p align="center"><img width=50% src="https://github.com/vsangelidakis/SHAPE/blob/master/figures/SHAPE_Logo_Extended.png"></p>
<h2 align="center">SHape Analyser for Particle Engineering</a></h2>
<p align="center">
    <a href="https://github.com/vsangelidakis/SHAPE/commits/master">
    <img src="https://img.shields.io/github/last-commit/vsangelidakis/SHAPE.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub last commit">
    <a href="https://github.com/vsangelidakis/SHAPE/issues">
    <img src="https://img.shields.io/github/issues-raw/vsangelidakis/SHAPE.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub issues">
    <a href="https://github.com/vsangelidakis/SHAPE/pulls">
    <img src="https://img.shields.io/github/issues-pr-raw/vsangelidakis/SHAPE.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub pull requests">
    <a href="https://opensource.org/licenses/GPL-3.0">
    <img src="https://img.shields.io/badge/license-GPL-blue.svg"
         alt="License">
    <a href="https://doi.org/10.5281/zenodo.4001670">
    <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.4001670.svg"
	     alt="DOI"></a>
    <a href="https://twitter.com/intent/tweet?text=SHape Analyser for Particle Engineering: &url=https%3A%2F%2Fgithub.com%2Fvsangelidakis%2FSHAPE">
    <img src="https://img.shields.io/twitter/url/https/github.com/vsangelidakis/SHAPE.svg?style=flat-square&logo=twitter"
         alt="GitHub tweet">
</p>
<p align="center">
  <a href="#what-shape-does">What SHAPE does</a> •
  <a href="#architectural-features">Architectural features</a> •
  <a href="#file-tree">File tree</a> •
  <a href="#simple-example">Simple example</a> •
  <a href="#credits">Credits</a> •
  <a href="#byos-bring-your-own-scripts">BYOS</a>
</p>

---

## What SHAPE does
SHAPE implements morphological characterisation of three-dimensional particles from imaging data, such as point clouds, surface and tetrahedral meshes or segmented voxelated images (derived using Computed Tomography). Characterisation of morphology is performed for all three aspects of shape, namely form, roundness and surface texture (roughness). The code also supports shape simplification, using edge-collapse techniques, to reduce the number of triangular faces of each particle to user-defined fidelity levels. The particle shapes can be exported to several formats, compatible with various FEA and DEM solvers.

## Architectural features
SHAPE is built using an object-oriented architecture, where each particle has the following set of attributes:

```Matlab
-Particle % e.g. 1, 2, 3, etc.
  -Particle_type % e.g. Original, Convex_hull, Face_No_100, Face_No_50, etc.
    -Mesh % Surface_mesh, Tetrahedral_mesh, Voxelated_image, Surface_texture
    -Auxiliary_geometries % AABB, OBB, Fitted_ellipsoid, Minimal_bounding_sphere, Maximal_inscribed_sphere
    -Geometrical_features % Volume, Centroid, Surface_area, Current_inertia_tensor, Principal_inertia_tensor, Principal_orientations
    -Morphological_features % Form, Roundness, Roughness
```

## File tree
- __SHAPE__
  - [LICENSE](LICENSE)
  - [README.md](README.md)
  - __classes__ (Definition of objects)
  - __examples__
  - __figures__
  - __functions__ (Some of the functions are overloaded as methods in the classes)
  - __lib__ (External dependencies)


## Simple example
This example demonstrates different ways to define Particle objects and characterise their morphology.

```Matlab
addpath(genpath('functions'));	% Load in-house functions
addpath(genpath('lib'));	% Load external functions (dependencies)
addpath(genpath('classes'));	% Load object-oriented architecture

% Define particle from Point Cloud
p1=Particle(P,[],[],[],options); % P (Nv x 3): List of Vertices; options (struct): options for shape characterisation and/or simplification

% Define particle from Surface/Tetrahedral Mesh and Texture profile
p2=Particle(P,F,[],Texture,options); % P (Nv x 3): List of Vertices; F (Nf x 3) or (Nf x 4): List of Faces/Elements; Texture (Nx x Ny): Planar roughness profile

% Define particle from voxelated (volumetric) image
p3=Particle([],[],Vox,[],options); % Vox (Nx x Ny x Nz): Segmented voxelated (3-D) image of particle geometry;
```

New users are advised to start from running the available examples in the [examples](examples) folder, to get familiarised with the syntax and functionalities of SHAPE.

## Credits
SHAPE uses several external functions available within the Matlab FEX community. We want to acknowledge the work of the following contributions, for making our lives easier:

Qianqian Fang - [Iso2Mesh](https://uk.mathworks.com/matlabcentral/fileexchange/68258-iso2mesh)

Luigi Giaccari - [Surface Reconstruction From Scattered Points Cloud](https://www.mathworks.com/matlabcentral/fileexchange/63730-surface-reconstruction-from-scattered-points-cloud)

Johaness Korsawe - [Minimal Bounding Box](https://uk.mathworks.com/matlabcentral/fileexchange/18264-minimal-bounding-box)

Pau Micó - [stlTools](https://uk.mathworks.com/matlabcentral/fileexchange/51200-stltools)

Yury Petrov - [Ellipsoid fit](https://uk.mathworks.com/matlabcentral/fileexchange/24693-ellipsoid-fit)

Anton Semechko - [Exact minimum bounding spheres and circles](https://uk.mathworks.com/matlabcentral/fileexchange/48725-exact-minimum-bounding-spheres-and-circles)

These external dependencies are added within the source code of SHAPE, to provide an out-of-the-box implementation. The licensing terms of each external dependency can be found inside the [lib](lib/) folder.

## BYOS (Bring Your Own Scripts)!
If you enjoy using SHAPE and you are interested in shape characterisation, you are welcome to require the implementation of new morphological descriptors and features or even better contribute and share your implementations. SHAPE was created out of our excitement and curiosity around the characterisation of irregular particle morphologies and we share this tool hoping that members of the community will find it useful. So, feel free to expand the code, propose improvements and report issues.

<h4 align="center">2020 © Vasileios Angelidakis, Sadegh Nadimi, Stefano Utili. Newcastle University, UK</a></h4>