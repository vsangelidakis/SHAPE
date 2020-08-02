function [R,C]=ApproxMinBoundSphereND(X)
% Find a near-optimal bounding sphere for a set of M points in 
% N-dimensional space using Ritter's algorithm. In 3D, the resulting sphere
% is approximately 5% bigger than the ideal minimum radius sphere.
%
% INPUT:
%   - X     : M-by-N array of point coordinates, where N>1 and M is the
%             number of point samples
%
% OUTPUT:
%   - R     : radius of the bounding sphere
%   - C     : centroid of the bounding sphere
%
% REFERENCES:
% [1] Ritter, J. (1990), 'An efficient bounding sphere', in Graphics Gems,
%     A. Glassner, Ed. Academic Press, pp.301�303
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%


% Basic error checking
if nargin<1 || ~ismatrix(X) || size(X,2)<2
    error('Invalid entry for 1st input argument (X)')
end

if size(X,1)==1
    R=0; C=X;
    return
elseif size(X,1)>2
    % standardize point cloud orientation
    dX=bsxfun(@minus,X,mean(X,2));
    [U,~,~]=svd(dX'*dX);
    U(:,3)=cross(U(:,1),U(:,2));
    X=X*U;
end
    
% Convex hull of the point set
F=convhull(X);
F=unique(F(:));
X=X(F,:);

% Find points with the most extreme coordinates
[~,idx_min]=min(X,[],1);
[~,idx_max]=max(X,[],1);

Xmin=X(idx_min(:),:);
Xmax=X(idx_max(:),:);

% Compute distances between bounding-box vertices
X1=permute(Xmin,[1 3 2]);
X2=permute(Xmax,[3 1 2]);
D2=bsxfun(@minus,X2,X1);
D2=sum(D2.^2,3);

% Select point pair with the largest distance
[D2_max,idx]=max(D2(:));
[i,j]=ind2sub(size(D2),idx);
Xmin=Xmin(i,:);
Xmax=Xmax(j,:);

% Initial radius (squared) and centroid
R2=D2_max/4;
R=sqrt(R2);
C=(Xmin+Xmax)/2;

% Loop through the M points, adjusting position and radius of the sphere
M=size(X,1);
for i=1:M
    
    di2=sum((X(i,:)-C).^2);
    if di2>R2
        di=sqrt(di2);
        R=(R+di)/2;
        R2=R^2;
        dR=di-R;
        C=(R*C+dR*X(i,:))/di;
    end
    
end

