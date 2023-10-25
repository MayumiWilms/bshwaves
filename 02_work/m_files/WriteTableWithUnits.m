function TableToSave = WriteTableWithUnits(TableToWrite, FileName)

[RowNum, ColNum]=size(TableToWrite);
HeaderRow=cell(1,ColNum+1);    
HeaderRow{1,1}='Time';
TableToSave=cell2table(cell(RowNum+1, ColNum+1));
for iCol=1:ColNum
    HeaderRow{1,iCol+1}=[TableToWrite.Properties.VariableNames{iCol}, ' [', TableToWrite.Properties.VariableUnits{iCol},']'];
end
TableToSave{1,:}=HeaderRow;
TableToSave{2:end,1}=cellstr(datestr(TableToWrite.Time,'yyyy-mm-ddTHH:MM:SS.FFFZ'));
TableToSave{2:end,2:end}=table2cell(TableToWrite(:,:));

writetable(TableToSave,FileName,'Delimiter','tab','WriteVariableNames',false)

return