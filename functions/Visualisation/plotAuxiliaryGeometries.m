function h=plotAuxiliaryGeometries(pt,options)
% 	pt		:		Particle_type: Original, Convex_hull etc
%	options	:		struct with fields:
%	- ellipsoid			:		boolean, whether to plot fitted ellipsoid
%	- obb				:		boolean, whether to plot obb
%	- inscribedSphere	:		boolean, whether to plot max inscribed sphere
%	- boundingSphere	:		boolean, whether to plot min bounding sphere
%	- Aabb				:		boolean, whether to plot Aabb

	h=gcf;
	%% FIXME: Maybe change what "h" is. Possibly provide a collection of all plots?
	%% 
	%% Particle
	Fm=pt.Mesh.Surface_mesh.Faces;
	Pm=pt.Mesh.Surface_mesh.Vertices;
	
	%% FIXME: Add option whether to plot the particle or not
	patch('Faces',Fm(:,1:3),'Vertices',Pm(:,1:3) ,'FaceColor',[0.6, 0.6, 0.6], 'EdgeColor', 'none', 'FaceAlpha',0.5); axis square %,'FaceColor','red'

	camlight;	% lighting gouraud; %phong

% 	axis equal;		
	axis vis3d equal;
% 	set(gca,'visible','off')

% 	view(45,22.5)	% view( -125, 12 );				% grain 1
% 	view(90,20)	% view( -125, 12 );
% 	view(95,40)	% view( -125, 12 );
% 	view(107,40)	% view( -125, 12 );				% grain 1
% 	view(105,14)
% 	view(191,43)

view( -125, 12 );

% 	view(93,-13)					% grain 3
% 	view(75,-5)					% grain 3
	
	grid on; hold on
	
	%% Fitted Ellipsoid
	if options.ellipsoid
% 		x=Pm(:,1);
% 		y=Pm(:,2);
% 		z=Pm(:,3);

		v=pt.Auxiliary_geometries.Fitted_ellipsoid.v;
		center = pt.Auxiliary_geometries.Fitted_ellipsoid.center;
		dim    = pt.Auxiliary_geometries.Fitted_ellipsoid.dimensions;
		rotmat  = pt.Auxiliary_geometries.Fitted_ellipsoid.rotmat;
		
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
		camlight;
		lighting gouraud; %phong

		
		%% FIXME
		%% Alternative code to plot ellipsoid (needs manual setting of orientation)
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
	if options.obb
		cornerpoints=pt.Auxiliary_geometries.OBB.cornerpoints;
		plotminbox(cornerpoints, 'k')
% 		hold on
	end

	%% Minimal bounding sphere
	if options.boundingSphere
		C=pt.Auxiliary_geometries.Minimal_bounding_sphere.center;
		R=pt.Auxiliary_geometries.Minimal_bounding_sphere.radius;
		
		% 	H=VisualizeBoundSphere(Pm,R,C,Xb); %ha % FIXME

		[x,y,z]=sphere(100);

		x = x * R;
		y = y * R;
		z = z * R;

		surf(x+C(1),y+C(2),z+C(3),'FaceAlpha',0.5,'FaceColor','b','EdgeColor','none')
% 		camlight
	end

	%% Maximal inscribed sphere
	if options.inscribedSphere
		C=pt.Auxiliary_geometries.Maximal_inscribed_sphere.center;
		R=pt.Auxiliary_geometries.Maximal_inscribed_sphere.radius;

		[x,y,z]=sphere(100);
		x = x * R;
		y = y * R;
		z = z * R;
		
		surf(x+C(1),y+C(2),z+C(3),'FaceAlpha',0.5,'FaceColor','r','EdgeColor','none')
% 		camlight
	end
	
	%% Aabb
	if options.Aabb
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
% 		hold on
% 		camlight
	end
	
	
end