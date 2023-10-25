function [bag] = DQC_Test08(bag,I2)

n = 8; % number of segments for each the mean is computed, UNESCO (1993)
P = 0.2; % [m], acceptable difference between two consecutive means (displacement), UNESCO (1993)    
segm_size = floor(numel(bag.Table_RAW_temp.heave)/n);
segm_mean = 1:n; % preallocate vector
for i3 = 1:1:n
    if i3 == n && ~isinteger(numel(bag.Table_RAW_temp.heave)/n)
        segm_mean(i3) = mean(bag.Table_RAW_temp.heave(1+segm_size*(i3-1):end,1),'omitnan');
    else
        segm_mean(i3) = mean(bag.Table_RAW_temp.heave(1+segm_size*(i3-1):segm_size+segm_size*(i3-1),1),'omitnan');
    end
end; clear i3;
%
if any(abs(diff(segm_mean)) >= P)
   bag.Table_RAW_qc0.dqf_heave_08(I2) = 4; % fail
elseif all(abs(diff(segm_mean)) < P)
   bag.Table_RAW_qc0.dqf_heave_08(I2) = 1; % pass   
end
clear segm_size segm_mean  

return