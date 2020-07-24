function [R,C]=FitCircle2Points(X)
% Fit a circle to a set of 2 or at most 3 points in 3D space. Note that
% point configurations with 3 collinear points do not have well-defined 
% solutions (i.e., they lie on circles with infinite radius).
%
% INPUT:
%   - X     : M-by-2 array of point coordinates, where M<=3.
%
% OUTPUT:
%   - R     : radius of the circle. R=Inf when the circle is undefined, as 
%             specified above.
%   - C     : coordinates of the circle centroid. C=nan(1,2) when the 
%             circle is undefined, as specified above.
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%


N=size(X,1);
if N>3
    error('Input must a N-by-2 array of point coordinates, with N<=3')
end

% Empty set
if isempty(X)
    C=nan(1,2);
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
    for i=1:(N-1)
        if size(X,1)<=i, break; end
        idx=chk(i,:);
        idx(1:i)=false;
        idx=find(idx);
        chk(idx,:)=[];
        chk(:,idx)=[];
        X(idx,:)=[];
    end
    [R,C]=FitCircle2Points(X);
    return
end


% Three unique, though possibly collinear points
tol=1E-2; % collinearity threshold (in degrees)
   
% Check for collinearity
D12=X(2,:)-X(1,:); D12=D12/norm(D12);
D13=X(3,:)-X(1,:); D13=D13/norm(D13);

chk=abs(D12*D13(:));
chk(chk>1)=1;
if acos(chk)*(180/pi)<tol
    R=inf;
    C=nan(1,2);
    return
end

% Circle centroid
A=2*bsxfun(@minus,X(2:3,:),X(1,:));
b=sum(bsxfun(@minus,X(2:3,:).^2,X(1,:).^2),2);
C=(A\b)';

% Circle radius
R=sqrt(sum((X(1,:)-C).^2,2));

