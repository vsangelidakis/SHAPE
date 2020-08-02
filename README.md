# SHAPE
###  SHape Analyser for Particle Engineering
2020 © Vasileios Angelidakis, Sadegh Nadimi, Stefano Utili. Newcastle University, UK

<p align="center"><img width=50% src="https://github.com/vsangelidakis/SHAPE/blob/master/figures/SHAPE_Logo_Extended.png"></p>
---

SHAPE implements morphological characterisation of three-dimensional particles from imaging data, such as point clouds, surface and tetrahedral meshes or segmented voxelated images (derived using Computed Tomography). Characterisation of morphology is performed for all three aspects of shape, namely form, roundness and surface texture (roughness). The code also supports shape simplification, using edge-collapse techniques to reduce the number of triangular faces of each particle to user-defined fidelity levels.

## Credits
SHAPE uses several external functions available within the Matlab FEX community. We want to acknowledge the work of the following contributions, for making our lives easier:

Anton Semechko - [Exact minimum bounding spheres and circles](https://uk.mathworks.com/matlabcentral/fileexchange/48725-exact-minimum-bounding-spheres-and-circles)

Qianqian Fang - [Iso2Mesh](https://uk.mathworks.com/matlabcentral/fileexchange/68258-iso2mesh)

Yury Petrov - [Ellipsoid fit](https://uk.mathworks.com/matlabcentral/fileexchange/24693-ellipsoid-fit)

Johaness Korsawe - [Minimal Bounding Box](https://uk.mathworks.com/matlabcentral/fileexchange/18264-minimal-bounding-box)

Pau Micó - [stlTools](https://uk.mathworks.com/matlabcentral/fileexchange/51200-stltools)

## BYOS (Bring Your Own Scripts)!
If you enjoyed using SHAPE and you are interested in shape characterisation, you are welcome to require the implementation of new morphological descriptors and features or even better contribute and share your implementations. SHAPE was created out of our excitement and curiosity around the characterisation of irregular particle morphologies and we share this tool hoping that members of our community may find it useful, so feel free to expand the code.

## License
GPLv3

