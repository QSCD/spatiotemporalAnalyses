%createFigure2Plots
inputFolder='F:\Brains'; %modify
%% load data
rng(pi)
[D,NSCs,sPhase1,sPhase2,~,redivs]=loadData('Interval_32h_H1',inputFolder);

%% Plot Figure 2E
figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),5,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on;
scatter(sPhase1(:,1), sPhase1(:,2),20,'MarkerEdgeColor','c','MarkerFaceColor','none'); % mark S-phase NSCs at Timepoint1
scatter(redivs(:,1), redivs(:,2),20,'MarkerEdgeColor','c','MarkerFaceColor','none'); % mark re-dividing NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend boxoff
camroll(-90) % to adapt to the angle in the Figure

%% Plot Figure 2F
figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),5,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on;
scatter(sPhase2(:,1), sPhase2(:,2),20,'MarkerEdgeColor','m','MarkerFaceColor','none'); % mark S-phase 2 NSCs
scatter(redivs(:,1), redivs(:,2),20,'MarkerEdgeColor','m','MarkerFaceColor','none'); % mark re-dividing NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend boxoff
camroll(-90) % to adapt to the angle in the Figure

%% Plot Figure 2G
figure('Position',[200,200,600,800]); % create figure
scatter(NSCs(:,1), NSCs(:,2),5,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on;
scatter(sPhase1(:,1), sPhase1(:,2),20,'MarkerEdgeColor','c','MarkerFaceColor','none'); % mark S-phase NSCs at Timepoint1
scatter(sPhase2(:,1), sPhase2(:,2),20,'MarkerEdgeColor','m','MarkerFaceColor','none'); % mark S-phase NSCs at Timepoint2
scatter(redivs(:,1), redivs(:,2),20,'MarkerEdgeColor','c','MarkerFaceColor','none'); % mark re-dividing NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend('NSCs', 'NSCs in S-phase at Time 1','NSCs in S-phase at Time 2','FontSize',14,'Location','southoutside') % define legend
legend boxoff
camroll(-90) % to adapt to the angle in the Figure

%% Plot Figure 2H
sPhase1Ids=logical(ismember(NSCs(:,4),1)+ismember(NSCs(:,4),4));
sPhase2Ids=ismember(NSCs(:,4),2);
DsP=D(sPhase1Ids,sPhase2Ids);

%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling

[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define time steps
K=K/40000;Krand=Krand/40000; % reduce numbers for nicer y-axis in plot.
figure('Position',[200,200,750,500]); % create figure
plot(r,K,'k','lineWidth',2); %plot observd K value
hold on;
patch([r fliplr(r)], [quantile(Krand,0.05) fliplr(quantile(Krand,0.95))],...
    [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k'); % plot sampled K CIs
plot(r,mean(Krand),'k--','lineWidth',2) % plot mean of sampled K values
xlabel('Radius [\mum]','Fontsize', 24)
ylabel('Discrete Ripley''s K','Fontsize', 24)
set(gca,'FontSize',24);
legend('Observed NSCs in S-phase','Random sampling','Location','northwest');

%% Plot Figure 2I
rng(pi)
figure('position',[100,100,1400,800]);
hold on;
%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling
for i = 1:15
    [D,NSCs,sPhase1,sPhase2,~,redivs]=loadData(sprintf('Interval_24h_H%i',i),inputFolder);
    sPhase1Ids=logical(ismember(NSCs(:,4),1)+ismember(NSCs(:,4),4));
    sPhase2Ids=ismember(NSCs(:,4),2);
    DsP=D(sPhase1Ids,sPhase2Ids);
    [K,Krand]=calculateRipleysK(NSCs, D, DsP);
    plot(1:150,(K-mean(Krand))./(quantile(Krand,0.90)-mean(Krand)),'k','LineWidth',2);
end
patch([[0,150] fliplr([0,150])], [[-1,-1] fliplr([1,1])], [0.5,0.5,0.5],'FaceAlpha',.5)
hline(0,'k--')
hline(-1,'k')
hline(1,'k')
ylim([-3,6])
xlabel('Radius [\mum]','Fontsize', 24)
ylabel('Standardized K','Fontsize', 24);
set(gca,'FontSize',24);