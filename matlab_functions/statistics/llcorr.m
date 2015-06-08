% FUNCTION corr_val = llcorr(v1,v2,ll_max)
%  Calculates lead-lag correlation values between variables v1 and v2.
%  Lengths of vectors v1 and v2 must be same. ll_max is the maximum
%  lead-lag between v1 and v2. It returns vector corr_val of length
%  2*ll_max+1. corr_val(1) is the value where v1 is
%  leading by ll_max time points from v2. For corr_val(2) v1 is leading
%  by ll_max-1 time points from v2. corr_val(ll_max+1) corresponds to
%  no-lead-lag between v1 and v2. corr_val(2*llmax+1) gives the value
%  of correlation where v1 is lagging by ll_max time points from v2.
%
%  author: Arindam <arch@caos.iisc.ernet.in>

 function corr_val = llcorr(v1,v2,ll_max)

 if length(v1) ~= length(v2)
  disp('Error from llcorr: Lengths of v1 and v2 must be same.');
  corr_val = -2;
  return;
 end

 ndy = length(v1);

 indx = 0;
 for i = -ll_max:ll_max

  indx = indx + 1;
  if i <= 0
   v2_i = 1 - i;
   v2_f = ndy;
   v1_i = 1;
   v1_f = ndy + i;
  else
   v2_i = 1;
   v2_f = ndy - i;
   v1_i = 1 + i;
   v1_f = ndy;
  end

  cmat = corrcoef(v2(v2_i:v2_f),v1(v1_i:v1_f));
  corr_val(indx) = cmat(1,2);

 end
