function [prcp_enso] = PRISM_enso_prcp(year,prcp_rm,ENSO_type,mstart,mend);

if (ENSO_type == 'CP');
   % Mo's cp enso
   %enso_year = [1969 1978 1991 1995 2002 2003 2005]
   % Yuhao's cp enso
   enso_year = [1954 1958 1959 1964 1966 1969 1978 1988 1992 1995 2003 2005 2010];
elseif (ENSO_type == 'EP');
   % Mo's ep enso
   %enso_year = [1964 1966 1970 1973 1977 1980 1983 1987 1988 1991 1998 2004]
   % Yuhao's ep enso
   enso_year = [1952 1970 1973 1977 1983 1987 1998 2007];
end

nmonth = mend - mstart + 1;
for NY = 1:length(enso_year);
   IYR = enso_year(NY) - year(1) + 1;
   prcp_enso(:,:,NY) = nanmean(prcp_rm((IYR-1)*12+mstart:(IYR-1)*12+mend,:,:),1);
end

