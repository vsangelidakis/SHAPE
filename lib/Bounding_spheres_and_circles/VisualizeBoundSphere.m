function H=VisualizeBoundSphere(X,R,C,Xb,ha)
% Visualize a point cloud (or a triangular surface mesh) and its minimum 
% bounding sphere (MBS).
%
% INPUT:
%   - X     : M-by-3 list of point coordinates or a triangular surface mesh
%             specified as a TriRep object.
%   - R     : radius of the sphere.
%   - C     : 1-by-3 vector specifying the centroid of the sphere.
%   - Xb    : K-by-3 array of points coordinates from which R and C were 
%             derived; 2<=K<=4. This argument is optional.
%   - ha    : handle of the axis where MBS is to be visualized (optional).
%
% OUTPUT:
%   - H     : 1-by-8 vector containing handles for the following objects: 
%               H(1)    : point cloud/mesh 
%               H(2)    : sphere
%               H(3:5)  : great circles 
%               H(6:7)  : lights used to illuminate the scene 
%               H(8)    : points used to obtain parameters of the MBS
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%


Tri=[];
if isnumeric(X) && ismatrix(X)
    if sum(isnan(X(:)) | isinf(X(:)))>0
        error('Point coordinates contain NaN or Inf entries. Remove them and try again.')
    elseif size(X,2)~=3
       error('This function works only for 3D data') 
    end    
else
    try
        [Tri,X]=GetMeshData(X);
    catch
        error('Invalid format for 1st input argument (X)')
    end    
end

if nargin<4
    Xb=[];
elseif ~isnumeric(Xb) || ~ismatrix(Xb) || size(Xb,2)~=3 || size(Xb,1)>4
    error('Invalid format for 4th input argument (Xb)')
end
    
if nargin<2 || isempty(R) || isempty(C)
    [R,C,Xb]=ExactMinBoundSphere3D(X);
end

% Generate a spherical mesh
tr=SubdivideSphericalMesh(IcosahedronMesh,4);
tr=triangulation(tr.ConnectivityList,bsxfun(@plus,R*tr.Points,C));

% Construct great circles 
t=linspace(0,2*pi,1E3);
x=R*cos(t);
y=R*sin(t);

[GC1,GC2,GC3]=deal(zeros(1E3,3));

GC1(:,1)=x; GC1(:,2)=y; % xy-plane
GC2(:,1)=y; GC2(:,3)=x; % zx-plane
GC3(:,2)=x; GC3(:,3)=y; % yz-plane

GC1=bsxfun(@plus,GC1,C);
GC2=bsxfun(@plus,GC2,C);
GC3=bsxfun(@plus,GC3,C);

% Visualize sample point cloud/mesh
if nargin<5 || isempty(ha) || numel(ha)>1 || ~ishandle(ha) || ~strcmp(get(ha,'type'),'axes')
    figure('color','w')
else
    axes(ha)
end
axis equal off
hold on

H=zeros(1,8); H(8)=nan;
if isempty(Tri) || size(Tri,2)~=3
    H(1)=plot3(X(:,1),X(:,2),X(:,3),'.k','MarkerSize',20);
else    
    H(1)=trimesh(triangulation(Tri,X));
    set(H(1),'EdgeColor','none','FaceColor',0.75*[1 1 1])
end

% Visualize bounding sphere and great circles
H(2)=trimesh(tr);
set(H(2),'EdgeColor','none','FaceColor',[0.85,0.33,0.10],'FaceAlpha',0.2)
H(3)=plot3(GC1(:,1),GC1(:,2),GC1(:,3),'-k','LineWidth',1.5);
H(4)=plot3(GC2(:,1),GC2(:,2),GC2(:,3),'-k','LineWidth',1.5);
H(5)=plot3(GC3(:,1),GC3(:,2),GC3(:,3),'-k','LineWidth',1.5);
axis tight vis3d
set(gca,'visible','on')
% Add some lighting
h1=light;
set(h1,'style','infinite','position',10*get(h1,'position'))
h2=light('position',-get(h1,'position'));
set(h2,'style','infinite')
lighting phong
H(6:7)=[h1 h2];

% Points on the sphere
if ~isempty(Xb)
    H(8)=plot3(Xb(:,1),Xb(:,2),Xb(:,3),'.b','MarkerSize',30);
end
drawnow
pause(0.1)

if nargout<1, clear H; end

