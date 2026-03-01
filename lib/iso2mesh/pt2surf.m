function varargout = pt2surf(p, thresh)
%
% [tri, vertices, tnorm] = ptcrust(p, thresh)
%
% Improved CRUST algorithm for reconstruction of 3D surface from a set of
% 3D points
%
% This function was improved by Qianqian Fang <q.fang at neu.edu> based on
% the MyCrust.m script written by Giaccari Luigi <giaccariluigi at msn.com>
% https://www.mathworks.com/matlabcentral/fileexchange/63730-surface-reconstruction-from-scattered-points-cloud
%
% input:
%   p      - Nx3 array of 3D points
%   thresh - (optional) Circumradius threshold multiplier (default: 3.0)
%            Triangles with circumradius > thresh*median(r) are removed
%
% output:
%   t        - Mx3 triangle indices
%   vertices - Kx3 vertex coordinates
%   tnorm    - Mx3 outward-pointing normals
%
% New features:
% - automatically detecting 2D point cloud and apply 2D triangulation
% - removing slivers by computing and thresholding circumcircle's radii
% -
%
% Original notes from MyCrust.m:
%
% Version of my Crust that performs the manifold extraction in order to have
% a regular surface. This algorithm uses the ball pivoting method to extract
% the manifold and return  outwards normals orientation.
%
% The more points there are the best the surface will be fitted, although
% you will have to wait more. For very large models an help memory errors
% may occurs. It is important even the point distribution, generally
% uniformly distributed points with denser zones in high curvature features
% give the best results.
%
% Remember  crust algorithom needs a cloud representing a VOLUME so open
% surface may give inaccurate results.  Surface with small holes are not
% considered open surface and generally are processed well.
%

if nargin < 2
    thresh = 3.0;
end

p = unique(p, 'rows', 'stable');

