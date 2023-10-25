function [bag] = DQC_Test12(bag) 

for i = 1:1:size(bag.VarNam_HIW,2)
    eval(['' bag.VarNam_HIW{i} 'MIN = bag.metadatabase.' bag.VarNam_HIW{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIW{i} 'MAX = bag.metadatabase.' bag.VarNam_HIW{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_12 = double(and(bag.T_HIW.' bag.VarNam_HIW{i} ' >= ' bag.VarNam_HIW{i} 'MIN,bag.T_HIW.' bag.VarNam_HIW{i} ' <= ' bag.VarNam_HIW{i} 'MAX)); % pass'])
    % if test failed, flag = 4
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_12(bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_12==0) = 4; % fail'])
    % if value is nan, flag = 9
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_12(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])    
end

for i = 1:1:size(bag.VarNam_HIS,2)
    eval(['' bag.VarNam_HIS{i} 'MIN = bag.metadatabase.' bag.VarNam_HIS{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIS{i} 'MAX = bag.metadatabase.' bag.VarNam_HIS{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_12 = double(and(bag.T_HIS.' bag.VarNam_HIS{i} ' >= ' bag.VarNam_HIS{i} 'MIN,bag.T_HIS.' bag.VarNam_HIS{i} ' <= ' bag.VarNam_HIS{i} 'MAX)); % pass'])
    % if test failed, flag = 4
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_12(bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_12==0) = 4; % fail'])
    % if value is nan, flag = 9
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_12(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])   
end

if isfield(bag,'T_LEV') 
    for i = 1:1:size(bag.VarNam_LEV,2)
        eval(['' bag.VarNam_LEV{i} 'MIN = bag.metadatabase.' bag.VarNam_LEV{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
        eval(['' bag.VarNam_LEV{i} 'MAX = bag.metadatabase.' bag.VarNam_LEV{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_12 = double(and(bag.T_LEV.' bag.VarNam_LEV{i} ' >= ' bag.VarNam_LEV{i} 'MIN,bag.T_LEV.' bag.VarNam_LEV{i} ' <= ' bag.VarNam_LEV{i} 'MAX)); % pass'])
        % if test failed, flag = 4
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_12(bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_12==0) = 4; % fail'])
        % if value is nan, flag = 9
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_12(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])   
    end
end   

return