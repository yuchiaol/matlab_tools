function [RHO] = MWJF_eos(T,S,Z)

%convert depth in meters to pressure in bars
% Z should be in meters
% the pressure is in bars
pressure = 0.059808*(exp(-0.025*Z) - 1.) + 0.100766*Z + 2.28405e-7*Z^2;
p = 10.*pressure;

p001=0.001;

% these constants will be used to construct the numerator
% factor unit change (kg/m^3 -> g/cm^3) into numerator terms

      mwjfnp0s0t0 =   9.99843699e+2 * p001; 
      mwjfnp0s0t1 =   7.35212840e+0 * p001; 
      mwjfnp0s0t2 =  -5.45928211e-2 * p001; 
      mwjfnp0s0t3 =   3.98476704e-4 * p001; 
      mwjfnp0s1t0 =   2.96938239e+0 * p001; 
      mwjfnp0s1t1 =  -7.23268813e-3 * p001; 
      mwjfnp0s2t0 =   2.12382341e-3 * p001; 
      mwjfnp1s0t0 =   1.04004591e-2 * p001; 
      mwjfnp1s0t2 =   1.03970529e-7 * p001; 
      mwjfnp1s1t0 =   5.18761880e-6 * p001; 
      mwjfnp2s0t0 =  -3.24041825e-8 * p001; 
      mwjfnp2s0t2 =  -1.23869360e-11* p001;

% these constants will be used to construct the denominator
      mwjfdp0s0t0 =   1.0e+0;         
      mwjfdp0s0t1 =   7.28606739e-3;  
      mwjfdp0s0t2 =  -4.60835542e-5;  
      mwjfdp0s0t3 =   3.68390573e-7;  
      mwjfdp0s0t4 =   1.80809186e-10; 
      mwjfdp0s1t0 =   2.14691708e-3;  
      mwjfdp0s1t1 =  -9.27062484e-6;  
      mwjfdp0s1t3 =  -1.78343643e-10; 
      mwjfdp0sqt0 =   4.76534122e-6;  
      mwjfdp0sqt2 =   1.63410736e-9;  
      mwjfdp1s0t0 =   5.30848875e-6;  
      mwjfdp2s0t3 =  -3.03175128e-16; 
      mwjfdp3s0t1 =  -1.27934137e-17;

TQ= T;
SQ = S;
SQR = sqrt(SQ);

% first calculate numerator of MWJF density [P_1(S,T,p)]
      mwjfnums0t0 = mwjfnp0s0t0 + p*(mwjfnp1s0t0 + p*mwjfnp2s0t0);
      mwjfnums0t1 = mwjfnp0s0t1;
      mwjfnums0t2 = mwjfnp0s0t2 + p*(mwjfnp1s0t2 + p*mwjfnp2s0t2);
      mwjfnums0t3 = mwjfnp0s0t3;
      mwjfnums1t0 = mwjfnp0s1t0 + p*mwjfnp1s1t0;
      mwjfnums1t1 = mwjfnp0s1t1;
      mwjfnums2t0 = mwjfnp0s2t0;

      WORK1 = mwjfnums0t0 + TQ * (mwjfnums0t1 + TQ * (mwjfnums0t2 + ...
              mwjfnums0t3 * TQ)) + SQ * (mwjfnums1t0 +              ...
              mwjfnums1t1 * TQ + mwjfnums2t0 * SQ);

% now calculate denominator of MWJF density [P_2(S,T,p)]
      mwjfdens0t0 = mwjfdp0s0t0 + p*mwjfdp1s0t0;
      mwjfdens0t1 = mwjfdp0s0t1 + p^3 * mwjfdp3s0t1;
      mwjfdens0t2 = mwjfdp0s0t2;
      mwjfdens0t3 = mwjfdp0s0t3 + p^2 * mwjfdp2s0t3;
      mwjfdens0t4 = mwjfdp0s0t4;
      mwjfdens1t0 = mwjfdp0s1t0;
      mwjfdens1t1 = mwjfdp0s1t1;
      mwjfdens1t3 = mwjfdp0s1t3;
      mwjfdensqt0 = mwjfdp0sqt0;
      mwjfdensqt2 = mwjfdp0sqt2;

      WORK2 = mwjfdens0t0 + TQ * (mwjfdens0t1 + TQ * (mwjfdens0t2 +  ...  
           TQ * (mwjfdens0t3 + mwjfdens0t4 * TQ))) +                 ...  
           SQ * (mwjfdens1t0 + TQ * (mwjfdens1t1 + TQ*TQ*mwjfdens1t3)+ ...
           SQR * (mwjfdensqt0 + TQ*TQ*mwjfdensqt2));

RHO = 1./WORK2*WORK1;

