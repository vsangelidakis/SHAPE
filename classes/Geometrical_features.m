% I can put the classes in a separate file
classdef Geometrical_features
	%GEOMETRICAL_FEATURES: Geometrical information of the particle
	%   Volume
	%	Centroid
	%	Surface_area
	%	Current_inertia tensor (i.e. for the current orientation)
	%	Principal_inertia_tensor
	%	Principal_inertia_orientations (relative to current orientation)
	%	Particle dimensions based on the minimal oriented bounding box
	%	Particle dimensions based on the least-squares fitted ellipsoid
	
	properties
		Volume
		Volume_CH; %Volume_of_convex_hull
		Centroid
		Surface_area
		Current_inertia_tensor
		Principal_inertia_tensor
		Principal_inertia_orientations
		S_obb; I_obb; L_obb
		S_eli; I_eli; L_eli
	end
	
	methods %(Static)
		function obj = Geometrical_features(ms, aux) %,aux
			%GEOMETRICAL_FEATURES Constructor to calculate geometrical_features

			% Volume, centroid, current inertia tensor, principal inertia tensor and orientations
			[obj.Volume, obj.Centroid, obj.Current_inertia_tensor, obj.Principal_inertia_tensor, obj.Principal_inertia_orientations] = volume_centroid_inertiaTensor(ms.Tetrahedral_mesh.Vertices, ms.Tetrahedral_mesh.Faces, true);

			% Surface area
			obj.Surface_area = surface_area(ms.Surface_mesh.Vertices, ms.Surface_mesh.Faces);

			%%
			%% FIXME: Rethink whether to save S,I,L both here and in the auxiliary geometries
			%%

			% Short, Intermediate and Long axis using the oriented bounding box
			axes_obb=aux.OBB.dimensions;
			obj.S_obb=axes_obb(1);	obj.I_obb=axes_obb(2);	obj.L_obb=axes_obb(3);

			% Short, Intermediate and Long axis using the fitted ellipsoid
			axes_eli=aux.Fitted_ellipsoid.dimensions;
			obj.S_eli=axes_eli(1);	obj.I_eli=axes_eli(2);	obj.L_eli=axes_eli(3);

		end

% 		function [volume, centroid, current_inertia_tensor, inertia_tensor, principalOrientations] = volume_centroid_inertiaTensor(pt, calculateInertia)
			%METHOD1 Summary of this method goes here
			%   Detailed explanation goes here
% 			[volume, centroid, current_inertia_tensor, inertia_tensor, principalOrientations] = volume_centroid_inertiaTensor(obj., elements, True)
% 			outputArg = obj.Property1 + inputArg;
% 		end
	end
end