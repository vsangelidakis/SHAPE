% I can put the classes in a separate file
classdef Mesh
	%MESH: Meshed geometries of the particle:
	%	Surface_Mesh
	%	Tetrahedral_Mesh
	%	Voxelised_image
	%	Surface_texture

	properties
		Surface_mesh
		Tetrahedral_mesh
		Voxelised_image
		Surface_texture
	end
	
	methods %(Static)
		function obj = Mesh(Vertices,Faces,Voxelised_image,Texture,options)
			%MESH Constructor of meshes from point cloud, mesh (surface or tetrahedral) or voxelised image
			
			if (isempty(Vertices)==false || isempty(Faces)==false) && isempty(Voxelised_image)==false % Check input variables: Do not allow simultaneous definition of Vertices-Faces and Voxelised_image
				error('Too many input arguments. Define either: "Vertices" or "Vertices" and Faces or "Voxelised_image"')
			end
			
			if isempty(Vertices) && isempty(Faces)==false % Check input variables: Do not allow definition of Faces without defining Vertices (the inverse is allowed)
				error('If Faces are defined, Vertices must be defined as well.')
			end

			if isempty(Vertices)==false
				if nargin==1 || isempty(Faces) % Point cloud, no faces are given
					if strcmp(options.Mesh.reconstructPointCloudMethod,'Crust') % Use Crust method to reconstruct the particle surface
						[Faces,~]=MyRobustCrust(Vertices);
					elseif strcmp(options.Mesh.reconstructPointCloudMethod,'Delaunay') % Use Delaunay triangulation to reconstruct the particle surface
						TR = delaunayTriangulation(Vertices);
						[Faces,Vertices] = freeBoundary(TR);
	% 				elseif strcmp(options.Mesh.reconstructPointCloudMethod,'alphaShape') % Use a concave alphaShape with critical alpha-value to reconstruct the particle surface
	% 					shp=alphaShape(Vertices,inf);
	% 					a = criticalAlpha(shp,'one-region')
					else
						error('options.Mesh.reconstructPointCloudMethod must be either "Crust" or "Delaunay"'); % or "alphaShape"
					end
				end
				
				if size(Faces,2)==3 %Surface mesh, vertices and faces are given 

					assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)])

					if options.meshcheckrepair
						% Repair mesh
						[Vertices,Faces]=stlSlimVerts(Vertices,Faces); % stlTools: Remove duplicate vertices
						[Vertices,Faces]=meshcheckrepair(Vertices,Faces,'meshfix'); % iso2mesh: repair a closed surface by the meshfix utility (new). It can remove self-intersecting elements and fill holes
					end
					
					[Pm,Fmtetra,~]=s2m(Vertices,Faces,1.0,options.Mesh.surf2mesh.maxvol,'tetgen',[],[]) ;%tetgen
					
					obj.Surface_mesh.Vertices=Vertices;
					obj.Surface_mesh.Faces=Faces;					
					obj.Tetrahedral_mesh.Vertices=Pm;
					obj.Tetrahedral_mesh.Faces=Fmtetra(:,1:4);
				
				elseif size(Faces,2)==4 % Tetrahedral mesh, vertices and elements are given
					tri=triangulation(Faces,Vertices);
					[F,P] = freeBoundary(tri); %% FIXME: See if I can bypass using F,P
					
					obj.Surface_mesh.Vertices=P;
					obj.Surface_mesh.Faces=F;
					obj.Tetrahedral_mesh.Vertices=tri.Points;
					obj.Tetrahedral_mesh.Faces=tri.ConnectivityList;

				end

