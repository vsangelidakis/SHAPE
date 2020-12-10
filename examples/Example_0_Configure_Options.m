% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk
%
% Example: Configure "options" variable.
%
% Short Description:
% Shape characterisation is a multi-variable problem, involving many
% decisions that are left to the discretion of the user. To this, SHAPE
% collects a number of options inside a structure parameter named
% "options". In the rest of the example files, the default options are
% loaded from a default file, but users can change these according to their
% preferences.
%
% This example demonstrates and explains the main fields of the "options"
% variable.

%%
clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load default simulation options
load('options.mat');

%% Modify options
	options.warning='off'; % Whether to turn warnings 'on' or 'off'.
	options.meshcheckrepair=true; % Whether to check and repair surface mesh input to remove duplicate vertices, erase intersecting faces and close holes.
	options.useConvexHull=true; % Whether to save the convex hull of the original particle and use it to generate convex simplified particles.
	options.Mesh.reconstructPointCloudMethod='Crust'; % 'Delaunay' % Method used to mesh a point cloud if no faces are given: 'Crust', or 'Delaunay'.
	options.Mesh.Voxelated_Image.div=100; % Number of divisions along the smallest face of the AABB of the particle to transform it into a voxelated image (i.e. smallest size of the voxelated image). Default value div=50 if left empty (i.e. if div=[]). This is used only if the particle geometry is initially given as a point cloud or a surface mesh.
	options.Mesh.surf2mesh.maxvol=10000; % Maximum tetrahedra element volume, when transforming surface meshes into tetrahedral meshes. By default we consider a large volume, but this depends on the application and the units/scale of the input mesh for each application.
	options.Auxiliary_Geometries.OBB.method='minVolume'; % 'PCA_points' 'minVolume', 'minSurfaceArea', 'minSumEdges'
	options.Auxiliary_Geometries.OBB.points='Voxel_points'; % 'Surface_points'; % 'Tetrahedra_points'; % 'Voxel_points' % Which points to consider when calculating the OBB using PCA. If the minimal OBB is sought, the surface points are always used. %% TODO: Use coordinates of voxels?
	options.Simplify.numFaces=[200 175]; % List with fidelity levels, in terms of triangular faces on the surface of the simplified particles.

% Future fields
% 	options.Mesh.centerParticle.Original=true; % Whether to center the original particle to its centroid. Any simplified versions of the particle will be centered to the same coordinate system.
% 	options.Mesh.centerParticle.Simplified=true; % Whether to center any simplified particles to their individual centroid.

%	options.Mesh.vol2surf.method='cgalmesh'; % FIXME: Add alternatives
%	options.Mesh.Principal_Orientations.Original=true; % Whether to orient the original particle to its principal inertial axes. Any simplified versions of the particle will be oriented to the same coordinate system.
% 	options.Mesh.Principal_Orientations.Simplified=true; % Whether to orient any simplified particles to their individual principal axes.

%	options.Auxiliary_Geometries.ELI.points='Surface_points'; % 'Tetrahedra_points'; % 'Voxel_points' % Which points to consider when calculating the fitted ellipsoid. %% TODO: Use coordinates of voxels?
%	options.Auxiliary_Geometries='OBB'; % ELI % FIXME: Should I add this? Choose which one to calculate
%	options.Auxiliary_Geometries.useOBB %% FIXME: Same here	


%% Save the preferred options. Different options can be considered per simulation/material of interest
% 	save('options_NEW.mat');

%% Apply options on the characterisation of a regular dodecahedron
% [P,F,~] = stlRead('Platonic_solids/Dodecahedron.stl'); % Load surface mesh
% p1=Particle(P,F,[],[],options); % Define particle

disp('Done!')