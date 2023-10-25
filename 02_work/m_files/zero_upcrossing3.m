function [upcrossing] = zero_upcrossing3(data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [upcrossing, downcrossing] = zero_crossing(data)
% Find indices of zero upcrossings and downcrossings in dataset "data".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(data);
data(find(abs(data) < max(abs(data))*1e-3)) = 0;

upcrossing = []; 
downcrossing = []; 

if data(1) ~=0
   if sign(data(2))-sign(data(1)) >  1; upcrossing   = [upcrossing,   2]; end
   if sign(data(2))-sign(data(1)) < -1; downcrossing = [downcrossing, 2]; end
end

for i=2:N-1
   if data(i)==0
      if     sign(data(i+1))-sign(data(i-1)) > 1
         upcrossing = [upcrossing, i+1];
      elseif sign(data(i+1))-sign(data(i-1)) < -1
         downcrossing = [downcrossing, i+1];
      end
   else
      if     sign(data(i+1))-sign(data(i)) > 1
         upcrossing = [upcrossing, i+1];
      elseif sign(data(i+1))-sign(data(i)) < -1
         downcrossing = [downcrossing, i+1];
      end
   end
end


return;