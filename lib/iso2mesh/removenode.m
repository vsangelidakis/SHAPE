function [no, el] = removenode(node, elem, idx)
%
% [no, el] = removenode(node, elem, idx)
%
% remove the nodes identified by their indices in idx in the mesh
%
% author: Qianqian Fang, <q.fang at neu.edu>
%
% input:
%   node:  node coordinates of the input mesh
%   elem:  triangules or tetrahedral elements
%   idx: integer list of the nodes to be removed
%
% output:
%   no: nodes after removing the specified nodes
%   el: remaining elements after removing any element containing the
%       removed nodes
%
% the outputs of this subroutine can be easily plotted using plotmesh()
%
% -- this function is part of iso2mesh toolbox (http://iso2mesh.sf.net)
%

oid = 1:size(node, 1);       % old node index
idx = sort(idx);
delta = zeros(size(oid));
delta(idx) = 1;
delta = -cumsum(delta);      % calculate the new node index after removing the isolated nodes
oid = oid + delta;           % map to new index
if (~iscell(elem))
    el = oid(elem);          % element list in the new index
else
    el = cellfun(@(x) oid(x), elem, 'UniformOutput', false);
end
no = node;
no(idx, :) = [];             % remove the isolated nodes
if (nargout > 1)
    [ix, iy] = find(el == 0);
    el(ix, :) = [];
end
