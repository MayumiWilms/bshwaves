function [bag] = DQC_Test16(bag) 

switch upper(bag.s_sensor)
    case 'DWR'
        bag.T_HIS.dqf_VTPK_16 = double(bag.T_HIS.VTPK >= bag.T_HIS.VTM02); % pass
        bag.T_HIS.dqf_VTM02_16 = double(and(bag.T_HIS.VTM02 <= bag.T_HIS.VTPK,bag.T_HIS.VTM02 >= bag.T_HIS.VTM24)); % pass
        bag.T_HIS.dqf_VTM24_16 = double(bag.T_HIS.VTM02 >= bag.T_HIS.VTM24); % pass

        if contains(bag.s_station,{'HHF','STO'}) % select LKN stations
            % for low sea states computation of VTPK is error-prone
            bag.T_HIS.dqf_VTPK_16(and(bag.T_HIS.dqf_VTPK_16==0,bag.T_HIS.VHM0 <= 0.25)) = 3; % probably bad
            bag.T_HIS.dqf_VTM02_16(and(bag.T_HIS.dqf_VTM02_16==0,bag.T_HIS.VHM0 <= 0.25)) = 3; % probably bad
            bag.T_HIS.dqf_VTM24_16(and(bag.T_HIS.dqf_VTM24_16==0,bag.T_HIS.VHM0 <= 0.25)) = 3; % probably bad          

            bag.T_HIS.dqf_VTPK_16(bag.T_HIS.dqf_VTPK_16==0) = 4; % fail
            bag.T_HIS.dqf_VTM02_16(bag.T_HIS.dqf_VTM02_16==0) = 4; % fail
            bag.T_HIS.dqf_VTM24_16(bag.T_HIS.dqf_VTM24_16==0) = 4; % fail
        else
            bag.T_HIS.dqf_VTPK_16(bag.T_HIS.dqf_VTPK_16==0) = 4; % fail
            bag.T_HIS.dqf_VTM02_16(bag.T_HIS.dqf_VTM02_16==0) = 4; % fail
            bag.T_HIS.dqf_VTM24_16(bag.T_HIS.dqf_VTM24_16==0) = 4; % fail
        end

        for i = 1:1:size(bag.VarNam_HIW,2)
            % parameters which are not tested get flag 0 = value not evaluated
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16 = zeros(height(bag.T_HIW),1);'])    
        end

        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02','VTM24'}))
                continue
            else        
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16 = zeros(height(bag.T_HIS),1);'])
            end
        end
    
    case {'RADAC', 'RADAC_SINGLE'}
        bag.T_HIS.dqf_VTPK_16 = double(bag.T_HIS.VTPK >= bag.T_HIS.VTM02); % pass
        bag.T_HIS.dqf_VTM02_16 = double(bag.T_HIS.VTM02 <= bag.T_HIS.VTPK); % pass

        bag.T_HIS.dqf_VTPK_16(bag.T_HIS.dqf_VTPK_16==0) = 4; % fail
        bag.T_HIS.dqf_VTM02_16(bag.T_HIS.dqf_VTM02_16==0) = 4; % fail

        bag.T_HIS.dqf_VTPK_16(isnan(bag.T_HIS.VTPK)) = 9; % missing value
        bag.T_HIS.dqf_VTM02_16(isnan(bag.T_HIS.VTM02)) = 9; % missing value        
        bag.T_HIS.dqf_VTPK_16(isnan(bag.T_HIS.VTM02)) = 0; % value cannot be evaluated
        bag.T_HIS.dqf_VTM02_16(isnan(bag.T_HIS.VTPK)) = 0; % value cannot be evaluated    

        bag.T_HIS.dqf_VTPK_16(ismissing(bag.T_HIS.VTPK,-9999.000)) = 4; % fail
        bag.T_HIS.dqf_VTM02_16(ismissing(bag.T_HIS.VTM02,-9999.000)) = 4; % fail
        
        for i = 1:1:size(bag.VarNam_HIW,2)
            % parameters which are not tested get flag 0 = value not evaluated
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16 = zeros(height(bag.T_HIW),1);'])  
            % if value is nan, flag = 9
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
            % if value is -9999.000, flag = 4
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16(ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % fail'])
        end
        
        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02'}))
                continue
            else        
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16 = zeros(height(bag.T_HIS),1);'])
                % if value is nan, flag = 9
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])
                % if value is -9999.000, flag = 4
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16(ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % fail'])
            end
        end        
        
        for i = 1:1:size(bag.VarNam_LEV,2)
            % parameters which are not tested get flag 0 = value not evaluated
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16 = zeros(height(bag.T_LEV),1);'])  
            % if value is nan, flag = 9
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])
            % if value is -9999.000, flag = 4
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])
        end        
            
    case 'AWAC'
        
    case 'FINODB'
        bag.T_HIS.dqf_VTPK_16 = double(bag.T_HIS.VTPK >= bag.T_HIS.VTM02); % pass
        bag.T_HIS.dqf_VTM02_16 = double(bag.T_HIS.VTM02 <= bag.T_HIS.VTPK); % pass

        bag.T_HIS.dqf_VTPK_16(bag.T_HIS.dqf_VTPK_16==0) = 4; % fail
        bag.T_HIS.dqf_VTM02_16(bag.T_HIS.dqf_VTM02_16==0) = 4; % fail

        bag.T_HIS.dqf_VTPK_16(isnan(bag.T_HIS.VTPK)) = 9; % missing value
        bag.T_HIS.dqf_VTM02_16(isnan(bag.T_HIS.VTM02)) = 9; % missing value
        bag.T_HIS.dqf_VTPK_16(isnan(bag.T_HIS.VTM02)) = 0; % value cannot be evaluated
        bag.T_HIS.dqf_VTM02_16(isnan(bag.T_HIS.VTPK)) = 0; % value cannot be evaluated        
        
        for i = 1:1:size(bag.VarNam_HIW,2)
            % parameters which are not tested get flag 0 = value not evaluated
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16 = zeros(height(bag.T_HIW),1);'])  
            % if value is nan, flag = 9
            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_16(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
        end
        
        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VTPK','VTM02'}))
                continue
            else        
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16 = zeros(height(bag.T_HIS),1);'])
                % if value is nan, flag = 9
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_16(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])
            end
        end        
        
        if isfield(bag,'T_LEV') 
            for i = 1:1:size(bag.VarNam_LEV,2)
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16 = zeros(height(bag.T_LEV),1);'])  
                % if value is nan, flag = 9
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])
                % if value is -9999.000, flag = 4
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_16(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])
            end        
        end
        
    otherwise
        warning('Unexpected sensor type.')        
end    

return