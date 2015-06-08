function [climatology TS_rm] = climatology_compute_remove(TS,parm1)

nm = 12;
% parm1 = 1 means the first dimension of TS is time
ord_old = [1:length(size(TS))];
ord_old(parm1) = nan;

nstep=0;
for n = 1:ndims(TS);
   if (isnan(ord_old(n))==0);
      nstep = nstep + 1;
      ord_temp(nstep) = ord_old(n);
      dim_space(nstep) = size(TS,n);
   end;
end;
ord_new = [parm1 ord_temp]

TS_tmp1 = permute(TS,ord_new);

dimT = size(TS_tmp1,1);
dimX = prod(size(TS_tmp1))/dimT;

TS_tmp2 = reshape(TS_tmp1,[dimT dimX]);
clear TS_tmp1;

for t = 1:nm
   clim(t,:) = nanmean(TS_tmp2(t:nm:dimT,:),1);
end

for t = 1:dimT
   tm = mod(t-1,nm)+1;
   TS_tmp3(t,:) = TS_tmp2(t,:)-clim(tm,:);
end
clear TS_tmp2;

TS_rm = reshape(TS_tmp3,[dimT dim_space]);
climatology = reshape(clim,[nm dim_space]);
