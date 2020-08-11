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
				%% FIXME: Handle the CT input case. Here and in the Mesh class
				
				%% FIXME: Set this up
				%% FIXME: Make this work for segmented, multi-particle voxelated images, where the user hasn't defined vertices yet
				
				Voxelised_Matrix.img
				Voxelised_Matrix.voxel_size
				
			end
		end
		
		%%: Method to calculate simplify particle geometry
		
		%% FIXME: Add a dense mesh first
		function Simplify(obj,options) %Simplify(obj,options)
			% % 			obj=Particle;
			if ~options.useConvexHull
				Pm_ini=obj.Original.Mesh.Surface_mesh.Vertices;
				Fm_ini=obj.Original.Mesh.Surface_mesh.Faces;
			else
				Pm_ini=obj.Convex_hull.Mesh.Surface_mesh.Vertices;
				Fm_ini=obj.Convex_hull.Mesh.Surface_mesh.Faces;
			end
			
			for numFaces=options.Simplify.numFaces
				% Add dynamic property in the Particle class
				pSimplified=obj.addprop(['Faces_No_',num2str(numFaces)]);
				
				% CGAL - resample
				keepratio=numFaces/length(Fm_ini);
				[P_simplified,F_simplified]=meshresample(Pm_ini,Fm_ini,keepratio); %[node,elem]
				
				% Generate convex simplified particle
				shp=alphaShape(P_simplified,inf); % Convex hull;
				
				if options.useConvexHull
					[F_simplified, P_simplified]=boundaryFacets(shp); % Boundary faces of convex hull
				end
				
				obj.(pSimplified.Name)=Particle_type(P_simplified,F_simplified,[],[],options,volume(shp));
				
				%% FIXME: For the simplified particle, do we use the same options? ATTENTION!
				
			end
			
		end
		
		
	end
end

