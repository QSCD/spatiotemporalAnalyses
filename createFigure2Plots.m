function createFigure2Plots(inputFolder)
fprintf('Creating Figure 2 ...\n') % show progress
%% 2A plot all brains in one figure
fprintf('Creating Figure 2A ...\n') % show progress
%%%
%%% D: distance matrix between all cell coordinates
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% sPhase1: all NSCs being in S-phase at the first time point
%%% sPhase2: all NSCs being in S-phase at the second time point
%%% redivs: all NSCs being in (different) S-phases at both time points
%%% DLS: all NSCs sharing the same S-phase (double labelled S-phases)
%%%

%define figure properties
figure('Position',[498,47,950,950]);
[ha,~]=tight_subplot(6,6,[.0001 .0001],[.0001 .0001],[.0001 .0001]);
counter=0;
%c={'k','w'}; %if black bg and white font
c={'w','k'};%if white bg and black font
intervals={'9h','18h','24h','32h','48h','72h'}; %labelling intervals
files = dir(inputFolder);
% iterate over all labelling intervals
for  iv=1:numel(intervals)
    interval=intervals{iv};
    fileCount=count([files.name],sprintf('cells_Interval_%s',interval));
    %iterate over all files of one labelling interval
    for i=1:fileCount
        [~,NSCs,sPhase1,sPhase2,DLS,redivs]=loadData(sprintf("Interval_%s_H%i",interval,i),inputFolder,1);
        counter=counter+1;
        axes(ha(counter)); % needed to manage tight_subplot function
        hold on; % allow more than one plot in the subfigure
        % scatter all different S-phase type cells
        scatter(NSCs(:,1),NSCs(:,2),1,[0.75,0.75,0.75]);
        scatter(sPhase1(:,1),sPhase1(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c');
        scatter(sPhase2(:,1),sPhase2(:,2),5,'MarkerEdgeColor','m','MarkerFaceColor','m');        
        scatter(redivs(:,1),redivs(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c'); 
        scatter(DLS(:,1),DLS(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c'); 
        
        % insert scale bar in upper right subplot
        if strcmp(interval ,'18h') && i==2
            plot([600,600+150],[650,650],c{2},'Linewidth',2.5)
            text(440,700,'150\mum','Color', c{2},'FontSize',16)
        end
        
        text(50,60,['\Deltat=',interval],'Color', c{2},'FontSize',16) % include staining interval as text
        set(gca,'Color',c{1}) % set background color
        set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
        set(gca,'ytick',[],'yticklabel',[],'xtick',[],'xticklabel',[]) % remove axes
        xlim([0,775]) % fix x limits for comparability
        ylim([0,775]) % fix y limits for comparability
        box % add box around plot
    end
    
end
set(gca,'FontSize',16)
%% load/generate data to plot 2B and C
fprintf('Creating Figure 2B ...\n')
% either load pre-optimized results
% or uncomment the next line to call the parameterInference function to create the data yourself which may take 2h
load(sprintf('%s/preprocessedData/expData.mat',extractBefore(inputFolder, '/Brains')),'parameters');
%parameters=parameterInference(inputFolder,{'32'});
%% plot Figure 2B
% extract strength and radus properties from the parameter inference data
optionsCI = PestoOptions();
optionsCI.mode = 'silent';
pi32=parameters{32};
pi32=getParameterConfidenceIntervals(pi32,0.95,optionsCI);
maxLStr=pi32.MS.par(2,1); % get strength maximum likelihood value
maxLRad=pi32.MS.par(1,1); % get radius maximum likelihood value
strengthsCI(1) = pi32.CI.S(2,1); % get strength lower CI value
strengthsCI(2) = pi32.CI.S(2,2); % get strength upper CI value
radiiCI(1) = pi32.CI.S(1,1); % get radius lower CI value
radiiCI(2) = pi32.CI.S(1,2); % get radius upper CI value

figure; % new figure
dscatter(pi32.S.par(1,:)',pi32.S.par(2,:)'); 
hold on; % allow more than one plot in the figure
colormap copper
% plot a line which defines random values at y=1
hl=hline(1); 
hl.LineWidth=2;
hl.Color='k';
hl.XData=[0,250];

ylabel('Strength') % define y-label
xlabel('Radius [\mum]') % define x-label
ylim([0.8,1.6]) % set y limits
xlim([0,250]) % set x limits
text(180,1.5,'\Deltat=32h','Color', 'k','FontSize',24)  % include labelling interval as text
% plot maximum likelihood values with CIs as error bars
h=ploterr(maxLRad,maxLStr,{radiiCI(1),radiiCI(2)},{strengthsCI(1),strengthsCI(2)},'k.');
h(1).MarkerSize=20;
h(2).LineWidth=3;
h(3).LineWidth=3;
h=colorbar('north','Position',...
    [0.222619047619048 0.857142857142857 0.29702380952381 0.0507936507936509],...
    'Ticks',[0.02 0.95],...
    'TickLength',0,...
    'TickLabels',{'low','high'});
text(34, 1.48,'Density','Color', 'k','FontSize',24)  % include labelling interval as text
set(gca,'FontSize',24) % increase font size

%% plot Figure 2CD
fprintf('Creating Figure 2C and 2D ...\n') % show progress
plotParameterInference(parameters,1);

end

