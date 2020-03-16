function createFigure5Plots(inputFolder)

%% load redivision morpheus example data
fprintf('Creating Figure 5 ...\n')
[gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, 0);

%% plot Figure 5A
fprintf('Creating Figure 5A ...\n')
figure('position',[100,100,500,500]);
hold on;
scatter(gfp(:,1), gfp(:,2),'k.');
scatter([divLoc1.x], [divLoc1.y],25,'MarkerEdgeColor','m','MarkerFaceColor','m');
scatter([divLoc2.x], [divLoc2.y],25,'MarkerEdgeColor','c','MarkerFaceColor','c');
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])

legend({'NSC','NSC in S-phase at time 1','NSC in S-phase at time 2'},'Location','ne','FontSize',16)
axis off

%% plot Figure 5B
fprintf('Creating Figure 5B ...\n')
NSCs =[[gfp;[divLoc2.x;divLoc2.y]';[divLoc1.x;divLoc1.y]'],[zeros(size(gfp,1),1);2*ones(numel(divLoc2),1);ones(numel(divLoc1),1)]];
D = euclideanDistanceMatrix(NSCs',NSCs');
DsP = D(end-numel(divLoc1)+1:end,end-numel(divLoc2)-numel(divLoc1)+1:end-numel(divLoc1));
rng(0);
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
legend('Simulated S-phase NSCs','Random sampling','Location', 'nw')%,'90% CI')
set(gca,'FontSize',24);

%% plot Figure 5CD
fprintf('Creating Figure 5C and 5D ...\n')
load(sprintf('%s/preprocessedData/simData_redivs.mat',extractBefore(inputFolder, '/Brains')),'parameters');
plotParameterInference(parameters,0);

%% load random morpheus example data
[gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, 1);

%% plot Figure 5E
fprintf('Creating Figure 5E ...\n')
figure('position',[100,100,500,500]);
hold on;
scatter(gfp(:,1), gfp(:,2),'k.');
scatter([divLoc1.x], [divLoc1.y],25,'MarkerEdgeColor','m','MarkerFaceColor','m');
scatter([divLoc2.x], [divLoc2.y],25,'MarkerEdgeColor','c','MarkerFaceColor','c');
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])

legend({'NSC','NSC in S-phase at time 1','NSC in S-phase at time 2'},'Location','ne','FontSize',16)
axis off

%% plot Figure 5F
fprintf('Creating Figure 5F ...\n')
NSCs =[[gfp;[divLoc2.x;divLoc2.y]';[divLoc1.x;divLoc1.y]'],[zeros(size(gfp,1),1);2*ones(numel(divLoc2),1);ones(numel(divLoc1),1)]];
D = euclideanDistanceMatrix(NSCs',NSCs');
DsP = D(end-numel(divLoc1)+1:end,end-numel(divLoc2)-numel(divLoc1)+1:end-numel(divLoc1));
rng(0);
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
legend('Simulated S-phase NSCs','Random sampling','Location', 'nw')%,'90% CI')
set(gca,'FontSize',24);
%% plot Figure 5GH
fprintf('Creating Figure 5G and 5H ...\n')
load(sprintf('%s/preprocessedData/simData_random.mat',extractBefore(inputFolder, '/Brains')),'parameters');
plotParameterInference(parameters,0);