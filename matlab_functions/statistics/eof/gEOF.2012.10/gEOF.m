%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%$Id: gEOF.m,v 1.10 2012/10/14 00:54:47 bguan Exp bguan $
%
% This file is part of gEOF.
%
% gEOF is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% gEOF is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with gEOF.  If not, see <http://www.gnu.org/licenses/>.
%
%
%
%                                 gEOF
%                            Version 2012.10
%                    Copyright (C) 2003-2012 Bin Guan.
%                     Bug report: bguan@atmos.umd.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;                                  

%------------------------Modify below as appropriate.----------------------

%I/O information.
dataset='sst_hadley'; %name of input data set [string].
indir='~/DATA/SST/'; %input dir [string].
infile='sst_seasonal'; %input file (do NOT include suffix) [string].
outdir='./output/'; %output dir [string].

%Calendar info.
calendar=''; %Leave it blank, or set to 365_day_calendar if needed in output .ctl file [string or empty string]. Note that sub-monthly data with leap years are NOT supported.
time_unit='mo'; %Time unit used by input file [string].
year_length=12; %Length of a complete calendar year. E.g., 12 if time_unit='mo', 365 if time_unit='dy' [integer; specified in time_unit].
t2_first=1; %Index of the first non-missing time step, counting from the beginning of the calendar year it belongs to. E.g., t2_first=12 if the input monthly data start from December, t2_first=3 if the input seasonal data start from summer (1=DJF, 2=MAM, 3=JJA, 4=SON).

%EOF method.
%1: EOF
%2: rotated EOF (REOF)
%3: rotated extended EOF (REEOF)
%4: extended EOF (EEOF)
%5: season-reliant EOF (SEOF)
method=3; %[integer]

%Analysis domain: 4 pre-defined domains.
%Pacific
%Atlantic
%Indo-Pacific
%IndianOcean
domain='Pacific'; %[string].

%Beginning/ending time step (non-dimensional) to be analyzed in each calendar year. E.g., 1 and 12 for all months of a monthly data set, 1 and 4 for all seasons of a seasonal data set.
t2_analyzed_start=1; %[integer; non-dimensional].
t2_analyzed_end=4; %[integer; non-dimensional].

%Beginning/ending calendar year to be analyzed (it is okay if they are incomplete years).
year_analyzed_start=1900; %[integer].
year_analyzed_end=2002; %[integer].

%Deseasoning settings (whether to remove the climatological seasonal cycle from the input data).
deseasoning=1; %[0 or 1].
clim_year_start=year_analyzed_start; clim_year_end=year_analyzed_end; %Beginning/ending calendar year for definition of climatology.

%Detrending settings.
detrending=0; %[0 or 1].

%Normalization settings.
%1: MeanSTD = sqrt(mean variance)
%2: SMeanSTD (for season-reliant EOF)
%3: LocalSTD
%4: LocalSTD^0.5 = sqrt(LocalSTD)
norm_method=1; %[integer].

%Extended EOF analysis settings.
lag_size=3; %Size of each lag [integer; specified in time_unit].
%Note: when selected months/seasons from a calendar year are analyzed, lag_size should be counted as if those unselected months/seasons were non-existent.
%E.g., if we have seasonal SSTs, and want to do a winter-only analysis, then lag_size=3 (mo) means yearly lags.
lag_start=-2; %Number of lags before zero-lag [integer; non-dimensional].
lag_end=2; %Number of lags after zero-lag [integer; non-dimensional].

%EOF mode selection.
num_modes_rot=7; %Number of modes to rotate, if applicable [integer].
num_modes_out=7; %Number of modes to write to output file [integer].

%----------------------Do not modify below this line.----------------------

%Reconstruction settings (OBSOLETE).
do_recon=0; %[0 or 1].
modes2exclude={[1,2,5,7],[1,2,7]};
modes_excluded=1; %[1 or 2].

mon_abbr={'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'};

methods={'EOF','REOF','REEOF','EEOF','SEOF'};
norm_methods={'MeanSTD','SMeanSTD','LocalSTD','LocalSTD^0.5'}; %MeanSTD=sqrt(mean variance); LocalSTD^0.5=sqrt(LocalSTD).

