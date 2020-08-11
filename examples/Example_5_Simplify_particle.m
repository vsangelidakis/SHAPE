% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Simplify particle shape to different fidelity levels. Fidelity
% is quantified in terms of triangular faces of the surface mesh of the
% particle.

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))			%FIXME: Maybe rename this to "extern"
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Shape simplification: Define target numbers of surface faces
options.Simplify.numFaces=[400,1000];

%% Load particle geometry
[P,F,n] = stlRead('Spheres_and_ellipsoids/Ellipsoid_R_1_1_2.stl');

%% Define particle and invoke simplification module
p1=Particle(P,F,[],[],options); 
p1.Simplify(options);

% Plot surface meshes of the simplified particles
plotMesh(p1.Original,     true,false,false,false);
plotMesh(p1.Faces_No_1000,true,false,false,false);
plotMesh(p1.Faces_No_400, true,false,false,false);


disp('Done!')