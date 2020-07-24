% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at: v.angelidakis2@ncl.ac.uk

% Example: Load particle shapes using GUI

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))			%FIXME: Maybe rename this to "extern"
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load multiple particle geometries using GUI
[file,path] = uigetfile('.stl','multiselect','on');
for i=1:length(file)
	try % if multiple particles are selected, file is a cell
		[P,F,n] = stlRead([path,file{i}]);
	catch  % if a single particle is selected, file is a string
		[P,F,n] = stlRead([path,file]);
	end
	particleContainer{i}=Particle(P,F,[],[],options);
end

%% FIXME: ALSO LOAD TEXTURE.txt for each file!!!
%% FIXME: ALSO LOAD A SEGMENTED CT image!!!
%% FIXME: IF I LOAD 1 PARTICLE, THE BRACES CAUSE AN ERROR

%% Save Workspace
% save('SavedSimulation'); % Save workspace (all variables)
save('Container','particleContainer'); % Save particle container only

disp('Done!')