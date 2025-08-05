function [bag] = DQC_rmdate(bag)
    
switch upper(bag.s_sensor)
    case 'DWR'
        if contains(bag.s_station,{'HHF','STO','SEE'}) % select LKN and NLWKN stations
        else
            %% save the original
            bag.T_HIS_cmplt = bag.T_HIS;
            bag.T_HIS_orgtme_cmplt = bag.T_HIS_orgtme;
            bag.T_GPS_cmplt = bag.T_GPS;
            bag.T_GPS_orgtme_cmplt = bag.T_GPS_orgtme;
            
            %% sync
            temp_HIS = bag.T_HIS; 
            temp_HIS_org_timestamp = temp_HIS.Time;
            temp_HIS.Time = dateshift(temp_HIS.Time,'start','minute','nearest'); % dateshift seconds to nearest minute; the original timestamp will be given back before writetable 
            temp_HIS.Time.Minute = 30 * floor(temp_HIS.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
            temp_HIS.Time = temp_HIS.Time - duration([00 30 00]);    
    
            %% find problematic timestamps 
            indx = find((diff(temp_HIS.Time) == 0));
            tmstmps = temp_HIS_org_timestamp([indx;indx+1]);
    
            %% remove all problematic timestamps    
            bag.T_HIS(ismember(bag.T_HIS.Time, tmstmps),:) = [];
            bag.T_HIS_orgtme = bag.T_HIS.Time;
    
            bag.T_GPS(ismember(bag.T_GPS.Time, tmstmps),:) = [];
            bag.T_GPS_orgtme = bag.T_GPS.Time;
            
            bag.tmstmps = tmstmps;
    
            %% display warning and create logfile 
            if ~isempty(indx)
                diff_timestampe = numel(bag.T_HIS_orgtme_cmplt) - numel(bag.T_HIS_orgtme);
                            
                log_file = fullfile(bag.s_log_folder,['tmc_check_dwr_' bag.s_station '_log.txt']); 
                if exist(log_file,'file')
                    delete(log_file)
                end
                errorMessage = ['There are problematic timestamps in *.his for DWR station ' bag.s_station ' starting from ' datestr(tmstmps(1)) '. ' num2str(diff_timestampe) ' measurements are concerned.'];
                WarnUser(errorMessage,log_file)
            end
        end
end

return