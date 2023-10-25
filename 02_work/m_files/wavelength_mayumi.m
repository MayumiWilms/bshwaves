function [k,L] = wavelength_mayumi(T,d)
g = 9.80655;
Ldeep = g.*T.^2/(2*pi); % wave length for deep water [m]
iter = 0;
L1=Ldeep;
Lit=Ldeep*tanh(2*pi*d/L1);
while (abs(Lit-L1)>=0.001 && iter<= 1500)
    L1=Lit;  
    Lit=Ldeep*tanh(2*pi*d/L1);
    iter = iter + 1;
end
L=L1;
k=2*pi/L;
    