%Load .spec file (metadata).
infile_spec=load([indir,infile,'.spec']);
undefi=infile_spec(1,1); %UNDEF in input .ctl.
undefo=undefi; %UNDEF in output .ctl.
x_total=infile_spec(2,1); lon_total_start=infile_spec(2,2); lon_grid_size=infile_spec(2,3); %XDEF.
y_total=infile_spec(3,1); lat_total_start=infile_spec(3,2); lat_grid_size=infile_spec(3,3); %YDEF.
t_total=infile_spec(4,1); year_total_start=infile_spec(4,2); time_grid_size=infile_spec(4,3);
year_grid_size=1; %year_grid_size must always be 1.
t2_total=year_length/time_grid_size; %Number of time steps per calendar year. E.g., 4 (seasons), 12 (months), etc.

if(t2_analyzed_start>t2_analyzed_end)
t2_analyzed_start1=1;
t2_analyzed_end1=t2_analyzed_end;
t2_analyzed_start2=t2_analyzed_start;
t2_analyzed_end2=t2_total;
end

if(~exist('t2_analyzed_start1'))
t2_analyzed=t2_analyzed_end-t2_analyzed_start+1;
else
t2_analyzed=(t2_analyzed_end1-t2_analyzed_start1+1)+(t2_analyzed_end2-t2_analyzed_start2+1);
end

%Definition of domains.
if(strcmp(domain,'Pacific')) %Pan-Pacific.
lon_analyzed_start=120; lon_analyzed_end=300; %120E--60W.
lat_analyzed_start=-20; lat_analyzed_end=60; %20S--60N.
end
if(strcmp(domain,'Atlantic')) %Atlantic.
lon_analyzed_start=280; lon_analyzed_end=380; %80W--20E.
lat_analyzed_start=-20; lat_analyzed_end=60; %20S--60N.
end
if(strcmp(domain,'Indo-Pacific')) %Pan-Pacific plus Indian Ocean.
lon_analyzed_start=30; lon_analyzed_end=300; %30E--60W.
lat_analyzed_start=-20; lat_analyzed_end=60; %20S--60N.
end
if(strcmp(domain,'US')) %Contiguous United States.
lon_analyzed_start=235; lon_analyzed_end=295; %125--65W.
lat_analyzed_start=25; lat_analyzed_end=50; %25--50N.
end
if(strcmp(domain,'India')) %India.
lon_analyzed_start=65; lon_analyzed_end=95; %65--95E.
lat_analyzed_start=5; lat_analyzed_end=35; %5--35N.
end
if(strcmp(domain,'IndianOcean')) %Indian Ocean.
lon_analyzed_start=20; lon_analyzed_end=120; %20--120E.
lat_analyzed_start=-40; lat_analyzed_end=30; %40S--30N.
end

%Define "extended" as 0 or 1.
if(strcmp(methods{method},'EEOF') | strcmp(methods{method},'REEOF'))
extended=1; %Extended EOF.
else
extended=0; %Regular EOF.
end

%Define "rotated" as 0 or 1.
if(strcmp(methods{method},'REOF') | strcmp(methods{method},'REEOF'))
rotated=1; %Rotated EOF.
else
rotated=0; %Unrotated EOF.
end

%Define "season_reliant" as 0 or 1.
if(strcmp(methods{method},'SEOF'))
season_reliant=1; %Season-reliant EOF.
else
season_reliant=0; %Not season-reliant EOF.
end

%Define lag_total for either extended or regular EOF analysis. Undefine lag_size, lag_start and lag_end for regular EOF analysis.
if(extended)
  lag_total=lag_end-lag_start+1;
elseif(season_reliant)
  lag_total=t2_analyzed;
  lag_size=time_grid_size;
  clear lag_start;
  clear lag_end; 
else
  lag_total=1;
  lag_size=time_grid_size;
  clear lag_start;
  clear lag_end; 
end

%Define output filenames, as follows:
%<dataset>_<xyt resolution>_<norm method>_<domain>_<period>_<t2 range>_<EOF variant>_[<?lagx?time_unit>]_[<rot?>]_<given name>.<extention>
outfile_common=[dataset,'_',num2str(lon_grid_size),'x',num2str(lat_grid_size),'x',num2str(time_grid_size),time_unit,'_','NormBy',norm_methods{norm_method},'_',domain,'_',num2str(year_analyzed_start),'to', ...
                num2str(year_analyzed_end),'_',num2str(t2_analyzed_start),'to',num2str(t2_analyzed_end),'_',methods{method},'_'];