% % 				obj.Surface_mesh.Vertices=Vertices;
% % 				obj.Surface_mesh.Faces=Faces;
% % 				
% % % 				obj.Surface_mesh.normals=normals; %% FIXME: Add the "normals" attribute in the class!!! Do I use it? Might it be useful for users?
% % 
% % 				[Pm,Fmtetra,~]=s2m(Vertices,Faces,1.0,options.Mesh.surf2mesh.maxvol,'tetgen',[],[]) ;%tetgen
% % 				obj.Tetrahedral_mesh.Vertices=Pm;
% % 				obj.Tetrahedral_mesh.Faces=Fmtetra;				
% % 				
% % 				%% FIXME: In Faces above, get only the first 4 columns, not all 5!
% % 
% % % 				DT=delaunayTriangulation(Vertices); %FIXME: Instead of DT, I can use alphaShape with a small alpha?
% % % 				obj.Tetrahedral_mesh.Vertices=DT.Points;
% % % 				obj.Tetrahedral_mesh.Faces=DT.ConnectivityList;
% % %
% % % 				[F,P] = freeBoundary(DT);
% % % 				obj.Surface_mesh.Vertices=P;
% % % 				obj.Surface_mesh.Faces=F;
% % 
% % 				assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)])
% % 
% % 				[imgTemp, map]=s2v(Vertices,Faces,options.Mesh.Voxelated_Image.div);
% % 				imgTemp2=imfill(imgTemp);
% % 				img=zeros(size(imgTemp2)+2);
% % 				img(2:end-1,2:end-1,2:end-1)=imgTemp2;
% % 				clear imgTemp imgTemp2
% % 
% % 				obj.Voxelised_image.img=img; %(~img);
% % 				obj.Voxelised_image.map=map;
% % 				obj.Voxelised_image.voxel_size=[map(1,1) map(2,2) map(3,3)];
% % % clc
% 			elseif isempty(Vertices)==false && size(Faces,2)==3 %Surface mesh, vertices and faces are given
% 				obj.Surface_mesh.Vertices=Vertices;
% 				obj.Surface_mesh.Faces=Faces;				
% 			end

% 				assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)])
% % 				ISO2MESH_TETGENOPT=[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)];
% 				[Pm,Fmtetra,~]=s2m(Vertices,Faces,1.0,options.Mesh.surf2mesh.maxvol,'tetgen',[],[]) ;%tetgen
% 				obj.Tetrahedral_mesh.Vertices=Pm;
% 				obj.Tetrahedral_mesh.Faces=Fmtetra;

				[imgTemp, map]=s2v(obj.Surface_mesh.Vertices,obj.Surface_mesh.Faces,options.Mesh.Voxelated_Image.div);
				imgTemp2=imfill(imgTemp);
				img=zeros(size(imgTemp2)+2);
				img(2:end-1,2:end-1,2:end-1)=imgTemp2;
				clear imgTemp imgTemp2

				obj.Voxelised_image.img=img;
				obj.Voxelised_image.map=map;
				obj.Voxelised_image.voxel_size=[map(1,1) map(2,2) map(3,3)];

			elseif isempty(Vertices) && isempty(Faces) && isempty(Voxelised_image)==false %Voxelised image is given

				%% FIXME Not working yet: To be amended soon!
				disp('Under development')
% 				obj.Voxelised_image=Voxelised_image;
% 				maxvol=10000;
				opt=[];
				method='cgalsurf'; % cgalsurf
				isovalues=0.5;
				assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)])
% 				ISO2MESH_TETGENOPT=[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)];
				[node,elem,face]=v2m(Voxelised_image,isovalues,opt,options.Mesh.surf2mesh.maxvol,method);

% 				[no,el,regions,holes]=v2s(Voxelised_image,isovalues,opt,method)
% 				obj.Surface_mesh.Vertices=Vertices;
% 				obj.Surface_mesh.Faces=Faces;
% clc
			end

			if isempty(Texture)==false
				obj.Surface_texture=Texture;
			end
		end

% 		function outputArg = method1(obj,inputArg)
% 			%METHOD1 Summary of this method goes here
% 			%   Detailed explanation goes here
% 			outputArg = obj.Property1 + inputArg;
% 		end
	end
end

