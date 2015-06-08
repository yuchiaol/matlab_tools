function filled=filmiss(input,undef,mesh)
%This script refills missing data into EOFs (normally) for plotting purpose.
%The script itself knows nothing about EOF, though.
%FILLED=FILMISS(INPUT,UNDEF,MESH)
%FILLED: EOFs filled with missing data.
%INPUT: Input EOFs (stored in such a way that each column corresponds to one mode of variability).
%UNDEF: Value denoting missing data in input; used to refill input.
%MESH: Mesh used to refill missing data. Note: can be a row or column vector.
%
%(C) 2003 Bin Guan. Distributed under GNU/GPL.

[n,m]=size(input);
undefs=ones(1,m)*undef;
filled=[];

in_idx=0;
for i=1:length(mesh)
    if(mesh(i)==1)
        in_idx=in_idx+1;
        filled=[filled;input(in_idx,:)];
    else
        filled=[filled;undefs];
    end
end
