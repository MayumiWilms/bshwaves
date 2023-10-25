function [bag] = DQC_Test05(bag,I2)
    
if isfield(bag,'Table_RAW') 
    IMIN = bag.metadatabase.IMIN(bag.metadatabase.platform_code == bag.s_station); % [m]; instrument minimum
    IMAX = bag.metadatabase.IMAX(bag.metadatabase.platform_code == bag.s_station); % [m]; instrument maximum
    LMIN = bag.metadatabase.LMIN(bag.metadatabase.platform_code == bag.s_station); % [m]; local minimum, location- and/or season dependent
    LMAX = bag.metadatabase.LMAX(bag.metadatabase.platform_code == bag.s_station); % [m]; local maximum, location- and/or season dependent, Hmax ca. 21
    
    switch upper(bag.s_sensor)
        case 'DWR'     
            heave = bag.Table_RAW_temp.heave;
            
        case {'RADAC', 'RADAC_SINGLE'}
            heave = bag.Table_RAW_temp.heave;
            heave = detrend(rmmissing(heave));
            
        case 'AWAC'
            
        otherwise
            warning('Unexpected sensor type.')     
    end
    
    if min(heave) < IMIN || max(heave) > IMAX
        bag.Table_RAW_qc0.dqf_heave_05(I2) = 4; % fail
    elseif min(heave) < LMIN || max(heave) > LMAX
        bag.Table_RAW_qc0.dqf_heave_05(I2) = 3; % probably bad, potentially correctable
    elseif min(heave) >= LMIN && max(heave) <= LMAX
        bag.Table_RAW_qc0.dqf_heave_05(I2) = 1; % pass
    end        

elseif isfield(bag,'Table_SPT')
%     VHM0MAX = bag.metadatabase.VHM0MAX(bag.metadatabase.platform_code == bag.s_station); % [m]
%     m0MAX = (VHM0MAX/4)^2; % [m^2]; maximum total energy of the scalar spectrum
%     
%     m0 = sum(bag.Table_SPEC_temp.Sf .* bag.Table_SPEC_temp.df); % [m^2]; total measured power spectrum
%       
%     bag.Table_SPT_qc0.dqf_Sf_05(bag.Table_SPT_dqf_03.Time(I2))  = double(m0 <= m0MAX); % pass   
%     bag.Table_SPT_qc0.dqf_Sf_05(bag.Table_SPT_qc0.dqf_Sf_05==0) = 4; % fail
% 
%     clear m0;
end

return