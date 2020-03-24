function createFigure1Plots(inputFolder)
%% load data
fprintf('Creating Figure 1 ...\n') % show progress
rng(37) % make plots reproducible
[D,NSCs,sPhase1,~,~,~]=loadData('PCNA',inputFolder);

%%%
%%% D: distance matrix between all cell coordinates
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% sPhase1: all NSCs being in S-phase at the first time point
%%%


%% Plot Figure 1J
fprintf('Creating Figure 1J ...\n') %show progress

figure('Position',[200,200,600,700]); % create figure
scatter(NSCs(:,1), NSCs(:,2),5,'MarkerEdgeColor','none','MarkerFaceColor',[0.75,0.75,0.75]); % scatter NSCs
hold on; % allow more than one plot in the figure
scatter(sPhase1(:,1), sPhase1(:,2),20,'MarkerEdgeColor','m','MarkerFaceColor','none'); % mark S-phase NSCs
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]); % remove axes
set(gca,'YDir','reverse') % inverse y-Axis as 0,0 is left upper corner for images
legend('NSCs', 'NSCs in S-phase','FontSize',14) % define legend
legend boxoff % remove box around figure

%% Plot Figure 1K
fprintf('Creating Figure 1K ...\n') % show progress

% create distance matrix between S-phase1 cells
sPhase1Ids=ismember(NSCs(:,4),1);
DsP=D(sPhase1Ids,sPhase1Ids);

% calculate discrete Ripley's K values
%%% K: observed K values, Krand: K values from random sampling
[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define radius steps
K=K/10000;Krand=Krand/10000; % reduce numbers for nicer y-axis in plot.
figure('Position',[200,200,750,500]); % create figure
plot(r,K,'k','lineWidth',2); %plot observed K values
hold on; % allow more than one plot in the figure
patch([r fliplr(r)], [quantile(Krand,0.05) fliplr(quantile(Krand,0.95))],...
    [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k'); % plot sampled K CIs
plot(r,mean(Krand),'k--','lineWidth',2) % plot mean of sampled K values
xlabel('Radius [\mum]','Fontsize', 24) % define x-label
ylabel('Discrete Ripley''s K','Fontsize', 24) % define y-label
set(gca,'FontSize',24);  % increase font size
legend('Observed NSCs in S-phase','Random sampling','Location','northwest'); % define legend



