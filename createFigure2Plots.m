function createFigure2Plots(inputFolder)
%%inputFolder='F:/Brains'; %modify
%% load data
fprintf('Creating Figure 2 ...\n') % show progress
rng(pi) % make plots reproducible
[D,NSCs,sPhase1,sPhase2,~,redivs]=loadData('Interval_32h_H1',inputFolder);

%%%
%%% D: distance matrix between all cell coordinates
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% sPhase1: all NSCs being in S-phase at the first time point
%%% sPhase2: all NSCs being in S-phase at the second time point
%%% redivs: all NSCs being in (different) S-phases at both time points
%%%


%% Plot Figure 2E
fprintf('Creating Figure 2E ...\n') % show progress
figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),8,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on; % allow more than one plot in the figure
scatter(sPhase1(:,1), sPhase1(:,2),30,'MarkerEdgeColor','c','MarkerFaceColor','none','LineWidth',2); % mark S-phase NSCs at time point1
scatter(redivs(:,1), redivs(:,2),30,'MarkerEdgeColor','c','MarkerFaceColor','none','LineWidth',2); % mark re-dividing NSCs (being in S-phase at both time points)
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
camroll(-90) % adapt to the angle in the Figure

%% Plot Figure 2F
fprintf('Creating Figure 2F ...\n') % show progress
figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),8,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on; % allow more than one plot in the figure
scatter(sPhase2(:,1), sPhase2(:,2),30,'MarkerEdgeColor','m','MarkerFaceColor','none','LineWidth',2); % mark S-phase 2 NSCs
scatter(redivs(:,1), redivs(:,2),30,'MarkerEdgeColor','m','MarkerFaceColor','none','LineWidth',2); % mark re-dividing NSCs (being in S-phase at both time points)
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
camroll(-90) % adapt to the angle in the Figure

%% Plot Figure 2G
fprintf('Creating Figure 2G ...\n') % show progress
figure('Position',[200,200,600,800]); % create figure
scatter(NSCs(:,1), NSCs(:,2),8,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on; % allow more than one plot in the figure
scatter(sPhase1(:,1), sPhase1(:,2),30,'MarkerEdgeColor','c','MarkerFaceColor','none','LineWidth',2); % mark S-phase NSCs at Timepoint1
scatter(sPhase2(:,1), sPhase2(:,2),30,'MarkerEdgeColor','m','MarkerFaceColor','none','LineWidth',2); % mark S-phase NSCs at Timepoint2
scatter(redivs(:,1), redivs(:,2),30,'MarkerEdgeColor','c','MarkerFaceColor','none','LineWidth',2); % mark re-dividing NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend('NSCs', 'NSCs in S-phase at Time 1','NSCs in S-phase at Time 2','FontSize',18,'Location','southoutside') % define legend
legend boxoff % remove box around figure
camroll(-90) % to adapt to the angle in the Figure

%% Plot Figure 2H
fprintf('Creating Figure 2H ...\n') % show progress
sPhase1Ids=logical(ismember(NSCs(:,4),1)+ismember(NSCs(:,4),4));
sPhase2Ids=ismember(NSCs(:,4),2);
DsP=D(sPhase1Ids,sPhase2Ids);

%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling
[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define radius steps
K=K/40000;Krand=Krand/40000; % reduce numbers for nicer y-axis in plot.
figure('Position',[200,200,750,500]); % create figure
plot(r,K,'k','lineWidth',2); %plot observd K value
hold on; % allow more than one plot in the figure
patch([r fliplr(r)], [quantile(Krand,0.05) fliplr(quantile(Krand,0.95))],...
    [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k'); % plot sampled K CIs
plot(r,mean(Krand),'k--','lineWidth',2) % plot mean of sampled K values
xlabel('Radius [\mum]','Fontsize', 24) % define x-label
ylabel('Discrete Ripley''s K','Fontsize', 24) % define y-label
set(gca,'FontSize',24); % increase font size
legend('Observed NSCs in S-phase','Random sampling','Location','northwest','FontSize',24); % define legend

%% Plot Figure 2I
fprintf('Creating Figure 2I ...\n') % show progress
rng(pi) % make plots reproducible
figure('position',[100,100,1400,800]); % create figure
hold on; % allow more than one plot in the figure

%iterate over all four hemispheres having a 32h staining interval
for i = 1:4 
    [D,NSCs,~,~,~,~]=loadData(sprintf('Interval_32h_H%i',i),inputFolder); 
    sPhase1Ids=logical(ismember(NSCs(:,4),1)+ismember(NSCs(:,4),4)); % find all S-phase1 and re-dividing cells
    sPhase2Ids=ismember(NSCs(:,4),2); % find all S-phase2 cells
    DsP=D(sPhase1Ids,sPhase2Ids); % extract distance matrix between sP1 and sP2 cells from D
    %calculate discrete Ripley's K values
    %K = observed K values, Krand = K values from random sampling
    [K,Krand]=calculateRipleysK(NSCs, D, DsP); 
    % plot observed K values depending on the 5% and 95% CI of randomly
    % sampled K values
    plot(1:150,(K-mean(Krand))./(quantile(Krand,0.90)-mean(Krand)),'k','LineWidth',2); 
end
% plot gray area between -1 and 1 and the mean at 0
patch([[0,150] fliplr([0,150])], [[-1,-1] fliplr([1,1])], [0.5,0.5,0.5],'FaceAlpha',.5)
hline(0,'k--')
hline(-1,'k')
hline(1,'k')
ylim([-3,6]) % set y limits
xlabel('Radius [\mum]','Fontsize', 24) % define x-label
ylabel('Standardized K','Fontsize', 24); % define y-label
set(gca,'FontSize',24); % increase font size