% Quick planarity check
S = svd((p - mean(p, 1))', 'econ');
variances = diag(S).^2 / sum(diag(S).^2);

if variances(3) < 1e-6
    % Co-planar - use simple 2D method
    [varargout{1:nargout}] = triangulate2DRobust(p, thresh);
else
    % 3D - use full crust algorithm
    [varargout{1:nargout}] = crust3d(p, thresh);
end

function [tri, vertices, tnorm] = triangulate2DRobust(p, thresh)
% triangulation of 2D point cloud

% Step 1: Clean input
n = size(p, 1);

if n < 3
    error('Need at least 3 unique points for triangulation');
end

% Step 2: Find best-fit plane
centroid = mean(p, 1);
p_centered = p - centroid;

% Use more robust covariance method
cov_mat = (p_centered' * p_centered) / n;
[U, S] = eig(cov_mat);
[Ssorted, order] = sort(diag(S), 'descend');
U = U(:, order);
S = S(order, order);

% Step 3: Project to 2D
p_2d = p_centered * U(:, 1:2);

% Check projection quality (replace range with max-min)
range_2d = [max(p_2d(:, 1)) - min(p_2d(:, 1)), ...
            max(p_2d(:, 2)) - min(p_2d(:, 2))];

% Normalize to avoid numerical issues
scale = max(range_2d);
if scale < eps
    error('Points are collinear or coincident');
end
p_2d_normalized = p_2d / scale;

% Step 4: Remove near-duplicate points in 2D
tol_2d = 1e-10;

% Replace uniquetol with manual implementation if needed
if exist('uniquetol', 'file')
    p_2d_unique = uniquetol(p_2d_normalized, tol_2d, 'ByRows', true);
else
    % Manual uniquetol implementation
    p_2d_sorted = sortrows(p_2d_normalized);
    diff_rows = sum(abs(diff(p_2d_sorted, 1, 1)), 2) > tol_2d;
    keep_idx = [true; diff_rows];
    p_2d_unique = p_2d_sorted(keep_idx, :);
end

if size(p_2d_unique, 1) < 3
    error('Less than 3 unique points in 2D projection');
end

% Step 5: 2D Delaunay with error handling
tri_2d = [];
attempts = 0;
max_attempts = 3;

while isempty(tri_2d) && attempts < max_attempts
    attempts = attempts + 1;

    try
        if attempts == 1
            % First attempt: direct
            tri_2d = delaunay(p_2d_unique(:, 1), p_2d_unique(:, 2));
        elseif attempts == 2
            % Second attempt: small perturbation
            perturb = randn(size(p_2d_unique)) * 1e-8;
            tri_2d = delaunay(p_2d_unique(:, 1) + perturb(:, 1), ...
                              p_2d_unique(:, 2) + perturb(:, 2));
        else
            % Third attempt: larger perturbation
            perturb = randn(size(p_2d_unique)) * 1e-6;
            tri_2d = delaunay(p_2d_unique(:, 1) + perturb(:, 1), ...
                              p_2d_unique(:, 2) + perturb(:, 2));
        end
    catch ME
        fprintf('  Failed: %s\n', ME.message);
        tri_2d = [];
    end
end

if isempty(tri_2d)
    error('Could not compute 2D Delaunay triangulation');
end

% Step 6: Map back to original 3D indices
% Find which original points correspond to unique 2D points
orig_idx = zeros(size(p_2d_unique, 1), 1);
for i = 1:size(p_2d_unique, 1)
    % Find closest match in normalized space
    dists = sum((p_2d_normalized - p_2d_unique(i, :)).^2, 2);
    [mindist, orig_idx(i)] = min(dists);
end

tri = orig_idx(tri_2d);

% Step 7: Filter by circumradius (optional)
if thresh > 0 && thresh < inf
    r = circumradius(p, tri);
    median_r = median(r);

    % Adaptive threshold: don't remove more than 50% of triangles
    max_removable = floor(0.5 * length(r));
    sorted_r = sort(r);
    adaptive_thresh = min(thresh * median_r, sorted_r(end - max_removable));

    valid = r <= adaptive_thresh;
    n_removed = sum(~valid);

    if n_removed > 0
        tri = tri(valid, :);
    end
end

if isempty(tri)
    error('No triangles remain after filtering');
end

% Step 8: Compute and orient normals
tnorm = surfacenorm(p, tri);

% Orient consistently with plane normal
plane_normal = U(:, 3)';
flip_mask = sum(tnorm .* plane_normal, 2) < 0;
tnorm(flip_mask, :) = -tnorm(flip_mask, :);
tri(flip_mask, :) = tri(flip_mask, [1, 3, 2]);

vertices = p;

%% crust algorithm

function [t, vertices, tnorm] = crust3d(p, thresh)
% crust3d - Surface reconstruction using Crust algorithm

if nargin < 2
    thresh = 3.0;
end

if size(p, 2) ~= 3
    error('Input must be Nx3 array of 3D points');
end

n_original = size(p, 1);

% Add shield points
[p_aug, nshield] = addShield(double(p));

% Delaunay tetrahedralization
% elem = delaunayn(p_aug);
[p_aug, elem] = s2m(p_aug, convhull(p_aug), 1, 1000, 'tetgen', [], [], '-YYA');
elem = int32(elem(:, 1:4));

% Build connectivity
[face2elem, elem2face, t] = buildConnectivity(elem);

% Compute circumcenters and radii
[r, cc] = circumradius(p_aug, elem);

% Mark inside/outside tetrahedra
tbound = markTetrahedra(p_aug, elem, elem2face, face2elem, cc, r, nshield);

% Extract boundary triangles
t = t(tbound, :);

if size(t, 1) == 0
    warning('No boundary triangles found!');
    tnorm = [];
    vertices = p;
    return
end

% Manifold extraction (on augmented points)
[t, tnorm] = extractManifold(t, p_aug);

if size(t, 1) == 0
    warning('No triangles after manifold extraction!');
    vertices = p;
    return
end

% NOW: Filter by circumradius BEFORE removing shield points
% This matches the original MyRobustCrust order
if thresh > 0 && thresh < inf
    [t, tnorm] = filterByCircumradius(t, tnorm, p_aug, thresh);
end

if size(t, 1) == 0
    warning('No triangles after filtering!');
    vertices = p;
    return
end

% Remove shield points and remap to original point cloud
[t, vertices] = remapToOriginal(t, p_aug, n_original);

% Recompute normals after remapping
if (nargout > 1 && ~isempty(t))
    tnorm = surfacenorm(vertices, t);
end

%% Remap to Original Points
function [t, vertices] = remapToOriginal(t, p_aug, n_original)
% Remove triangles referencing shield points and remap to original points

% Keep only triangles with all vertices in original point set
valid_tri = all(t <= n_original, 2);
t = t(valid_tri, :);

if isempty(t)
    vertices = p_aug(1:n_original, :);
    return
end

[vertices, t] = removeisolatednode(p_aug, t);

%% Add Shield Points
function [pnew, nshield] = addShield(p)
% Identical to original
bbox_min = min(p);
bbox_max = max(p);
step = max(bbox_max - bbox_min);

bbox_min = bbox_min - step;
bbox_max = bbox_max + step;

N = 10;
step = step / (N * N);
nshield = N * N * 6;

vx = linspace(bbox_min(1), bbox_max(1), N);
vy = linspace(bbox_min(2), bbox_max(2), N);
vz = linspace(bbox_min(3), bbox_max(3), N);

[x, y] = meshgrid(vx, vy);
facez1 = [x(:), y(:), ones(N * N, 1) * bbox_max(3)];
facez2 = [x(:), y(:), ones(N * N, 1) * bbox_min(3)];

[x, y] = meshgrid(vy, vz - step);
facex1 = [ones(N * N, 1) * bbox_max(1), x(:), y(:)];
facex2 = [ones(N * N, 1) * bbox_min(1), x(:), y(:)];

[x, y] = meshgrid(vx - step, vz);
facey1 = [x(:), ones(N * N, 1) * bbox_max(2), y(:)];
facey2 = [x(:), ones(N * N, 1) * bbox_min(2), y(:)];

pnew = [p; facex1; facex2; facey1; facey2; facez1; facez2];

%% Build Connectivity
function [face2elem, elem2face, t] = buildConnectivity(elem)

[t, idx, face2elem] = uniqfaces(elem);

numt = size(elem, 1);
nume = size(t, 1);
elem2face = zeros(nume, 2, 'int32');
count = ones(nume, 1, 'int8');

for k = 1:numt
    for jj = 1:4
        ce = face2elem(k, jj);
        elem2face(ce, count(ce)) = k;
        count(ce) = count(ce) + 1;
    end
end

%% Mark Tetrahedra
function tbound = markTetrahedra(p, elem, elem2face, face2elem, cc, r, nshield)
% Identical to original algorithm
TOLLDIFF = 0.01;
INITTOLL = 0.99;
MAXLEVEL = 10 / TOLLDIFF;
BRUTELEVEL = MAXLEVEL - 50;

np = size(p, 1) - nshield;
numtetr = size(elem, 1);
nt = size(elem2face, 1);

% Vectorized initialization
deleted = any(elem > np, 2);
checked = deleted;
onfront = false(nt, 1);
onfront(face2elem(checked, :)) = true;
countchecked = sum(checked);

toll = zeros(nt, 1) + INITTOLL;
level = 0;

% Intersection factor (vectorized)
Ifact = zeros(nt, 1);
i = elem2face(:, 2) > 0;
distcc = sum((cc(elem2face(i, 1), :) - cc(elem2face(i, 2), :)).^2, 2);
Ifact(i) = (-distcc + r(elem2face(i, 1)).^2 + r(elem2face(i, 2)).^2) ./ ...
           (2 * r(elem2face(i, 1)) .* r(elem2face(i, 2)));

clear cc r;  % Free memory

ids = 1:nt;
queue = ids(onfront);
nqueue = length(queue);

while countchecked < numtetr && level < MAXLEVEL
    level = level + 1;

    for i = 1:nqueue
        id = queue(i);
        elem1 = elem2face(id, 1);
        elem2 = elem2face(id, 2);

        if elem2 == 0
            onfront(id) = false;
            continue
        elseif checked(elem1) && checked(elem2)
            onfront(id) = false;
            continue
        end

        if Ifact(id) >= toll(id)
            if checked(elem1)
                deleted(elem2) = deleted(elem1);
                checked(elem2) = true;
                countchecked = countchecked + 1;
                onfront(face2elem(elem2, :)) = true;
            else
                deleted(elem1) = deleted(elem2);
                checked(elem1) = true;
                countchecked = countchecked + 1;
                onfront(face2elem(elem1, :)) = true;
            end
            onfront(id) = false;
        elseif Ifact(id) < -toll(id)
            if checked(elem1)
                deleted(elem2) = ~deleted(elem1);
                checked(elem2) = true;
                countchecked = countchecked + 1;
                onfront(face2elem(elem2, :)) = true;
            else
                deleted(elem1) = ~deleted(elem2);
                checked(elem1) = true;
                countchecked = countchecked + 1;
                onfront(face2elem(elem1, :)) = true;
            end
            onfront(id) = false;
        else
            toll(id) = toll(id) - TOLLDIFF;
        end
    end

    if level == BRUTELEVEL
        warning('Brute continuation necessary');
        onfront(face2elem(~checked, :)) = true;
    end

    queue = ids(onfront);
    nqueue = length(queue);
end

% Extract boundary triangles (identical to original)
tbound = true(nt, 2);
ind = elem2face > 0;
tbound(ind) = deleted(elem2face(ind));
tbound = sum(tbound, 2) == 1;

if level == MAXLEVEL
    warning('%d th level was reached', level);
end

%% Extract Manifold
function [t, tnorm] = extractManifold(t, p)
numt = size(t, 1);
vect = 1:numt;

e = [t(:, [1, 2]); t(:, [2, 3]); t(:, [3, 1])];
[e, jtmp, j] = unique(sort(e, 2), 'rows');
te = [j(vect), j(vect + numt), j(vect + 2 * numt)];

clear jtmp;

nume = size(e, 1);
ne = size(e, 1);
count = zeros(ne, 1, 'int32');
etmapc = zeros(ne, 4, 'int32');

for i = 1:numt
    i1 = te(i, 1);
    i2 = te(i, 2);
    i3 = te(i, 3);
    etmapc(i1, 1 + count(i1)) = i;
    etmapc(i2, 1 + count(i2)) = i;
    etmapc(i3, 1 + count(i3)) = i;
    count(i1) = count(i1) + 1;
    count(i2) = count(i2) + 1;
    count(i3) = count(i3) + 1;
end

etmap = cell(ne, 1);
for i = 1:ne
    etmap{i, 1} = etmapc(i, 1:count(i));
end
clear etmapc;

tkeep = false(numt, 1);
efront = zeros(nume, 1, 'int32');

tnorm = surfacenorm(p, t);

[maxp, t1] = max((p(t(:, 1), 3) + p(t(:, 2), 3) + p(t(:, 3), 3)) / 3);
if tnorm(t1, 3) < 0
    tnorm(t1, :) = -tnorm(t1, :);
end

tkeep(t1) = true;
efront(1:3) = te(t1, 1:3);
e2t = zeros(nume, 2, 'int32');
e2t(te(t1, 1:3), 1) = t1;
nf = 3;

while nf > 0
    k = efront(nf);

    if e2t(k, 2) > 0 || e2t(k, 1) < 1 || count(k) < 2
        nf = nf - 1;
        continue
    end

    idtcandidate = etmap{k, 1};
    t1 = e2t(k, 1);

    alphamin = inf;
    ttemp = t(t1, :);
    etemp = e(k, :);
    p1 = etemp(1);
    p2 = etemp(2);
    p3 = ttemp(ttemp ~= p1 & ttemp ~= p2);

    idt = 0;
    for i = 1:length(idtcandidate)
        t2 = idtcandidate(i);
        if t2 == t1
            continue
        end

        ttemp = t(t2, :);
        p4 = ttemp(ttemp ~= p1 & ttemp ~= p2);

        [alpha, tnorm2] = computeTriAngle(p(p1, :), p(p2, :), p(p3, :), p(p4, :), tnorm(t1, :));

        if alpha < alphamin
            alphamin = alpha;
            idt = t2;
            tnorm(t2, :) = tnorm2;
        end
    end

    if idt > 0
        tkeep(idt) = true;
        for j = 1:3
            ide = te(idt, j);

            if e2t(ide, 1) < 1
                efront(nf) = ide;
                nf = nf + 1;
                e2t(ide, 1) = idt;
            else
                efront(nf) = ide;
                nf = nf + 1;
                e2t(ide, 2) = idt;
            end
        end
    end

    nf = nf - 1;
end

t = t(tkeep, :);
tnorm = tnorm(tkeep, :);

%% Compute Triangle Angle
function [alpha, tnorm2] = computeTriAngle(p1, p2, p3, p4, planenorm)
% Identical to original
test = sum(planenorm .* p4 - planenorm .* p3);

v21 = p1 - p2;
v31 = p3 - p1;
tnorm1(1) = v21(2) * v31(3) - v21(3) * v31(2);
tnorm1(2) = v21(3) * v31(1) - v21(1) * v31(3);
tnorm1(3) = v21(1) * v31(2) - v21(2) * v31(1);
tnorm1 = tnorm1 ./ norm(tnorm1);

v41 = p4 - p1;
tnorm2(1) = v21(2) * v41(3) - v21(3) * v41(2);
tnorm2(2) = v21(3) * v41(1) - v21(1) * v41(3);
tnorm2(3) = v21(1) * v41(2) - v21(2) * v41(1);
tnorm2 = tnorm2 ./ norm(tnorm2);

alpha = tnorm1 * tnorm2';
alpha = acos(alpha);

if test < 0
    alpha = alpha + 2 * (pi - alpha);
end

testor = sum(planenorm .* tnorm1);
if testor > 0
    tnorm2 = -tnorm2;
end

%% Filter by Circumradius
function [t, tnorm] = filterByCircumradius(t, tnorm, p, thresh)
r = circumradius(p, t);

median_r = median(r);
valid = r <= thresh * median_r;

t = t(valid, :);
tnorm = tnorm(valid, :);
