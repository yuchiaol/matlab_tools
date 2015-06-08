function [squeezed,mesh]=delmiss(input,undef)
%This script removes missing data in a field for EOF analysis.
%[SQUEEZED,MESH]=DELMISS(INPUT,UNDEF)
%SQUEEZED: Output field.
%MESH: Mesh used by filmiss() to refill missing data.
%Note: MESH here is a row vector. filmiss() requires MESH to be a column vector.
%INPUT: Input field (stored in such a way that time varies along y-direction, i.e.,
%each row corresponds to one observation).
%UNDEF: Value denoting missing data, e.g., -1e30.
%
%(C) 2006 Bin Guan. Distributed under GNU/GPL.

mesh=input;
if(isnan(undef))
mesh(~isnan(mesh))=1;
mesh(isnan(mesh))=0;
else
mesh(find(mesh~=undef))=1;
mesh(find(mesh==undef))=0;
end
mesh=(mean(mesh)==1);
squeezed=input;
squeezed(:,find(mesh==0))=[];