if(extended~=0)
outfile_common=[outfile_common,num2str(lag_total),'lag','x',num2str(lag_size),time_unit,'_'];
end
if(rotated~=0)
outfile_common=[outfile_common,'rot',num2str(num_modes_rot),'_'];
end
eof_outfile=[outfile_common,'eof.dat'];
eof_ctlfile=[outfile_common,'eof.ctl'];
ec_outfile=[outfile_common,'ec.dat'];
ec_ctlfile=[outfile_common,'ec.ctl'];
pct_expl_file=[outfile_common,'pctexpl.txt'];
recon_outfile=[outfile_common,'recon',num2str(modes_excluded),'.dat'];
workspace=[outfile_common,'wkspc.mat'];

disp('gEOF>Pre-processing started...');

%Read data into matrix "data".
fid=fopen([indir,infile,'.dat'],'r');
data=fread(fid,inf,'real*4');
fclose(fid);
data(find(data==undefi))=NaN; %Replacing missing values with NaN.
data=reshape(data,[x_total*y_total,t_total]);
data(:,isnan(nanmean(data,1)))=[]; %Drop possible redundant missing values at the beginning/end of the data.
[null,t_total]=size(data); %New t_total NOT including possible redundant missing values at the beginning/end of the data.
disp('gEOF>Data obtained.');

t2_last=mod(t_total,t2_total)+t2_first-1;
if(t2_last==0)
t2_last=t2_total;
end
if(t2_last>t2_total)
t2_last=t2_last-t2_total;
end

%Manipulation of .ctl information.
lon_total_end=lon_total_start+(x_total-1)*lon_grid_size;
lat_total_end=lat_total_start+(y_total-1)*lat_grid_size;
year_total=(t_total+t2_first-1+t2_total-t2_last)/t2_total;
year_total_end=year_total_start+year_total-1;

%Convert world coordinates to (integer) grid coordinates.
x_analyzed_start=find(lon_total_start:lon_grid_size:lon_total_end<=lon_analyzed_start,1,'last');
x_analyzed_end=find(lon_total_start:lon_grid_size:lon_total_end>=lon_analyzed_end,1,'first');
x_analyzed=x_analyzed_end-x_analyzed_start+1;
y_analyzed_start=find(lat_total_start:lat_grid_size:lat_total_end<=lat_analyzed_start,1,'last');
y_analyzed_end=find(lat_total_start:lat_grid_size:lat_total_end>=lat_analyzed_end,1,'first');
y_analyzed=y_analyzed_end-y_analyzed_start+1;
yearidx_analyzed_start=find(year_total_start:year_grid_size:year_total_end<=year_analyzed_start,1,'last');
yearidx_analyzed_end=find(year_total_start:year_grid_size:year_total_end>=year_analyzed_end,1,'first');
yearidx_analyzed=yearidx_analyzed_end-yearidx_analyzed_start+1;
t_analyzed=t2_analyzed*yearidx_analyzed-(t2_first-1)-(t2_total-t2_last);

if(isempty(yearidx_analyzed_start))
disp('gEOF>Error: year_analyzed_start too small. Please check.');
return
end
if(isempty(yearidx_analyzed_end))
disp('gEOF>Error: year_analyzed_end too large. Please check.');
return
end

%Adjust analysis domain to be consistent with integer grid coordinates.
lon_analyzed_start=lon_total_start+(x_analyzed_start-1)*lon_grid_size;
lon_analyzed_end=lon_total_start+(x_analyzed_end-1)*lon_grid_size;
lat_analyzed_start=lat_total_start+(y_analyzed_start-1)*lat_grid_size;
lat_analyzed_end=lat_total_start+(y_analyzed_end-1)*lat_grid_size;

%Get a subset of the data, weight and store in matrix "subset".
data=[ones(x_total*y_total,t2_first-1)*NaN,data,ones(x_total*y_total,t2_total-t2_last)*NaN]; %Form complete calendar years if needed to facilitate subsetting and deseasoning.
data=reshape(data,[x_total,y_total,t2_total,year_total]);
if(~exist('t2_analyzed_start1'))
subset=data(x_analyzed_start:x_analyzed_end,y_analyzed_start:y_analyzed_end, ...
            t2_analyzed_start:t2_analyzed_end,yearidx_analyzed_start:yearidx_analyzed_end); %Getting subset.
