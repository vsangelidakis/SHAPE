% SHAPE: SHape Analyser for Particle Engineering
% Authors: Angelidakis, V., Nadimi, S., Utili, S. (2020)
%
% Report issues on github or email at v.angelidakis2@ncl.ac.uk

% Example: Load all particle shapes inside a specific directory

clc; clear; close all

%% Include code data-structure
addpath(genpath('../functions'))
addpath(genpath('../lib'))
addpath(genpath('../classes'))

%% Load simulation options
load('options.mat');

%% Load all particles in specific folder
inputDirectory='Platonic_solids/'; % Directory where all the particle shapes are stored. All the particles will be parsed by default.

%%
parDir=dir(inputDirectory);
ind=1;
for i=1:size(parDir,1)
	if parDir(i,1).isdir==false % skip folders (subdirectories), read only files
		if strcmp(parDir(i,1).name(end-2:end),'stl') % here we can include more/any file formats, as long as we have a function to load them
			[P,F,n] = stlRead([parDir(i,1).folder,'\',parDir(i,1).name]);
			particleContainer{ind}=Particle(P,F,[],[],options);			

% 			particleDirectories{ind,1}=['Particle_',num2str(ind)]; %Particle id
% 			particleDirectories{ind,2}=parDir(i,1).name; % Particle filename

% 			particleContainer{ind}.id=ind; %Particle id
% 			particleContainer{ind}.Directory=parDir(i,1).folder; % Particle filename
% 			particleContainer{ind}.Filename=parDir(i,1).name; % Particle filename

			ind=ind+1;
		end
	end
end

%% Save Workspace
% save('SavedSimulation');					% Save workspace (all variables)
save('PlatonicSolids','particleContainer');	% Save particle container only

disp('Done!')