function h=plotAuxiliaryGeometries(pt,options)
% 	pt		:		Particle_type: Original, Convex_hull, Face_No_100, etc.
%	options	:		struct with fields:
%	- ellipsoid			:		boolean, whether to plot fitted ellipsoid
%	- OBB				:		boolean, whether to plot obb
%	- inscribedSphere	:		boolean, whether to plot max inscribed sphere
%	- boundingSphere	:		boolean, whether to plot min bounding sphere
%	- AABB				:		boolean, whether to plot Aabb

%% FIXME: Update options

	h=gcf;
	%% FIXME: Maybe change what "h" is. Possibly provide a collection of all plots?
	%% 
	
% 	grid on; hold on
% 	axis equal;

	
%% FIXME: Support subplots
	% 		options.plotAuxiliaryGeometries.subplots=true

	
		%% Particle
		if options.plotAuxiliaryGeometries.Surface_mesh
	% 		plotMesh()
			fig=plotMesh(pt,true,false,false,false);
	% 		Fm=pt.Mesh.Surface_mesh.Faces;
	% 		Pm=pt.Mesh.Surface_mesh.Vertices;
	% 		patch('Faces',Fm(:,1:3),'Vertices',Pm(:,1:3) ,'FaceColor',[0.6, 0.6, 0.6], 'EdgeColor', 'none', 'FaceAlpha',0.5); axis square %,'FaceColor','red'
		end
	
	grid on
	hold on
	axis equal;
	view( -125, 12 );
	

	%% Fitted Ellipsoid
	if options.plotAuxiliaryGeometries.ellipsoid
		% x=Pm(:,1);
		% y=Pm(:,2);
		% z=Pm(:,3);
		v		= pt.Auxiliary_geometries.Fitted_ellipsoid.v;
		center	= pt.Auxiliary_geometries.Fitted_ellipsoid.center;
		dim		= pt.Auxiliary_geometries.Fitted_ellipsoid.dimensions;
		rotmat	= pt.Auxiliary_geometries.Fitted_ellipsoid.rotmat;
		
		mind = center' - rotmat*(dim/0.5)';
		maxd = center' + rotmat*(dim/0.5)';

% 		mind = center' - rotmat*(dim)';
% 		maxd = center' + rotmat*(dim)';		
		
		%% FIXME: For particle 14, the ellipsoid is not rendered properly

% 		mind = min( [ x y z ] );
% 		maxd = max( [ x y z ] );
		nsteps = 400;
		step = ( maxd - mind ) / nsteps;
		[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
		Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
			2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
			2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
		p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
		set( p, 'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha',0.5 );
% 		camlight;
% 		lighting gouraud; %phong

		
		%% FIXME
		%% Alternative code to plot ellipsoid (needs manual setting of orientation)
		%% FIXME: Or use ellipsoid() to begin with
% 		[x,y,z]=sphere;
% 		radii=dim/2.;
% 		x = x * radii(1);
% 		y = y * radii(2);
% 		z = z * radii(3);
% 
% 		surf(x+center(1),y+center(2),z+center(3),'FaceAlpha',0.5,'FaceColor','b','EdgeColor','none')
% 		camlight

	end

	%% OBB
	if options.plotAuxiliaryGeometries.OBB
		cornerpoints=pt.Auxiliary_geometries.OBB.cornerpoints;
		plotminbox(cornerpoints, 'k')
	end

	hold on
	%% Minimal bounding sphere
	if options.plotAuxiliaryGeometries.boundingSphere
		C=pt.Auxiliary_geometries.Minimal_bounding_sphere.center;
		R=pt.Auxiliary_geometries.Minimal_bounding_sphere.radius;
		
		% 	H=VisualizeBoundSphere(Pm,R,C,Xb); %ha % FIXME
		
		[x,y,z]=sphere(100);
		
		x = x * R;
		y = y * R;
		z = z * R;
		
		surf(x+C(1),y+C(2),z+C(3),'FaceAlpha',0.5,'FaceColor','b','EdgeColor','none')
	end

	hold on
	%% Maximal inscribed sphere
	if options.plotAuxiliaryGeometries.inscribedSphere
		C=pt.Auxiliary_geometries.Maximal_inscribed_sphere.center;
		R=pt.Auxiliary_geometries.Maximal_inscribed_sphere.radius;

		[x,y,z]=sphere(100);
		x = x * R;
		y = y * R;
		z = z * R;
		
		surf(x+C(1),y+C(2),z+C(3),'FaceAlpha',0.5,'FaceColor','r','EdgeColor','none')
	end
	
	%% AABB
	if options.plotAuxiliaryGeometries.AABB
		ex=pt.Auxiliary_geometries.AABB.Extrema;
		ce=pt.Auxiliary_geometries.AABB.Centroid;
		dim=(ex(2,:)-ex(1,:))/2;

		cornerpoints=[
			ce(1)-dim(1) ce(2)-dim(2) ce(3)-dim(3);
			ce(1)+dim(1) ce(2)-dim(2) ce(3)-dim(3);
			ce(1)+dim(1) ce(2)+dim(2) ce(3)-dim(3);
			ce(1)-dim(1) ce(2)+dim(2) ce(3)-dim(3);
			ce(1)-dim(1) ce(2)-dim(2) ce(3)+dim(3);
			ce(1)+dim(1) ce(2)-dim(2) ce(3)+dim(3);
			ce(1)+dim(1) ce(2)+dim(2) ce(3)+dim(3);
			ce(1)-dim(1) ce(2)+dim(2) ce(3)+dim(3)	];
		
		plotminbox(cornerpoints, 'k')
	end
	
% 	camlight;	% lighting gouraud; %phong
end