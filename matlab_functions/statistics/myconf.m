function [c] = myconf(x,f,p)
% written by Lord Francois 

dx = x(2)-x(1);
[F,ii] = sort(f,'descend');
dF = F.*dx;
cdf = cumsum(dF); % compute the sorted cumulative probability distribution
jj = max(find((cdf<p/100))); % find the smallest interval that contains
                               % p-percent of the probability
I = x(ii(1:jj));
% Assume c is a continuous interval
c = [min(I) max(I)];
