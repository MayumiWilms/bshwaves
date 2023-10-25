function [bag] = DQC_Test10(bag,I2)

switch upper(bag.s_sensor)
    case 'DWR'  
        if any(bag.Table_RAW_temp.status > 1)
            bag.Table_RAW_qc0.dqf_heave_10(I2) = 3; % probably bad, potentially correctable
        elseif all(bag.Table_RAW_temp.status <= 1)
            bag.Table_RAW_qc0.dqf_heave_10(I2) = 1; % pass
        end
    
    case {'RADAC', 'RADAC_SINGLE'}
        % Test is not evaluated because RADAC does not provide a status
        % fill dqf_02_position with flag = 0 (test not evaluated)
        bag.Table_RAW_qc0.dqf_heave_10 = zeros(height(bag.Table_RAW_qc0),1); % not evaluated   
        
    case 'AWAC'
        
    otherwise
        warning('Unexpected sensor type.')     
end

return