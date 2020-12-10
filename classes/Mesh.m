% I can put the classes in a separate file
classdef Mesh
	% MESH: Discretised geometric representations of the particle:
	%	Surface_Mesh
	%	Tetrahedral_Mesh
	%	Voxelated_image
	%	Surface_texture

	properties
		Surface_mesh
		Tetrahedral_mesh
		Voxelated_image
		Surface_texture
	end
	
	methods
		function obj = Mesh(Vertices,Faces,Voxelated_image,Texture,options)
			%MESH Constructor from point cloud, mesh (surface or tetrahedral) or voxelated image
			
			%% Safeguard input
			if (isempty(Vertices)==false || isempty(Faces)==false) && isempty(Voxelated_image)==false % Check input variables: Do not allow simultaneous definition of Vertices-Faces and Voxelated_image
				error('Too many input arguments. Define either: "Vertices" or "Vertices" and Faces or "Voxelated_image"')
			end
			
			if isempty(Vertices) && isempty(Faces)==false % Check input variables: Do not allow definition of Faces without defining Vertices (the inverse is allowed)
				error('If Faces are defined, Vertices must be defined as well.')
			end

			%% If the user provides vertices (mesh input)
			if isempty(Vertices)==false
				if nargin==1 || isempty(Faces) % Point cloud, no faces are given
					if strcmp(options.Mesh.reconstructPointCloudMethod,'Crust') % Use Crust method to reconstruct the particle surface
						[Faces,~]=MyRobustCrust(Vertices);
					elseif strcmp(options.Mesh.reconstructPointCloudMethod,'Delaunay') % Use Delaunay triangulation to reconstruct the particle surface
						TR = delaunayTriangulation(Vertices);
						[Faces,Vertices] = freeBoundary(TR);
%					elseif strcmp(options.Mesh.reconstructPointCloudMethod,'alphaShape') % Use a concave alphaShape with critical alpha-value to reconstruct the particle surface
%						shp=alphaShape(Vertices,inf);
%						a = criticalAlpha(shp,'one-region')
					else
						error('options.Mesh.reconstructPointCloudMethod must be either "Crust" or "Delaunay"'); % or "alphaShape"
					end
				end
				
				if size(Faces,2)==3 %Surface mesh, vertices and faces are given 
					assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)]) % tetgen settings
					
					if options.meshcheckrepair % Repair mesh
						[Vertices,Faces]=stlSlimVerts(Vertices,Faces);				% stlTools: Remove duplicate vertices
						[Vertices,Faces]=meshcheckrepair(Vertices,Faces,'meshfix');	% iso2mesh: repair a closed surface using the meshfix utility. It can remove self-intersecting elements and fill holes
					end
					
					[Pm,Fmtetra,~]=s2m(Vertices,Faces,1.0,options.Mesh.surf2mesh.maxvol,'tetgen',[],[]); % Transform surface mesh to tetrahedral mesh
					
					obj.Surface_mesh.Vertices=Vertices;
					obj.Surface_mesh.Faces=Faces;		
					
					obj.Tetrahedral_mesh.Vertices=Pm;
					obj.Tetrahedral_mesh.Faces=Fmtetra(:,1:4);
				elseif size(Faces,2)==4 % Tetrahedral mesh, vertices and elements are given
					tri=triangulation(Faces,Vertices);
					[F,P] = freeBoundary(tri); %% FIXME: See if I can bypass using F,P
					
					if options.meshcheckrepair % Repair mesh
						[P,F]=stlSlimVerts(P,F);				% stlTools: Remove duplicate vertices
						[P,F]=meshcheckrepair(P,F,'meshfix');	% iso2mesh: repair a closed surface using the meshfix utility. It can remove self-intersecting elements and fill holes
					end
					
					obj.Surface_mesh.Vertices=P;
					obj.Surface_mesh.Faces=F;
					
					obj.Tetrahedral_mesh.Vertices=tri.Points;
					obj.Tetrahedral_mesh.Faces=tri.ConnectivityList;
				end

%				obj.Surface_mesh.normals=normals; %% FIXME: Add the "normals" attribute in the class! Do I use it? Might it be useful for users?

				%% Transform surface mesh to voxelated image (of a single particle)
				[imgTemp, map]=s2v(obj.Surface_mesh.Vertices,obj.Surface_mesh.Faces,options.Mesh.Voxelated_Image.div);
				imgTemp2=imfill(imgTemp); % Fill the interior of the particle
				img=zeros(size(imgTemp2)+2); % Enlarge the image by 2 voxels per direction, to ensure that outer voxels are empty (zero)
				img(2:end-1,2:end-1,2:end-1)=imgTemp2; %% FIXME: Try using less 3D matrices here, as they are costly, memory-wise
				clear imgTemp imgTemp2

				obj.Voxelated_image.img=img; clear img;
				obj.Voxelated_image.map=map;
				obj.Voxelated_image.voxel_size=[map(1,1) map(2,2) map(3,3)];

			%% if the user provides a segmented, voxelated image
			elseif isempty(Vertices) && isempty(Faces) && isempty(Voxelated_image)==false %Voxelated image is given
				opt=2; %see vol2mesh function in iso2mesh
				method='cgalmesh'; % cgalsurf cgalpoly
				isovalues=[]; %see vol2mesh function in iso2mesh
				assignin('base','ISO2MESH_TETGENOPT',[' -A -Q -q1.414a' num2str(options.Mesh.surf2mesh.maxvol)])
				[node,elem,face]=v2m(Voxelated_image.img,isovalues,opt,options.Mesh.surf2mesh.maxvol,method);

				node=node*Voxelated_image.voxel_size(1); % Transform from voxel space to Cartesian space
				
					% FIXME: Check again the transformation from voxel space to Cartesian space above
				
				obj.Surface_mesh.Vertices=node(:,1:3);
				obj.Surface_mesh.Faces=face(:,1:3);
				
				obj.Tetrahedral_mesh.Vertices=node(:,1:3);
				obj.Tetrahedral_mesh.Faces=elem(:,1:4);
				
				obj.Voxelated_image.img=Voxelated_image.img;
				obj.Voxelated_image.voxel_size=Voxelated_image.voxel_size;
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

