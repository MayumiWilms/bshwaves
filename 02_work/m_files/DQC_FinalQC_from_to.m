function [bag] = DQC_FinalQC_from_to(bag) 

if isfield(bag,'Table_RAW')     
    
    % heave
    sortedNamesRAW = sort(bag.Table_RAW_qc0.Properties.VariableNames);
    bag.Table_RAW_qc0 = bag.Table_RAW_qc0(:,sortedNamesRAW);               
    indxDateLocComplRAW = find(contains(bag.Table_RAW_qc0.Properties.VariableNames,'dqf_0')); % dqf von date, location, completeness test   
    indxhv = find(contains(bag.Table_RAW_qc0.Properties.VariableNames,'dqf_heave')); 
    str = [string(table2array(bag.Table_RAW_qc0(:,indxDateLocComplRAW))),string(table2array(bag.Table_RAW_qc0(:,indxhv))),zeros(height(bag.Table_RAW_qc0),6)];    
    bag.Table_RAW_qc.dqf_heave = regexprep(join(str), '\s', '');
    Table_RAW_qc_temp = table2array(bag.Table_RAW_qc0(:,[indxDateLocComplRAW,indxhv]));
    Table_RAW_qc_temp(Table_RAW_qc_temp > 4) = NaN;        
    bag.Table_RAW_qc.fqf_heave = max(Table_RAW_qc_temp,[],2);   
    %
    clear sortedNamesRAW indx* str Table*
    
elseif isfield(bag,'Table_SPT')

    % spectrum
    sortedNamesSPT = sort(bag.Table_SPT_qc0.Properties.VariableNames);
    bag.Table_SPT_qc0 = bag.Table_SPT_qc0(:,sortedNamesSPT);     
    indxDateLocComplSPT = find(contains(bag.Table_SPT_qc0.Properties.VariableNames,'dqf_0')); % dqf von date, location, completeness test   
    indxSf = find(contains(bag.Table_SPT_qc0.Properties.VariableNames,'dqf_Sf')); 
    if numel(indxSf) == 1 % if only Test 11 is done (Copernicus v1.0)
        str = [string(table2array(bag.Table_SPT_qc0(:,indxDateLocComplSPT))),zeros(height(bag.Table_SPT_qc0),7),string(table2array(bag.Table_SPT_qc0(:,indxSf))),zeros(height(bag.Table_SPT_qc0),5)];
    elseif numel(indxSf) == 2 % if Test 5 and Test 11 are done (Copernicus v1.1)
        indxSf_05 = find(contains(bag.Table_SPT_qc0.Properties.VariableNames,'dqf_Sf_05')); 
        indxSf_11 = find(contains(bag.Table_SPT_qc0.Properties.VariableNames,'dqf_Sf_11')); 
        str = [string(table2array(bag.Table_SPT_qc0(:,indxDateLocComplSPT))),zeros(height(bag.Table_SPT_qc0),1),string(table2array(bag.Table_SPT_qc0(:,indxSf_05))),zeros(height(bag.Table_SPT_qc0),5),string(table2array(bag.Table_SPT_qc0(:,indxSf_11))),zeros(height(bag.Table_SPT_qc0),5)];
    end
    bag.Table_SPT_qc.dqf_spectrum = regexprep(join(str), '\s', '');
    Table_SPT_qc_temp = table2array(bag.Table_SPT_qc0(:,[indxDateLocComplSPT,indxSf]));
    Table_SPT_qc_temp(Table_SPT_qc_temp > 4) = NaN;
    bag.Table_SPT_qc.fqf_spectrum = max(Table_SPT_qc_temp,[],2); 
    %
    clear sortedNamesSPT indx* str Table*    
    
