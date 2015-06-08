function [output_enso] = CP_EP_enso_choose(year,input_rm,ENSO_type,mstart,mend,dimension,YR_0);

if (ENSO_type == 'CP');
   % Mo's cp enso
   %enso_year = [1969 1978 1991 1995 2002 2003 2005]
   % Yuhao's cp enso
   %enso_year = [1954 1958 1959 1964 1966 1969 1978 1988 1992 1995 2003 2005 2010];
   %enso_year = [1954 1958 1959 1964 1966 1969 1978 1988 1992 1995 2003 2005];
   % ERA Intermin data year
   enso_year = [1988 1992 1995 2003 2005 2010];

elseif (ENSO_type == 'EP');
   % Mo's ep enso
   %enso_year = [1964 1966 1970 1973 1977 1980 1983 1987 1988 1991 1998 2004]
   % Yuhao's ep enso
   %enso_year = [1952 1970 1973 1977 1983 1987 1998 2007];
   %enso_year = [1952 1970 1973 1977 1983 1987 1998];
   % ERA Intermin data year
   enso_year = [1983 1987 1998 2007];
end;

if YR_0 == 0;
enso_year = enso_year - 1;
end;

nmonth = mend - mstart + 1;
for NY = 1:length(enso_year);
   IYR = enso_year(NY) - year(1) + 1;
   if (dimension==3);output_enso(:,:,:,NY) = nanmean(input_rm((IYR-1)*12+mstart:(IYR-1)*12+mend,:,:,:),1);end;
   if (dimension==2);output_enso(:,:,NY) = nanmean(input_rm((IYR-1)*12+mstart:(IYR-1)*12+mend,:,:),1);end;
   if (dimension==1);output_enso(:,NY) = nanmean(input_rm((IYR-1)*12+mstart:(IYR-1)*12+mend));end;
end;

