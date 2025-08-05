function Table_GPS = read_DWR_GPS_CMEMS_op(s_GpsFiles,s_InPath)

% import gps.txt to timetable
    % s_GpsFiles = 'AV0}2019-08 GPS.txt';
    % s_InPath = 'I:\DWR\AVF\2019\August';

date_now = datetime('now','TimeZone','UTC');

%% import gps.txt
if ~isempty(s_GpsFiles)
    VariableNames =  {'Time','STATUS','LATITUDE','LONGITUDE'};
    delimiter = ' ';
    formatSpec = '%s%f%f%f%[^\n\r]';
    fileID = fopen(fullfile(s_InPath,s_GpsFiles),'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    if strlength(dataArray{1,1}(1:1)) <= 24
        Table_GPS = table(dataArray{1:end-1}, 'VariableNames', VariableNames);
        try
            Table_GPS.Time = datetime(Table_GPS.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS''Z'); 
        catch
            Table_GPS.Time = datetime(Table_GPS.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS'); 
            disp([datestr(date_now) ' ' fullfile(s_InPath,s_GpsFiles) ' is post-processed or Waves5.'])
        end   
        Table_GPS.Properties.VariableUnits = {'','','decimal degrees','decimal degrees'};
        Table_GPS.Time.TimeZone = 'UTC';
        Table_GPS = table2timetable(Table_GPS); 
        clear VariableNames delimiter formatSpec fileID dataArray;
    else                
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_GpsFiles) ' is empty  or corrupted.'])  
        Table_GPS = [];
    end    
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_GpsFiles) ' does not exist.'])
    Table_GPS = [];
end

return