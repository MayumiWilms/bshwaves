function [bag] = DQC_Test02(bag)

bag.LATITUDE = bag.metadatabase.LATITUDE(bag.metadatabase.platform_code == bag.s_station);
bag.LONGITUDE = bag.metadatabase.LONGITUDE(bag.metadatabase.platform_code == bag.s_station);
bag.EPS_LAT = bag.metadatabase.EPS_LAT(bag.metadatabase.platform_code == bag.s_station);
bag.EPS_LON = bag.metadatabase.EPS_LON(bag.metadatabase.platform_code == bag.s_station);

switch upper(bag.s_sensor)
    case 'DWR'
        if isfield(bag,'Table_RAW')               
            % raw
            % temp_table = synchronize(Table_RAW_qc0,Table_GPS,'first','fillwithconstant');        
            % Table_RAW_qc0.dqf_02_position = temp_table.dqf_02_position; clear temp_table;        

            % Test is not evaluated here because gps.txt is not read in for now
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.Table_RAW_qc0.dqf_02_position = zeros(height(bag.Table_RAW_qc0),1); % not evaluated
    
        elseif isfield(bag,'Table_SPT')
            % spt
            % temp_table = synchronize(Table_SPT_qc0,Table_GPS,'first','fillwithconstant');        
            % Table_SPT_qc0.dqf_02_position = temp_table.dqf_02_position; clear temp_table;        

            % Test is not evaluated here because gps.txt is not read in for now
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.Table_SPT_qc0.dqf_02_position = zeros(height(bag.Table_SPT_qc0),1); % not evaluated
        elseif isfield(bag,'T_HIS') && contains(bag.s_station,{'HHF','STO'}) % select LKN stations
            % gps
            bag.T_GPS.dqf_02_position = double(and(abs(bag.T_GPS.LATITUDE - bag.LATITUDE) <= bag.EPS_LAT,abs(bag.T_GPS.LONGITUDE - bag.LONGITUDE) <= bag.EPS_LON)); % pass
            bag.T_GPS.dqf_02_position(bag.T_GPS.dqf_02_position==0) = 4; % fail  
            bag.T_GPS.dqf_02_position(any([isnan(bag.T_GPS.LATITUDE),isnan(bag.T_GPS.LONGITUDE)],2)) = 9; % missing value  

            % his
            % fill dqf_02_position with corresponding values from Table_GPS
            temp_table = synchronize(bag.T_HIS,bag.T_GPS,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
            temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
            bag.T_HIS.dqf_02_position = temp_table.dqf_02_position; clear temp_table;            

            % hiw
            % fill dqf_02_position with corresponding values from Table_GPS
            temp_table = synchronize(bag.T_HIW,bag.T_GPS,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
            temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
            bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table;                

        else
            % gps
            bag.T_GPS.dqf_02_position = double(and(abs(bag.T_GPS.LATITUDE - bag.LATITUDE) <= bag.EPS_LAT,abs(bag.T_GPS.LONGITUDE - bag.LONGITUDE) <= bag.EPS_LON)); % pass
            bag.T_GPS.dqf_02_position(bag.T_GPS.dqf_02_position==0) = 4; % fail  
            bag.T_GPS.dqf_02_position(any([isnan(bag.T_GPS.LATITUDE),isnan(bag.T_GPS.LONGITUDE)],2)) = 9; % missing value  

            % his
            % fill dqf_02_position with corresponding values from Table_GPS
            temp_table = synchronize(bag.T_HIS,bag.T_GPS,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
            temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
            bag.T_HIS.dqf_02_position = temp_table.dqf_02_position; clear temp_table;

            % hiw
            if isfield(bag,'CF_indicator')
                if bag.CF_indicator == 1
                    % fill dqf_02_position with corresponding values from Table_GPS
                    % if CF_indicator is true, then T_GPS.Time does not need to be
                    % recalculated to beginning of measurement
                    temp_table = synchronize(bag.T_HIW,bag.T_GPS,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
                    temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
                    bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table;     
                else
                    % fill dqf_02_position with corresponding values from Table_GPS
                    % because *GPS.txt has a timestamp when it was received and *.hiw
                    % has a timestamp when measurement startet, Table_GPS.Time needs to
                    % be temporarily brought "back" to the corresponding start_time
                    % (minus 30 min and then the closest hour or half-hour)
                    T_GPS_tmp = bag.T_GPS;
                    T_GPS_tmp.Time.Minute = 30 * floor(T_GPS_tmp.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
                    T_GPS_tmp.Time = T_GPS_tmp.Time - duration([00 30 00]);            
                    S = timerange(bag.T_HIW.Time(1)-minutes(5),bag.T_HIW.Time(end)+minutes(5));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timerange of Table_HIW    
                    S = withtol(bag.T_HIW.Time, seconds(59));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timestamps close to Table_HIW   
                    temp_table = synchronize(bag.T_HIW, T_GPS_tmp,'first','fillwithmissing');
                    temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
                    bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table T_GPS_tmp;      
                end
            elseif isfield(bag,'waves5_indicator')
                if bag.waves5_indicator == 1
                    % fill dqf_02_position with corresponding values from Table_GPS
                    % because *GPS.txt has a timestamp when it was received and *.hiw
                    % has a timestamp when measurement startet, Table_GPS.Time needs to
                    % be temporarily brought "back" to the corresponding start_time
                    % (minus 30 min)
                    T_GPS_tmp = bag.T_GPS;
                    
                    T_GPS_tmp.Time = T_GPS_tmp.Time - duration([00 30 00]);            
                    S = timerange(bag.T_HIW.Time(1)-minutes(5),bag.T_HIW.Time(end)+minutes(5));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timerange of Table_HIW    
                    S = withtol(bag.T_HIW.Time, seconds(59));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timestamps close to Table_HIW  
                    temp_table = synchronize(bag.T_HIW, T_GPS_tmp,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
                    temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
                    bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table T_GPS_tmp;     
                else
                    % fill dqf_02_position with corresponding values from Table_GPS
                    % because *GPS.txt has a timestamp when it was received and *.hiw
                    % has a timestamp when measurement startet, Table_GPS.Time needs to
                    % be temporarily brought "back" to the corresponding start_time
                    % (minus 30 min and then the closest hour or half-hour)
                    T_GPS_tmp = bag.T_GPS;
                    T_GPS_tmp.Time.Minute = 30 * floor(T_GPS_tmp.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
                    T_GPS_tmp.Time = T_GPS_tmp.Time - duration([00 30 00]);            
                    S = timerange(bag.T_HIW.Time(1)-minutes(5),bag.T_HIW.Time(end)+minutes(5));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timerange of Table_HIW    
                    S = withtol(bag.T_HIW.Time, seconds(59));
                    T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timestamps close to Table_HIW   
                    temp_table = synchronize(bag.T_HIW, T_GPS_tmp,'first','fillwithmissing'); % caution: 'fillwithconstant' 'Constant' '9' creates a bug, instead of '9' -> '57' is created
                    temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
                    bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table T_GPS_tmp;      
                end                
            else
                % fill dqf_02_position with corresponding values from Table_GPS
                % because *GPS.txt has a timestamp when it was received and *.hiw
                % has a timestamp when measurement startet, Table_GPS.Time needs to
                % be temporarily brought "back" to the corresponding start_time
                % (minus 30 min and then the closest hour or half-hour)
                T_GPS_tmp = bag.T_GPS;
                T_GPS_tmp.Time.Minute = 30 * floor(T_GPS_tmp.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
                T_GPS_tmp.Time = T_GPS_tmp.Time - duration([00 30 00]);            
                S = timerange(bag.T_HIW.Time(1)-minutes(5),bag.T_HIW.Time(end)+minutes(5));
                T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timerange of Table_HIW    
                S = withtol(bag.T_HIW.Time, seconds(59));
                T_GPS_tmp = T_GPS_tmp(S,:); clear S; % select timestamps close to Table_HIW   
                temp_table = synchronize(bag.T_HIW, T_GPS_tmp,'first','fillwithmissing');
                temp_table.dqf_02_position(isnan(temp_table.dqf_02_position)) = 9; % missing value  
                bag.T_HIW.dqf_02_position = temp_table.dqf_02_position; clear temp_table T_GPS_tmp;  
            end
        end
        
    case {'RADAC', 'RADAC_SINGLE'}
        
        if isfield(bag,'Table_RAW')      
            % raw
            % Test is not evaluated here because there is no gps.txt 
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.Table_RAW_qc0.dqf_02_position = zeros(height(bag.Table_RAW_qc0),1); % not evaluated            
    
        elseif isfield(bag,'Table_SPT')
            % spt
            % Test is not evaluated here because there is no gps.txt 
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.Table_SPT_qc0.dqf_02_position = zeros(height(bag.Table_SPT_qc0),1); % not evaluated  

        else
            % Test cannot be evaluated because the sensor does not measure gps
            % and it is firmly installed at the platform
            bag.T_GPS.dqf_02_position = zeros(height(bag.T_GPS),1); % not evaluated      
            % his
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.T_HIS.dqf_02_position = zeros(height(bag.T_HIS),1); % not evaluated
            % hiw
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.T_HIW.dqf_02_position = zeros(height(bag.T_HIW),1); % not evaluated 
            % lev
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.T_LEV.dqf_02_position = zeros(height(bag.T_LEV),1); % not evaluated            
        end
            
    case 'AWAC'
        
    case 'FINODB'            
            % Test cannot be evaluated because the sensor does not measure gps
            % and it is firmly installed at the platform
            bag.T_GPS.dqf_02_position = zeros(height(bag.T_GPS),1); % not evaluated      
            % his
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.T_HIS.dqf_02_position = zeros(height(bag.T_HIS),1); % not evaluated
            % hiw
            % fill dqf_02_position with flag = 0 (test not evaluated)
            bag.T_HIW.dqf_02_position = zeros(height(bag.T_HIW),1); % not evaluated         
        
    otherwise
        warning('Unexpected sensor type.')        
end

return