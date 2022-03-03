% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk
%
% Example: Try different input formats
%

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

runPart=1; % 1: run Part 1: Input from point cloud/surface mesh/tetrahedral mesh
           % 2: run Part 2: Input from segmented voxelated image with multiple particles

if runPart==1
	%% Load surface mesh from .stl file
	[P,F,n] = stlRead('Platonic_solids/Dodecahedron.stl');
	options.useConvexHull=false; % Do not calculate the convex hull; e.g. if the particle is already convex or if we do not need it

	%% Load surface texture. "Texture" is a struct with fields:
		%  z: 2-D matrix with equal spacing, where the intensity/value of each pixel/element reflects the elevation of each point of the surface texture.
		% dx: spacing between measurements in X direction (in length units)
		% dy: spacing between measurements in Y direction (in length units)
	load('Texture.mat');
    
	%% Case 1: Define particle from a point cloud, using the "Crust" algorithm to reconstruct its surface
	p1=Particle(P,[],[],Texture,options);
	
	%% Case 2: Define particle from a surface mesh
	p2=Particle(P,F,[],[],options); 

	%% Case 3: Define particle from a tetrahedral mesh
	[Ptet,Etet,Ftet]=s2m(P,F,1,10000); % Transform surface to tetrahedral mesh using iso2mesh
	p3=Particle(Ptet,Etet(:,1:4),[],[],options);

	%% Plot p1, p2, p3
	figure()
	subplot(2,2,1); title('Input=Point cloud')
	patch(p1.Original.Mesh.Surface_mesh,'FaceColor','g')
	axis equal; grid on; box on; alpha 0.8; view(3); camlight
	
	subplot(2,2,2); title('Input=Surface mesh')
	patch(p2.Original.Mesh.Surface_mesh,'FaceColor','b')
	axis equal; grid on; box on; alpha 0.8; view(3); camlight

	subplot(2,2,3); title('Input=Tetrahedral mesh')
	patch(p3.Original.Mesh.Surface_mesh,'FaceColor','r')
	axis equal; grid on; box on; alpha 0.8; view(3); camlight

elseif runPart==2
	%% Load segmented voxelated image
	load('SegmentedImage');
	options.Auxiliary_Geometries.OBB.method='PCA_points';
	% SegmentedImage is a struct with fields: 
	% - img (Nx x Ny x Nz):	labeled voxelated image
	% - voxel_size (1 x 3):	voxel size in x,y,z directions (generally equal values)
	
	options.useConvexHull=false; % Do not calculate the convex hull; the particles are already convex
	
	labels=unique(SegmentedImage.img); % Find unique labels of particles
	labels(labels==0)=[]; % Remove zero value (corresponding to empty voxels) from the labels list
	
	% Iterate through all different particles
	for i=1:length(labels) % TODO: This can become a parfor in a next release
		% The "vox" struct contains the voxelated image (Nx x Ny x Nz) and
		% the voxel size (1 x 3), like the 'SegmentedImage' struct, but for
		% each particle
		vox.img=SegmentedImage.img.*(SegmentedImage.img==labels(i));  % Isolate each label (i.e. each particle)
		vox.voxel_size=SegmentedImage.voxel_size; % Add voxel size
		
		p{i}=Particle([],[],vox,[],options);
	end
	
	%% Plot initial voxelated image in voxel space: Reinstate this
	figure()
	volshow(SegmentedImage.img);		% Plot greyscale volumetric image
% 	labelvolshow(SegmentedImage.img);	% Plot labeled volumetric image
	
	%% Plot surface meshes in Cartesian space
	figure()
	patch(p{1}.Original.Mesh.Surface_mesh,'FaceColor','g','EdgeColor','none')
	patch(p{2}.Original.Mesh.Surface_mesh,'FaceColor','b','EdgeColor','none')
	axis equal; grid on; box on; view(3); camlight
end

disp('Done!')