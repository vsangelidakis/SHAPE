classdef Particle_type %< dynamicprops
	%PARTICLE_TYPE: Type of the particle, e.g.:
	%	Original (real particle geometry)
	%	Convex_hull (calculated if options.useConvexHull=true)
	%	Faces_No_100 (if this is a simplified particle geometry)
	%	Faces_No_50  (if this is a simplified particle geometry)
	%	etc.
	%
	%	More subclasses can be added with "addprop", which allows the
	%	creation of dynamic properties for a class

	%% FIXME: INSTEAD OF NAMING THIS Particle_type, I COULD NAME IT: Particle_properties
	
	properties
		Mesh
		Auxiliary_geometries
		Geometrical_features
		Morphological_features 
		
% 		P = addprop(H,'PropertyName') in the script
	end
	
	methods %(Static)
		function obj = Particle_type(Vertices,Faces,Voxelated_image,Texture,options,varargin)
			%PARTICLE_TYPE Constructor from point cloud, surface or tetrahedral mesh

			% vararging{1} contains the volume of the convex hull

			%%
			%% FIXME: Add the the constructor from CT data
			%% FIXME: Update the nargin value if I remove any parameters!!
			%%
			%% FIXME: Do I need dynamic properties here?

			obj.Mesh=Mesh(Vertices,Faces,Voxelated_image,Texture,options);
			obj.Auxiliary_geometries=Auxiliary_geometries(obj.Mesh,options);
			obj.Geometrical_features=Geometrical_features(obj.Mesh, obj.Auxiliary_geometries);

			if nargin==6 % if the volume of the convex hull is given (for concave particles)
				if varargin{1}>0
					obj.Geometrical_features.Volume_CH=varargin{1};
				elseif varargin{1}==0 % if 0 is given, we compute the convex hull once more, in the Particle_type=Original object
						shp=alphaShape(obj.Mesh.Surface_mesh.Vertices,inf); % FIXME: With this, I calculate the CH twice. To be optimised
						obj.Geometrical_features.Volume_CH=volume(shp);
				else
					error('Volume of the convex hull must be positive.')
				end
			else % if the volume of the convex hull is not given (for convex particles)
				obj.Geometrical_features.Volume_CH=obj.Geometrical_features.Volume;
			end

% 			ms.Surface_mesh.Vertices=ms.Surface_mesh.Vertices-geom.Centroid;
% 			ms.Tetrahedral_mesh.Vertices=ms.Tetrahedral_mesh.Vertices-geom.Centroid;
% 			Vertices=Vertices-geom.Centroid;
% 			geom.Centroid=[0,0,0];

			obj.Morphological_features=Morphological_features(obj.Mesh, obj.Geometrical_features, options);
		end
	end
end

