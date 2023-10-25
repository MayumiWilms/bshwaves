function [bag] = DQC_Test04(bag,I2)

switch upper(bag.s_sensor)
    case 'DWR' 
        heave = bag.Table_RAW_temp.heave;
        [Flag,despiked] = SpikeTest_QARTOD(heave); 
        % % Moving window method by Wilms
        % fs = numel(bag.Table_RAW_temp.heave)/1800; % [Hz], sampling frequency
        % [Flag,despiked,~,~,~] = SpikeTest_Mayumi(bag.Table_RAW_temp.heave,M,fs);
        bag.Table_RAW_qc0.dqf_heave_04(I2) = Flag;   
        bag.Table_RAW_temp.despiked = despiked;    
        bag.Table_despiked = [bag.Table_despiked; bag.Table_RAW_temp(:,'despiked')];  

    case {'RADAC', 'RADAC_SINGLE'}
        heave = detrend(rmmissing(bag.Table_RAW_temp.heave));
        [Flag,~] = SpikeTest_QARTOD(heave); 
        % % Moving window method by Wilms
        % fs = numel(bag.Table_RAW_temp.heave)/1800; % [Hz], sampling frequency
        % [Flag,despiked,~,~,~] = SpikeTest_Mayumi(bag.Table_RAW_temp.heave,M,fs);
        bag.Table_RAW_qc0.dqf_heave_04(I2) = Flag;   
        
    case 'AWAC'        
        
    otherwise
        warning('Unexpected sensor type.')
end    

clear Flag despiked   

return