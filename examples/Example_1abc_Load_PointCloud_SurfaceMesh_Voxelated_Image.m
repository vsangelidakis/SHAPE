% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk
%
% Example: Try different input formats
%
%

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

runPart=2; % 1: run Part 1: Input from point cloud/surface mesh/tetrahedral mesh
           % 2: run Part 2: Input from segmented voxelated image with multiple particles

if runPart==1
	options.convexHull=false; % Do not calculate the convex hull; the particle is already convex
	%% PART 1: Load surface mesh from .stl file
	[P,F,n] = stlRead('Platonic_solids/Dodecahedron.stl');

	%% Case 1: Define particle providing a point cloud and using the "Crust" algorithm to mesh the particle
	p1=Particle(P,[],[],[],options);

	%% Case 2: Define particle providing a surface mesh
	p2=Particle(P,F,[],[],options); 

	%% Case 3: Define particle providing a tetrahedral mesh
	[Ptet,Etet,Ftet]=s2m(P,F,1,10000); % Transform surface to tetrahedral mesh
	p3=Particle(Ptet,Etet(:,1:4),[],[],options);

	%% Plot p1, p2, p3
	figure()
	subplot(2,2,1); title('Input=Point cloud')
	plotmesh(p1.Original.Mesh.Surface_mesh.Vertices,p1.Original.Mesh.Surface_mesh.Faces,'FaceColor','g')
	axis equal; grid on; alpha 0.8; camlight

	subplot(2,2,2); title('Input=Surface mesh')
	plotmesh(p2.Original.Mesh.Surface_mesh.Vertices,p2.Original.Mesh.Surface_mesh.Faces,'FaceColor','b')
	axis equal; grid on; alpha 0.8; camlight

	subplot(2,2,3); title('Input=Tetrahedral mesh')
	plotmesh(p3.Original.Mesh.Surface_mesh.Vertices,p3.Original.Mesh.Surface_mesh.Faces,'FaceColor','r')
	axis equal; grid on; alpha 0.8; camlight

elseif runPart==2
	%% Load segmented voxelated image
	load('SegmentedImage');
	
	labels=unique(SegmentedImage.img); %%
	labels(labels==0)=[]; % Remove zero (empty) voxels from the labels list
	
	% Iterate through all different particles
	for i=1:length(labels) % TODO: This can become a parfor in a next release
		% The "vox" struct contains the voxelated image (Nx x Ny x Nz) and the voxel size (1 x 3)
		vox.img=SegmentedImage.img.*(SegmentedImage.img==labels(i));  % Isolate each label (i.e. each particle)
		vox.voxel_size=SegmentedImage.voxel_size; % Add voxel size
		p{i}=Particle([],[],vox,[],options);
	end
	
	%% Plot initial voxelated image in voxel space
	figure()
	volshow(SegmentedImage.img)       % Plot greyscale volumetric image
% 	labelvolshow(SegmentedImage.img)  % Plot labeled volumetric image
	
	%% Plot surface meshes in Cartesian space
	figure()
	patch(p{1}.Original.Mesh.Surface_mesh,'FaceColor','g','EdgeColor','none')
	patch(p{2}.Original.Mesh.Surface_mesh,'FaceColor','b','EdgeColor','none')
	axis equal; grid on; box on; view(3)
	camlight
end

disp('Done!')