else
    switch upper(bag.s_sensor)
        case 'DWR'
            % hiw
            bag.T_HIW.Time = bag.T_HIW_orgtme; % rounded timestamps are replaced with original timestamps
            bag.T_HIW = bag.T_HIW((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % his
            bag.T_HIS.Time = bag.T_HIS_orgtme; % rounded timestamps are replaced with original timestamps
            
            % gps
            bag.T_GPS.Time = bag.T_GPS_orgtme; % rounded timestamps are replaced with original timestamps
            
            if isfield(bag,'CF_indicator')  
                if bag.CF_indicator == 1
                    bag.T_HIS = bag.T_HIS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
                    bag.T_GPS = bag.T_GPS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to   
                else
                    bag.T_HIS = bag.T_HIS((timerange(bag.date_from+minutes(30), bag.date_to+minutes(30),'closed')),:); % select the timerange date_from to date_to
                    bag.T_GPS = bag.T_GPS((timerange(bag.date_from+minutes(30), bag.date_to+minutes(30),'closed')),:); % select the timerange date_from to date_to                   
                end
            elseif contains(bag.s_station,{'HHF','STO'}) % select LKN stations
                bag.T_HIS = bag.T_HIS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
                bag.T_GPS = bag.T_GPS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to      
            else
                bag.T_HIS = bag.T_HIS((timerange(bag.date_from+minutes(30), bag.date_to+minutes(30),'closed')),:); % select the timerange date_from to date_to
                bag.T_GPS = bag.T_GPS((timerange(bag.date_from+minutes(30), bag.date_to+minutes(30),'closed')),:); % select the timerange date_from to date_to       
            end
            
        case {'RADAC', 'RADAC_SINGLE'}    
            % hiw
            bag.T_HIW = bag.T_HIW((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % his
            bag.T_HIS = bag.T_HIS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % gps
            bag.T_GPS = bag.T_GPS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to    

            % lev
            bag.T_LEV = bag.T_LEV((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

        case 'AWAC'
            
        case 'FINODB'
            % hiw
            bag.T_HIW = bag.T_HIW((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % his
            bag.T_HIS = bag.T_HIS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to

            % gps
            bag.T_GPS = bag.T_GPS((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to                
            
            if isfield(bag,'T_LEV') 
                % lev
                bag.T_LEV = bag.T_LEV((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
            end
            
        otherwise
            warning('Unexpected sensor type.')        
    end

    % prepare bag.T_HIW_qc
    sortedNamesHIW = sort(bag.T_HIW.Properties.VariableNames(contains(bag.T_HIW.Properties.VariableNames,'dqf')));
    bag.T_HIW = [bag.T_HIW(:,1:width(bag.T_HIW)-numel(sortedNamesHIW)) bag.T_HIW(:,sortedNamesHIW)];                
    VariableNamesHIW = bag.T_HIW.Properties.VariableNames;
    indxDateLocComplHIW = find(contains(VariableNamesHIW,'dqf_0')); % dqf von date, location, completeness test   
    bag.T_HIW_qc = table(bag.T_HIW.Time,'VariableNames',{'Time'}); 

    for i = 1:1:size(bag.VarNam_HIW,2)     
        % var
        eval(['bag.T_HIW_qc.' bag.VarNam_HIW{i} ' = bag.T_HIW.' bag.VarNam_HIW{i} ';']) %#ok<*EVLDOT> 
        eval(['indx = find(contains(VariableNamesHIW,''dqf_' bag.VarNam_HIW{i} '_''));'])            
        str = [string(table2array(bag.T_HIW(:,indxDateLocComplHIW))),zeros(height(bag.T_HIW),8),string(table2array(bag.T_HIW(:,indx)))];  %#ok<NASGU>
        eval(['bag.T_HIW_qc.dqf_' bag.VarNam_HIW{i} ' = regexprep(join(str), ''\s'', '''');'])
        T_HIW_qc_temp = table2array(bag.T_HIW(:,[indxDateLocComplHIW,indx]));
        T_HIW_qc_temp(T_HIW_qc_temp > 4) = NaN;  %#ok<NASGU>
        eval(['bag.T_HIW_qc.fqf_' bag.VarNam_HIW{i} ' = max(T_HIW_qc_temp,[],2); clear indx str *_temp;'])    
    end

    % prepare bag.T_HIS_qc
    sortedNamesHIS = sort(bag.T_HIS.Properties.VariableNames(contains(bag.T_HIS.Properties.VariableNames,'dqf')));
    bag.T_HIS = [bag.T_HIS(:,1:width(bag.T_HIS)-numel(sortedNamesHIS)) bag.T_HIS(:,sortedNamesHIS)];                
    VariableNamesHIS = bag.T_HIS.Properties.VariableNames;
    indxDateLocComplHIS = find(contains(VariableNamesHIS,'dqf_0')); % dqf von date, location, completeness test   
    bag.T_HIS_qc = table(bag.T_HIS.Time,'VariableNames',{'Time'}); 

    for i = 1:1:size(bag.VarNam_HIS,2)     
        % var
        eval(['bag.T_HIS_qc.' bag.VarNam_HIS{i} ' = bag.T_HIS.' bag.VarNam_HIS{i} ';'])
        eval(['indx = find(contains(VariableNamesHIS,''dqf_' bag.VarNam_HIS{i} '_''));'])
        str = [string(table2array(bag.T_HIS(:,indxDateLocComplHIS))),zeros(height(bag.T_HIS),8),string(table2array(bag.T_HIS(:,indx)))]; %#ok<NASGU>
        eval(['bag.T_HIS_qc.dqf_' bag.VarNam_HIS{i} ' = regexprep(join(str), ''\s'', '''');'])
        T_HIS_qc_temp = table2array(bag.T_HIS(:,[indxDateLocComplHIS,indx]));
        T_HIS_qc_temp(T_HIS_qc_temp > 4) = NaN; %#ok<NASGU>
        eval(['bag.T_HIS_qc.fqf_' bag.VarNam_HIS{i} ' = max(T_HIS_qc_temp,[],2); clear indx str *_temp;'])    
    end

    switch upper(bag.s_sensor)
        case 'DWR'
            % k
            bag.T_HIS_qc.k = bag.T_HIS.Bat;
            bag.T_HIS_qc.dqf_k = repmat("0000000000000000",height(bag.T_HIS),1);
            bag.T_HIS_qc.fqf_k = zeros(height(bag.T_HIS),1);
            
            if contains(bag.s_station,{'HHF','STO'}) % select LKN stations
                % VPED
                bag.T_HIS_qc.dqf_VPED = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VPED = 9*ones(height(bag.T_HIS),1);

                % VPSP
                bag.T_HIS_qc.dqf_VPSP = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VPSP = 9*ones(height(bag.T_HIS),1);

                % VTPC
                bag.T_HIS_qc.dqf_VTPC = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VTPC = 9*ones(height(bag.T_HIS),1);    

                % VTNU
                bag.T_HIS_qc.dqf_VTNU = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VTNU = 9*ones(height(bag.T_HIS),1);     

                % VTES
                bag.T_HIS_qc.dqf_VTES = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VTES = 9*ones(height(bag.T_HIS),1);    

                % VSTS
                bag.T_HIS_qc.dqf_VSTS = repmat("9999999999999999",height(bag.T_HIS),1);
                bag.T_HIS_qc.fqf_VSTS = 9*ones(height(bag.T_HIS),1);                    
            end            
    end

    % prepare bag.T_GPS_qc
    sortedNamesGPS = sort(bag.T_GPS.Properties.VariableNames(contains(bag.T_GPS.Properties.VariableNames,'dqf')));
    bag.T_GPS = [bag.T_GPS(:,1:width(bag.T_GPS)-numel(sortedNamesGPS)) bag.T_GPS(:,sortedNamesGPS)];                
    VariableNamesGPS = bag.T_GPS.Properties.VariableNames;                
    indxGPS = find(contains(VariableNamesGPS,'dqf')); 
    bag.T_GPS_qc = bag.T_GPS(:,{'STATUS' 'LATITUDE' 'LONGITUDE'});
    bag.T_GPS_qc = timetable2table(bag.T_GPS_qc);    
    bag.T_GPS_qc.dqf_gps = regexprep(join(string(table2array(bag.T_GPS(:,indxGPS)))), '\s', '');
    Table_GPS_qc_temp = table2array(bag.T_GPS(:,indxGPS));
    Table_GPS_qc_temp(Table_GPS_qc_temp > 4) = NaN;
    bag.T_GPS_qc.fqf_gps = max(Table_GPS_qc_temp,[],2);  clear *_temp
    bag.T_GPS_qc.dqf_gps = pad(bag.T_GPS_qc.dqf_gps,16,'right','0'); % Add leading or trailing characters to strings
    bag.T_GPS_qc = bag.T_GPS_qc(:,{'Time' 'STATUS' 'LATITUDE' 'dqf_gps' 'fqf_gps' 'LONGITUDE'  'dqf_gps' 'fqf_gps'});
    bag.T_GPS_qc.Properties.VariableNames{'dqf_gps'} = 'dqf_LATITUDE';
    bag.T_GPS_qc.Properties.VariableNames{'fqf_gps'} = 'fqf_LATITUDE';
    bag.T_GPS_qc.Properties.VariableNames{'dqf_gps_1'} = 'dqf_LONGITUDE';
    bag.T_GPS_qc.Properties.VariableNames{'fqf_gps_1'} = 'fqf_LONGITUDE';    

    % prepare bag.T_LEV_qc
    if isfield(bag,'T_LEV') 
        % lev        
        sortedNamesLEV = sort(bag.T_LEV.Properties.VariableNames(contains(bag.T_LEV.Properties.VariableNames,'dqf')));
        bag.T_LEV = [bag.T_LEV(:,1:width(bag.T_LEV)-numel(sortedNamesLEV)) bag.T_LEV(:,sortedNamesLEV)];                
        VariableNamesLEV = bag.T_LEV.Properties.VariableNames;
        indxDateLocComplLEV = find(contains(VariableNamesLEV,'dqf_0')); % dqf von date, location, completeness test   
        bag.T_LEV_qc = table(bag.T_LEV.Time,'VariableNames',{'Time'});  

        for i = 1:1:size(bag.VarNam_LEV,2)     
            % var
            eval(['bag.T_LEV_qc.' bag.VarNam_LEV{i} ' = bag.T_LEV.' bag.VarNam_LEV{i} ';'])
            eval(['indx = find(contains(VariableNamesLEV,''dqf_' bag.VarNam_LEV{i} '_''));'])            
            str = [string(table2array(bag.T_LEV(:,indxDateLocComplLEV))),zeros(height(bag.T_LEV),8),string(table2array(bag.T_LEV(:,indx)))];  %#ok<NASGU>
            eval(['bag.T_LEV_qc.dqf_' bag.VarNam_LEV{i} ' = regexprep(join(str), ''\s'', '''');'])
            T_LEV_qc_temp = table2array(bag.T_LEV(:,[indxDateLocComplLEV,indx]));
            T_LEV_qc_temp(T_LEV_qc_temp > 4) = NaN;  %#ok<NASGU>
            eval(['bag.T_LEV_qc.fqf_' bag.VarNam_LEV{i} ' = max(T_LEV_qc_temp,[],2); clear indx str *_temp;'])    
        end   
    end
    
    %% Special Cases
    if and(bag.s_station == "DBU",bag.s_sensor == "RADAC")
        % tupper = time of Radac software update
        bag.T_HIS_qc.fqf_VMDR(isbetween(bag.T_HIS.Time,bag.tlower,datetime('04.05.2023 23:59:59','TimeZone','UTC'))) = 4;
        bag.T_HIS_qc.fqf_VPED(isbetween(bag.T_HIS.Time,bag.tlower,datetime('04.05.2023 23:59:59','TimeZone','UTC'))) = 4;
        bag.T_HIS_qc.fqf_VPSP(isbetween(bag.T_HIS.Time,bag.tlower,datetime('04.05.2023 23:59:59','TimeZone','UTC'))) = 4;
    end

end

return