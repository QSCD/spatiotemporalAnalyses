function createFigure4Plots(inputFolder)

%% load redivision morpheus example data
fprintf('Creating Figure 4 ...\n') % show progress
%%%
%%% NSCs: all neural stem cells (NSCs) with x,y coordinates
%%% gfp: non dividing neural stem cells (NSCs) with x,y coordinates
%%% divLoc1: coordinates of NSCs being in S-phase at the first time point
%%% divLoc2: coordinates of NSCs being in S-phase at the second time point
%%%
% load preprocessed data created from 'model_morpheus_redivision.xml'
[gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, 0);

%% plot Figure 4A
fprintf('Creating Figure 4A ...\n') % show progress
figure('position',[100,100,500,500]);
hold on; % allow more than one plot in the figure
% scatter NSCs and both S-phase locations
scatter(gfp(:,1), gfp(:,2),'k.');
scatter([divLoc1.x], [divLoc1.y],25,'MarkerEdgeColor','m','MarkerFaceColor','m');
scatter([divLoc2.x], [divLoc2.y],25,'MarkerEdgeColor','c','MarkerFaceColor','c');
% modify axes
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[],'YTickLabel',[],'XTickLabel',[])
axis off
text(900,1150,{'p_{re-div}=0.38','      \Deltat=48h'},'Color', 'k','FontSize',24)  % include labelling interval as text
% plot legend
legend({'NSC','NSC in S-phase at Time 1','NSC in S-phase at Time 2'},'Position',[0.4,0.015,0.58,0.17],'FontSize',16)

%% plot Figure 4B
fprintf('Creating Figure 4B ...\n') % show progress
rng(0); % make plots reproducible
% add gfps and sPase 1 and 2 together
NSCs =[[gfp;[divLoc2.x;divLoc2.y]';[divLoc1.x;divLoc1.y]'],[zeros(size(gfp,1),1);2*ones(numel(divLoc2),1);ones(numel(divLoc1),1)]];
% calculate distance matrix and extract sub matrix for sPhase distances
D = euclideanDistanceMatrix(NSCs',NSCs');
DsP = D(end-numel(divLoc1)+1:end,end-numel(divLoc2)-numel(divLoc1)+1:end-numel(divLoc1));
%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling
[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define radius steps
K=K/600;Krand=Krand/600; % reduce numbers for nicer y-axis in plot.
figure('Position',[200,200,750,500]); % create figure
plot(r,K,'k','lineWidth',2); %plot observd K value
hold on; % allow more than one plot in the figure
patch([r fliplr(r)], [quantile(Krand,0.05) fliplr(quantile(Krand,0.95))],...
    [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k'); % plot sampled K CIs
plot(r,mean(Krand),'k--','lineWidth',2) % plot mean of sampled K values
% set axes properties and legend
xlim([0,100]);
xlabel('Radius [\mum]','Fontsize', 24)
ylabel('Discrete Ripley''s K','Fontsize', 24)
legend('Simulated S-phase NSCs','Random sampling','Location', 'nw')

set(gca,'FontSize',24); % increase font size

%% plot Figure 4CD
fprintf('Creating Figure 4C and 4D ...\n') % show progress
% load preprocessed morpheus inference data
load(sprintf('%s/preprocessedData/simData_redivs.mat',extractBefore(inputFolder, '/Brains')),'parameters');
plotParameterInference(parameters,0);

%% load random morpheus example data
% load preprocessed data created from 'model_morpheus_random.xml'
[gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, 1);

%% plot Figure 4E
fprintf('Creating Figure 4E ...\n') % show progress
figure('position',[100,100,500,500]);
hold on; % allow more than one plot in the figure
% scatter NSCs and both S-phase locations
scatter(gfp(:,1), gfp(:,2),'k.');
scatter([divLoc1.x], [divLoc1.y],25,'MarkerEdgeColor','m','MarkerFaceColor','m');
scatter([divLoc2.x], [divLoc2.y],25,'MarkerEdgeColor','c','MarkerFaceColor','c');
% modify axes
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[],'YTickLabel',[],'XTickLabel',[])
axis off
text(950,1160,{'p_{re-div}=0','\Deltat=48h'},'Color', 'k','FontSize',24)  % include labelling interval as text
% plot legend
legend({'NSC','NSC in S-phase at Time 1','NSC in S-phase at Time 2'},'Position',[0.4,0.015,0.58,0.17],'FontSize',16)

%% plot Figure 4F
fprintf('Creating Figure 4F ...\n') % show progress
rng(0); % make plots reproducible
% add gfps and sPase 1 and 2 together
NSCs =[[gfp;[divLoc2.x;divLoc2.y]';[divLoc1.x;divLoc1.y]'],[zeros(size(gfp,1),1);2*ones(numel(divLoc2),1);ones(numel(divLoc1),1)]];
% calculate distance matrix and extract sub matrix for sPhase distances
D = euclideanDistanceMatrix(NSCs',NSCs');
DsP = D(end-numel(divLoc1)+1:end,end-numel(divLoc2)-numel(divLoc1)+1:end-numel(divLoc1));
%calculate discrete Ripley's K values
%K = observed K values, Krand = K values from random sampling
[K,Krand]=calculateRipleysK(NSCs, D, DsP);

% Plot K values
r=1:150; % define time steps
K=K/680;Krand=Krand/680; % reduce numbers for nicer y-axis in plot.

figure('Position',[200,200,750,500]); % create figure
plot(r,K,'k','lineWidth',2); %plot observd K value
hold on; % allow more than one plot in the figure
patch([r fliplr(r)], [quantile(Krand,0.05) fliplr(quantile(Krand,0.95))],...
    [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k'); % plot sampled K CIs
plot(r,mean(Krand),'k--','lineWidth',2) % plot mean of sampled K values
% set axes properties and legend
xlim([0,100]);
xlabel('Radius [\mum]','Fontsize', 24)
ylabel('Discrete Ripley''s K','Fontsize', 24)
legend('Simulated S-phase NSCs','Random sampling','Location', 'nw')

set(gca,'FontSize',24); % increase font size

%% plot Figure 4GH
fprintf('Creating Figure 4G and 4H ...\n') % show progress
% load preprocessed morpheus inference data
load(sprintf('%s/preprocessedData/simData_random.mat',extractBefore(inputFolder, '/Brains')),'parameters');
plotParameterInference(parameters,0);