else
subset=data(x_analyzed_start:x_analyzed_end,y_analyzed_start:y_analyzed_end, ...
            [t2_analyzed_start1:t2_analyzed_end1,t2_analyzed_start2:t2_analyzed_end2],yearidx_analyzed_start:yearidx_analyzed_end); %Getting subset.
end
subset=reshape(subset,[x_analyzed,y_analyzed,t2_analyzed*yearidx_analyzed]);
if(do_recon)
recon=reshape(subset,[x_analyzed*y_analyzed,t2_analyzed*yearidx_analyzed])'; %Save for reconstruction.
end
subset=subset.*repmat(sqrt(cos((lat_analyzed_start:lat_grid_size:lat_analyzed_end)/180*pi)),[x_analyzed,1,t2_analyzed*yearidx_analyzed]); %Weighting by sqrt(cos(phi)).
subset=reshape(subset,[x_analyzed*y_analyzed,t2_analyzed*yearidx_analyzed]);
subset=subset';
disp('gEOF>Data subsetted and appropriately weighted.');
clear data; %Freeing memory.

%Deseasoning.
if(deseasoning)
clim_yearidx_start=find(year_analyzed_start:year_grid_size:year_analyzed_end==clim_year_start);
clim_yearidx_end=find(year_analyzed_start:year_grid_size:year_analyzed_end==clim_year_end);
Ano=deseason(subset,t2_analyzed,clim_yearidx_start,clim_yearidx_end); %Note: To use the function deseason(), there must be equal number of months/seasons in each calendar year. 
disp('gEOF>Climatological seasonal cycle removed.');
else
clear clim_year_start;
clear clim_year_end;
Ano=subset;
disp('gEOF>Climatological seasonal cycle NOT removed.');
end
notNaN_idx=find(~isnan(nanmean(Ano,2)));
numNaNstart=notNaN_idx(1)-1; %Number of preceding NaN time slices after subsetting (could be fewer than those added in forming full calendar years); for later use.
numNaNend=t2_analyzed*yearidx_analyzed-notNaN_idx(end); %Number of ensuing NaN time slices after subsetting (could be fewer than those added in forming full calendar years); for later use.
Ano(isnan(nanmean(Ano,2)),:)=[]; %Revert to incomplete calendar years if that was the case.
clear subset; %Freeing memory.

%For SEOF, complete calendar years are required.
if(season_reliant)
if(numNaNstart~=0)
disp('gEOF>Error: year_analyzed_start too small. Please check.');
return
end
if(numNaNend~=0)
disp('gEOF>Error: year_analyzed_end too large. Please check.');
return
end
end

%Remove missing data, and calculate mask for refilling.
[F,mask]=delmiss(Ano,NaN);
mask=repmat(mask,[1,lag_total]);
disp('gEOF>Missing values (if any) removed.');
clear Ano; %Freeing memory.

%Detrending.
if(detrending)    
    F=detrend(F);
    disp('gEOF>Data detrended.');
else
    disp('gEOF>Data NOT detrended.');
end

%Extending/reorganizing the matrix.
if(extended)
  ExF=extend(F,lag_size/time_grid_size,lag_start,lag_end);
  disp('gEOF>Data extended for (R)EEOF.');
elseif(season_reliant)
  ExF=[];
  for lag_cnt=1:lag_total
  ExF=[ExF F(lag_cnt:lag_total:end,:)];
  end
  disp('gEOF>Data reorganized for SEOF.');
else
  ExF=F;
end
clear F; %Freeing memory.

%Getting the dimensions of the matrix to be EOF'ed.
[n,m]=size(ExF);
m_sub=m/lag_total;

