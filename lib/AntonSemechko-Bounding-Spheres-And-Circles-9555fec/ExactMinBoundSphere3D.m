function [R,C,Xb]=ExactMinBoundSphere3D(X)
% Compute exact minimum bounding sphere of a 3D point cloud (or a 
% triangular surface mesh) using Welzl's algorithm [1]. 
%
% INPUT:
%   - X     : M-by-3 list of point co-ordinates OR a triangular surface 
%             mesh specified as a (i) 'TriRep' object, (ii) 'triangulation'
%             object, (iii) 1-by-2 cell such that TR={Tri,V}, where Tri is
%             an M-by-3 array of faces and V is an N-by-3 array of vertex
%             coordinates, (iv) structure with 'faces' and 'vertices'
%             fields, such as the one returned by the 'isosurface'
%             function.
%
% OUTPUT:
%   - R     : radius of the minimum bounding sphere of X.
%   - C     : 1-by-3 vector specifying centroid co-ordinates of the 
%             minimum bounding sphere of X.
%   - Xb    : K-by-3 array of point co-ordinates from which R and C were 
%             computed; 2<=K<=4. Xb is a subset of X. See function 
%             'FitSphere2Points' for more info.
%
% REREFERENCES:
% [1] Welzl, E. (1991), 'Smallest enclosing disks (balls and ellipsoids)',
%     Lecture Notes in Computer Science, Vol. 555, pp. 359-370
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%


if isnumeric(X) && ismatrix(X)
    if sum(~isfinite(X(:)))>0
        error('Point coordinates contain NaN or Inf entries. Remove them and try again.')
    elseif size(X,2)~=3
       error('This function works only for 3D data') 
    end    
else
    try
        % Input may be a mesh
        [~,X]=GetMeshData(X);
        if size(X,2)==2
            [R,C,Xb]=ExactMinBoundCircle(X);
            return
        end
    catch
        error('Invalid format for 1st input argument (X)')
    end    
end


% Get minimum bounding sphere
% -------------------------------------------------------------------------

if size(X,1)>3
    
    % Check points for co-planarity 
    Xo=mean(X,1);
    dX=bsxfun(@minus,X,Xo);
    [U,D]=svd((dX'*dX)/size(X,1),0);
    D=diag(D);
    if D(3)<1E-15
        [R,C,Xb]=ExactMinBoundCircle(dX*U(:,1:2));
        C=(U(:,1:2)*C')'+Xo;
        Xb=bsxfun(@plus,(U(:,1:2)*Xb')',Xo);
        return
    end
    
    % Get convex hull of the point set
    F=convhull(X);
    F=unique(F(:));
    X=X(F,:);

end

try
    % Remove duplicates
    X=uniquetol(X,eps,'ByRows',true);
catch
    % older version of Matlab; 'uniquetol' is unavailable
end

if size(X,1)<4
    [R,C]=FitSphere2Points(X); 
    Xb=X;
    return
end

% Randomly permute the point set
idx=randperm(size(X,1));
X=X(idx(:),:);
if size(X,1)<1E3
    try
        
        % Center and radius of the sphere
        [R,C]=B_MinSphere(X,[]);
        
        % Coordinates of the points used to compute parameters of the 
        % minimum bounding sphere
        D=sum(bsxfun(@minus,X,C).^2,2);
        [D,idx]=sort(abs(D-R^2));
        Xb=X(idx(1:4),:);
        D=D(1:4);
        Xb=Xb(D/R*100<1E-3,:);
        [~,idx]=sort(Xb(:,1));
        Xb=Xb(idx,:);
        return

    catch
    end
end
    
% If we got to this point, then either size(X,1)>=1E3 or recursion depth 
% limit was reached. So need to break-up point-set into smaller sets and
% then recombine the results.
M=size(X,1);
dM=max(min(floor(M/4),300),4);
res=mod(M,dM);
n=ceil(M/dM);  
idx=dM*ones(1,n);
if res>0, idx(end)=res; end
 
if res<0.25*dM && res>0
    idx(n-1)=idx(n-1)+idx(n);
    idx(n)=[];
    n=n-1;
end

X=mat2cell(X,idx,3);
Xb=[];
for i=1:n
    
    % Center and radius of the sphere
    [R,C,Xi]=B_MinSphere([Xb;X{i}],[]);    
    
    % 40 points closest to the sphere
    if i<n
        D=abs(sum(bsxfun(@minus,Xi,C).^2,2)-R^2);
    else
        D=abs(sqrt(sum(bsxfun(@minus,Xi,C).^2,2))-R);
    end
    [D,idx]=sort(D);
    Xb=Xi(idx(1:min(40,numel(D))),:);
    
end

% Points on the bounding sphere
D=D(1:min(40,numel(D)));
Xb=Xb(D/R*100<1E-3,:);
if size(Xb,1)>4,Xb=Xb(1:4,:); end
[~,idx]=sort(Xb(:,1));
Xb=Xb(idx,:);


    function [R,C,P]=B_MinSphere(P,B)
        
    if size(B,1)==4 || isempty(P)
        [R,C]=FitSphere2Points(B); % fit sphere to boundary points (B)
        return
    end
    
    % Remove the last (i.e., end) point, p, from the P list
    P_new=P;
    P_new(end,:)=[];
    p=P(end,:);
        
    % Check if p is on or inside the bounding sphere. If not, it must be
    % part of the new boundary.
    [R,C,P_new]=B_MinSphere(P_new,B); 
    if isnan(R) || isinf(R) || R<=eps
        chk=true;
    else
        chk=norm(p-C)>(R+eps);
    end
    
    if chk
        B=[p;B];
        [R,C]=B_MinSphere(P_new,B);
        P=[p;P_new];
    end
        
    end

end

