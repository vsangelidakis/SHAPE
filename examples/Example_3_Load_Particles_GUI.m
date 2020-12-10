% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Load particle shapes using GUI

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load multiple particle geometries using GUI
[file,path] = uigetfile('*.stl','Pick .stl files','multiselect','on');

if ischar(file) % if a single particle is selected, file is of char type
	[P,F,n] = stlRead([path,file]);
	particleContainer{1}=Particle(P,F,[],[],options);
else % if multiple particles are selected, file is of cell type
	for i=1:length(file)
		[P,F,n] = stlRead([path,file{i}]);
		particleContainer{i}=Particle(P,F,[],[],options);
	end
end

%% Save Workspace
% save('SavedSimulation');				% Save workspace (all variables)
save('Container','particleContainer');	% Save particle container only

disp('Done!')