%Normalizing.
if(strcmp(norm_methods{norm_method},'MeanSTD'))
mean_var=sum(sum(ExF.^2)/(n-1))/m; %Mean variance of the ORIGINAL data matrix. Do not confuse it with that of the matrix actually EOF'd.
ExF=ExF./sqrt(mean_var); %Final version of the data matrix to be EOF'd.
end
if(strcmp(norm_methods{norm_method},'SMeanSTD') & season_reliant==1)
ExF=reshape(ExF,[n*m_sub,lag_total]);
smean_var=sum(ExF.^2)/(n-1)/m_sub; %Season-reliant mean variance of the ORIGINAL data matrix. Do not confuse it with that of the matrix actually EOF'd.
ExF=ExF./repmat(sqrt(smean_var),[n*m_sub,1]);
ExF=reshape(ExF,[n,m]); %Final version of the data matrix to be EOF'd.
end
if(strcmp(norm_methods{norm_method},'SMeanSTD') & season_reliant==0)
disp('gEOF>SMeanSTD not yet supported for this EOF method. (Need work on normalization and denormalization code.)');
return;
end
if(strcmp(norm_methods{norm_method},'LocalSTD'))
local_var=sum(ExF.^2)/(n-1); %Local variance of the ORIGINAL data matrix. Do not confuse it with that of the matrix actually EOF'd.
ExF=ExF./repmat(sqrt(local_var),[n,1]); %Final version of the data matrix to be EOF'd.
end
if(strcmp(norm_methods{norm_method},'LocalSTD^0.5'))
local_var=sum(ExF.^2)/(n-1); %Local variance of the ORIGINAL data matrix. Do not confuse it with that of the matrix actually EOF'd.
ExF=ExF./repmat(local_var.^0.25,[n,1]); %Final version of the data matrix to be EOF'd.
end
mean_var_final=sum(sum(ExF.^2)/(n-1))/m; %Mean variance of the final data matrix. To be used when calculating percentage variance explained.
disp('gEOF>Data normalized.');

disp('gEOF>Pre-processing done.');
disp('gEOF>EOF started. This may take a few minutes...');

%EOF analysis.
num_modes_calc=max([59,num_modes_rot,num_modes_out]); %Number of modes to calculate [integer]. Note: too large numbers will lead to "out of memory" problem.
[EOF,EC,lambda]=simpleEOF(ExF,num_modes_calc); %Unrotated. Note 1: It's quicker to calculate all EOF (default). Note 2: The vector "lambda" only contains NON-ZERO eigenvalues.
EOF_size=size(EOF);
EC_size=size(EC);

%Renormalization of EOF and EC, i.e., each EOF (EC) is multiplied (divided) by the square root of the corresponding eigenvalue.
%After re-normalization, EOFs will carry units, while ECs will be dimensionless and have variance 1. 
EOF=EOF*spdiags(sqrt(lambda),0,EOF_size(2),length(lambda)); %Re-normalizing EOF.
EC=EC*spdiags(1./sqrt(lambda),0,EC_size(2),length(lambda)); %Re-normalizing EC.
pct_expl=100*sum(EOF.^2)'/(mean_var_final*m); %Percentage explained. Note: Cannot use lambda to calculate the same if/when not all lambda's were calculated.

disp('gEOF>EOF done.');
clear ExF;

