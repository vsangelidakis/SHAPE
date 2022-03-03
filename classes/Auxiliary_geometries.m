% I can put the classes in a separate file
classdef Auxiliary_geometries
	%AUXILIARY_GEOMETRIES: Used for shape characterisation:
	%	AABB (Axis-aligned bounding box for the current orientation)
	%		Extrema (Coordinates of two extreme points)
	%		Dimensions (length of edges)
	%			%Centroid
	%			%Volume
	%			%Surface_area
	%	OBB (Oriented bounding box)
	%		Extrema (Coordinates of two extreme points)
	%		Dimensions (length of edges)
	%		Centroid
	%		Volume
	%		Surface_area
	%			%Orientation
	%	Fitted_ellipsoid (using least squares)
	%		Extrema (Coordinates of two extreme points)
	%		Dimensions (length of axes)
	%		Centroid
	%			%Volume
	%			%Surface_area
	%			%Orientation
	%	Minimal_bounding_sphere (using Ritter's algorithm)
	%		Radius
	%		Centre
	%			%Volume
	%			%Surface_area
	%	Maximal_inscribed_sphere (using a Euclidean map)
	%		Radius
	%		Centre
	%			%Volume
	%			%Surface_area

	%% FIXME: Add orientation of OBB/ELI?
	%% CHECK: Do/Should I monitor the centroid, volume, surface area for all of the shapes above?

	properties
% 		Extreme_points
		% These ARE auxiliary geometries, they are not properties
		AABB
		OBB
		Fitted_ellipsoid
		Minimal_bounding_sphere
		Maximal_inscribed_sphere
	end
	
	methods %(Static)
		function obj = Auxiliary_geometries(ms,options) %ms,geom,options
			%AUXILIARY_GEOMETRIES Constructor to calculate characteristics of bounding volumes and fitted ellipsoid 
			ver_surf=ms.Surface_mesh.Vertices;
%  			ver_mesh=ms.Tetrahedral_mesh.Vertices;
			
% 			img=ms.Voxelated_image
			img=ms.Voxelated_image.img;
% 			map=ms.Voxelated_image.map;

			%% AABB
			obj.AABB.Extrema=[min(ver_surf); max(ver_surf)];
			obj.AABB.Centroid=mean(obj.AABB.Extrema);
% 			obj.AABB.cornerpoints=[min(ver_surf); max(ver_surf)];
			
			
			%% OBB
				% FIXME: See if I can use this from minBoundBox
%				ind = strmatch(metric,{'volume','surface','edges'});
			minimalOBB={'minVolume','minSurfaceArea','minSumEdges'};
			[LIA, LOC] = ismember(options.Auxiliary_Geometries.OBB.method, minimalOBB);
			if LIA
				%% Minimal OBB (minimal volume or surface area or sum of edges)
				metric={'v','s','e'}; % Cell serving as dictionary to minimalOBB variable
				[R,cornerpoints,volume,surface,~] = minboundbox(ver_surf(:,1),ver_surf(:,2),ver_surf(:,3),metric{LOC},3);
				E1=cornerpoints(1,:); E2=cornerpoints(2,:); E4=cornerpoints(4,:); E5=cornerpoints(5,:);
				D(1)=norm(E1-E2); D(2)=norm(E1-E4); D(3)=norm(E1-E5);
				
				[S_obb, ind_S] = min(D); D(ind_S)=-1;
				[L_obb, ind_L] = max(D);
				ind_I=6 - ind_S - ind_L;
				I_obb = D(ind_I);

				obj.OBB.cornerpoints=cornerpoints;
				obj.OBB.rotmat=[R(:,ind_S), R(:,ind_I), R(:,ind_L)]; % Sorted unit vectors, following the order of S, I, L axes
				obj.OBB.volume=volume;
				obj.OBB.surface=surface;
				obj.OBB.center=mean(cornerpoints);
				obj.OBB.dimensions=[S_obb, I_obb, L_obb];
				clear ind_S ind_L				
				
			elseif strcmp(options.Auxiliary_Geometries.OBB.method,'PCA_points')
				switch options.Auxiliary_Geometries.OBB.points
					case 'Surface_points'
						ver=ver_surf;
					case 'Tetrahedra_points'
						ver=ms.Tetrahedral_mesh.Vertices;						
					case 'Voxel_points'
						
						%% FIXME: voxel_size will become 1x1 and so I don't need the index (1) below
						%% FIXME: Do not load voxelData twice, I also use it below for the inscribed sphere
						
						%% FIXME: clear any 3D matrices I don't need
						
						% Here I center the voxel coordinates to the centroid of the voxelated image
						voxelData=ms.Voxelated_image.img; 
						[data(:,1),data(:,2),data(:,3)] = ind2sub(size(voxelData),find(voxelData>0));
						tempData=data*ms.Voxelated_image.voxel_size(1);
						ver=tempData - ones(length(tempData),1)*mean(tempData);% + geom.Centroid;

% 						ver(:,1)=obj.AABB.Extrema(1,1)-2*dx+data(:,1)*dx; % Remap voxels of centroid to Cartesian space
% 						ver(:,2)=obj.AABB.Extrema(1,2)-2*dx+data(:,2)*dx;
% 						ver(:,3)=obj.AABB.Extrema(1,3)-2*dx+data(:,3)*dx;
					otherwise
						error('options.Auxiliary_Geometries.OBB.points must be either: "Surface_points", "Tetrahedra_points" or "Voxel_points".')
				end
				[obj.OBB.cornerpoints,obj.OBB.rotmat,obj.OBB.volume,obj.OBB.surface,obj.OBB.center,obj.OBB.dimensions]=OBB_PCA_SVD(ver);
			else
				error('options.Auxiliary_Geometries.OBB.method must be either "PCA_points", "minVolume", "minSurfaceArea" or "minSumEdges"')
			end

		
			%% Fitted ellipsoid
			
				%% TODO: ADD options.ELL: ver_surf, ver_tetr
				%% TODO: Rename _obb to _OBB and _eli to _ELL
			
% 			[center, radii, evecs, v, chi] = ellipsoid_fit([ver_mesh(:,1),ver_mesh(:,2),ver_mesh(:,3)]);
			[center, radii, evecs, v, chi] = ellipsoid_fit(ver_surf,'');
			
			[S_eli, ind_S] = min(radii);  radii(ind_S)=-1;
			[L_eli, ind_L] = max(radii);
			ind_I=6 - ind_S - ind_L;
			I_eli = radii(ind_I);

			% Multiply the radii with 2 to get the length of the axes of the ellipsoid (double the radii).
			S_eli = S_eli * 2;
			I_eli = I_eli * 2;
			L_eli = L_eli * 2;

 			rotmat=[evecs(:,ind_S), evecs(:,ind_I), evecs(:,ind_L)];

			obj.Fitted_ellipsoid.center=center';
			obj.Fitted_ellipsoid.rotmat=rotmat;
			obj.Fitted_ellipsoid.dimensions=[S_eli, I_eli, L_eli];
			obj.Fitted_ellipsoid.v=v;
			obj.Fitted_ellipsoid.chi=chi;

			%% FIXME: Maybe I don't need to store these in two different places
% 			% Small, Intermediate and Long axis using the fitted ellipsoid
% % 			axes_eli=aux.Fitted_ellipsoid.dimensions;
% 			geom.S_eli=S_eli;	geom.I_eli=I_eli;	geom.L_eli=L_eli;
			
			%% Minimal bounding sphere
% 			try
				% Calculate the exact bounding sphere, using Welzl's algorithm
				[R,C,Xb]=ExactMinBoundSphere3D(ver_surf);
				obj.Minimal_bounding_sphere.Xb=Xb; % Points used to calculate the sphere
% 			catch
				% TODO: If the exact calculation fails, go for the approximate calculation of Ritter.
				% Calculate an approximate bounding sphere, using Ritter's algorithm
% 				[R,C]=ApproxMinBoundSphereND(ver_surf);
% 			end
				obj.Minimal_bounding_sphere.radius=R; % Circumradius
				obj.Minimal_bounding_sphere.center=C; % Center
			
			%% Maximal inscribed sphere
			edtImage = bwdist(~img);		% Euclidean map (Euclidean distance transformation)
			radius = max(edtImage(:)); %-1	% Inradius in voxel units %%FIXME: Do I need to add -1 here?
			[xCenter, yCenter, zCenter]= ind2sub(size(img),find(edtImage == radius)); % Center in voxel units

			%% FIXME: Check if I need to change x,y above.
			%% TODO: If the particle is convex, use linear programming, to specify the inradius as the Chebychev center.
			
			%% I think the 3 lines below are wrong. Use instead the first element
% 			xCenter=mean(xCenter);
% 			yCenter=mean(yCenter);
% 			zCenter=mean(zCenter);

			%% ATTENTION: Instead of using the first element, find the element closest to the centroid!
			%%
			xCenter=xCenter(1);
			yCenter=yCenter(1);
			zCenter=zCenter(1);
			
			% ---------------------------------------------
			% ATTENTION!
			% FIXME: I need to go back and check the sequence of xCenter,
			% yCenter, zCenter: They might be out of order, since vol2surf
			% uses a shiftdim at some point.
			% ---------------------------------------------

			dx=ms.Voxelated_image.voxel_size;

			%% FIXME: voxel_size should be 1x1: Change this and remove the indices (1), (2), (3) below
			
			xC=obj.AABB.Extrema(1,1)-dx(1)+xCenter*dx(1); % Remap voxels of centroid to Cartesian space
			yC=obj.AABB.Extrema(1,2)-dx(2)+yCenter*dx(2);
			zC=obj.AABB.Extrema(1,3)-dx(3)+zCenter*dx(3);

			%% FIXME
			%%
%  			dx
			
% 			r=radius*mean(dx)*103/100
% 			size(img)
% 			radius*dx(1)
% 			radius=(radius+1)*dx(1)
% 			radius*dx(1)+dx(1)*sqrt(3) %-dx(1)/4
			obj.Maximal_inscribed_sphere.radius=radius*mean(dx); % Transform radius to Cartesian space
			obj.Maximal_inscribed_sphere.center=[xC, yC, zC];

		end

% 		function outputArg = method1(obj,inputArg)
% 			%METHOD1 Summary of this method goes here
% 			%   Detailed explanation goes here
% 			outputArg = obj.Property1 + inputArg;
% 		end
	end
end

