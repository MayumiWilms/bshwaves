function [bag] = DQC_Test01(bag)

bag.tlower = datetime(bag.metadatabase.tlower(bag.metadatabase.platform_code == bag.s_station),'TimeZone','UTC');
if isfield(bag,'CF_indicator') 
    if bag.CF_indicator == 1
        bag.tupper = datetime(bag.metadatabase.tupper(bag.metadatabase.platform_code == bag.s_station),'TimeZone','UTC');
    else
        bag.tupper = bag.date_to_x;
    end
else
    bag.tupper = bag.date_to_x;
end

if isfield(bag,'Table_RAW')     
    bag.Table_RAW_qc0.dqf_01_date_raw = double(isbetween(bag.Table_RAW_qc0.Time,bag.tlower,bag.tupper)); % pass
    bag.Table_RAW_qc0.dqf_01_date_raw(bag.Table_RAW_qc0.dqf_01_date_raw==0) = 4; % fail      
    
elseif isfield(bag,'Table_SPT')
    bag.Table_SPT_qc0.dqf_01_date_spt = double(isbetween(bag.Table_SPT_qc0.Time,bag.tlower,bag.tupper)); % pass
    bag.Table_SPT_qc0.dqf_01_date_spt(bag.Table_SPT_qc0.dqf_01_date_spt==0) = 4; % fail         
    
else
    bag.T_HIW.dqf_01_date_hiw = double(isbetween(bag.T_HIW.Time,bag.tlower,bag.tupper)); % pass
    bag.T_HIS.dqf_01_date_his = double(isbetween(bag.T_HIS.Time,bag.tlower,bag.tupper)); % pass
    bag.T_GPS.dqf_01_date_gps = double(isbetween(bag.T_GPS.Time,bag.tlower,bag.tupper)); % pass

    bag.T_HIW.dqf_01_date_hiw(bag.T_HIW.dqf_01_date_hiw==0) = 4; % fail
    bag.T_HIS.dqf_01_date_his(bag.T_HIS.dqf_01_date_his==0) = 4; % fail
    bag.T_GPS.dqf_01_date_gps(bag.T_GPS.dqf_01_date_gps==0) = 4; % fail
    
    if isfield(bag,'T_LEV') 
        bag.T_LEV.dqf_01_date_lev = double(isbetween(bag.T_LEV.Time,bag.tlower,bag.tupper)); % pass
        bag.T_LEV.dqf_01_date_lev(bag.T_LEV.dqf_01_date_lev==0) = 4; % fail        
    end    
end

return