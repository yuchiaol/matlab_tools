function ExF=extend(F,lag_size,lag1,lag2)
%Extend the given matrix with specified lags.
%
%Usage: ExF=extend(F,lag_size,lag1,lag2)
%       ExF: extended matrix.
%       F: input matrix.
%       lag_size: lag size. A nondimensional number.
%       lag1: # of lags before. A supposedly (though not necessarily) negative number.
%       lag2: # of lags after. A supposedly (though not necessarily) positive number.
%
%Copyright (C) 2004 Bin Guan. Distributed under GNU/GPL.

F_size=size(F);
ExF=[];
lag_total=lag2-lag1+1;
for lag=0:lag_total-1
  begin_row=1+lag*lag_size;
  end_row=F_size(1)-(lag_total-1)*lag_size+lag*lag_size;
  ExF=[ExF,F(begin_row:end_row,:)];
end
