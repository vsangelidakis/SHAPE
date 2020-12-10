% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Save/load processed sample for post-processing.

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))			%FIXME: Maybe rename this to "extern"
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load particle geometries by loading the directory manually
%% Case 1: Load single particle
% [P,F,n] = stlRead('Platonic_solids/Dodecahedron.stl');
% % [P,F,n] = stlRead('Platonic_solids/Hexahedron.stl');
% 
% options='all';
% particleContainer=Particle(P,F,[],[],options,false); %false

%% Case 2: Load multiple particles
directories={'Platonic_solids/Dodecahedron.stl', 'Platonic_solids/Hexahedron.stl'};

for i=1:length(directories)
	[P,F,n] = stlRead(directories{i});
	particleContainer{i}=Particle(P,F,[],[],options); %false
end

%% Save Workspace or Particles
% save('SavedSimulation'); % Save workspace (all variables)
save('SavedSimulation','particleContainer'); % Save particle container only

%% Clear Workspace
clear

%% Load Workspace or Particles
% load('SavedSimulation');						% Load workspace (all variables)
load('SavedSimulation','particleContainer');	% Load particle container only

disp('Done!')