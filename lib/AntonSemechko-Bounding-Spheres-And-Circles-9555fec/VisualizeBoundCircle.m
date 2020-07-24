function H=VisualizeBoundCircle(X,R,C,ha)
% Visualize a 3D point cloud and its bounding circle.
%
% INPUT:
%   - X     : M-by-2 list of point co-ordinates 
%   - R     : radius of the circle
%   - C     : 1-by-3 vector specifying the centroid of the circle
%   - ha    : handle of the axis where bounding circle is to be visualized 
%             (optional).
%
% OUTPUT:
%   - H     : 1-by-2 vector containing handles for the following objects: 
%               H(1)    : handle of the point cloud
%               H(2)    : handle for the circle
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%

if nargin<2 || isempty(R) || isempty(C)
    [R,C]=ExactMinBoundCircle(X);
end

% Construct bounding circle
t=linspace(0,2*pi,1E3);
x=R*cos(t)+C(1);
y=R*sin(t)+C(2);

% Visualize point cloud
if nargin<4 || isempty(ha) || numel(ha)>1 || ~ishandle(ha) || ~strcmp(get(ha,'type'),'axes')
    figure('color','w')
else
    axes(ha)
end

H=zeros(1,2);
H(1)=plot(X(:,1),X(:,2),'.b','MarkerSize',15);
hold on

% Visualize bounding circle
H(2)=plot(x,y,'--k','LineWidth',1);
axis equal off tight 
