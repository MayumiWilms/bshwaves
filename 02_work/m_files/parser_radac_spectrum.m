function [bag] = parser_radac_spectrum(bag)

% select data 
% data needs to be selected by dir*.name because dir*.datenum is
% the last modified date of the file

% spectrum
switch upper(bag.s_sensor)
    case 'RADAC'
        dirinfo_spt_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'height\Czz10','*.txt')); 
               
    case 'RADAC_SINGLE'
        dirinfo_spt_year = dir(fullfile(bag.s_incoming_folder,bag.s_station,'Czz10','*.txt'));        
        
    otherwise
        warning('Unexpected sensor type.')
end

if isempty(dirinfo_spt_year)
    error([datestr(bag.date_now) ' No spectrum data at station ' bag.s_station '.'])
end

str_date = {dirinfo_spt_year.name}';
for I2=1:1:numel(str_date)    
    str_date_temp0 = str_date{I2,:}(1:end-4);
    str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
    dirinfo_spt_year(I2).name_datenum = datenum(str_date_temp1);
    clear str_date_temp* 
end; clear I2 str_date
date_from_x = datetime(floor(datenum(bag.date_from_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
date_to_x = datetime(ceil(datenum(bag.date_to_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
dirinfo_spt_yearX = dirinfo_spt_year(and([dirinfo_spt_year.name_datenum] >= datenum(date_from_x),[dirinfo_spt_year.name_datenum] <= datenum(date_to_x))); 
[~,index] = sortrows({dirinfo_spt_yearX.name_datenum}.'); dirinfo_spt_yearX = dirinfo_spt_yearX(index); clear index % sort by name; datenum could be date_modified   

% check if spt exist
if isempty(dirinfo_spt_yearX)
    error([datestr(bag.date_now) ' No spectrum data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end  

% load data into workspace     
bag.Table_SPT = timetable;
bag.Table_SPEC = timetable;
bag.Table_SPT_dqf_03 = table;
for I2 = 1:1:numel(dirinfo_spt_yearX)
    % read spectrum
    [Table_SPEC_temp, dqf_03_compl_spt_temp] = read_RADAC_Czz10(dirinfo_spt_yearX(I2).name,dirinfo_spt_yearX(I2).folder);   
    [Table_SPEC_temp, indexSPEC] = sortrows(Table_SPEC_temp); %#ok<ASGLU>
    bag.Table_SPEC = [bag.Table_SPEC; Table_SPEC_temp];
    % creating quality control (qc) tables
    str_date_spt = regexp(dirinfo_spt_yearX(I2).name,'\d\d\d\d\d\d\d\d','match','once');
    startTime = datetime(str_date_spt,'InputFormat','yyyyMMdd','TimeZone','UTC');      
    Table_SPT_dqf_03_temp = table(startTime, dqf_03_compl_spt_temp,'VariableNames',{'Time', 'dqf_03_compl_spt'}); % collect timestamp of each file in table   
    bag.Table_SPT_dqf_03 = [bag.Table_SPT_dqf_03; Table_SPT_dqf_03_temp]; 
    clear *_temp str_date_spt startTime 
end; clear I2    
bag.Table_SPT_dqf_03 = table2timetable(bag.Table_SPT_dqf_03);
%%% RADAC / RADAC_SINGLE addition to create the right time vector
    %{
    if height(bag.Table_SPT_dqf_03) == 1
        bag.Table_SPT_dqf_03 = [bag.Table_SPT_dqf_03; bag.Table_SPT_dqf_03];    
        bag.Table_SPT_dqf_03.Time(2) = bag.Table_SPT_dqf_03.Time(1) + days(1); 
        bag.Table_SPT_dqf_03 = retime(bag.Table_SPT_dqf_03,'minutely','linear');
    else
        bag.Table_SPT_dqf_03 = retime(bag.Table_SPT_dqf_03,'minutely','linear');
    end
    %}
    bag.Table_SPT_dqf_03 = [bag.Table_SPT_dqf_03; bag.Table_SPT_dqf_03(end,:)];    
    bag.Table_SPT_dqf_03.Time(end) = bag.Table_SPT_dqf_03.Time(end) + days(1); % to include the whole last day
    bag.Table_SPT_dqf_03 = retime(bag.Table_SPT_dqf_03,'minutely','linear');
    %
    bag.Table_SPT_dqf_03 = bag.Table_SPT_dqf_03((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
    bag.Table_SPEC = bag.Table_SPEC((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the timerange date_from to date_to
    bag.Table_SPEC.Time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    bag.Table_SPT_dqf_03.Time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    
    % in operational mode, bag.Table_SPT.Time(end) and bag.date_to_x might
    % differ > 20 min, which causes an error in for-loop (Test04-Test10) =
    % no Table_SPT_temp. date_to and date_to_x needs to be adapted.
    % check if spt exist for selected timerange
    if isempty(bag.Table_SPEC)
        error([datestr(bag.date_now) ' No spectrum data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
    end
    if abs(bag.Table_SPEC.Time(end) - bag.date_to_x) > seconds(1)
        bag.date_to_x = bag.Table_SPEC.Time(end);
        bag.date_to = bag.date_to_x;
        bag.Table_SPT_dqf_03 = bag.Table_SPT_dqf_03((timerange(bag.date_from, bag.date_to,'closed')),:); % select the timerange date_from to date_to
        bag.Table_SPEC = bag.Table_SPEC((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the timerange date_from to date_to
    end    
%%%
bag.Table_SPT_qc = timetable('RowTimes',bag.Table_SPT_dqf_03.Time); % 
bag.Table_SPT_qc0 = bag.Table_SPT_qc; % interim variable 
          
%%% RADAC / RADAC_SINGLE addition to transform Table_SPEC to include f [Hz] and df [Hz]
    bag.Table_SPEC_org = bag.Table_SPEC;
    f_vec = repmat((0:0.01:0.5)', height(bag.Table_SPEC), 1); % frequency in [Hz]
    t_vec = sort(repmat(bag.Table_SPEC.Time, 51, 1));
    df_vec = repmat([0.005; 0.01*ones(49,1); 0.005], height(bag.Table_SPEC), 1); % delta frequency in [Hz]
    
    SPEC_tab = timetable2table(bag.Table_SPEC);
    SPEC_tab = removevars(SPEC_tab, 'Time');
    SPEC_tab = table2array(SPEC_tab);
    SPEC_trans = transpose(SPEC_tab);
    SPEC_vec = SPEC_trans(:);
    
    bag.Table_SPEC = timetable(f_vec, SPEC_vec, df_vec, 'RowTimes', t_vec, 'VariableNames', {'f','Sf','df'});
    bag.Table_SPEC.Properties.VariableUnits =  {'Hz','m2 s','Hz'};
    
    clear *_vec SPEC*;
%%%

%%% RADAC addition to include Th010 and S0bh10 in Table_SPEC  
switch upper(bag.s_sensor)
    case 'RADAC'        
        dirinfo_Th010 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'direction\Th010','*.txt'));
        dirinfo_S0bh10 = dir(fullfile(bag.s_incoming_folder,bag.s_station,'direction\S0bh10','*.txt'));
        
        % check if files exist 
        if isempty(dirinfo_Th010)
            error([datestr(bag.date_now) ' No spectrum (Th010) data at station ' bag.s_station '.'])
        end
        
        if isempty(dirinfo_S0bh10)
            error([datestr(bag.date_now) ' No spectrum (S0bh10) data at station ' bag.s_station '.'])
        end        
        
        str_date = {dirinfo_Th010.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_Th010(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        date_from_x = datetime(floor(datenum(bag.date_from_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
        date_to_x = datetime(ceil(datenum(bag.date_to_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
        dirinfo_Th010X = dirinfo_Th010(and([dirinfo_Th010.name_datenum] >= datenum(date_from_x),[dirinfo_Th010.name_datenum] <= datenum(date_to_x))); 
        [~,index] = sortrows({dirinfo_Th010X.name_datenum}.'); dirinfo_Th010X = dirinfo_Th010X(index); clear index % sort by name; datenum could be date_modified   
        
        str_date = {dirinfo_S0bh10.name}';
        for I2=1:1:numel(str_date)    
            str_date_temp0 = str_date{I2,:}(1:end-4);
            str_date_temp1 = datetime(str_date_temp0,'InputFormat','yyyyMMdd');  
            dirinfo_S0bh10(I2).name_datenum = datenum(str_date_temp1);
            clear str_date_temp* 
        end; clear I2 str_date
        date_from_x = datetime(floor(datenum(bag.date_from_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
        date_to_x = datetime(ceil(datenum(bag.date_to_x)),'ConvertFrom','datenum','TimeZone','UTC'); % floor date to date at midnight
        dirinfo_S0bh10X = dirinfo_S0bh10(and([dirinfo_S0bh10.name_datenum] >= datenum(date_from_x),[dirinfo_S0bh10.name_datenum] <= datenum(date_to_x))); 
        [~,index] = sortrows({dirinfo_S0bh10X.name_datenum}.'); dirinfo_S0bh10X = dirinfo_S0bh10X(index); clear index % sort by name; datenum could be date_modified   
       
        % check if files exist 
        if isempty(dirinfo_Th010X)
            error([datestr(bag.date_now) ' No spectrum (Th010) data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
        end      
        
        if isempty(dirinfo_S0bh10X)
            error([datestr(bag.date_now) ' No spectrum (S0bh10) data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
        end          
        
        % load data into workspace   
        Table_Th010 = timetable;
        for I2 = 1:1:numel(dirinfo_Th010X)
            Table_Th010_temp = read_RADAC_Th010(dirinfo_Th010X(I2).name, dirinfo_Th010X(I2).folder);  
            Table_Th010 = [Table_Th010; Table_Th010_temp]; %#ok<AGROW>
        end; clear I2 *temp
        Table_Th010 = sortrows(Table_Th010);
        Table_Th010 = unique(Table_Th010); % remove duplicate rows with same time and data
        Table_Th010 = Table_Th010((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        bag.Table_Th010_org = Table_Th010;
        
        Table_S0bh10 = timetable;
        for I2 = 1:1:numel(dirinfo_S0bh10X)
            Table_S0bh10_temp = read_RADAC_S0bh10(dirinfo_S0bh10X(I2).name, dirinfo_S0bh10X(I2).folder);  
            Table_S0bh10 = [Table_S0bh10; Table_S0bh10_temp]; %#ok<AGROW>
        end; clear I2 *temp
        Table_S0bh10 = sortrows(Table_S0bh10);
        Table_S0bh10 = unique(Table_S0bh10); % remove duplicate rows with same time and data
        Table_S0bh10 = Table_S0bh10((timerange(bag.date_from_x, bag.date_to_x,'closed')),:); % select the last X+1 days
        bag.Table_S0bh10_org = Table_S0bh10;
   
        % syncronize Th010 and S0bh10 with Table_SPEC
        % check if timestamps in Czz10, Th010 and Sb0h10 are equal
        if size(bag.Table_SPEC_org.Time, 1) ~= size(bag.Table_Th010_org.Time, 1)
            log_file = fullfile(bag.s_log_folder,['tmc_check_radac_th010_' bag.s_station '_log.txt']); 
            if exist(log_file,'file')
                delete(log_file)
            end
            errorMessage = ['Timestamps in Czz10 and Th010 for RADAC station ' bag.s_station ' and timerange ' datestr(bag.date_from_x) ' to ' datestr(bag.date_to_x) ' are not equal.'];
            WarnUser(errorMessage,log_file)
            
        elseif size(bag.Table_SPEC_org.Time, 1) ~= size(bag.Table_S0bh10_org.Time, 1)
            log_file = fullfile(bag.s_log_folder,['tmc_check_radac_s0bh10_' bag.s_station '_log.txt']); 
            if exist(log_file,'file')
                delete(log_file)
            end
            errorMessage = ['Timestamps in Czz10 and Sb0h10 for RADAC station ' bag.s_station ' and timerange ' datestr(bag.date_from_x) ' to ' datestr(bag.date_to_x) ' are not equal.'];
            WarnUser(errorMessage,log_file)
        else            
        end        

        % find united time vector
        tu = union(bag.Table_SPEC_org.Time, bag.Table_Th010_org.Time); 
        tu = union(tu, bag.Table_S0bh10_org.Time);
        Table_SPEC_sync = retime(bag.Table_SPEC_org, tu, 'fillwithmissing');
        Table_Th010_sync = retime(bag.Table_Th010_org, tu, 'fillwithmissing');
        Table_S0bh10_sync = retime(bag.Table_S0bh10_org, tu, 'fillwithmissing');

        % transform Table_SPEC new
        f_vec = repmat((0:0.01:0.5)', height(Table_SPEC_sync), 1); % frequency in [Hz]
        t_vec = sort(repmat(Table_SPEC_sync.Time, 51, 1));
        df_vec = repmat([0.005; 0.01*ones(49,1); 0.005], height(Table_SPEC_sync), 1); % delta frequency in [Hz]
        
        SPEC_tab = timetable2table(Table_SPEC_sync);
        SPEC_tab = removevars(SPEC_tab, 'Time');
        SPEC_tab = table2array(SPEC_tab);
        SPEC_trans = transpose(SPEC_tab);
        SPEC_vec = SPEC_trans(:);
        
        bag.Table_SPEC = timetable(f_vec, SPEC_vec, df_vec, 'RowTimes', t_vec, 'VariableNames', {'f','Sf','df'});
        bag.Table_SPEC.Properties.VariableUnits =  {'Hz','m2 s','Hz'};
        
        clear *_vec SPEC* tu;      

        Table_Th010 = Table_Th010_sync;
        Table_S0bh10 = Table_S0bh10_sync;

        % Th010
        f_vec = repmat((0:0.01:0.5)', height(Table_Th010), 1); % frequency in [Hz]
        t_vec = sort(repmat(Table_Th010.Time, 51, 1));
        Th010_tab = timetable2table(Table_Th010);
        Th010_tab = removevars(Th010_tab, 'Time');
        Th010_tab = table2array(Th010_tab);
        Th010_trans = transpose(Th010_tab);
        Th010_vec = Th010_trans(:);
        Table_Th010 = timetable(f_vec, Th010_vec, 'RowTimes', t_vec, 'VariableNames', {'f','Th010'});
        Table_Th010.Properties.VariableUnits =  {'Hz','degree'};
        clear *_vec Th010*;
        
        % S0bh10
        f_vec = repmat((0:0.01:0.5)', height(Table_S0bh10), 1); % frequency in [Hz]
        t_vec = sort(repmat(Table_S0bh10.Time, 51, 1));
        S0bh10_tab = timetable2table(Table_S0bh10);
        S0bh10_tab = removevars(S0bh10_tab, 'Time');
        S0bh10_tab = table2array(S0bh10_tab);
        S0bh10_trans = transpose(S0bh10_tab);
        S0bh10_vec = S0bh10_trans(:);
        Table_S0bh10 = timetable(f_vec, S0bh10_vec, 'RowTimes', t_vec, 'VariableNames', {'f','S0bh10'});
        Table_S0bh10.Properties.VariableUnits =  {'Hz','degree'};
        clear *_vec S0bh10*;

        % combine
        bag.Table_SPEC.Th010 = Table_Th010.Th010;
        bag.Table_SPEC.S0bh10 = Table_S0bh10.S0bh10;   

        %{
        % check if timestamps in Czz10, Th010 and Sb0h10 are equal
        if all(bag.Table_SPEC.Time == Table_Th010.Time) 
            bag.Table_SPEC.Th010 = Table_Th010.Th010;
        else
            bag.Table_SPEC.Th010 = zeros(height(Table_Th010), 1);            
            log_file = fullfile(bag.s_log_folder,['tmc_check_radac_th010_' bag.s_station '_log.txt']); 
            if exist(log_file,'file')
                delete(log_file)
            end
            errorMessage = ['Timestamps in Czz10 and Th010 for RADAC station ' bag.s_station ' and timerange ' datestr(bag.date_from_x) ' to ' datestr(bag.date_to_x) ' are not equal.'];
            WarnUser(errorMessage,log_file)
        end

        if all(bag.Table_SPEC.Time == Table_S0bh10.Time)
            bag.Table_SPEC.S0bh10 = Table_S0bh10.S0bh10;            
        else
            bag.Table_SPEC.S0bh10 = zeros(height(Table_S0bh10), 1);
            log_file = fullfile(bag.s_log_folder,['tmc_check_radac_s0bh10_' bag.s_station '_log.txt']); 
            if exist(log_file,'file')
                delete(log_file)
            end
            errorMessage = ['Timestamps in Czz10 and Sb0h10 for RADAC station ' bag.s_station ' and timerange ' datestr(bag.date_from_x) ' to ' datestr(bag.date_to_x) ' are not equal.'];
            WarnUser(errorMessage,log_file)
        end        
        %}

        bag.Table_SPEC.Properties.VariableUnits =  {'Hz','m2 s','Hz','degree','degree'};
        
    case 'RADAC_SINGLE'        
        
    otherwise
        warning('Unexpected sensor type.')
end
%%%

% check if spt exist for selected timerange
if isempty(bag.Table_SPEC)
    error([datestr(bag.date_now) ' No spectrum data at station ' bag.s_station ' for ' datestr(bag.date_from) ' to ' datestr(bag.date_to) '.'])
end

return