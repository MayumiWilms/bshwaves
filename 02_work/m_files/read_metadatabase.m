function Metadatenbank = read_metadatabase(workbookFile, sheetName, dataLines)

% import data from a spreadsheet
    %  Example:
    %  Metadatenbank = read_metadatabase("H:\MATLAB\DQC_Server\work\DQC\Metadatenbank.xlsx", "DWR");

switch upper(sheetName)
    case 'DWR'
        % Input handling

        % If no sheet is specified, read first sheet
        if nargin == 1 || isempty(sheetName)
            sheetName = 1;
        end        
        
        % If row start and end points are not specified, define defaults
        if nargin <= 2
            dataLines = [2, 30];    
        end

        % Setup the Import Options
        opts = spreadsheetImportOptions("NumVariables", 116);

        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "A" + dataLines(1, 1) + ":DL" + dataLines(1, 2);

        % Specify column names and types
        opts.VariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VTM20MIN", "VTM20MAX", "VTM01MIN", "VTM01MAX", "VTM24MIN", "VTM24MAX", "VTPCMIN", "VTPCMAX", "VT110MIN", "VT110MAX", "VPEDMIN", "VPEDMAX", "VPSPMIN", "VPSPMAX", "TEMPMIN", "TEMPMAX", "VTNUMIN", "VTNUMAX", "VTESMIN", "VTESMAX", "VTZCMIN", "VTZCMAX", "VPQPMIN", "VPQPMAX", "VSTSMIN", "VSTSMAX", "VZNWMIN", "VZNWMAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "MAXVTM20DIFF", "MAXVTM01DIFF", "MAXVTM24DIFF", "MAXVTPCDIFF", "MAXVT110DIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VTM20", "EPS_VTM01", "EPS_VTM24", "EPS_VTPC", "EPS_VT110", "EPS_VPED", "EPS_VPSP", "EPS_TEMP", "EPS_VTNU", "EPS_VTES", "EPS_VTZC", "EPS_VPQP", "EPS_VSTS", "EPS_VZNW", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "MAXVTM20DIFFSTD", "MAXVTM01DIFFSTD", "MAXVTM24DIFFSTD", "MAXVTPCDIFFSTD", "MAXVT110DIFFSTD", "EPS_HEAVE"];
        opts.SelectedVariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VTM20MIN", "VTM20MAX", "VTM01MIN", "VTM01MAX", "VTM24MIN", "VTM24MAX", "VTPCMIN", "VTPCMAX", "VT110MIN", "VT110MAX", "VPEDMIN", "VPEDMAX", "VPSPMIN", "VPSPMAX", "TEMPMIN", "TEMPMAX", "VTNUMIN", "VTNUMAX", "VTESMIN", "VTESMAX", "VTZCMIN", "VTZCMAX", "VPQPMIN", "VPQPMAX", "VSTSMIN", "VSTSMAX", "VZNWMIN", "VZNWMAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "MAXVTM20DIFF", "MAXVTM01DIFF", "MAXVTM24DIFF", "MAXVTPCDIFF", "MAXVT110DIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VTM20", "EPS_VTM01", "EPS_VTM24", "EPS_VTPC", "EPS_VT110", "EPS_VPED", "EPS_VPSP", "EPS_TEMP", "EPS_VTNU", "EPS_VTES", "EPS_VTZC", "EPS_VPQP", "EPS_VSTS", "EPS_VZNW", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "MAXVTM20DIFFSTD", "MAXVTM01DIFFSTD", "MAXVTM24DIFFSTD", "MAXVTPCDIFFSTD", "MAXVT110DIFFSTD", "EPS_HEAVE"];
        opts.VariableTypes = ["string", "string", "double", "double", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
        opts = setvaropts(opts, 6, "InputFormat", "");
        opts = setvaropts(opts, 7, "InputFormat", "");
        opts = setvaropts(opts, [1, 2], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, [1, 2], "EmptyFieldRule", "auto");        
        
        % Import the data
        Metadatenbank = readtable(workbookFile, opts, "UseExcel", false);

        for idx = 2:size(dataLines, 1)
            opts.DataRange = "A" + dataLines(idx, 1) + ":DL" + dataLines(idx, 2);
            tb = readtable(workbookFile, opts, "UseExcel", false);
            Metadatenbank = [Metadatenbank; tb]; %#ok<AGROW>
        end        

    case 'RADAC'
        % Input handling

        % If no sheet is specified, read first sheet
        if nargin == 1 || isempty(sheetName)
            sheetName = 2;
        end

        % If row start and end points are not specified, define defaults
        if nargin <= 2
            dataLines = [2, 30];
        end

        % Setup the Import Options
        opts = spreadsheetImportOptions("NumVariables", 82);

        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "A" + dataLines(1, 1) + ":CD" + dataLines(1, 2);

        % Specify column names and types
        opts.VariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VPEDMIN", "VPEDMAX", "VPSPMIN", "VPSPMAX", "VMDRMIN", "VMDRMAX", "VZNWMIN", "VZNWMAX", "SLEV_H1MIN", "SLEV_H1MAX", "SLEV_H10MIN", "SLEV_H10MAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VPED", "EPS_VPSP", "EPS_VMDR", "EPS_VZNW", "EPS_SLEV_H1", "EPS_SLEV_H10", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "EPS_HEAVE"];
        opts.SelectedVariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VPEDMIN", "VPEDMAX", "VPSPMIN", "VPSPMAX", "VMDRMIN", "VMDRMAX", "VZNWMIN", "VZNWMAX", "SLEV_H1MIN", "SLEV_H1MAX", "SLEV_H10MIN", "SLEV_H10MAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VPED", "EPS_VPSP", "EPS_VMDR", "EPS_VZNW", "EPS_SLEV_H1", "EPS_SLEV_H10", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "EPS_HEAVE"];
        opts.VariableTypes = ["string", "string", "double", "double", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
        opts = setvaropts(opts, 6, "InputFormat", "");
        opts = setvaropts(opts, 7, "InputFormat", "");
        opts = setvaropts(opts, [1, 2], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, [1, 2], "EmptyFieldRule", "auto");

        % Import the data
        Metadatenbank = readtable(workbookFile, opts, "UseExcel", false);

        for idx = 2:size(dataLines, 1)
            opts.DataRange = "A" + dataLines(idx, 1) + ":CD" + dataLines(idx, 2);
            tb = readtable(workbookFile, opts, "UseExcel", false);
            Metadatenbank = [Metadatenbank; tb]; %#ok<AGROW>
        end


    case 'RADAC_SINGLE'   
        % Input handling

        % If no sheet is specified, read first sheet
        if nargin == 1 || isempty(sheetName)
            sheetName = 3;
        end

        % If row start and end points are not specified, define defaults
        if nargin <= 2
            dataLines = [2, 30];
        end

        % Setup the Import Options
        opts = spreadsheetImportOptions("NumVariables", 73);

        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "A" + dataLines(1, 1) + ":BU" + dataLines(1, 2);

        % Specify column names and types
        opts.VariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VZNWMIN", "VZNWMAX", "SLEV_H1MIN", "SLEV_H1MAX", "SLEV_H10MIN", "SLEV_H10MAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VZNW", "EPS_SLEV_H1", "EPS_SLEV_H10", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "EPS_HEAVE"];
        opts.SelectedVariableNames = ["platform_code", "platform_name", "LATITUDE", "LONGITUDE", "water_depth", "tlower", "tupper", "EPS_LAT", "EPS_LON", "IMIN", "IMAX", "LMIN", "LMAX", "VHM0MIN", "VHM0MAX", "VZMXMIN", "VZMXMAX", "VH110MIN", "VH110MAX", "VAVHMIN", "VAVHMAX", "VHZAMIN", "VHZAMAX", "VTPKMIN", "VTPKMAX", "VTM02MIN", "VTM02MAX", "VTZMMIN", "VTZMMAX", "VAVTMIN", "VAVTMAX", "VTZAMIN", "VTZAMAX", "VZNWMIN", "VZNWMAX", "SLEV_H1MIN", "SLEV_H1MAX", "SLEV_H10MIN", "SLEV_H10MAX", "MAXVHM0DIFF", "MAXVZMXDIFF", "MAXVH110DIFF", "MAXVAVHDIFF", "MAXVHZADIFF", "MAXVTPKDIFF", "MAXVTM02DIFF", "MAXVTZMDIFF", "MAXVAVTDIFF", "MAXVTZADIFF", "EPS_VHM0", "EPS_VZMX", "EPS_VH110", "EPS_VAVH", "EPS_VHZA", "EPS_VTPK", "EPS_VTM02", "EPS_VTZM", "EPS_VAVT", "EPS_VTZA", "EPS_VZNW", "EPS_SLEV_H1", "EPS_SLEV_H10", "MAXVHM0DIFFSTD", "MAXVZMXDIFFSTD", "MAXVH110DIFFSTD", "MAXVAVHDIFFSTD", "MAXVHZADIFFSTD", "MAXVTPKDIFFSTD", "MAXVTM02DIFFSTD", "MAXVTZMDIFFSTD", "MAXVAVTDIFFSTD", "MAXVTZADIFFSTD", "EPS_HEAVE"];
        opts.VariableTypes = ["string", "string", "double", "double", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
        opts = setvaropts(opts, 6, "InputFormat", "");
        opts = setvaropts(opts, 7, "InputFormat", "");
        opts = setvaropts(opts, [1, 2], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, [1, 2], "EmptyFieldRule", "auto");

        % Import the data
        Metadatenbank = readtable(workbookFile, opts, "UseExcel", false);

        for idx = 2:size(dataLines, 1)
            opts.DataRange = "A" + dataLines(idx, 1) + ":BU" + dataLines(idx, 2);
            tb = readtable(workbookFile, opts, "UseExcel", false);
            Metadatenbank = [Metadatenbank; tb]; %#ok<AGROW>
        end

    case 'AWAC'

    otherwise
        warning('Unexpected sensor type.')     
end

return