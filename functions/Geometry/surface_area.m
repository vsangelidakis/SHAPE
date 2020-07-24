function [surfaceArea] = surface_area(nodes, faces)
%% Surface area of 3-D triangular (surface) mesh

% 	nodes: Nodes of surface mesh (Np,3), Np the number of nodes
%	faces: Faces of surface mesh (Nf,3), Nf the number of faces



	%% FIXME: Replace loop with @bsxfun expressions
	%%
% 	v1 = Vertices(Faces(:, 2), :) - Vertices(Faces(:, 1), :);
% 	v2 = Vertices(Faces(:, 3), :) - Vertices(Faces(:, 1), :);
% 	vecCross=bsxfun(@times, v1(:,[2 3 1],:), v2(:,[3 1 2],:)) - bsxfun(@times, v2(:,[2 3 1],:), v1(:,[3 1 2],:));
% 	vecNorm= sqrt(sum(vecCross.*vecCross,2));
% 	TriangAreas =  vecNorm/2; % this is m-by-1 matrix



	surfaceArea=0;
	for i=1:size(faces,1)

		a=nodes(faces(i,1),:)';
		b=nodes(faces(i,2),:)';
		c=nodes(faces(i,3),:)';

		n1=b-a; n2=c-a;

		areaTr=0.5*norm(cross(n1',n2'));
		surfaceArea=surfaceArea+areaTr;
	end
end