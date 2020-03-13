function createFigure1Plots(inputFolder)
%% load data
fprintf('Creating Figure 1 ...\n')
rng(37)
[D,NSCs,sPhase1,~,~,~]=loadData('PCNA',inputFolder);

%% Plot Figure 1J
fprintf('Creating Figure 1J ...\n')
figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),5,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on;
scatter(sPhase1(:,1), sPhase1(:,2),20,'MarkerEdgeColor','m','MarkerFaceColor','none'); % mark S-phase NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend('NSCs', 'NSCs in S-phase','FontSize',14) % define legend
legend boxoff

%% Plot Figure 1K
fprintf('Creating Figure 1K ...\n')
%create distance matrix between S-phase cells
sPhase1Ids=ismember(NSCs(:,4),1);
DsP=D(sPhase1Ids,sPhase1Ids);

%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling
[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define time steps
K=K/10000;Krand=Krand/10000; % reduce numbers for nicer y-axis in plot.
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



