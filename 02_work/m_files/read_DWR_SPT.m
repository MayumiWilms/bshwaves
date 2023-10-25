function [Table_SPT, Table_SPEC, dqf_03_compl_spt] = read_DWR_SPT(s_InDataFile,s_InPath) 

% import .spt to timetable
    % s_InDataFile = dirinfo_spt_yearX(I2).name;
    % s_InPath = dirinfo_spt_yearX(I2).folder;

date_now = datetime('now','TimeZone','UTC');

%% import .spt
s_SptFile = fullfile(s_InPath,s_InDataFile);
VariableNames1 =  {'tn','H_m0','T_z','Smax','Tref','Tsea','Bat','Av','Ax','Ay','Ori','Incli'};
VariableNames2 =  {'f','SfSmax','Dirf','Sprf','Skewf','Kurtf'};
delimiter = ',';
formatSpec = '%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(s_SptFile,'r');
try
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
    fclose(fileID);
    
    if abs(76 - numel(dataArray{1})) > 0 
        disp([datestr(date_now) ' ' s_SptFile ' is incomplete.'])
        Table_SPT = [];
        Table_SPEC = [];
        dqf_03_compl_spt = 4;
        return
    end
    
    % Table_SPT
    Table_SPT0 = array2table(dataArray{1:1}(1:12,1)', 'VariableNames', VariableNames1);        
    Table_SPT0.H_m0 = Table_SPT0.H_m0 ./ 100; % convert cm in m
    Table_SPT0.Properties.VariableUnits = {'-','m','s','m2 s','degrees_C','degrees_C','-','-','-','-','degree','degree'};
    % datetime    
    if contains(s_SptFile,'Z')
        startTime = datetime(s_SptFile(end-20:end-4),'InputFormat','yyyy-MM-dd''T''HH''h''mm''Z'); 
    else
        startTime = datetime(s_SptFile(end-19:end-4),'InputFormat','yyyy-MM-dd''T''HH''h''mm');       
        disp([datestr(date_now) ' ' s_SptFile ' is post-processed.'])
    end      
    endTime = startTime + seconds(1800) - seconds(1/1.28) ;
    %
    Table_SPT = table2timetable(Table_SPT0,'RowTimes',(startTime:seconds((1800 - (1/1.28))/(size(Table_SPT0,1)-1)):endTime)'); 
    Table_SPT.Time.TimeZone = 'UTC';
    
    % Table_SPEC
    Table_SPEC0 = table(dataArray{1:end-1}, 'VariableNames', VariableNames2);
    Table_SPEC0 = Table_SPEC0(13:end,1:end); % delete first 12 rows    
    Table_SPEC = table2timetable(Table_SPEC0,'RowTimes',repelem(startTime,size(Table_SPEC0,1))');    
    Table_SPEC.Sf = Table_SPEC.SfSmax .* Table_SPT.Smax;
    Table_SPEC.df = [0.005*ones(15,1); 0.0075; 0.01*ones(48,1)];
    Table_SPEC.Properties.VariableUnits =  {'Hz','-','degree','degree','-','-','m2 s','Hz'};
    Table_SPEC.Time.TimeZone = 'UTC';
    
    dqf_03_compl_spt = 1;
    
catch
    disp([datestr(date_now) ' ' s_SptFile ' is empty  or corrupted.'])
    Table_SPT = [];
    Table_SPEC = [];
    dqf_03_compl_spt = 4;
end

return