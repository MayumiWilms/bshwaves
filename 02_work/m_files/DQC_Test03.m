function [bag] = DQC_Test03(bag)

if isfield(bag,'Table_RAW')     
    bag.Table_RAW_qc0.dqf_03_compl_raw = bag.Table_RAW_dqf_03.dqf_03_compl_raw; % corresponding flag is handed over
    
elseif isfield(bag,'Table_SPT')
    bag.Table_SPT_qc0.dqf_03_compl_spt = bag.Table_SPT_dqf_03.dqf_03_compl_spt; % corresponding flag is handed over
    
else
    bag.T_HIS.dqf_03_compl_his = double(all(~ismissing(bag.T_HIS),2)); % pass
    bag.T_HIW.dqf_03_compl_hiw = double(all(~ismissing(bag.T_HIW),2)); % pass
    bag.T_GPS.dqf_03_compl_gps = double(all(~ismissing(bag.T_GPS),2)); % pass     

    bag.T_HIS.dqf_03_compl_his(bag.T_HIS.dqf_03_compl_his==0) = 4; % fail
    bag.T_HIW.dqf_03_compl_hiw(bag.T_HIW.dqf_03_compl_hiw==0) = 4; % fail
    bag.T_GPS.dqf_03_compl_gps(bag.T_GPS.dqf_03_compl_gps==0) = 4; % fail    
    
    if isfield(bag,'T_LEV') 
        bag.T_LEV.dqf_03_compl_lev = double(all(~ismissing(bag.T_LEV),2)); % pass
        bag.T_LEV.dqf_03_compl_lev(bag.T_LEV.dqf_03_compl_lev==0) = 4; % fail
    end    
end

switch upper(bag.s_sensor)
    case 'DWR'
    
    case {'RADAC', 'RADAC_SINGLE'}  
        % if radac controler did not store the whole parameter set
        %{
        bag.T_HIS.dqf_03_compl_his(bag.T_HIS.dqf_03_compl_his==4) = 2; % probably good
        bag.T_HIW.dqf_03_compl_hiw(bag.T_HIW.dqf_03_compl_hiw==4) = 2; % probably good
        bag.T_GPS.dqf_03_compl_gps(bag.T_GPS.dqf_03_compl_gps==4) = 2; % probably good   
        bag.T_LEV.dqf_03_compl_lev(bag.T_LEV.dqf_03_compl_lev==4) = 2; % probably good
        %}
        
    case 'AWAC'
        
    case 'FINODB' 
        bag.T_HIS.dqf_03_compl_his(bag.T_HIS.dqf_03_compl_his==4) = 2; % probably good
        bag.T_HIW.dqf_03_compl_hiw(bag.T_HIW.dqf_03_compl_hiw==4) = 2; % probably good
        bag.T_GPS.dqf_03_compl_gps(bag.T_GPS.dqf_03_compl_gps==4) = 2; % probably good   
        if isfield(bag,'T_LEV') 
            bag.T_LEV.dqf_03_compl_lev(bag.T_LEV.dqf_03_compl_lev==4) = 2; % probably good       
        end          
        
    otherwise
        warning('Unexpected sensor type.')     
end

return