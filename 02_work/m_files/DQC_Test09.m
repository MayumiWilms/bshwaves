function [bag] = DQC_Test09(bag,I2)

d = bag.metadatabase.water_depth(bag.metadatabase.platform_code == bag.s_station); % [m]; instrument minimum
fs = mode(1./seconds(diff(rmmissing(bag.Table_RAW_temp.Time))));
x = detrend(rmmissing(bag.Table_RAW_temp.heave));
[~,Tup] = geometrical_parameters_upcrossing(x,d,fs);
T_max = max(Tup);
if T_max <= 25
    bag.Table_RAW_qc0.dqf_heave_09(I2) = 1; % pass   
else
    bag.Table_RAW_qc0.dqf_heave_09(I2) = 4; % fail   
end
clear fs Tup T_max

return

% fs = numel(bag.Table_RAW_temp.heave)/1800; % [Hz], sampling frequency