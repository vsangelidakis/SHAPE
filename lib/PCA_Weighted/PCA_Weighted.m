function [VerT,eigVecs,eigVals,exp,wCentroid] = PCA_Weighted(Vertices ,Faces)
 
% PCA_Weighted: Perform WEIGHTED PCA on triangular mesh using the weighted
% covariance matrix and the eigenvalue decomposition algorithm. This allows to
% detect the principal axis of a 3D triangular mesh independently of the triangular
% discretization, i.e. regions with lots of small triangles will not skew the results
%
% Inputs:
%         Vertices [nx3], each row contains one vertice  x,y z coordinates
%         Faces [mx3], each row made of 3 vertices indexes
%
%Outputs:
%
%     VertT:  Transformed Vertices centred and rotated, also known as 'Scores'
%
%     eigVecs: eigenvectors of the weighted covariance matrix, can be viewed as a
%                  coordinate system or rotation matrix
%
%     eigVals: eigenvalues, also known as 'latent ‘correspond to the variance
%                 explained by each principal component.
%
%     exp: percentage of the total variance explained by each principal component
%
%     wCentroid: weighted centroid of mesh, equal to the weighted sample mean
%                     using areas of triangles as weights
%
% Usage:
%            [VerT,eigVecs,eigVals,exp,wCentroid] = PCA_Weighted(Vertices ,Faces)
%            [VerT,~,~,~,~] = PCA_Weighted(Vertices ,Faces)
%            use ~ to omit a particulare output

% Last amended::        Germano Gomes 1/06/2014.
% Created:                  Germano Gomes 2012
 
 
% check number of input arguments (minimum 2, maximum 2)

narginchk(2,2);
 
% check number of output arguments (minimum 1, maximum 5)

nargoutchk(1,5);
 
% verify that input matrices are have 3 columns and at least 2 rows

[nvert,ncol1] = size(Vertices); [nface, ncol2] = size(Faces);
if nvert  < 2 || ncol1 ~= 3 ||  nface  < 2 || ncol2 ~= 3
    error ('The input data matrices (Vertices and Faces) must have exactly three columns and at least 2 rows')
end
 
% compute the centroid for each face/triangle, store in (FacesC)

nface=length(Faces);
FacesC = [   ...
    sum(reshape(Vertices(Faces,1),[nface 3]), 2)/3, ...
    sum(reshape(Vertices(Faces,2),[nface 3]), 2)/3, ...
    sum(reshape(Vertices(Faces,3),[nface 3]), 2)/3 ];
 
[m,~]=size(FacesC); % m is the number of faces in the mesh
 
% compute areas of each face by: computing two direction vectors, using first face
% vertex as origin area of each triangle is half the cross product norm, this works
% very well in general but Heron's formula gives better results for degenerated
% triangles (see e.g.  function triangle_area found in matlab central)
 
v1 = Vertices(Faces(:, 2), :) - Vertices(Faces(:, 1), :);
v2 = Vertices(Faces(:, 3), :) - Vertices(Faces(:, 1), :);
vecCross=bsxfun(@times, v1(:,[2 3 1],:), v2(:,[3 1 2],:)) - bsxfun(@times, v2(:,[2 3 1],:), v1(:,[3 1 2],:));
vecNorm= sqrt(sum(vecCross.*vecCross,2));
TriangAreas =  vecNorm/2; % this is m-by-1 matrix
 
% Start Weighted PCA
 
Weights=TriangAreas;
 
% weighted centroid of mesh=weighted sample mean
 
wCentroid = sum(bsxfun(@times, Weights , FacesC))/sum( Weights);
 
% centering of the data by weighted mean removal (subtraction)
 
data= bsxfun(@minus, FacesC, wCentroid);
 
% calculate the WEIGHTED covariance matrix
 
data=bsxfun(@times,data,sqrt(Weights));
covariance = data' * data/(m-1); %normalized by m-1 because data is already centered.
 
% find the eigenvectors and eigenvalues
 
[eigVecsUnsorted, eigValDiag] = eig(covariance);
 
% sort the variances in decreasing order, eigVals also known as Latent
 
[eigVals, indices] = sort(diag(eigValDiag),'descend');
eigVecs = eigVecsUnsorted(:,indices);
 
% Make sure the 3 orthogonal axis follows the right hand rule using a cross
% product. Note: this is perfectly valid but somewhat arbitrary. PCA does not
% resolve axis signals(+,-) so different valid coordinates systems should (and can)
% be made, one other possible rule is to force the largest element in each column
% of eigVec to have a positive sign. I prefer to enforce the right hand system.
 
eigVecs(:,3)=cross(eigVecs(:,1),eigVecs(:,2));
 
% percentage of the total variance explained by each principal component.
 
exp = 100*eigVals/sum(eigVals);
 
% Transform the original Vertices data set by entering at [0 0 0] and rotating with
% eigVecs, the result is also known as 'Scores'.
 
VerT= bsxfun(@minus, Vertices,wCentroid)*eigVecs;

end
