function [bag] = DQC_Test14(bag)

% double loop - faster, but first 24 hours (date_from_x) does not get "0"
% as it should, instead those times will be neglected in DQC_FinalQC
% (date_from)
% instead of taking indx to find flat lines, the parameter itself is taken;
% if parameter does not start with a flat line, the first measurement will
% be falsely detected as a flat line, but will be neglected in DQC_FinalQC
% (date_from)
timespan24 = duration([24 00 00]);

for i = 1:1:size(bag.VarNam_HIW,2)
    if any(strcmpi(bag.VarNam_HIW{i},{'VZNW'}))
        % parameters which are not tested get flag 0 = value not evaluated
        eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14 = zeros(height(bag.T_HIW),1);'])
        continue
    end
    eval(['EPS_' bag.VarNam_HIW{i} ' = bag.metadatabase.EPS_' bag.VarNam_HIW{i} '(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIW{i} 'MIN = bag.metadatabase.' bag.VarNam_HIW{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIW{i} 'MAX = bag.metadatabase.' bag.VarNam_HIW{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['indx = unique(sort([find(abs(diff(bag.T_HIW.' bag.VarNam_HIW{i} ')) < EPS_' bag.VarNam_HIW{i} '); find(abs(diff(bag.T_HIW.' bag.VarNam_HIW{i} ')) < EPS_' bag.VarNam_HIW{i} ') + 1]));'])
    
    % pre-allocation
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14 = ones(height(bag.T_HIW),1); % pass']) 
    % if value is nan, flag = 9
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
    % if value is -9999.000, flag = 4
    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14(ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % fail'])  
    
    if isempty(indx) % no flat lines
        clear indx
        continue     
    else
        eval(['indx2 = find([0;abs(diff(bag.T_HIW.' bag.VarNam_HIW{i} '))<EPS_' bag.VarNam_HIW{i} '] < 1);'])
        eval(['indx3 = [find( (abs(diff(bag.T_HIW.' bag.VarNam_HIW{i} '))<EPS_' bag.VarNam_HIW{i} ') < 1); height(bag.T_HIW)];'])
        
        for k = 1:1:size(indx2,1)
            s_t = size(bag.T_HIW.Time(timerange(bag.T_HIW.Time(indx3(k))-timespan24, bag.T_HIW.Time(indx3(k)),'openleft')),1);        
            s_flat = size(bag.T_HIW.Time(timerange(bag.T_HIW.Time(indx2(k)), bag.T_HIW.Time(indx3(k)),'closed')),1);             
            if s_flat >= s_t                   
                T_HIW_temp = bag.T_HIW(timerange(bag.T_HIW.Time(indx2(k)), bag.T_HIW.Time(indx3(k)),'closed'),:);
                if height(T_HIW_temp) == 1 % measurement does not start with a flat line
                    continue
                else
                    if eval(['(size((T_HIW_temp.' bag.VarNam_HIW{i} ' > 0.0),1) > 0.5*height(T_HIW_temp)) && all(T_HIW_temp.' bag.VarNam_HIW{i} ' >= ' bag.VarNam_HIW{i} 'MIN) && all(T_HIW_temp.' bag.VarNam_HIW{i} ' <= ' bag.VarNam_HIW{i} 'MAX)'])
                        eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_14 = 4*ones(height(T_HIW_temp),1); % fail'])
                    else
                        eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_14 = ones(height(T_HIW_temp),1); % pass'])
                    end 
                    % if value is nan, flag = 9
                    eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_14(isnan(T_HIW_temp.' bag.VarNam_HIW{i} ')) = 9; % missing value'])    
                    % if value is -9999.000, flag = 4
                    eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_14(ismissing(T_HIW_temp.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % fail'])                 

                    table_temp = synchronize(bag.T_HIW, T_HIW_temp,'first','fillwithmissing'); %#ok<NASGU>
                    eval(['table_temp.dqf_' bag.VarNam_HIW{i} '_14_2(isnan(table_temp.dqf_' bag.VarNam_HIW{i} '_14_2)) = table_temp.dqf_' bag.VarNam_HIW{i} '_14_1(isnan(table_temp.dqf_' bag.VarNam_HIW{i} '_14_2));'])
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14 = table_temp.dqf_' bag.VarNam_HIW{i} '_14_2; clear *temp;'])

                    % if value is nan, flag = 9
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])    
                    % if value is -9999.000, flag = 4
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_14(ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % fail'])  
                end
            else
                continue
            end      
            clear s_t s_flat
        end 
        
        clear indx*
    end
end

for i = 1:1:size(bag.VarNam_HIS,2)
    eval(['EPS_' bag.VarNam_HIS{i} ' = bag.metadatabase.EPS_' bag.VarNam_HIS{i} '(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIS{i} 'MIN = bag.metadatabase.' bag.VarNam_HIS{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['' bag.VarNam_HIS{i} 'MAX = bag.metadatabase.' bag.VarNam_HIS{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
    eval(['indx = unique(sort([find(abs(diff(bag.T_HIS.' bag.VarNam_HIS{i} ')) < EPS_' bag.VarNam_HIS{i} '); find(abs(diff(bag.T_HIS.' bag.VarNam_HIS{i} ')) < EPS_' bag.VarNam_HIS{i} ') + 1]));'])
        
    % pre-allocation
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14 = ones(height(bag.T_HIS),1); % pass']) 
    % if value is nan, flag = 9
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])
    % if value is -9999.000, flag = 4
    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14(ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % fail'])  
    
    if isempty(indx) % no flat lines
        clear indx
        continue     
    else        
        eval(['indx2 = find([0;abs(diff(bag.T_HIS.' bag.VarNam_HIS{i} '))<EPS_' bag.VarNam_HIS{i} '] < 1);'])
        eval(['indx3 = [find( (abs(diff(bag.T_HIS.' bag.VarNam_HIS{i} '))<EPS_' bag.VarNam_HIS{i} ') < 1); height(bag.T_HIS)];'])
        
        for k = 1:1:size(indx2,1)
            s_t = size(bag.T_HIS.Time(timerange(bag.T_HIS.Time(indx3(k))-timespan24, bag.T_HIS.Time(indx3(k)),'openleft')),1);        
            s_flat = size(bag.T_HIS.Time(timerange(bag.T_HIS.Time(indx2(k)), bag.T_HIS.Time(indx3(k)),'closed')),1);             
            if s_flat >= s_t                   
                T_HIS_temp = bag.T_HIS(timerange(bag.T_HIS.Time(indx2(k)), bag.T_HIS.Time(indx3(k)),'closed'),:);
                if height(T_HIS_temp) == 1 % measurement does not start with a flat line
                    continue
                else
                    if eval(['(size((T_HIS_temp.' bag.VarNam_HIS{i} ' > 0.0),1) > 0.5*height(T_HIS_temp)) && all(T_HIS_temp.' bag.VarNam_HIS{i} ' >= ' bag.VarNam_HIS{i} 'MIN) && all(T_HIS_temp.' bag.VarNam_HIS{i} ' <= ' bag.VarNam_HIS{i} 'MAX)'])
                        eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_14 = 4*ones(height(T_HIS_temp),1); % fail'])
                    else
                        eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_14 = ones(height(T_HIS_temp),1); % pass'])
                    end 
                    % if value is nan, flag = 9
                    eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_14(isnan(T_HIS_temp.' bag.VarNam_HIS{i} ')) = 9; % missing value'])    
                    % if value is -9999.000, flag = 4
                    eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_14(ismissing(T_HIS_temp.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % fail'])                 

                    table_temp = synchronize(bag.T_HIS, T_HIS_temp,'first','fillwithmissing'); %#ok<NASGU>
                    eval(['table_temp.dqf_' bag.VarNam_HIS{i} '_14_2(isnan(table_temp.dqf_' bag.VarNam_HIS{i} '_14_2)) = table_temp.dqf_' bag.VarNam_HIS{i} '_14_1(isnan(table_temp.dqf_' bag.VarNam_HIS{i} '_14_2));'])
                    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14 = table_temp.dqf_' bag.VarNam_HIS{i} '_14_2; clear *temp;'])

                    % if value is nan, flag = 9
                    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])    
                    % if value is -9999.000, flag = 4
                    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_14(ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % fail'])  
                end
            else
                continue
            end      
            clear s_t s_flat
        end        
        
        clear indx*  
    end
end

if isfield(bag,'T_LEV') 
    for i = 1:1:size(bag.VarNam_LEV,2)
        eval(['EPS_' bag.VarNam_LEV{i} ' = bag.metadatabase.EPS_' bag.VarNam_LEV{i} '(bag.metadatabase.platform_code == bag.s_station);'])
        eval(['' bag.VarNam_LEV{i} 'MIN = bag.metadatabase.' bag.VarNam_LEV{i} 'MIN(bag.metadatabase.platform_code == bag.s_station);'])
        eval(['' bag.VarNam_LEV{i} 'MAX = bag.metadatabase.' bag.VarNam_LEV{i} 'MAX(bag.metadatabase.platform_code == bag.s_station);'])
        eval(['indx = unique(sort([find(abs(diff(bag.T_LEV.' bag.VarNam_LEV{i} ')) < EPS_' bag.VarNam_LEV{i} '); find(abs(diff(bag.T_LEV.' bag.VarNam_LEV{i} ')) < EPS_' bag.VarNam_LEV{i} ') + 1]));'])

        % pre-allocation
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14 = ones(height(bag.T_LEV),1); % pass']) 
        % if value is nan, flag = 9
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])
        % if value is -9999.000, flag = 4
        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])  

        if isempty(indx) % no flat lines
            clear indx
            continue     
        else
            eval(['indx2 = find([0;abs(diff(bag.T_LEV.' bag.VarNam_LEV{i} '))<EPS_' bag.VarNam_LEV{i} '] < 1);'])
            eval(['indx3 = [find( (abs(diff(bag.T_LEV.' bag.VarNam_LEV{i} '))<EPS_' bag.VarNam_LEV{i} ') < 1); height(bag.T_LEV)];'])
        
            for k = 1:1:size(indx2,1)
                s_t = size(bag.T_LEV.Time(timerange(bag.T_LEV.Time(indx3(k))-timespan24, bag.T_LEV.Time(indx3(k)),'openleft')),1);        
                s_flat = size(bag.T_LEV.Time(timerange(bag.T_LEV.Time(indx2(k)), bag.T_LEV.Time(indx3(k)),'closed')),1);             
                if s_flat >= s_t                   
                    T_LEV_temp = bag.T_LEV(timerange(bag.T_LEV.Time(indx2(k)), bag.T_LEV.Time(indx3(k)),'closed'),:);
                    if height(T_LEV_temp) == 1 % measurement does not start with a flat line
                        continue
                    else
                        if eval(['(size((T_LEV_temp.' bag.VarNam_LEV{i} ' > 0.0),1) > 0.5*height(T_LEV_temp)) && all(T_LEV_temp.' bag.VarNam_LEV{i} ' >= ' bag.VarNam_LEV{i} 'MIN) && all(T_LEV_temp.' bag.VarNam_LEV{i} ' <= ' bag.VarNam_LEV{i} 'MAX)'])
                            eval(['T_LEV_temp.dqf_' bag.VarNam_LEV{i} '_14 = 4*ones(height(T_LEV_temp),1); % fail'])
                        else
                            eval(['T_LEV_temp.dqf_' bag.VarNam_LEV{i} '_14 = ones(height(T_LEV_temp),1); % pass'])
                        end 
                        % if value is nan, flag = 9
                        eval(['T_LEV_temp.dqf_' bag.VarNam_LEV{i} '_14(isnan(T_LEV_temp.' bag.VarNam_LEV{i} ')) = 9; % missing value'])    
                        % if value is -9999.000, flag = 4
                        eval(['T_LEV_temp.dqf_' bag.VarNam_LEV{i} '_14(ismissing(T_LEV_temp.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])                 

                        table_temp = synchronize(bag.T_LEV, T_LEV_temp,'first','fillwithmissing'); %#ok<NASGU>
                        eval(['table_temp.dqf_' bag.VarNam_LEV{i} '_14_2(isnan(table_temp.dqf_' bag.VarNam_LEV{i} '_14_2)) = table_temp.dqf_' bag.VarNam_LEV{i} '_14_1(isnan(table_temp.dqf_' bag.VarNam_LEV{i} '_14_2));'])
                        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14 = table_temp.dqf_' bag.VarNam_LEV{i} '_14_2; clear *temp;'])

                        % if value is nan, flag = 9
                        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])    
                        % if value is -9999.000, flag = 4
                        eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_14(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])  
                    end
                else
                    continue
                end      
                clear s_t s_flat
            end            
            
            clear indx*
        end
    end
end

return