%createFigure1Plots
%% Figure 1K
%load data
[D,NSCs,sPhase1,~,~,~]=loadData('PCNA','D:\Seafile\Brains');
%create distance matrix between S-phase cells
sPhase1Ids=ismember(NSCs(:,4),1);
DsP=D(sPhase1Ids,sPhase1Ids);
%calculate Ripley's K
[KSC,KcsrSC,t]=calculateRipleysK(NSCs, D, DsP);
%% Plot 
figure('Position',[680,582,750,500])
plot(t,KSC,'k','lineWidth',2)
hold on
patch([t fliplr(t)], [quantile(KcsrSC,0.05) fliplr(quantile(KcsrSC,0.95))], [0.5,0.5,0.5],'FaceAlpha',.5,'EdgeColor','k')
plot(t,mean(KcsrSC),'k--','lineWidth',2)
xlabel('Radius [\mum]','Fontsize', 24)
ylabel('Discrete Ripley''s K','Fontsize', 24)
set(gca,'FontSize',24);
legend('Observed NSCs in S-phase','Random sampling','Location','northwest');