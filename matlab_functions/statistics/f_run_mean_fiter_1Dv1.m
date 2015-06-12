function [ data_run_mean] = f_run_mean_filter_1Dv1( data_raw, year_run, cutoff, filter)
%% fuction for running mean with selective filters
% function [ data_run_mean] = f_run_mean_filter_1D( data_raw, year_run, cutoff, filter_type)
% input = data_raw: Tx1 vector(T:time), year: *year-mean (integer)
%         cutoff: cutoff period in Integer (zero w/o cutoff)
%         filter: 'hpf': high pass filter, 'lpf': low pass filter(default)
% output = data_run_mean: Tx1 running mean matrix
% note that end grid padded with zero for the running mean

format long

%% 
if size(data_raw,2)> 1
    data_raw=data_raw'; %1xT to Tx1
end    

%% determine coefficient 
%parameter
%number of the point for running mean
if mod(year_run,2)==0
    npt= year_run+1; %odd for filter
else
    npt= year_run;
end

%cutoff frequency 
ncut= cutoff;

if strcmp(filter,'hpf')==1 %default : low pass filter    
    %% high pass filter
    hhp= zeros(npt,1);
    whp= zeros(npt,1);
    chp= zeros(npt,1); %coefficient
    
    h00= 1-2/ncut;
    h01= ncut/2;
    w00= npt-1;
    
    %Hamming window
    for i=1:npt
        n= floor(i-(npt+1)/2);
        
        if n ~= 0
            hhp(i)= (sin(pi*n)-sin(pi*n/h01))/(pi*n);
        else            
            hhp(i)= h00;
        end
        
        whp(i)= 0.54+0.46*cos(2*pi*n/w00);
        chp(i)= hhp(i)*whp(i); %coefficient        
    end
    cflt= chp;
   
else
    %% low pass filter
    hlp= zeros(npt,1);
    wlp= zeros(npt,1);
    clp= zeros(npt,1); %coefficient
    
    hl0= 2/ncut;
    hl1= ncut/2;
    w00= npt-1;
    
    %Hamming window
    for i=1:npt
        n= floor(i-(npt+1)/2);
        
        if n ~= 0
            hlp(i)= sin(pi*n/hl1)/(pi*n);
        else
            hlp(i)= hl0;
        end
        
        wlp(i)= 0.54+0.46*cos(2*pi*n/w00);
        clp(i)= hlp(i)*wlp(i);
    end  
    cflt= clp;
end

%running mean without filtering if cutoff=0
if ncut ==0
    cflt(:)= 1/size(zeros(npt,1),1);
end
             
%% running mean including filter 
% dimensions
tim_T= size(data_raw,1); %time
% 
%half of the window
yr_indx= floor(year_run/2); 
%
%running mean
data_run_mean= zeros(tim_T,1);

data_add_start =zeros(1,1);
data_add_end =zeros(1,1);
data_tim= data_raw;

%add 1st and end element to calculate for zero
data_add_start(1:yr_indx,1)= 0; 
data_add_end(1:yr_indx,1)= 0;
data_tim= [data_add_start;  data_tim;  data_add_end]; %patch 1st and last element

%compute running mean
for i=1+yr_indx:size(data_tim,1)-yr_indx
    data_run_mean(i-yr_indx,1)= sum( data_tim(i-yr_indx:i+yr_indx).*cflt);
end 

end
      
            
