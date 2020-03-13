function createTable1(inputFolder, outputFolder)
fprintf('Creating Table 1 ...\n')
intervals={'9h','18h','24h','32h','48h','72h'};
files = dir(inputFolder);
counter=1;
%manualCorrection= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,9,10,2,0,2,5,0,1,2,1,1,0,0,1,4,0,0,1,1];
xlswrite(sprintf('%s/Table1.xlsx',outputFolder),{'Experiment','NSCs','T1 NSCs','T2 NSCs','NSC redivisions','DLS NSCs'},1,'A1');
for  iv=1:numel(intervals)
    interval=intervals{iv};
    fileCount=count([files.name],sprintf('cells_Interval_%s',interval));
    intNum = str2double(interval(1:end-1));
    for i=1:fileCount
        [~,NSCs,sPhase1,sPhase2,DLS,redivs]=loadData(sprintf("Interval_%s_H%i",interval,i),inputFolder,1);   
        
        xlswrite(sprintf('%s/Table1.xlsx',outputFolder),...
            {sprintf('Interval %s H%i',interval,i),size(NSCs,1),size(sPhase1,1)+size(redivs,1)+size(DLS,1),size(sPhase2,1)+size(redivs,1)+size(DLS,1)...
            size(redivs,1),size(DLS,1)},1,strcat('A',string(counter+1)));
        counter=counter+1;
    end
end

