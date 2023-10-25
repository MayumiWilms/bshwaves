function [bag] = DQC_Test15(bag) 

% switch case
switch upper(bag.s_sensor)
    case 'DWR'
        for i = 1:1:size(bag.VarNam_HIW,2)
            if any(strcmpi(bag.VarNam_HIW{i},{'VTZC','VZNW'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1);'])    
            else                
                eval(['MAX' bag.VarNam_HIW{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIW{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                if height(bag.T_HIW) >= 3
                    for j = 1:1:height(bag.T_HIW)
                        if j == 1 && diff(bag.T_HIW.Time(j:j+1)) < minutes(61)
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])
                        elseif j == 1 && diff(bag.T_HIW.Time(j:j+1)) >= minutes(61)
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end '])                            
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])                            
                        elseif j == height(bag.T_HIW) && diff(bag.T_HIW.Time(j-1:j)) < minutes(61)
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        elseif j == height(bag.T_HIW) && diff(bag.T_HIW.Time(j-1:j)) >= minutes(61)
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])                            
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])                            
                        elseif all(diff(bag.T_HIW.Time(j-1:j+1)) < minutes(61)) 
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j-1)) + abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        else
                            eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j-1)) + abs(bag.T_HIW.' bag.VarNam_HIW{i} '(j) - bag.T_HIW.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])
                            eval(['if bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        end
                    end              
                else
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1); % value not evaluated'])
                end
            end
        end

        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VPED','VPSP','TEMP','VTNU','VTES','VPQP','VSTS'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1);'])    
            else
                eval(['MAX' bag.VarNam_HIS{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIS{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                if height(bag.T_HIS) >= 3
                    for j = 1:1:height(bag.T_HIS)
                        if j == 1 && diff(bag.T_HIS.Time(j:j+1)) < minutes(61)
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])
                        elseif j == 1 && diff(bag.T_HIS.Time(j:j+1)) >= minutes(61)
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end '])                            
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])                            
                        elseif j == height(bag.T_HIS) && diff(bag.T_HIS.Time(j-1:j)) < minutes(61)
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        elseif j == height(bag.T_HIS) && diff(bag.T_HIS.Time(j-1:j)) >= minutes(61)
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])                            
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])                            
                        elseif all(diff(bag.T_HIS.Time(j-1:j+1)) < minutes(61)) 
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j-1)) + abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        else
                            eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j-1)) + abs(bag.T_HIS.' bag.VarNam_HIS{i} '(j) - bag.T_HIS.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])
                            eval(['if bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        end
                    end              
                else
                    eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1); % value not evaluated'])
                end
            end
        end

    case {'RADAC', 'RADAC_SINGLE'}
        for i = 1:1:size(bag.VarNam_HIW,2)
            if any(strcmpi(bag.VarNam_HIW{i},{'VZNW'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1);'])    
                % if value is nan, flag = 9
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
                % if value is -9999.000, flag = 4
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % fail'])
            else                
                eval(['MAX' bag.VarNam_HIW{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIW{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                eval(['T_HIW_temp = bag.T_HIW(~ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',[NaN -9999.000]),''' bag.VarNam_HIW{i} '''); % ignore NaNs and -9999.000 values'])                
                if ~isempty(T_HIW_temp)
                    if height(T_HIW_temp) >= 3
                        for j = 1:1:height(T_HIW_temp)
                            if j == 1 && diff(T_HIW_temp.Time(j:j+1)) < minutes(61)
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])
                            elseif j == 1 && diff(T_HIW_temp.Time(j:j+1)) >= minutes(61)
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end '])                            
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])                            
                            elseif j == height(T_HIW_temp) && diff(T_HIW_temp.Time(j-1:j)) < minutes(61)
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                            elseif j == height(T_HIW_temp) && diff(T_HIW_temp.Time(j-1:j)) >= minutes(61)
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])                            
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])                            
                            elseif all(diff(T_HIW_temp.Time(j-1:j+1)) < minutes(61)) 
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) + abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                            else
                                eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) + abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])
                                eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                            end
                        end  
                    else
                        eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1); % value not evaluated'])
                    end
                    table_temp = synchronize(bag.T_HIW, T_HIW_temp,'first','fillwithmissing'); %#ok<NASGU>
                    eval(['table_temp.dqf_' bag.VarNam_HIW{i} '_15(isnan(table_temp.dqf_' bag.VarNam_HIW{i} '_15)) = 9; % missing value  '])
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = table_temp.dqf_' bag.VarNam_HIW{i} '_15; clear *temp;'])
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',-9999.000)) = 4; % if value is -9999.000, flag = 4'])
                else
                    eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
                end
            end
        end

        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VPED','VPSP','VMDR'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1);'])    
                % if value is nan, flag = 9
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])
                % if value is -9999.000, flag = 4
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % fail'])
            else
                eval(['MAX' bag.VarNam_HIS{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIS{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                eval(['T_HIS_temp = bag.T_HIS(~ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',[NaN -9999.000]),''' bag.VarNam_HIS{i} '''); % ignore NaNs and -9999.000 values'])                
                if height(T_HIS_temp) >= 3
                    for j = 1:1:height(T_HIS_temp)
                        if j == 1 && diff(T_HIS_temp.Time(j:j+1)) < minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])
                        elseif j == 1 && diff(T_HIS_temp.Time(j:j+1)) >= minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end '])                            
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])                            
                        elseif j == height(T_HIS_temp) && diff(T_HIS_temp.Time(j-1:j)) < minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        elseif j == height(T_HIS_temp) && diff(T_HIS_temp.Time(j-1:j)) >= minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])                            
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])                            
                        elseif all(diff(T_HIS_temp.Time(j-1:j+1)) < minutes(61)) 
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) + abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        else
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) + abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        end
                    end                       
                else
                    eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1); % value not evaluated'])
                end
                table_temp = synchronize(bag.T_HIS, T_HIS_temp,'first','fillwithmissing'); %#ok<NASGU>
                eval(['table_temp.dqf_' bag.VarNam_HIS{i} '_15(isnan(table_temp.dqf_' bag.VarNam_HIS{i} '_15)) = 9; % missing value  '])
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = table_temp.dqf_' bag.VarNam_HIS{i} '_15; clear *temp;'])
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',-9999.000)) = 4; % if value is -9999.000, flag = 4'])
            end
        end 
        
        for i = 1:1:size(bag.VarNam_LEV,2)
            % parameters which are not tested get flag 0 = value not evaluated
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15 = zeros(height(bag.T_LEV),1);'])    
            % if value is nan, flag = 9
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])
            % if value is -9999.000, flag = 4
            eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])
        end        
            
    case 'AWAC'
        
    case 'FINODB' 
        for i = 1:1:size(bag.VarNam_HIW,2)
            if any(strcmpi(bag.VarNam_HIW{i},{'VTZC','VZNW'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1);'])    
                % if value is nan, flag = 9
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15(isnan(bag.T_HIW.' bag.VarNam_HIW{i} ')) = 9; % missing value'])
            else
                eval(['MAX' bag.VarNam_HIW{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIW{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                eval(['T_HIW_temp = bag.T_HIW(~ismissing(bag.T_HIW.' bag.VarNam_HIW{i} ',[NaN -9999.000]),''' bag.VarNam_HIW{i} '''); % ignore NaNs and -9999.000 values'])                
                if height(T_HIW_temp) >= 3
                    for j = 1:1:height(T_HIW_temp)
                        if j == 1 && diff(T_HIW_temp.Time(j:j+1)) < minutes(61)
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])
                        elseif j == 1 && diff(T_HIW_temp.Time(j:j+1)) >= minutes(61)
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end '])                            
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end '])                            
                        elseif j == height(T_HIW_temp) && diff(T_HIW_temp.Time(j-1:j)) < minutes(61)
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        elseif j == height(T_HIW_temp) && diff(T_HIW_temp.Time(j-1:j)) >= minutes(61)
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) <= MAX' bag.VarNam_HIW{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])                            
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])                            
                        elseif all(diff(T_HIW_temp.Time(j-1:j+1)) < minutes(61)) 
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) + abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        else
                            eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = double(abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j-1)) + abs(T_HIW_temp.' bag.VarNam_HIW{i} '(j) - T_HIW_temp.' bag.VarNam_HIW{i} '(j+1)) <= 2*MAX' bag.VarNam_HIW{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 1; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 2; end'])
                            eval(['if T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) == 0; T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15(j) = 3; end'])
                        end
                    end  
                else
                    eval(['T_HIW_temp.dqf_' bag.VarNam_HIW{i} '_15 = zeros(height(bag.T_HIW),1); % value not evaluated'])
                end
                table_temp = synchronize(bag.T_HIW, T_HIW_temp,'first','fillwithmissing'); %#ok<NASGU>
                eval(['table_temp.dqf_' bag.VarNam_HIW{i} '_15(isnan(table_temp.dqf_' bag.VarNam_HIW{i} '_15)) = 9; % missing value  '])
                eval(['bag.T_HIW.dqf_' bag.VarNam_HIW{i} '_15 = table_temp.dqf_' bag.VarNam_HIW{i} '_15; clear *temp;'])
            end
        end

        for i = 1:1:size(bag.VarNam_HIS,2)
            if any(strcmpi(bag.VarNam_HIS{i},{'VPED','VPSP','VMDR'}))
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1);'])    
                % if value is nan, flag = 9
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15(isnan(bag.T_HIS.' bag.VarNam_HIS{i} ')) = 9; % missing value'])
            else
                eval(['MAX' bag.VarNam_HIS{i} 'DIFFSTD = bag.metadatabase.MAX' bag.VarNam_HIS{i} 'DIFFSTD(bag.metadatabase.platform_code == bag.s_station);'])
                eval(['T_HIS_temp = bag.T_HIS(~ismissing(bag.T_HIS.' bag.VarNam_HIS{i} ',[NaN -9999.000]),''' bag.VarNam_HIS{i} '''); % ignore NaNs and -9999.000 values'])                
                if height(T_HIS_temp) >= 3
                    for j = 1:1:height(T_HIS_temp)
                        if j == 1 && diff(T_HIS_temp.Time(j:j+1)) < minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])
                        elseif j == 1 && diff(T_HIS_temp.Time(j:j+1)) >= minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end '])                            
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end '])                            
                        elseif j == height(T_HIS_temp) && diff(T_HIS_temp.Time(j-1:j)) < minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        elseif j == height(T_HIS_temp) && diff(T_HIS_temp.Time(j-1:j)) >= minutes(61)
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) <= MAX' bag.VarNam_HIS{i} 'DIFFSTD); % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])                            
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])                            
                        elseif all(diff(T_HIS_temp.Time(j-1:j+1)) < minutes(61)) 
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) + abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        else
                            eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = double(abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j-1)) + abs(T_HIS_temp.' bag.VarNam_HIS{i} '(j) - T_HIS_temp.' bag.VarNam_HIS{i} '(j+1)) <= 2*MAX' bag.VarNam_HIS{i} 'DIFFSTD);  % pass'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 1; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 2; end'])
                            eval(['if T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) == 0; T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15(j) = 3; end'])
                        end
                    end                       
                else
                    eval(['T_HIS_temp.dqf_' bag.VarNam_HIS{i} '_15 = zeros(height(bag.T_HIS),1); % value not evaluated'])
                end
                table_temp = synchronize(bag.T_HIS, T_HIS_temp,'first','fillwithmissing'); %#ok<NASGU>
                eval(['table_temp.dqf_' bag.VarNam_HIS{i} '_15(isnan(table_temp.dqf_' bag.VarNam_HIS{i} '_15)) = 9; % missing value  '])
                eval(['bag.T_HIS.dqf_' bag.VarNam_HIS{i} '_15 = table_temp.dqf_' bag.VarNam_HIS{i} '_15; clear *temp;'])
            end
        end 
        
        if isfield(bag,'T_LEV') 
            for i = 1:1:size(bag.VarNam_LEV,2)
                % parameters which are not tested get flag 0 = value not evaluated
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15 = zeros(height(bag.T_LEV),1);'])    
                % if value is nan, flag = 9
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15(isnan(bag.T_LEV.' bag.VarNam_LEV{i} ')) = 9; % missing value'])
                % if value is -9999.000, flag = 4
                eval(['bag.T_LEV.dqf_' bag.VarNam_LEV{i} '_15(ismissing(bag.T_LEV.' bag.VarNam_LEV{i} ',-9999.000)) = 4; % fail'])
            end        
        end
        
    otherwise
        warning('Unexpected sensor type.')        
end

return
