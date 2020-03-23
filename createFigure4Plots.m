function createFigure4Plots(inputFolder)
% load data from excel sheet
fprintf('Creating Figure 4 ...\n')
data = xlsread(sprintf('%s/Table1',inputFolder));
%% 4F 
fprintf('Creating Figure 4F ...\n')
figure('OuterPosition',[174 624 576 513]);
% generate two vectores with tps and groups for plotting
tps = [repmat(9,4,1);repmat(18,4,1);repmat(24,11,1)];
gs=[ones(4,1);repmat(2,4,1);repmat(3,11,1)];

% extract DLS proportions
DLS=data([1:8,13:23],5)./data([1:8,13:23],2)*100;

groups = splitapply( @(x){x}, [DLS], (gs) );
g = tps;
% first plot the box plot to determine plot positions on x-axis
boxplot(DLS,g,'colors','k','positions',[9,18,24]);

hold on;
% second plot single data points
sh=plotSpread(gca,groups,'xValues',[9,18,24]);
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);
% replot boxplot to overlay points
h=boxplot(DLS,g,'colors','k','positions',[9,18,24]);
set(h,{'linew'},{2})

% modify x-axis labels
xticks([0,20,40,60,80]);
xticklabels([0,20,40,60,80]);

% Create ylabel
ylabel({'Double labelled'; 'S-phases (DLS) [%]'});

% Create xlabel
xlabel('Labelling interval \Deltat [h]');
% adapt axis limits
 xlim([0 80]);
 ylim([0 100]);
box('on');
set(gca,'FontSize',22);
%% 4T
fprintf('Creating Figure 4T ...\n')
figure('OuterPosition',[174 624 576 513]);

tps = [repmat(18,4,1);repmat(24,11,1);repmat(32,4,1);repmat(48,4,1);repmat(72,5,1)];
gs=[repmat(1,4,1);repmat(2,11,1);repmat(3,4,1);repmat(4,4,1);repmat(5,5,1)];
% Crea
redivs=data([5:8,13:end],4)./data([5:8,13:end],2)*100;
groups = splitapply( @(x){x}, [redivs], (gs) );
g = tps;
boxplot(redivs,g,'positions',[18,24,32,48,72],'colors','k');

hold on;
sh=plotSpread(gca,groups,'xValues',[18,24,32,48,72]);
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);
h=boxplot(redivs,g,'positions',[18,24,32,48,72],'colors','k');
set(h,{'linew'},{2})
xticks([0,20,40,60,80]);
xticklabels([0,20,40,60,80]);
% Create ylabel
ylabel('Re-dividing NSCs [%]');

% Create xlabel
xlabel('Labelling interval \Deltat [h]');

% Uncomment the following line to preserve the X-limits of the axes
 xlim([0 80]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim([0 27]);
box('on');
% Set the remaining axes properties
set(gca,'FontSize',22);

%% 4U
fprintf('Creating Figure 4U ...\n')
divs=data(:,2)./data(:,1)*100;
figure;
g = [zeros(length(divs), 1); ones(length(redivs), 1)];
boxplot([divs;redivs],g,'colors','k','Width',0.7); %plot it first for legend reasons

hold on;
sh=plotSpread(gca,{divs,redivs});
set(sh{1},'color',[0.5,0.5,0.5],'markerSize',20);
h=boxplot([divs;redivs],g,'colors','k','Width',0.7); %replot it over boxes
set(h,{'linew'},{2})
ylabel({'Dividing NSCs [%]'},'FontSize',22)
set(gca,'XTickLabel',{'Divisions','Re-divisions'},'FontSize',22)
ylim([0 27]);
yticks([0,10,20]);
yticklabels([0,10,20]);
set(gca,'FontSize',22);
[~,y]=kstest2(divs',redivs');
s=sigstar([1,2],y);
set(s(2),'fontSize',15)