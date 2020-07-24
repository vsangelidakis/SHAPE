function fig=plotMesh(pt,surface_mesh,tetrahedral_mesh,voxelised_mesh,surface_texture)
% 	pt				:	Particle_type: Original, Convex_hull etc
%	surface_mesh	:	boolean, whether to plot surface mesh
%	tetrahedral_mesh:	boolean, whether to plot tetrahedral mesh
%	voxelised_mesh	:	boolean, whether to plot voxelised image
%	surface_texture	:	boolean, whether to plot surface texture

% Enable OpenGL to use volshow
opengl software
opengl hardware
opengl hardwarebasic

% set(0,'defaultTextInterpreter','latex'); %trying to set the default
 	%% Surface mesh
	if surface_mesh
		fig.SurfaceMesh=figure();
% 		set(gca,'Interpreter','LaTeX')
		sur=pt.Mesh.Surface_mesh;
		c=[0.7,0.7,0.7];
% 		trisurf(sur.Faces(:,1:3),sur.Vertices(:,1),sur.Vertices(:,2),sur.Vertices(:,3),'FaceColor',c,'EdgeColor','none')
		patch('Faces',sur.Faces(:,1:3),'Vertices',sur.Vertices(:,1:3),'FaceColor',c,'EdgeColor','none')
		grid on
		
		title('\textbf{Surface mesh}','FontSize',16,'Interpreter','LaTeX')
		set(gca,'TickLabelInterpreter','LaTeX')		
		axis equal
		alpha 0.98
% 		view(45,22.5)
		view( -125, 12 );
		camlight
	end
	
	%% Tetrahedral mesh
	if tetrahedral_mesh
		fig.TetrahedralMesh=figure();
		tet=pt.Mesh.Tetrahedral_mesh;
		c=repmat([0.7,0.7,0.7],length(tet.Faces),1);
% 		tetramesh(tet.Faces(:,1:4),tet.Vertices(:,1:3),c)
% 		tetramesh(tet.Faces(:,1:4),tet.Vertices(:,1:3))
% 		tetramesh(tet.Vertices(:,1:3),tet.Faces(:,1:4))

		TR=triangulation(tet.Faces(:,1:4),tet.Vertices(:,1:3));

		tetramesh(TR)
		
		grid on
		
		title('\textbf{Tetrahedral mesh}','FontSize',16,'Interpreter','LaTeX')
		set(gca,'TickLabelInterpreter','LaTeX')		
		axis equal
% 		alpha 0.9
% 		view(45,22.5)
		view( -125, 12 );
		camlight
	end
% 	
	%% Volumetric mesh
	if voxelised_mesh
		fig.Voxelised_mesh=figure();
		p = uipanel('Title','Voxelised mesh','FontSize',16,'TitlePosition','centertop','FontName','Modern No. 20');
		vox=pt.Mesh.Voxelised_image.img;
		volshow(vox,'Parent',p);
	end
% 
	%% Surface texture (roughness)
	if surface_texture==true && isempty(pt.Mesh.Surface_texture)
		warning('Surface texture has not been defined for this particle.')
	elseif surface_texture==true
		fig.SurfaceTexture=figure();
		z=pt.Mesh.Surface_texture;
		
% 		mesh(rough);
% 		surf(rough);
% 		colormap jet %parula
		
		[n,m] = size(z);
		x = linspace(0,(m-1) * 1 , m);
		y = linspace(0,(n-1) * 1 , n);

		[X,Y] = meshgrid(x,y);
		h=mesh(X,Y,z);
		colormap jet %parula
% 		axis equal

% 		set(gca,'visible','off')
		camlight
		shading interp
		
		
		title('\textbf{Surface texture}','FontSize',16,'Interpreter','LaTeX')
		set(gca,'TickLabelInterpreter','LaTeX')		
% 		axis equal
		alpha 0.9
% 		view(45,22.5)
		view( -125, 12 );
		camlight
	end

end