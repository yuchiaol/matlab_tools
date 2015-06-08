function newF=deseason(F,num_t_yearly,clim_year_start,clim_year_end)
% $Id: deseason.m,v 1.1 2011/10/13 23:57:17 bguan Exp $
%This script removes the seasonal cycle in field "F" to facilitate EOF
%analysis. Data in "F" must be stored in such a way that month (time)
%varies along the first dimension, e.g.,
%(Jan2000, Grid 1) (Jan2000, Grid 2) (Jan2000, Grid 3)
%(Feb2000, Grid 1) (Feb2000, Grid 2) (Feb2000, Grid 3)
%...
%(Dec2000, Grid 1) (Dec2000, Grid 2) (Dec2000, Grid 3)
%(Jan2001, Grid 1) (Jan2001, Grid 2) (Jan2001, Grid 3)
%(Feb2001, Grid 1) (Feb2001, Grid 2) (Feb2001, Grid 3)
%...
%(Dec2001, Grid 1) (Dec2001, Grid 2) (Dec2001, Grid 3)
%
%Usage: NEWF=DESEASON(F,NUM_T_YEARLY,CLIM_YEAR_START,CLIM_YEAR_END)
%       NEWF: deseasoned field.
%       F: original field. F MUST contain complete calendar years.
%       NUM_T_YEARLY: number of time grids each year.
%       CLIM_YEAR_START (optional): beginning year for definition of climotology. Defaults to first year.
%       CLIM_YEAR_END (optional): ending year for definition of climotology. Defaults to last year.
%
%Copyright (C) 2003 Bin Guan. Distributed under GNU/GPL.
[n,m]=size(F);
num_years=n/num_t_yearly;

if(nargin==2)
clim_year_start=1;
clim_year_end=num_years;
elseif(nargin==3)
clim_year_end=num_years;
end

FF=reshape(F,[num_t_yearly,num_years,m]);
season=nanmean(FF(:,clim_year_start:clim_year_end,:),2);
season=repmat(season,[1,num_years,1]);
season=reshape(season,[n,m]);
newF=F-season;
