function [Table_RADAC_Czz10, dqf_03_compl_spt] = read_RADAC_Czz10(s_Czz10Files,s_InPath)

% import radac spectrum .txt to timetable
    % Example:
    % Table_RADAC_Czz10 = importfile('20180909.txt','H:\MATLAB\DATA\working_folder\NO1\RADAC\height\Czz10');
    %
    % s_Czz10Files = latest_Czz10;
    % s_InPath = fullfile(s_InPathSystem,'height\Czz10');

date_now = datetime('now','TimeZone','UTC');

%% import .txt
delimiter = ',';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_Czz10Files),'r');
try
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines', 5, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);

    VariableNames = compose('Czz10_%d',1:1:numel(dataArray)-2); % first and last column do not belong to Czz10
    VariableNames = ['Time',VariableNames];
    UnitsNames = cellstr(repmat('m2 s',numel(dataArray)-2,1)); 
    UnitsNames = ['Time';UnitsNames]';

    year = s_Czz10Files(1:4);
    month = s_Czz10Files(5:6);
    day = s_Czz10Files(7:end-4);
    datum = datetime([year,'-',month,'-',day],'InputFormat','yyyy-MM-dd');

    if ~isempty(dataArray{1,1})  
        dataArray2 = cell2mat(dataArray(1:numel(dataArray)-1));
        dataArray2(:,2:end) = dataArray2(:,2:end)./ (100^2); % convert cm^2/Hz in m^2/Hz
        Table_RADAC_Czz10 = array2table(dataArray2, 'VariableNames', VariableNames);
        Table_RADAC_Czz10.Time = datum + seconds(Table_RADAC_Czz10.Time/1000); % convert ms into s    
        Table_RADAC_Czz10.Properties.VariableUnits =  UnitsNames;
        Table_RADAC_Czz10 = table2timetable(Table_RADAC_Czz10);     
        Table_RADAC_Czz10.Time.TimeZone = 'UTC';
        dqf_03_compl_spt = 1;
    else
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_Czz10Files) ' is empty or corrupted.'])
        dqf_03_compl_spt = 4;
    end
catch
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_Czz10Files) ' is empty or corrupted.'])
    Table_RADAC_Czz10 = [];
    dqf_03_compl_spt = 4;
end

return
