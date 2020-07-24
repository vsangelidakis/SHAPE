function [cornerpoints,rotmat,volume,surface,center,dimensions]=OBB_PCA_SVD(X)

%% Function to calculate OBB using SVD/PCA, based on: https://www.mathworks.com/matlabcentral/answers/405327-reparameterize-3d-points-with-respect-to-pca-vector#answer_324419?s_tid=prof_contriblnk
% INPUT
% X: Vertices

% OUTPUT
% BB: Coordinates of OBB
% T:

%% FIXME: I don't use fv.faces

%% FIXME: Delete the covariance matrix
% pcacov

% Perform PCA on X
X_ave=mean(X,1);             % centroid
dX=bsxfun(@minus,X,X_ave);   % center the vertices
C=dX'*dX;                    % covariance matrix
[U,~]=svd(C);

%% FIXME: Delete pcacov below
% pcacov

U(:,3)=cross(U(:,1),U(:,2)); % make sure there is no reflection

% Transformation that aligns centroid of X with the origin and its
% principal axes with Cartesian basis vectors
T1=eye(4); T1(1:3,4)=-X_ave(:);
T2=eye(4); T2(1:3,1:3)=U';
T=T2*T1;

% Apply T to X to get Y
Y=X;
Y(:,4)=1;
Y=(T*Y')';
Y(:,4)=[];

% PCA-based bounding box (for better visualization)
BBo=unit_cube;
L=max(Y)-min(Y);

V=bsxfun(@times,L,BBo.vertices);
V=bsxfun(@plus,V,min(Y));
BBo.vertices=V; % BB around Y

V(:,4)=1;
V=(T\V')';
V(:,4)=[];
BB=BBo;
BB.vertices=V; % BB around X; same as BBo but rotated and translated


%% FIXME: Verify whether I need to save BB or BBo!!


v1=V(1,:); v2=V(2,:); v4=V(4,:); v5=V(5,:); % Isolate vertices used to calculate dimensions of OBB
edgeX=v2-v1; edgeY=v4-v1; edgeZ=v5-v1;
R=[edgeX'/norm(edgeX), edgeY'/norm(edgeY), edgeZ'/norm(edgeZ)]; % Each column represents a unit vector of the box
D=[norm(edgeX),norm(edgeY),norm(edgeZ)];

[S_obb, ind_S] = min(D); D(ind_S)=-1;
[L_obb, ind_L] = max(D);
ind_I=6 - ind_S - ind_L;
I_obb = D(ind_I);

cornerpoints=V;
rotmat=[R(:,ind_S), R(:,ind_I), R(:,ind_L)]; % Sorted unit vectors, following the order of S, I, L axes
volume=prod([S_obb, I_obb, L_obb]);
surface=2*(S_obb*I_obb+S_obb*L_obb+I_obb*L_obb);
center=mean(cornerpoints);
dimensions=[S_obb, I_obb, L_obb];


% % Visualize X and Y
% figure('color','w')
% 
% % subplot(1,2,1)
% plot3(X(:,1),X(:,2),X(:,3),'.k','MarkerSize',20) % MarkerSize, 1
% axis equal
% set(get(gca,'Title'),'String','Original Point Cloud','FontSize',20)
% view([20 20])
% hold on
% h=patch(BB);
% set(h,'FaceColor','b','FaceAlpha',0.25,'EdgeColor','r')

% subplot(1,2,2)
% plot3(Y(:,1),Y(:,2),Y(:,3),'.k','MarkerSize',20)
% axis equal
% set(get(gca,'Title'),'String','After PCA Normalization','FontSize',20)
% view([20 20])
% hold on
% h=patch(BBo);
% set(h,'FaceColor','b','FaceAlpha',0.25,'EdgeColor','r')
% % end

end

% Edges are made by vertices:
% 1 2 x
% 1 4 y
% 1 5 z

function fv=unit_cube
% Create axis-aligned unit cube
fv.vertices=[ 0 0 0; 1 0 0; 1 1 0; 0 1 0;
			  0 0 1; 1 0 1; 1 1 1; 0 1 1 ];

fv.faces=[ 1 4 3 2; 5 6 7 8; 2 3 7 6;	
		   3 4 8 7; 1 5 8 4; 1 2 6 5 ];
end