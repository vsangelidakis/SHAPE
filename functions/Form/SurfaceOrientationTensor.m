function [C, F, R, eigenValues, eigenVectors] = SurfaceOrientationTensor(nodes, faces)

% Surface orientation tensor as introduced by Bagi & Orosz (2020)
%% INPUT
% 	nodes: Nodes of surface mesh (Np,3), Np the number of nodes
%	faces: Faces of surface mesh (Nf,3), Nf the number of faces

%% OUTPUT
% C: Compactness (or equancy)
% F: Flakiness (or flatness or platyness)
% R: Rodness (or elongation)

facesNo=size(faces,1); % Number of faces

n=zeros(facesNo,3);
Area=zeros(facesNo,1);
for i=1:size(faces,1)
	A=nodes(faces(i,1),:);
	B=nodes(faces(i,2),:);
	C=nodes(faces(i,3),:);
	
	e_AB=B-A;
	e_BC=C-B;

	
	v=cross(e_AB,e_BC); % normal vector
	Area(i)=0.5*norm(v);
	n(i,1:3)=v/norm(v); % normal vectors (normalised)
end

%% Surface orientation tensor
f=zeros(3);
for k=1:facesNo
	f = f + Area(k)*(n(k,:)'*n(k,:)); % Outer product
end
f=f/sum(Area); % Normalise to the total surface area

%% Eigenvalues & Shape indices
[vectors,eigen]=eig(f,'vector');
[eigenValues,index]=sort(eigen,'descend'); % Sort eigenvalues in descending order

f1=eigenValues(1); % Largest eigenvalue
f2=eigenValues(2); % Intermediate eigenvalue
f3=eigenValues(3); % Smallest eigenvalue

eigenVectors=[vectors(:,index(1)),vectors(:,index(2)),vectors(:,index(3))]; % Sort eigenVectors

%% Compactness - Flakiness - Rodness
C =      f3/f1;	% Compactness
F = (f1-f2)/f1; % Flakiness
R = (f2-f3)/f1; % Rodness

end