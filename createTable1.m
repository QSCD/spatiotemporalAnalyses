function createTable1(inputFolder, outputFolder)
%%%
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% sPhase1: all NSCs being in S-phase at the first time point
%%% sPhase2: all NSCs being in S-phase at the second time point
%%% redivs: all NSCs being in (different) S-phases at both time points
%%% DLS: all NSCs sharing the same S-phase (double labelled S-phases)
%%%
fprintf('Creating Table 1 ...\n') % show progress
intervals={'9h','18h','24h','32h','48h','72h'}; % define labelling intervals
files = dir(inputFolder);
counter=1;
data=[];
exps=[];
% write header to excel sheet
%xlswrite(sprintf('%s/Table1.xlsx',outputFolder),{'Experiment','NSCs','T1 NSCs','T2 NSCs','NSC redivisions','DLS NSCs'},1,'A1');
%iterate over all labelling intervals
for  iv=1:numel(intervals)
    interval=intervals{iv};
    fileCount=count([files.name],sprintf('cells_Interval_%s',interval));
    % iterate over all files of one lablelling interval
    for i=1:fileCount
        % load data of one hemisphere
        [~,NSCs,sPhase1,sPhase2,DLS,redivs]=loadData(sprintf("Interval_%s_H%i",interval,i),inputFolder,1);
        % write numbers to excel sheet
        data=[data;[size(NSCs,1),size(sPhase1,1)+size(redivs,1)+size(DLS,1),size(sPhase2,1)+size(redivs,1)+size(DLS,1)...
            size(redivs,1),size(DLS,1)]];
        exps{end+1}=sprintf('Interval %s H%i',interval,i);
       % xlswrite(sprintf('%s/Table1.xlsx',outputFolder),...
        %    {sprintf('Interval %s H%i',interval,i),size(NSCs,1),size(sPhase1,1)+size(redivs,1)+size(DLS,1),size(sPhase2,1)+size(redivs,1)+size(DLS,1)...
        %    size(redivs,1),size(DLS,1)},1,strcat('A',string(counter+1)));
        counter=counter+1;
    end
end

T = [cell2table(exps', 'VariableNames', {'Experiments'}),  array2table(data,'VariableNames',{'NSCs','T1 NSCs','T2 NSCs','NSC redivisions','DLS NSCs'})];
writetable(T,sprintf('%s/Table1.xlsx',outputFolder),'Sheet',1,'Range','A1');

