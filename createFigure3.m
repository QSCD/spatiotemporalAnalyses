%% 3A plot all brains in one figure#

lis= {'9h','18h','24h','32h','48h','72h'}; %label intervals
%define figure properties
fig=figure('Position',[498,47,950,950]);
[ha,pos]=tight_subplot(6,6,[.0001 .0001],[.0001 .0001],[.0001 .0001]);
counter=0;cv c v c 
%c={'k','w'}; %if black bg and white font
c={'w','k'};%if white bg and black font
cellStats=1;
h=[];
intervals={'9h','18h','24h','32h','48h','72h'};
files = dir(inputFolder);
for  iv=1:numel(intervals)
    interval=intervals{iv};
    fileCount=count([files.name],sprintf('cells_Interval_%s',interval));
    intNum = str2double(interval(1:end-1));
    for i=1:fileCount
        [D,NSCs,sPhase1,sPhase2,DLS,redivs]=loadData(sprintf("Interval_%s_H%i",interval,i),inputFolder,1);
        counter=counter+1;
        axes(ha(counter));
        hold on;
        scatter(NSCs(:,1),NSCs(:,2),1,[0.75,0.75,0.75]);
        h(1)=scatter(sPhase1(:,1),sPhase1(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c');
        h(2)=scatter(sPhase2(:,1),sPhase2(:,2),5,'MarkerEdgeColor','m','MarkerFaceColor','m');
        
        scatter(redivs(:,1),redivs(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c');
        scatter(DLS(:,1),DLS(:,2),5,'MarkerEdgeColor','c','MarkerFaceColor','c');
        
        if strcmp(interval ,'18h') && i==2
            plot([600,600+150],[650,650],c{2},'Linewidth',2.5)
            text(440,700,'150\mum','Color', c{2},'FontSize',16)
        end
        text(50,60,['\Deltat=',interval],'Color', c{2},'FontSize',16)
                set(gca,'Color',c{1})
        set(gca,'YDir','reverse')
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
        xlim([0,775])
        ylim([0,775])
        box
    end
    
end
fig.InvertHardcopy = 'off';
%legend('NSCs','Time 1 S-Phase','Time 2 S-Phase')
set(gca,'FontSize',16)
