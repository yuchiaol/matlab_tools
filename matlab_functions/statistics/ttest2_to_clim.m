function [H_2D P_2D] = ttest2_to_clim(var,var_clim,parm)

% var should be three dimension
% var_clim should be two dimension
for nn = 1:size(var,3);
   var_clim_ENSO(:,:,nn) = var_clim;
end;

for II = 1:size(var_clim,1);for JJ = 1:size(var_clim,2);
   [H_2D(II,JJ) P_2D] = ttest2(var_clim_ENSO(II,JJ,:),var(II,JJ,:),parm);
end;end;
H_2D(H_2D==0)=nan;

