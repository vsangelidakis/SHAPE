% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Save/load processed sample for post-processing.

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load particle geometries by specifying the directories manually
directories={'Platonic_solids/Dodecahedron.stl', 'Platonic_solids/Hexahedron.stl'};

for i=1:length(directories)
	[P,F,n] = stlRead(directories{i});
	particleContainer{i}=Particle(P,F,[],[],options); %false
end

%% Save Workspace or Particles
% save('SavedSimulation');					 % Save workspace (all variables)
save('SavedSimulation','particleContainer'); % Save particle container only

%% Clear Workspace
clear

%% Load Workspace or Particles
% load('SavedSimulation');						% Load workspace (all variables)
load('SavedSimulation','particleContainer');	% Load particle container only

disp('Done!')