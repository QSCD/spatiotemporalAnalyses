%createFigure1Plots
%% Figure 1K
%load data
[D,NSCs,sPhase1,~,~,~]=loadData('PCNA','D:\Seafile\Brains');
%create distance matrix between S-phase cells
[Dcombined] = computeDistMatrix([[T2Cells.x]' [T2Cells.y]' [T2Cells.z]'],'approx',0,0,p,zg);
sPhase1Ids=NSCs(:,4)==1;
DsP=D(sPhase1Ids,sPhase1Ids);
%calculate Ripley's K
[KSC,KcsrSC,t]=plotRipleysK(allCells, 1,T2Cells, D, Dcombined,p,zg, 'D:', '','xx',T1Cells,0);
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