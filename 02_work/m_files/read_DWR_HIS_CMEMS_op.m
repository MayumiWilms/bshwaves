function Table_HIS = read_DWR_HIS_CMEMS_op(s_HisFiles,s_InPath)

% import .his to timetable
    % s_HisFiles = 'AV0}2019-08.his';
    % s_InPath = 'I:\DWR\AVF\2019\August';

date_now = datetime('now','TimeZone','UTC');

%% import .his
% VariableNames =  {'Time','T_p','Dir_p','Spr_p','T_z','H_m0','T_I','T_1',...
%     'T_c','T_dw2','T_dw1','T_pc','nu','eps','QP','Ss','Tref','Tsea','Bat'};
VariableNames =  {'Time','VTPK','VPED','VPSP','VTM02','VHM0','VTM20','VTM01',...
    'VTM24','T_dw2','T_dw1','VTPC','VTNU','VTES','VPQP','VSTS','Tref','TEMP','Bat'};
delimiter = ',';
formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(fullfile(s_InPath,s_HisFiles),'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
if ~isempty(dataArray{1,1})
    Table_HIS = table(dataArray{1:end-1}, 'VariableNames', VariableNames); 
    try
        Table_HIS.Time = datetime(Table_HIS.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS''Z'); 
    catch
        Table_HIS.Time = datetime(Table_HIS.Time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS'); 
        disp([datestr(date_now) ' ' fullfile(s_InPath,s_HisFiles) ' is post-processed.'])
    end    
    Table_HIS.VHM0 = Table_HIS.VHM0 ./ 100; % convert cm in m
    Table_HIS.Properties.VariableUnits =  {'','s','°','°','s','m','s','s',...
        's','s','s','s','','','','','','',''};
    Table_HIS.Time.TimeZone = 'UTC';
    Table_HIS = table2timetable(Table_HIS); 
else
    disp([datestr(date_now) ' ' fullfile(s_InPath,s_HisFiles) ' is empty or corrupted.'])
    Table_HIS = [];
end

return