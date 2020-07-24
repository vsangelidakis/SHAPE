function MinBoundSphereDemo
%
% AUTHOR: Anton Semechko (a.semechko@gmail.com)
%

% Load sample triangular surface meshes
Meshes=load('MBS demo meshes.mat');
Fields=fieldnames(Meshes);

% Compute exact minimum bounding spheres (MBS) of the sample meshes using
% Wezlz's algorithm and visualize meshes along with their respective MBSs.
% Also compute approximate MBSs using Ritter's algorithm for comparison.
N=numel(Fields);
R=zeros(N,2);
for i=1:N
    
    % Get i-th sample mesh
    TR=getfield(Meshes,Fields{i});
    [~,X]=GetMeshData(TR); % array of vertex coordinates
    
    % Exact bounding sphere
    [R(i,1),C,Xb]=ExactMinBoundSphere3D(X); % this function also accepts surface and volumetric meshes directly  
    
    % Visualize sample mesh and its MBS
    [~]=VisualizeBoundSphere(TR,R(i,1),C,Xb);
    set(gcf,'Name',Fields{i})    
    
    % Radius of the approximate MBS
    R(i,2)=ApproxMinBoundSphereND(X);
    
end

% Compare radii of the MBSs computed with the Ritter's and Welzl's algorithms;
% the former and latter produce approximate and exact solutions, respectively
fprintf('\nApproximate (R_ap) vs exact (R_ex) min bounding sphere radii\n')
fprintf('==============================================================\n')
fprintf('%-16s%-14s%-14s%-14s\n','Object','R_ap', 'R_ex','Relative Diff.(%)')
fprintf('--------------------------------------------------------------\n')
for i=1:N
    fprintf('%-16s%-14.4f%-14.4f%-14.4f\n',Fields{i},R(i,2),R(i,1),(R(i,2)-R(i,1))/R(i,1)*100)
end
fprintf('--------------------------------------------------------------\n')

