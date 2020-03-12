function plotParameterInference(parameters,expData)

maxLStr=[];
maxLRad=[];
strengths =[];
radii = [];

xRealCoords = [1,2,5,7,10,15,23];
if expData
    inputs = {'1','9','18','24','32','48','72'};    
    xRange = cellfun(@str2num, inputs);
else
xRange = [6,9:3:75];
end
%inputs = {'3','9','18','24','30','48','72'};


for i = 1:size(xRange,2)
    optionsCI = PestoOptions();
    optionsCI.mode = 'silent';
    a=parameters{xRange(i)};
    a.S.par=a.S.par(:,(a.S.par(1,:)<300&a.S.par(1,:)>30));
    a=getParameterConfidenceIntervals(a,0.95,optionsCI);
    maxLStr(i)=a.MS.par(2,1);
    maxLRad(i)=a.MS.par(1,1);
    strengths(i,1) = a.CI.S(2,1);
    strengths(i,2) = a.CI.S(2,2);
    radii(i,1) = a.CI.S(1,1);
    radii(i,2) = a.CI.S(1,2);

end

%% fit line
xRange(1)=0;
figure('position',[100,100,800,600]);
if expData
        P=fitlm(xRange,maxLRad-1,'y~1');
else
    P=fitlm(xRange(xRealCoords),maxLRad(xRealCoords)-1,'y~1');
end
    yfit=P.Fitted;
h1=subplot(2,1,1);
h=ploterr(xRange,maxLRad,[],{radii(:,1),radii(:,2)},'k.');
hold on;
if ~expData
    set(h(2),'Color',[.5,.5,.5])
set(h(1),'Color',[.5,.5,.5])
    h(1).MarkerSize=20;
    h(2).LineWidth=2;

    h=ploterr(xRange(xRealCoords),maxLRad(xRealCoords),[],{radii(xRealCoords,1),radii(xRealCoords,2)},'k.');
end
    h(1).MarkerSize=20;
    h(2).LineWidth=2;
if expData
plot(xRange,yfit,'k--','LineWidth',2);
else
    plot(xRange(xRealCoords),yfit,'k--','LineWidth',2);
end
set(gca,'XTickLabel',[])
ylabel({'Radius [\mum]'})
set(gca,'FontSize',22)
ylim([20,270])
xlim([-1,76])
h1_pos = get(h1,'Position');
set(h1,'Position',h1_pos)
if expData
    P=fitlm(xRange,maxLStr-1,'y~1');
else
    P=fitlm(xRange(xRealCoords),maxLStr(xRealCoords)-1,'y~1');
end
    yfit=P.Fitted+1;
h2=subplot(2,1,2);
h=ploterr(xRange,maxLStr,[],{strengths(:,1),strengths(:,2)},'k.');
if ~expData
    set(h(2),'Color',[.5,.5,.5])
set(h(1),'Color',[.5,.5,.5])
    h(1).MarkerSize=20;
    h(2).LineWidth=2;
hold on;
    h=ploterr(xRange(xRealCoords),maxLStr(xRealCoords),[],{strengths(xRealCoords,1),strengths(xRealCoords,2)},'k.');
end
    h(1).MarkerSize=20;
    h(2).LineWidth=2;
hold on;
if expData
plot(xRange,yfit,'k--','LineWidth',2);
else
    plot(xRange(xRealCoords),yfit,'k--','LineWidth',2);
end
text(50,1.85,sprintf('p-value=%.4f',P.Coefficients.pValue),'FontSize',22);
xlabel('Labelling interval \Deltat [h]')
ylabel({'Strength'})
xlim([-1,76])
hl=hline(1);
hl.LineWidth=2;
hl.Color='k';
set(gca,'FontSize',40)
set(gca,'FontSize',22)
ylim([0.3,1.7])
ylim([0.7,2.1])

h2_pos=get(h2,'Position'); 
set(h2,'Position',[h2_pos(1) h1_pos(2)-h1_pos(4)-0.1 h2_pos(3:end)]) 