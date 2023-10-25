function [H,T,L, SG_H_max, SG_T_Hmax, SG_H_13, SG_T_H13, SG_H_110, SG_T_H110, SG_Tav] = geometrical_parameters_upcrossing(x,d,fs)
g = 9.80655; %#ok<NASGU> % Erdbeschleunigung [m/s2]
if ~isrow(x)
    x = x';
end

zc_x = zero_upcrossing3(x)';

if numel(zc_x) < 2
    H = NaN;
    T = NaN;
    L = NaN;
else
    for j=1:1:numel(zc_x)-1
        wave = x(zc_x(j,1):zc_x(j+1,1)-1); % Einzelwelle
        [aC, ~] = max(wave);  % Maxima der Welle = positive Amplitude
        aT = min(wave); % Minima der Welle = negative Amplitude    
        H = aC + abs(aT); % Wellenhöhe [m]        
        T = numel(wave)/fs; % wave period [s]
        [~,L] = wavelength_mayumi(T,d);        
        
        H_matrix(j) = H; %#ok<AGROW>
        T_matrix(j) = T; %#ok<AGROW>
        L_matrix(j) = L;  %#ok<AGROW>
        
        clear wave aC aT H T L
    end

    H = H_matrix;
    T = T_matrix;
    L = L_matrix;
    
    % max
    [SG_H_max, indxHMAX] = max(H);
    SG_T_Hmax = T(indxHMAX);
    
    [H_sort, indxHSORT] = sort(H);
    T_Hsort = T(indxHSORT);
    % 1/3
    gg13 = ceil(numel(H_sort)*2/3)+1;
    SG_H_13 = mean(H_sort(gg13:end)); % signifikante Wellenhöhe    
    SG_T_H13 = mean(T_Hsort(gg13:end));
    % 1/10
    gg10 = ceil(numel(H_sort)*9/10)+1;
    SG_H_110 = mean(H_sort(gg10:end));
    SG_T_H110 = mean(T_Hsort(gg10:end));
    
    SG_Tav = mean(T);
    

end