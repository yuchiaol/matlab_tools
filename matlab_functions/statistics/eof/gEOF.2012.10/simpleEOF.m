function [EOF,PC,lambda]=simpleEOF(F,K)
%Simple EOF calculation based on SVD.
%
%Usage: [lambda,EOF,PC]=simpleEOF(F,K)
%       lambda: eigenvalues.
%       EOF: each column of the matrix is a EOF.
%       PC: each column of the matrix is a PC.
%       F: input field; each column is a variable, and each row is an observation.
%       K: Compute only the leading K EOFs.
%
% Copyright (C) 2003 Bin Guan. Distributed under GNU/GPL.

[n,m]=size(F);

[U,S,EOF]=svds(F,K);

PC=U*S;

lambda=diag(S).^2/(n-1);
