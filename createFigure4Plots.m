function createFigure4Plots(inputFolder)
% load data from excel sheet
fprintf('Creating Figure 4 ...\n') % show progress
%%%
%%% D: distance matrix between all cell coordinates
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% redivs: all NSCs being in (different) S-phases at both time points
%%% DLS: all NSCs sharing the same S-phase
%%%
% read data to plot from table1
data = xlsread(sprintf('%s/Table1',inputFolder));
%% 4F
fprintf('Creating Figure 4F ...\n') % show progress
figure('OuterPosition',[174 624 576 513]);
% generate two vectores with tps and groups for plotting
tps = [repmat(9,4,1);repmat(18,4,1);repmat(24,11,1)];
gs=[ones(4,1);repmat(2,4,1);repmat(3,11,1)];

% extract DLS proportions
DLS=data([1:8,13:23],5)./data([1:8,13:23],2)*100;

groups = splitapply( @(x){x}, DLS, (gs) );
g = tps;
% first plot the box plot to determine plot positions on x-axis
boxplot(DLS,g,'colors','k','positions',[9,18,24]);

hold on; % allow more than one plot in the figure
% second plot single data points
sh=plotSpread(gca,groups,'xValues',[9,18,24]);
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);
% replot boxplot to overlay points
h=boxplot(DLS,g,'colors','k','positions',[9,18,24]);
set(h,{'linew'},{2})

% modify x-axis labels
xticks([0,20,40,60,80]);
xticklabels([0,20,40,60,80]);

ylabel({'Double labelled'; 'S-phases (DLS) [%]'}); % Create ylabel
xlabel('Labelling interval \Deltat [h]'); % Create xlabel
% adapt axis limits
xlim([0 80]);
ylim([0 100]);
box('on');
set(gca,'FontSize',22);
%% 4T
fprintf('Creating Figure 4T ...\n') % show progress
figure('OuterPosition',[174 624 576 513]);
% generate two vectores with tps and groups for plotting
tps = [repmat(18,1,1);repmat(24,11,1);repmat(32,4,1);repmat(48,4,1);repmat(72,5,1)];
gs=[ones(1,1);repmat(2,11,1);repmat(3,4,1);repmat(4,4,1);repmat(5,5,1)];
% extract re-dividing cell proportions
redivs=data([6,13:end],4)./data([6,13:end],2)*100;
groups = splitapply( @(x){x}, redivs, (gs) );

% first plot the box plot to determine plot positions on x-axis
boxplot(redivs,tps,'positions',[18,24,32,48,72],'colors','k');
hold on; % allow more than one plot in the figure
% plot all single data points
sh=plotSpread(gca,groups,'xValues',[18,24,32,48,72]);
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);
% replot boxplot to overlay points
h=boxplot(redivs,tps,'positions',[18,24,32,48,72],'colors','k');
set(h,{'linew'},{2})
% define xticks below the boxplots
xticks([0,20,40,60,80]);
xticklabels([0,20,40,60,80]);

ylabel('Re-dividing NSCs [%]');% Create ylabel
xlabel('Labelling interval \Deltat [h]');% Create xlabel
xlim([0 80]); % Define x limits
ylim([0 27]); % Define y limits
box('on');
set(gca,'FontSize',22);

%% 4U
fprintf('Creating Figure 4U ...\n') % show progress
divs=data(:,2)./data(:,1)*100;
figure;
% create labels to plot divs and re-divs
g = [zeros(length(divs), 1); ones(length(redivs), 1)];
boxplot([divs;redivs],g,'colors','k','Width',0.7); %plot it first for legend reasons

hold on; % allow more than one plot in the figure
% plot single data points
sh=plotSpread(gca,{divs,redivs}); 
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);

% replot boxplot to overlay points
h=boxplot([divs;redivs],g,'colors','k','Width',0.7); 
set(h,{'linew'},{2})

% label the boxplots
set(gca,'XTickLabel',{'Divisions','Re-divisions'},'FontSize',22)

% modify y axis
ylim([0 27]);
yticks([0,10,20]);
yticklabels([0,10,20]);
ylabel({'Dividing and re-dividing NSCs [%]'},'FontSize',22)

set(gca,'FontSize',22); % increase font size
% test for significance and plot the respective amount of stars
[~,y]=kstest2(divs',redivs');
s=sigstar([1,2],y);
set(s(2),'fontSize',15)