%Rotation.
if(rotated)
    disp('gEOF>Rotation started. This may take a few minutes...');
    [rotEOF,rotmax]=rotatefactors(EOF(:,1:num_modes_rot),'Normalize','off','Reltol',1e-10,'Maxit',1000); %Rotating in sample space.
    rotEC=EC(:,1:num_modes_rot)*rotmax; %Obtaining expansion coefficients for rotated EOF.
    rot_pct_expl=100*sum(rotEOF.^2)'/(mean_var_final*m); %Percentage variance explained after rotation, i.e., ...
    %EOF variance divided by total variance of the final data matrix EOF'd (!!!Note: not mean_var*m, which is of the unnormalized ORIGINAL data matrix).

    %Sort rotated EOF according to percentage variance explained. The order could be different from before rotation. 
    [rot_pct_expl,order]=sort(rot_pct_expl); %Note: "order" is a column vector since "rot_pct_expl" is a column vector.
    rotEOF=rotEOF(:,order');
    rotEC=rotEC(:,order');
    rot_pct_expl=flipud(rot_pct_expl); %Changing from ascending to descending order.
    rotEOF=fliplr(rotEOF); %Changing from ascending to descending order.
    rotEC=fliplr(rotEC); %Changing from ascending to descending order.
    disp('gEOF>Rotation done.');
else
    disp('gEOF>EOF NOT rotated.');
    clear num_modes_rot;
end

%Selection of output.
if(rotated)
    out_pct_expl=rot_pct_expl(1:num_modes_out);
    outEOF=rotEOF(:,1:num_modes_out);
    outEC=rotEC(:,1:num_modes_out);

    clear rotEOF;
    clear rotEC;
else
    out_pct_expl=pct_expl(1:num_modes_out);
    outEOF=EOF(:,1:num_modes_out);
    outEC=EC(:,1:num_modes_out);
end
clear EOF;
clear EC;

%Polarity issues: force mean EOF loadings to be positive, and adjust EC accordingly.
lag_central_idx=ceil((lag_total+1)/2);
outEOF_central=outEOF(((lag_central_idx-1)*m_sub+1):lag_central_idx*m_sub,:);
outEOF_central_sum=sum(outEOF_central.*(abs(outEOF_central)>=0.333));
outEOF_sign=(outEOF_central_sum>=0)-(outEOF_central_sum<0);
outEOF=outEOF.*repmat(outEOF_sign,[m,1]);
outEC=outEC./repmat(outEOF_sign,[n,1]);

%Denormalization (so that EOFs have physically meaningful magnitudes).
if(strcmp(norm_methods{norm_method},'MeanSTD'))
outEOF_denormed=outEOF.*sqrt(mean_var);
end
if(strcmp(norm_methods{norm_method},'SMeanSTD') & season_reliant==1)
outEOF=reshape(outEOF,[m_sub,lag_total,num_modes_out]);
outEOF_denormed=outEOF.*repmat(sqrt(smean_var),[m_sub,1,num_modes_out]);
outEOF_denormed=reshape(outEOF_denormed,[m,num_modes_out]);
end
if(strcmp(norm_methods{norm_method},'LocalSTD'))
outEOF_denormed=outEOF.*repmat(sqrt(local_var'),[1,num_modes_out]);
end
if(strcmp(norm_methods{norm_method},'LocalSTD^0.5'))
outEOF_denormed=outEOF.*repmat((local_var').^0.25,[1,num_modes_out]);
end
disp('gEOF>EOF denormalized.');

%Refill missing data into EOF with NaN and unweight.
outEOF_refilled=filmiss(outEOF_denormed,NaN,mask'); %Refilling.
outEOF_refilled=reshape(outEOF_refilled,[x_analyzed,y_analyzed,lag_total,num_modes_out]); %Reshaping, to facilitate unweighting.
outEOF_unweighted=outEOF_refilled./repmat(sqrt(cos((lat_analyzed_start:lat_grid_size:lat_analyzed_end)/180*pi)), ...
                                          [x_analyzed,1,lag_total,num_modes_out]); %Unweighting by sqrt(cos(phi)).
outEOF_permuted=permute(outEOF_unweighted,[1,2,4,3]); %Shift the "time" (actually "time lags") dimension to the end to conform with GrADS convention.
disp('gEOF>EOF refilled with missing values and appropriately unweighted.');

%For extended EOF analysis, pad missing values to beginning/end of EC.
%For season-reliant EOF where EC has only one value per calendar year, make copies of that value equal to the number of months/seasons analyzed.
if(extended)
   outEC_padded=[ones(-lag_size*lag_start/time_grid_size,num_modes_out)*NaN;outEC;ones(lag_size*lag_end/time_grid_size,num_modes_out)*NaN];
elseif(season_reliant)
   outEC_padded=reshape(outEC,[1,yearidx_analyzed*num_modes_out]);
   outEC_padded=repmat(outEC_padded,[t2_analyzed,1]);
   outEC_padded=reshape(outEC_padded,[t_analyzed,num_modes_out]);
else
   outEC_padded=outEC;
end

%Form complete calendar years to facilitate subsequent processing.
outEC_padded=[ones(numNaNstart,num_modes_out)*NaN;outEC_padded;ones(numNaNend,num_modes_out)*NaN];

%For EOF of selected months/seasons, add back to EC the unselected months/seasons with missing values, to facilitate analyzing/plotting in GrADS.
outEC_padded=reshape(outEC_padded,[t2_analyzed,yearidx_analyzed,num_modes_out]);
if(~exist('t2_analyzed_start1')) % add NaN to the two ends of a calendar year
outEC_padded=[ones(t2_analyzed_start-1,yearidx_analyzed,num_modes_out)*NaN;outEC_padded;ones(t2_total-t2_analyzed_end,yearidx_analyzed,num_modes_out)*NaN];
else % add NaN to the middle of a calendar year
outEC_padded=[outEC_padded(1:t2_analyzed_end1,:,:);ones(t2_analyzed_start2-t2_analyzed_end1-1,yearidx_analyzed,num_modes_out)*NaN;outEC_padded(end-(t2_total-t2_analyzed_start2):end,:,:)];
end
outEC_padded=reshape(outEC_padded,[t2_total*yearidx_analyzed,num_modes_out]);

%Do reconstruction.
if(do_recon)
disp('gEOF>Reconstruction started...');
outEOF_refilled_exclude=outEOF_permuted(:,:,modes2exclude{modes_excluded},(lag_total+1)/2); %EOF to exclude when reconstructing.
outEOF_refilled_exclude=reshape(outEOF_refilled_exclude,[x_analyzed*y_analyzed,length(modes2exclude{modes_excluded})]);
outEC_padded_exclude=outEC_padded(:,modes2exclude{modes_excluded});
recon=recon-outEC_padded_exclude*outEOF_refilled_exclude';
recon=recon';
disp('gEOF>Reconstruction done.');
end

%Replace NaN with "undefo" for output.
outEOF_permuted(isnan(outEOF_permuted))=undefo;
outEC_padded(isnan(outEC_padded))=undefo;
if(do_recon)
recon(isnan(recon))=undefo;
end

disp('gEOF>Output started...');

%Save the workspace.
eval(['save ',outdir,workspace]);

%Write output to files.
fid=fopen([outdir,eof_outfile],'w');
fwrite(fid,outEOF_permuted(:,:,1:num_modes_out,:),'real*4');
fclose(fid);
fid=fopen([outdir,ec_outfile],'w');
fwrite(fid,outEC_padded(:,1:num_modes_out)','real*4');
fclose(fid);
fid=fopen([outdir,pct_expl_file],'w');
fprintf(fid,'%.1f\n',out_pct_expl(1:num_modes_out));
fclose(fid);
if(do_recon)
fid=fopen([outdir,recon_outfile],'w');
fwrite(fid,recon,'real*4');
fclose(fid);
end

%Generate EOF .ctl file for GrADS.
fid=fopen([outdir,eof_ctlfile],'w');
fprintf(fid,'DSET ^%s\n',eof_outfile);
fprintf(fid,'UNDEF %g\n',undefo);
fprintf(fid,'TITLE SST EOF 1--%g\n',num_modes_out);
if(~isempty(calendar))
fprintf(fid,'OPTIONS %s\n',calendar);
end
fprintf(fid,'XDEF %.0f LINEAR %.2f %.2f\n',x_analyzed,lon_analyzed_start,lon_grid_size);
fprintf(fid,'YDEF %.0f LINEAR %.2f %.2f\n',y_analyzed,lat_analyzed_start,lat_grid_size);
fprintf(fid,'ZDEF %.0f LINEAR %.2f %.2f\n',num_modes_out,1,1);
fprintf(fid,'TDEF %.0f LINEAR %s%.0f %.0f%s\n',lag_total,mon_abbr{1},year_analyzed_start,lag_size,time_unit);
fprintf(fid,'VARS %.0f\n',1);
fprintf(fid,'eof %.0f 99 Each (fictitious) level corresponds to one EOF.\n',num_modes_out);
fprintf(fid,'ENDVARS\n');
fclose(fid);

%Generate EC .ctl file for GrADS.
fid=fopen([outdir,ec_ctlfile],'w');
fprintf(fid,'DSET ^%s\n',ec_outfile);
fprintf(fid,'UNDEF %g\n',undefo);
fprintf(fid,'TITLE SST EC 1--%g\n',num_modes_out);
if(~isempty(calendar))
fprintf(fid,'OPTIONS %s\n',calendar);
end
fprintf(fid,'XDEF %.0f LEVELS %.2f\n',1,0);
fprintf(fid,'YDEF %.0f LEVELS %.2f\n',1,0);
fprintf(fid,'ZDEF %.0f LINEAR %.2f %.2f\n',num_modes_out,1,1);
fprintf(fid,'TDEF %.0f LINEAR %s%.0f %.0f%s\n',t2_total*yearidx_analyzed,mon_abbr{1},year_analyzed_start,time_grid_size,time_unit);
fprintf(fid,'VARS %.0f\n',1);
fprintf(fid,'ec %.0f 99 Each (fictitious) level corresponds to one EC.\n',num_modes_out);
fprintf(fid,'ENDVARS\n');
fclose(fid);

disp('gEOF>Output written to:');
disp([outdir,eof_outfile]);
disp([outdir,eof_ctlfile]);
disp([outdir,ec_outfile]);
disp([outdir,ec_ctlfile]);
disp([outdir,pct_expl_file]);
if(do_recon)
disp([outdir,recon_outfile]);
end
disp([outdir,workspace]);
disp('gEOF>Program completed successfully.');

beep;
