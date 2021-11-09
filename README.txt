█ █ █ █ █                                                    █ █ █ █ █
 █ █ █ █       ███████╗██╗  ██╗ █████╗ ██████╗ ███████╗       █ █ █ █ 
█ █ █ █ █      ██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝      █ █ █ █ █
 █ █ █ █       ███████╗███████║███████║██████╔╝█████╗         █ █ █ █ 
█ █ █ █ █      ╚════██║██╔══██║██╔══██║██╔═══╝ ██╔══╝        █ █ █ █ █
 █ █ █ █       ███████║██║  ██║██║  ██║██║     ███████╗       █ █ █ █ 
█ █ █ █ █      ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝      █ █ █ █ █
 █ █ █ █        Shape Analyser for Particle Engineering       █ █ █ █ 
█ █ █ █ █                                                    █ █ █ █ █

█ Contents
  • What SHAPE does
  • Architectural features
  • File tree
  • Simple example
  • Credits
  • BYOS (Bring Your Own Scripts)!
  • Acknowledging SHAPE

█ What SHAPE does
SHAPE implements morphological characterisation of three-dimensional particles from imaging data, such as point clouds, surface and tetrahedral meshes or segmented voxelated images (derived using Computed Tomography). Characterisation of morphology is performed for all three aspects of shape, namely form, roundness and surface texture (roughness). The code also supports shape simplification, using edge-collapse techniques, to reduce the number of triangular faces of each particle to user-defined fidelity levels. The particle shapes can be exported to several formats, compatible with various FEA and DEM solvers.

█ Architectural features
SHAPE is built using an object-oriented architecture, where each particle has the following set of attributes:

-Particle % e.g. 1, 2, 3, etc.
  -Particle_type % e.g. Original, Convex_hull, Face_No_100, Face_No_50, etc.
    -Mesh % Surface_mesh, Tetrahedral_mesh, Voxelated_image, Surface_texture
    -Auxiliary_geometries % AABB, OBB, Fitted_ellipsoid, Minimal_bounding_sphere, Maximal_inscribed_sphere
    -Geometrical_features % Volume, Centroid, Surface_area, Current_inertia_tensor, Principal_inertia_tensor, Principal_orientations
    -Morphological_features % Form, Roundness, Roughness

█ File tree
• __SHAPE__
  • LICENSE
  • README.md (README file in "Markdown" format - This generates the html summary of SHAPE on github.com)
  • README.txt (README file in readable, unformatted form - This can be used to read the summary of SHAPE in a text editor/offline)
  • __classes__ (Definition of objects)
  • __examples__
  • __figures__
  • __functions__
  • __lib__ (External dependencies)

█ Simple example
This example demonstrates different ways to define Particle objects and characterise their morphology.

addpath(genpath('functions'));	% Load in-house functions
addpath(genpath('lib'));	% Load external functions (dependencies)
addpath(genpath('classes'));	% Load object-oriented architecture

% Define particle from Point Cloud
p1=Particle(P,[],[],[],options); % P (Nv x 3): List of Vertices; options (struct): options for shape characterisation and/or simplification

% Define particle from Surface/Tetrahedral Mesh and Texture profile
p2=Particle(P,F,[],Texture,options); % P (Nv x 3): List of Vertices; F (Nf x 3) or (Nf x 4): List of Faces/Elements; Texture (Nx x Ny): Planar roughness profile

% Define particle from voxelated (volumetric) image
p3=Particle([],[],Vox,[],options); % Vox.img (Nx x Ny x Nz): Segmented voxelated (3-D) image of particle geometry;

New users are advised to start from running the available examples in the "examples" folder, to get familiarised with the syntax and functionalities of SHAPE.

█ Credits
SHAPE uses several external functions available within the Matlab FEX community. We want to acknowledge the work of the following contributions, for making our lives easier:
  • Qianqian Fang - [Iso2Mesh](https://uk.mathworks.com/matlabcentral/fileexchange/68258-iso2mesh)
  • Luigi Giaccari - [Surface Reconstruction From Scattered Points Cloud](https://www.mathworks.com/matlabcentral/fileexchange/63730-surface-reconstruction-from-scattered-points-cloud)
  • Johaness Korsawe - [Minimal Bounding Box](https://uk.mathworks.com/matlabcentral/fileexchange/18264-minimal-bounding-box)
  • Pau Micó - [stlTools](https://uk.mathworks.com/matlabcentral/fileexchange/51200-stltools)
  • Yury Petrov - [Ellipsoid fit](https://uk.mathworks.com/matlabcentral/fileexchange/24693-ellipsoid-fit)
  • Anton Semechko - [Exact minimum bounding spheres and circles](https://uk.mathworks.com/matlabcentral/fileexchange/48725-exact-minimum-bounding-spheres-and-circles)

These external dependencies are added within the source code of SHAPE, to provide an out-of-the-box implementation. The licensing terms of each external dependency can be found inside the "lib" folder.

█ BYOS (Bring Your Own Scripts)!
If you enjoy using SHAPE and you are interested in shape characterisation, you are welcome to ask for the implementation of new morphological descriptors and features or even better contribute and share your implementations. SHAPE was created out of our excitement and curiosity around the characterisation of irregular particle morphologies and we share this tool hoping that members of the community will find it useful. So, feel free to expand the code, propose improvements and report issues.

█ Acknowledging SHAPE
Angelidakis, V., Nadimi, S. and Utili, S., 2021. SHape Analyser for Particle Engineering (SHAPE): Seamless characterisation and simplification of particle morphology from imaging data. Computer Physics Communications, p.107983.

█ Copyright
2021 © Vasileios Angelidakis, Sadegh Nadimi, Stefano Utili. Newcastle University, UK
