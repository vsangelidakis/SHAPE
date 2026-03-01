function [r, cc] = circumradius(p, t)
%
% [r, cc] = circumradius(p, t)
% Compute circumradius and circumcenter for triangles/tets
%
% Input:
%   p - Nx3 vertex coordinates
%   t - Mx3 (triangles) or Mx4 (tetrahedra) element connectivity
%
% Output:
%   r  - Mx1 circumradius
%   cc - Mx3 circumcenter coordinates

if size(t, 2) == 3  % Triangular mesh
    % Get triangle vertices
    v1 = p(t(:, 1), :);
    v2 = p(t(:, 2), :);
    v3 = p(t(:, 3), :);

    % Edge vectors
    d1 = v2 - v1;
    d2 = v3 - v1;

    % Cross product (2 * triangle area vector)
    n = cross(d1, d2, 2);
    n_len_sq = sum(n.^2, 2);

    if nargout > 1
        % Circumcenter (needed for radius anyway if requested)
        alpha = sum(d2.^2, 2) .* dot(d1, d1 - d2, 2) ./ (2 * n_len_sq);
        beta = sum(d1.^2, 2) .* dot(d2, d2 - d1, 2) ./ (2 * n_len_sq);
        cc = v1 + alpha .* d1 + beta .* d2;

        % Circumradius from center
        r = sqrt(sum((v1 - cc).^2, 2));
    else
        % Circumradius without computing center
        a = sqrt(sum((v2 - v3).^2, 2));
        b = sqrt(sum(d2.^2, 2));
        c = sqrt(sum(d1.^2, 2));
        area = sqrt(n_len_sq) / 2;
        r = (a .* b .* c) ./ (4 * area);
    end

else  % Tetrahedral mesh
    % Get tet vertices
    v1 = p(t(:, 1), :);
    v2 = p(t(:, 2), :);
    v3 = p(t(:, 3), :);
    v4 = p(t(:, 4), :);

    % Edge vectors from v1
    a = v2 - v1;
    b = v3 - v1;
    c = v4 - v1;

    if nargout > 1
        % Circumcenter using Cramer's rule
        d1 = sum(c .* (v1 + v4) * 0.5, 2);
        d2 = sum(a .* (v1 + v2) * 0.5, 2);
        d3 = sum(b .* (v1 + v3) * 0.5, 2);

        det23 = a(:, 2) .* b(:, 3) - a(:, 3) .* b(:, 2);
        det13 = a(:, 3) .* b(:, 1) - a(:, 1) .* b(:, 3);
        det12 = a(:, 1) .* b(:, 2) - a(:, 2) .* b(:, 1);

        Det = c(:, 1) .* det23 + c(:, 2) .* det13 + c(:, 3) .* det12;

        detx = d1 .* det23 + c(:, 2) .* (-(d2 .* b(:, 3)) + (a(:, 3) .* d3)) + ...
               c(:, 3) .* ((d2 .* b(:, 2)) - (a(:, 2) .* d3));
        dety = c(:, 1) .* ((d2 .* b(:, 3)) - (a(:, 3) .* d3)) + d1 .* det13 + ...
               c(:, 3) .* ((d3 .* a(:, 1)) - (b(:, 1) .* d2));
        detz = c(:, 1) .* ((a(:, 2) .* d3) - (d2 .* b(:, 2))) + ...
               c(:, 2) .* (d2 .* b(:, 1) - a(:, 1) .* d3) + d1 .* det12;

        cc = [detx ./ Det, dety ./ Det, detz ./ Det];

        % Circumradius from center
        r = sqrt(sum((v2 - cc).^2, 2));
    else
        % Circumradius without computing center
        V = abs(dot(a, cross(b, c, 2), 2)) / 6;
        A = [sqrt(sum(cross(b, c, 2).^2, 2)), ...
             sqrt(sum(cross(c, a, 2).^2, 2)), ...
             sqrt(sum(cross(a, b, 2).^2, 2)), ...
             sqrt(sum(cross(v3 - v2, v4 - v2, 2).^2, 2))] / 2;
        r = sqrt(sum(A.^2, 2)) ./ (4 * V);
    end
end
