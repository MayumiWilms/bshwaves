%% WarnUser
function WarnUser(errorMessage,log_file)
    % Alert user via the command window and a popup message.
    fprintf(1, '%s\n', errorMessage); % To command window.
    %   uiwait(warndlg(errorMessage));

    % Open the Error Log file for appending.
    try
        fullFileName = log_file;
        fid = fopen(fullFileName, 'at');
        fprintf(fid, '%s\n', errorMessage); % To file
        fclose(fid);
    catch
        disp(['The log file ' log_file ' could not be saved.'])
    end

return