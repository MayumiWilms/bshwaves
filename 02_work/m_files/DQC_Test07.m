function [bag] = DQC_Test07(bag,I2)

diff_x = diff(bag.Table_RAW_temp.heave);
diff_t = seconds(diff(bag.Table_RAW_temp.Time));
grad_xt = [diff_x ./ diff_t; 0] ;
grad_xt = rmmissing(grad_xt);
if any(abs(grad_xt) > 6)
    bag.Table_RAW_qc0.dqf_heave_07(I2) = 3; % probably bad, potentially correctable
elseif all(abs(grad_xt) <= 6)
    bag.Table_RAW_qc0.dqf_heave_07(I2) = 1; % pass
end           
clear diff_x diff_t grad_xt
    
return