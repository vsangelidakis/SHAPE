function [volume, centroid, current_inertia_tensor, inertia_tensor, principalOrientations] = volume_centroid_inertiaTensor(nodes, elements, calculateInertia)
%% Volume, centroid, current inertia tensor and principal inertia tensor and orientations of 3-D tetrahedral mesh

%% INPUT
% 	nodes:    Vertices of tetrahedral mesh (Nv,3), Nv the number of vertices
%	elements: Elements of tetrahedral mesh (Ne,4), Ne the number of elements
%	calculateInertia: Whether to calculate the principal inertia tensor and	orientations (boolean)

	%%
	%% FIXME: Should I define Np, Ne here? 
	%% FIXME: Replace loop with @bsxfun expressions
	%%


	%% Calculation of "Centroid" & "Volume"
	volume=0;
	vx=0; vy=0; vz=0;

	v=zeros(1,size(elements,1));
	xcm = zeros(1,size(elements,1));
	ycm = zeros(1,size(elements,1));
	zcm = zeros(1,size(elements,1));
	
	for i=1:size(elements,1)
        a=nodes(elements(i,1),:)';
        b=nodes(elements(i,2),:)';
        c=nodes(elements(i,3),:)';
        d=nodes(elements(i,4),:)';

        v(i)=abs((1/6)*det([a-d, b-d, c-d]));
        volume=volume+v(i);

        xcm(i) = mean([a(1),b(1),c(1),d(1)]);
        ycm(i) = mean([a(2),b(2),c(2),d(2)]);
        zcm(i) = mean([a(3),b(3),c(3),d(3)]);

        vx=vx+v(i)* xcm(i);
        vy=vy+v(i)* ycm(i);
        vz=vz+v(i)* zcm(i);
	end
	
    %% centroid=[x,y,z] the centroid of the polyhedron
    x=vx/volume;
    y=vy/volume;
    z=vz/volume;
	centroid=[x,y,z];
	
	if calculateInertia==false
		inertia_tensor=zeros(3);
		principalOrientations=zeros(3);
	else
		%% Centering of the particle to its centroid to calculate inertia tensor
		nodes(:,1)=nodes(:,1)-x;
		nodes(:,2)=nodes(:,2)-y;
		nodes(:,3)=nodes(:,3)-z;

% 		P1=nodes;

		%% Calculation of Inertia Tensor to the Centroid of the Particle

		Ixx = zeros(1,size(elements,1));
		Iyy = zeros(1,size(elements,1));
		Izz = zeros(1,size(elements,1));
		Ixy = zeros(1,size(elements,1));
		Ixz = zeros(1,size(elements,1));
		Iyz = zeros(1,size(elements,1));	

		for i=1:length(elements)
			a=nodes(elements(i,1),:)';
			b=nodes(elements(i,2),:)';
			c=nodes(elements(i,3),:)';
			d=nodes(elements(i,4),:)';

			x1=a(1); y1=a(2); z1=a(3);
			x2=b(1); y2=b(2); z2=b(3);
			x3=c(1); y3=c(2); z3=c(3);
			x4=d(1); y4=d(2); z4=d(3);

			% Inertia tensor to the centroid of each tetrahedron (Tonon, 2005)
			% a
			Ixx(i)=6*v(i)*(  y1^2 + y1*y2 + y2^2 + y1*y3 + y2*y3 +...
						  + y3^2 + y1*y4 + y2*y4 + y3*y4 + y4^2 + z1^2 + z1*z2+...
						  + z2^2 + z1*z3 + z2*z3 + z3^2 + z1*z4 + z2*z4 + z3*z4 + z4^2)/60;
			% b
			Iyy(i)=6*v(i)*(  x1^2 + x1*x2 + x2^2 + x1*x3 + x2*x3 +...
						  + x3^2 + x1*x4 + x2*x4 + x3*x4 + x4^2 + z1^2 + z1*z2+...
						  + z2^2 + z1*z3 + z2*z3 + z3^2 + z1*z4 + z2*z4 + z3*z4 + z4^2)/60;
			% c
			Izz(i)=6*v(i)*(  x1^2 + x1*x2 + x2^2 + x1*x3 + x2*x3 +...
						  + x3^2 + x1*x4 + x2*x4 + x3*x4 + x4^2 + y1^2 + y1*y2 +...
						  + y2^2 + y1*y3 + y2*y3 + y3^2 + y1*y4 + y2*y4 + y3*y4 + y4^2)/60;
			% a'
			Iyz(i)=6*v(i)*(  2*y1*z1 + y2*z1 + y3*z1 + y4*z1 + y1*z2 +...
						  + 2*y2*z2 + y3*z2 + y4*z2 + y1*z3 + y2*z3 + 2*y3*z3+... 
						  +   y4*z3 + y1*z4 + y2*z4 + y3*z4 + 2*y4*z4)/120;
			% c'
			Ixy(i)=6*v(i)*(  2*x1*y1 + x2*y1 + x3*y1 + x4*y1 + x1*y2 +...
						  + 2*x2*y2 + x3*y2 + x4*y2 + x1*y3 + x2*y3 + 2*x3*y3+... 
						  +   x4*y3 + x1*y4 + x2*y4 + x3*y4 + 2*x4*y4)/120;
			% b'
			Ixz(i)=6*v(i)*(  2*x1*z1 + x2*z1 + x3*z1 + x4*z1 + x1*z2 +...
						  + 2*x2*z2 + x3*z2 + x4*z2 + x1*z3 + x2*z3 + 2*x3*z3+... 
						  +   x4*z3 + x1*z4 + x2*z4 + x3*z4 + 2*x4*z4)/120;
	%                      clear a b c d 
		end

		%Inertia tensor of the particle to the Origin(1st Steiner)
		Ixx_final=0; for i=1:length(elements), Ixx_final=Ixx_final+Ixx(i); end
		Iyy_final=0; for i=1:length(elements), Iyy_final=Iyy_final+Iyy(i); end
		Izz_final=0; for i=1:length(elements), Izz_final=Izz_final+Izz(i); end

		Iyz_final=0; for i=1:length(elements), Iyz_final=Iyz_final+Iyz(i); end
		Ixy_final=0; for i=1:length(elements), Ixy_final=Ixy_final+Ixy(i); end
		Ixz_final=0; for i=1:length(elements), Ixz_final=Ixz_final+Ixz(i); end

		current_inertia_tensor=[  Ixx_final -Ixy_final -Ixz_final
								 -Ixy_final  Iyy_final -Iyz_final
								 -Ixz_final -Iyz_final  Izz_final];

		 %% Principal Inertia Tensor & New axis system
		 % when the principal inertia tensor has been already calculated.
			[principalOrientations,inertia_tensor]=eig(current_inertia_tensor); % Principal Moments of Inertia: Eigenvalues
	%		P1=P1*DirP; % Rotation of the vertices to the Principal Directions: Eigenvectors
	
end