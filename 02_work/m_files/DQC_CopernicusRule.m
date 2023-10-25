function [bag] = DQC_CopernicusRule(bag)

switch upper(bag.s_sensor)
    case 'DWR'        
        % convert to timetable to sync
        temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
        temp_HIS_qc = table2timetable(bag.T_HIS_qc); 

        % *_org_timestamp
        temp_HIW_qc_org_timestamp = temp_HIW_qc.Time;
        temp_HIS_qc_org_timestamp = temp_HIS_qc.Time;

        % syncronize with corresponding start_time
        % because *.his has a timestamp when it was received and *.hiw has
        % a timestamp when measurement startet, temp_HIS_qc needs to be
        % temporarily brought "back" to the corresponding start_time (minus
        % 30 min and then the closest hour or half-hour)
        temp_HIS_qc.Time = dateshift(temp_HIS_qc.Time,'start','minute','nearest'); % dateshift seconds to nearest minute; the original timestamp will be given back before writetable 
        if ~isfield(bag,'CF_indicator')
            temp_HIS_qc.Time.Minute = 30 * floor(temp_HIS_qc.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
            temp_HIS_qc.Time = temp_HIS_qc.Time - duration([00 30 00]);    
        end
        temp_HIW_qc.Time = dateshift(temp_HIW_qc.Time,'start','minute','current'); % dateshift seconds to current minute; the original timestamp will be given back before writetable
        temp_qc = synchronize(temp_HIW_qc,temp_HIS_qc); % syncronize his and hiw
        
        if any((diff(temp_HIS_qc.Time) == 0))
            error('HIS table contains duplicate times. DQC is not possible. Please check data.')   
        end  
        
        % Copernicus Rule: If one main parameter fails, all parameters fail
        % assign flag = 4 for parameters if main parameters are bad
        if any(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VTM01 == 4, temp_qc.fqf_VAVH == 4],2))
            for i = 1:1:size(bag.VarNam_HIW,2)    
                eval(['temp_qc.fqf_' bag.VarNam_HIW{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VTM01 == 4, temp_qc.fqf_VAVH == 4],2)) = 4;'])
            end

            for i = 1:1:size(bag.VarNam_HIS,2)   
                if any(strcmpi(bag.VarNam_HIS{i},{'TEMP'}))
                    continue
                else         
                    eval(['temp_qc.fqf_' bag.VarNam_HIS{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VTM01 == 4, temp_qc.fqf_VAVH == 4],2)) = 4;'])
                end
            end    
        end    
        
        % seperate hiw and his again
        temp_HIW_qc = temp_qc(:,temp_HIW_qc.Properties.VariableNames); % separate his and hiw again
        temp_HIW_qc = rmmissing(temp_HIW_qc); % remove rows with missing values
        temp_HIW_qc.Time = temp_HIW_qc_org_timestamp; % rounded timestamps are replaced with original timestamps
        bag.T_HIW_qc = timetable2table(temp_HIW_qc); % convert back to table

        temp_HIS_qc = temp_qc(:,temp_HIS_qc.Properties.VariableNames); % separate his and hiw again
        temp_HIS_qc = rmmissing(temp_HIS_qc); % remove rows with missing values
        temp_HIS_qc.Time = temp_HIS_qc_org_timestamp; % rounded timestamps are replaced with original timestamps
        bag.T_HIS_qc = timetable2table(temp_HIS_qc); % convert back to table         
             
	case {'RADAC','RADAC_SINGLE'}
        % convert to timetable to sync
        temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
        temp_HIS_qc = table2timetable(bag.T_HIS_qc); 
        temp_LEV_qc = table2timetable(bag.T_LEV_qc); 
        temp_qc0 = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw
        temp_qc = synchronize(temp_qc0,temp_LEV_qc,'union','fillwithmissing'); % syncronize his, hiw and lev
        
        % Copernicus Rule: If one main parameter fails, all parameters fail
        % assign flag = 4 for parameters if main parameters are bad
        if any(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VAVH == 4],2))
            for i = 1:1:size(bag.VarNam_HIW,2)    
                eval(['temp_qc.fqf_' bag.VarNam_HIW{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VAVH == 4],2)) = 4;'])
            end

            for i = 1:1:size(bag.VarNam_HIS,2)   
                if any(strcmpi(bag.VarNam_HIS{i},{'TEMP'}))
                    continue
                else         
                    eval(['temp_qc.fqf_' bag.VarNam_HIS{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VAVH == 4],2)) = 4;'])
                end
            end  
            
            for i = 1:1:size(bag.VarNam_LEV,2)    
                eval(['temp_qc.fqf_' bag.VarNam_LEV{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4, temp_qc.fqf_VAVH == 4],2)) = 4;'])
            end
        end      
        
        % seperate hiw, his and lev again
        temp_HIW_qc = temp_qc(:,temp_HIW_qc.Properties.VariableNames); 
        temp_HIS_qc = temp_qc(:,temp_HIS_qc.Properties.VariableNames); 
        temp_LEV_qc = temp_qc(:,temp_LEV_qc.Properties.VariableNames);
        
        % convert back to table
        bag.T_HIW_qc = timetable2table(temp_HIW_qc); 
        bag.T_HIS_qc = timetable2table(temp_HIS_qc);           
        bag.T_LEV_qc = timetable2table(temp_LEV_qc); 
        
    case 'AWAC'
        
    case 'FINODB'
        if isfield(bag,'T_LEV') 
            % convert to timetable to sync
            temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
            temp_HIS_qc = table2timetable(bag.T_HIS_qc);   
            temp_LEV_qc = table2timetable(bag.T_LEV_qc); 
            % *_org_timestamp
            temp_HIS_qc_org_timestamp = temp_HIS_qc.Time;        
            % syncronize with corresponding start_time
            if bag.CF_indicator == false
                temp_HIS_qc.Time.Minute = 30 * floor(temp_HIS_qc.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
                temp_HIS_qc.Time = temp_HIS_qc.Time - duration([00 30 00]);    
            end        
            temp_qc0 = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his and hiw
            temp_qc = synchronize(temp_qc0,temp_LEV_qc,'union','fillwithmissing'); % syncronize his, hiw and lev

            % Copernicus Rule: If one main parameter fails, all parameters fail
            % assign flag = 4 for parameters if main parameters are bad
            % if available include VHM0, VTPK, VTM02 and VAVH
            if any(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2))
                for i = 1:1:size(bag.VarNam_HIW,2)    
                    eval(['temp_qc.fqf_' bag.VarNam_HIW{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2)) = 4;'])
                end

                for i = 1:1:size(bag.VarNam_HIS,2)   
                    if any(strcmpi(bag.VarNam_HIS{i},{'TEMP'}))
                        continue
                    else         
                        eval(['temp_qc.fqf_' bag.VarNam_HIS{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2)) = 4;'])
                    end
                end  
                
                for i = 1:1:size(bag.VarNam_LEV,2)    
                    eval(['temp_qc.fqf_' bag.VarNam_LEV{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2)) = 4;'])
                end                
            end      

            % seperate hiw, his and lev again
            temp_HIW_qc = temp_qc(:,temp_HIW_qc.Properties.VariableNames); 
            temp_HIW_qc = rmmissing(temp_HIW_qc, 1, 'MinNumMissing', width(bag.T_HIW_qc) - 1 - ((width(bag.T_HIW_qc)-1)/3)); % remove complete rows with missing values
            temp_HIS_qc = temp_qc(:,temp_HIS_qc.Properties.VariableNames); 
            temp_HIS_qc = rmmissing(temp_HIS_qc, 1, 'MinNumMissing', width(bag.T_HIS_qc) - 1 - ((width(bag.T_HIS_qc)-1)/3)); % remove complete rows with missing values
            temp_HIS_qc.Time = temp_HIS_qc_org_timestamp; % timestamps are replaced with original timestamps
            temp_LEV_qc = temp_qc(:,temp_LEV_qc.Properties.VariableNames);
            temp_LEV_qc = rmmissing(temp_LEV_qc, 1, 'MinNumMissing', width(bag.T_LEV_qc) - 1 - ((width(bag.T_LEV_qc)-1)/3)); % remove complete rows with missing values
            
            % convert back to table
            bag.T_HIW_qc = timetable2table(temp_HIW_qc); 
            bag.T_HIS_qc = timetable2table(temp_HIS_qc);   
            bag.T_LEV_qc = timetable2table(temp_LEV_qc); 
            
        else
            % convert to timetable to sync
            temp_HIW_qc = table2timetable(bag.T_HIW_qc); 
            temp_HIS_qc = table2timetable(bag.T_HIS_qc);         
            % *_org_timestamp
            temp_HIS_qc_org_timestamp = temp_HIS_qc.Time;        
            % syncronize with corresponding start_time
            if bag.CF_indicator == false
                temp_HIS_qc.Time.Minute = 30 * floor(temp_HIS_qc.Time.Minute/30); % dateshift time variable to the closest hour or half-hour
                temp_HIS_qc.Time = temp_HIS_qc.Time - duration([00 30 00]);    
            end        
            temp_qc = synchronize(temp_HIW_qc,temp_HIS_qc,'union','fillwithmissing'); % syncronize his, hiw

            % Copernicus Rule: If one main parameter fails, all parameters fail
            % assign flag = 4 for parameters if main parameters are bad
            % if available include VHM0, VTPK, VTM02 and VAVH
            if any(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2))
                for i = 1:1:size(bag.VarNam_HIW,2)    
                    eval(['temp_qc.fqf_' bag.VarNam_HIW{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2)) = 4;'])
                end

                for i = 1:1:size(bag.VarNam_HIS,2)   
                    if any(strcmpi(bag.VarNam_HIS{i},{'TEMP'}))
                        continue
                    else         
                        eval(['temp_qc.fqf_' bag.VarNam_HIS{i} '(any([temp_qc.fqf_VHM0 == 4, temp_qc.fqf_VTPK == 4, temp_qc.fqf_VTM02 == 4],2)) = 4;'])
                    end
                end  
            end      

            % seperate hiw, his and lev again
            temp_HIW_qc = temp_qc(:,temp_HIW_qc.Properties.VariableNames); 
            temp_HIW_qc = rmmissing(temp_HIW_qc, 1, 'MinNumMissing', width(bag.T_HIW_qc) - 1 - ((width(bag.T_HIW_qc)-1)/3)); % remove complete rows with missing values
            temp_HIS_qc = temp_qc(:,temp_HIS_qc.Properties.VariableNames); 
            temp_HIS_qc = rmmissing(temp_HIS_qc, 1, 'MinNumMissing', width(bag.T_HIS_qc) - 1 - ((width(bag.T_HIS_qc)-1)/3)); % remove complete rows with missing values
            temp_HIS_qc.Time = temp_HIS_qc_org_timestamp; % timestamps are replaced with original timestamps

            % convert back to table
            bag.T_HIW_qc = timetable2table(temp_HIW_qc); 
            bag.T_HIS_qc = timetable2table(temp_HIS_qc);           
        end
        
    otherwise
        warning('Unexpected sensor type.')        
end

return