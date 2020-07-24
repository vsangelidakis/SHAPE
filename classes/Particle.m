classdef Particle < dynamicprops
	%PARTICLE: Class containing all the information of a particle
	properties
		Original

		%% FIXME: Choose whether to save the attributes below for each particle
		%%
% 		id
% 		Directory
% 		Filename
	end
	
	methods %(Static)
		function obj = Particle(Vertices,Faces,Voxelised_Matrix,Texture,options)
			
			%% FIXME: I don't need warnings to be defined for every particle maybe?
			%% Can I move it somewhere where it is processed once?
			
			% Whether to display warnings
			if strcmp(options.warning,'on')
				warning on
			elseif strcmp(options.warning,'off')
				warning off
			else
				warning on
				warning('warning must be "on" or "off"')
			end
			
			if isempty(Vertices)==false	% Vertices are given as input
				shp=alphaShape(Vertices,inf);
				Volume_CH=volume(shp); %Volume_of_convex_hull
				obj.Original=Particle_type(Vertices,Faces,Voxelised_Matrix,Texture,options,Volume_CH);
				
				if options.useConvexHull
					obj.addprop('Convex_hull');
					[F, V] = boundaryFacets(shp);
					obj.Convex_hull=Particle_type(V,F,[],[],options); % []: Voxelised_image
				end
				
			else % Voxelised_image is given as input

				
				%% FIXME: Set this up
				%% FIXME: Make this work for segmented, multi-particle voxelated images, where the user hasn't defined vertices yet
				
				Voxelised_Matrix.img
				Voxelised_Matrix.voxel_size
				
			end
		end
	end
end

