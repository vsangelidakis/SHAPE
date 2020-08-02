function [R,C]=FitSphere2Points(X)
% Fit a sphere to a set of 2, 3, or at most 4 points in 3-space. Note that
% point configurations with 3 collinear or 4 coplanar points do not have 
% well-defined solutions (i.e., they lie on spheres with infinite radius).
%
% INPUT:
%   - X     : N-by-3 array of point coordinates, where 2<=N<=4.
%
% OUTPUT:
%   - R     : radius of the sphere. R=Inf when the sphere is undefined;
%             because points in X are either coplanar or collinear. 
%   - C     : 1-by-3 vector containing coordinates of sphere's centroid. 
%             C=nan(1,3) when the sphere is undefined.
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%


N=size(X,1);
if N>4 
    error('Input must a N-by-3 array of point coordinates; 2<=N<=4')
end

% Empty set
if isempty(X)
    C=nan(1,3);
    R=nan; 
    return
end

% A single point
if N==1
    C=X;
    R=0;
    return
end

% Line segment
if N==2
    C=mean(X,1);
    R=norm(X(2,:)-X(1,:))/2;
    return
end

% Remove duplicate vertices, if there are any
D=bsxfun(@minus,permute(X,[1 3 2]),permute(X,[3 1 2]));
D=sqrt(sum(D.^2,3));
D(1:(N+1):end)=Inf;
chk=D<=1E-12;
if sum(chk(:))>0
    for i=1:N
        if size(X,1)<=i, break; end
        idx=chk(i,:);
        idx(1:i)=false;
        idx=find(idx);
        chk(idx,:)=[];
        chk(:,idx)=[];
        X(idx,:)=[];
    end
    [R,C]=FitSphere2Points(X);
    return
end


% Three unique, though possibly collinear points
tol=1E-2; % collinearity/coplanarity threshold (in degrees)
if N==3
   
    % Check for collinearity
    D12=X(2,:)-X(1,:); D12=D12/norm(D12);
    D13=X(3,:)-X(1,:); D13=D13/norm(D13);

    chk=abs(D12*D13(:));
    chk(chk>1)=1;
    if acos(chk)/pi*180<tol
        R=inf;
        C=nan(1,3);
        return
    end
    
    % Make plane formed by the points parallel with the xy-plane  
    n=cross(D13,D12);
    n=n/norm(n);
    r=cross(n,[0 0 1]); r=acos(n(3))*r/norm(r); % Euler rotation vector
    Rmat=expm([0 -r(3) r(2); r(3) 0 -r(1); -r(2) r(1) 0]);
    Xr=(Rmat*X')'; 
        
    % Circle centroid
    x=Xr(:,1:2);
    A=2*bsxfun(@minus,x(2:3,:),x(1,:));
    b=sum(bsxfun(@minus,x(2:3,:).^2,x(1,:).^2),2);
    C=(A\b)';
    
    % Circle radius
    R=sqrt(sum((x(1,:)-C).^2,2));     
    
    % Rotate centroid back into the original frame of reference
    C(3)=mean(Xr(:,3));
    C=(Rmat'*C(:))';
    return
end


% If we got to this point then we have 4 unique, though possibly collinear
% or coplanar points. 

% Check if the the points are collinear
D12=X(2,:)-X(1,:); D12=D12/norm(D12);
D13=X(3,:)-X(1,:); D13=D13/norm(D13);
D14=X(4,:)-X(1,:); D14=D14/norm(D14);

chk1=abs(D12*D13(:));
chk1(chk1>1)=1;
chk2=abs(D12*D14(:));
chk2(chk2>1)=1;

if acos(chk1)/pi*180<tol || acos(chk2)/pi*180<tol
    R=inf;
    C=nan(1,3);
    return
end

% Check if the the points are coplanar
n1=cross(D12,D13); n1=norm(n1);
n2=cross(D12,D14); n2=norm(n2);

chk=abs(n1*n2(:));
chk(chk>1)=1;
if acos(chk)/pi*180<tol
    R=inf;
    C=nan(1,3);
    return
end

% Centroid of the sphere
A=2*bsxfun(@minus,X(2:end,:),X(1,:));
b=sum(bsxfun(@minus,X(2:end,:).^2,X(1,:).^2),2);
C=(A\b)';

% Radius of the sphere
R=sqrt(sum((X(1,:)-C).^2,2));

