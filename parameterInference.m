function parameters=parameterInference(inputFolder,intervals)

%
%returns the most likely parameters via parameter inference for a give labelling intervals
%

files = dir(inputFolder);
%iterate over all labelling intervals and infer the best parameters
for  iv=1:numel(intervals)
    interval=intervals{iv};
    fileCount=count([files.name],sprintf('cells_Interval_%s',interval));
    intNum = str2double(interval(1:end-1));
    funs=[]; %collects the objective functions over several experiments
    nrs=[]; % saves the input sizes per experiment
    for i=1:fileCount
        %load data and determine sPhase1 and sPhase2 cells
        [D,NSCs,~,~,~,~]=loadData(sprintf("Interval_%s_H%i",interval,i),inputFolder);
        sPhase1Ids=logical(ismember(NSCs(:,4),1)+ismember(NSCs(:,4),4));
        sPhase2Ids=ismember(NSCs(:,4),2);
        
        DsP=D(sPhase1Ids,sPhase2Ids);   % distance matrix between sPhase1 and sPhase2 cells
        Dall= D(sPhase1Ids,~sPhase1Ids); %distance matrix between sPhase1 and all other cells
        
        %define the ojective function for one experiment
        objFun = @(sigma)-sum(log(localInfluence(DsP,sigma(1),sigma(2))/sum(localInfluence(Dall,sigma(1),sigma(2)))));
        %save function and numbers
        funs{i}=objFun;
        nrs{i}=size(DsP);
        
    end
    %combine all objective functions of all experiments for one labelling interval
    funMultiDens = @(sigma) addObjFunctions(sigma,funs);
    parameters{intNum}.objFkt =funMultiDens;    
    
    %% call pesto parameter inference toolbox    
    parameters{intNum}=callPesto({'radius','strength'},[20,0],[300,20],funMultiDens,'dhc',50,nrs,1);
    
end