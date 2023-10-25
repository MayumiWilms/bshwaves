function [bag] = DQC_Test06(bag,I2)

EPS_HEAVE = bag.metadatabase.EPS_HEAVE(bag.metadatabase.platform_code == bag.s_station); % [m]; instrument minimum

indx = find(abs(diff(bag.Table_RAW_temp.heave)) < EPS_HEAVE);
indx_diff = diff(indx);
pos_fail = strfind(indx_diff',ones(1,10-1));
if isempty(pos_fail)   %#ok<STREMP>
    bag.Table_RAW_qc0.dqf_heave_06(I2) = 1; % pass
else
    bag.Table_RAW_qc0.dqf_heave_06(I2) = 3; % probably bad, potentially correctable
end  
clear indx indx_diff pos_fail

return