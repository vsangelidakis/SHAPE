% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Different input methods

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))			%FIXME: Maybe rename this to "extern"
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load particle geometries by loading the directory manually
[P,F,n] = stlRead('Platonic_solids/Dodecahedron.stl');
% % [P,F,n] = stlRead('Spheres_and_ellipsoids/Sphere_R_1.stl');  %% FIXME: Restore this!!!
% 
% options='all';
% 
%% Load point cloud and use the "Crust" algorithm to mesh the particle
% p1=Particle(P,[],[],[],options);
% 
%% Load surface mesh
p2=Particle(P,F,[],[],options); 

%% Load segmented voxelated image
% load('SegmentedImage');
% 
% labels=unique(SegmentedImage.img); %%
% labels(labels==0)=[]; % Remove zero (empty) voxels from the labels list
% % labels( ~any(labels,2), : ) = []; % Remove zero (empty) voxels from the labels list
% 
% % for i=1:length(labels)
% % 	p{i}=Particle([],[],SegmentedImage(SegmentedImage.img==labels(i)),[],options,false); %false
% % end
% % uniq=unique(SegmentedImage.img);
% 
% % a=SegmentedImage.img(SegmentedImage.img==labels(1));
% 
% for i=1:length(labels)    
%     C_logical=(SegmentedImage.img==labels(i));
%     c.img=SegmentedImage.img.*C_logical;
% 	c.voxel_size=SegmentedImage.voxel_size;
% 	p{i}=Particle([],[],c,[],options,false); %false
% end
% 
% 
% % figure()
% % subplot(1,2,1)
% % plotmesh(p1.Original.Mesh.Surface_mesh.Vertices,p1.Original.Mesh.Surface_mesh.Faces,'FaceColor','g')
% % camlight
% % 
% % subplot(1,2,2)
% % plotmesh(p2.Original.Mesh.Surface_mesh.Vertices,p2.Original.Mesh.Surface_mesh.Faces,'FaceColor','b')
% % camlight
% 
% % Dodecahedron=p2.Original.Mesh.Voxelated_image;
% % save('Dodecahedron','Dodecahedron');



%% Load segmented (labeled) voxelated image
% p2=Particle([],[],img,[],options,false); %false    %% FIXME FIXME


% %% Save Workspace
% save('SavedSimulation'); % Save all variables
% % save('Dodecahedron','p'); % Save specific particle
% 
% %% Clear Workspace
% clear
% 
% %% Load Workspace
% load('SavedSimulation'); % Load all variables
% % load('Dodecahedron','p'); % Load specific particle

disp('Done!')