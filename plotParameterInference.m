function plotParameterInference(parameters,expData)

%%%
%%% plots parameter inference either for experimental or simulated data
%%%
%define arrays to be filled by iterating over all hemispheres
maxLStr=[]; % strength maximum likelihood values
maxLRad=[]; % radius maximum likelihood values
strengthsCI =[]; % strength confidence interval (CI) values
radiiCI = []; % radius CI values
% to highlight real labelling interval values in simulated data
xRealCoords = [1,2,5,7,10,15,23];
% define labelling intervals
if expData
    intervals = {'1','9','18','24','32','48','72'};
    xRange = cellfun(@str2num, intervals);
else
    xRange = [3,9:3:75];
end
% extract maxL and CI information from parameter inference data
% (parameters)
for i = 1:size(xRange,2)
    optionsCI = PestoOptions();
    optionsCI.mode = 'silent';
    par=parameters{xRange(i)};
    par.S.par=par.S.par(:,(par.S.par(1,:)<300&par.S.par(1,:)>30));
    par=getParameterConfidenceIntervals(par,0.95,optionsCI);
    maxLStr(i)=par.MS.par(2,1);
    maxLRad(i)=par.MS.par(1,1);
    strengthsCI(i,1) = par.CI.S(2,1);
    strengthsCI(i,2) = par.CI.S(2,2);
    radiiCI(i,1) = par.CI.S(1,1);
    radiiCI(i,2) = par.CI.S(1,2);    
end

%% plot parameter inference

%for plotting set self inference to 0
xRange(1)=0;
figure('position',[100,100,800,600]);
%%  plot radius
h1=subplot(2,1,1);
% plot maxL values with CI as errorbars
h=ploterr(xRange,maxLRad,[],{radiiCI(:,1),radiiCI(:,2)},'k.');
hold on;
% modify for not experimental data the color of non exp intervals to gray
if ~expData
    set(h(2),'Color',[.5,.5,.5])
    set(h(1),'Color',[.5,.5,.5])
    h(1).MarkerSize=20;
    h(2).LineWidth=3;    
    h=ploterr(xRange(xRealCoords),maxLRad(xRealCoords),[],{radiiCI(xRealCoords,1),radiiCI(xRealCoords,2)},'k.');
end
h(1).MarkerSize=20;
h(2).LineWidth=3;

% fit constant to maxL radius values
if expData
    P=fitlm(xRange,maxLRad-1,'y~1');
else
    P=fitlm(xRange(xRealCoords),maxLRad(xRealCoords)-1,'y~1');
end
yfit=P.Fitted;
% plot the fitted constant
if expData
    plot(xRange,yfit,'k--','LineWidth',2);
else
    plot(xRange(xRealCoords),yfit,'k--','LineWidth',2);
end
% modify x and y axes
set(gca,'XTickLabel',[])
ylabel({'Radius [\mum]'})
set(gca,'FontSize',22)
ylim([20,270])
xlim([-1,76])
%adjust subplot position
h1_pos = get(h1,'Position');
set(h1,'Position',h1_pos)

%%  plot strength
h2=subplot(2,1,2);
% plot maxL values with CI as errorbars
h=ploterr(xRange,maxLStr,[],{strengthsCI(:,1),strengthsCI(:,2)},'k.');
hold on;
% modify for not experimental data the color of non exp intervals to gray
if ~expData
    set(h(2),'Color',[.5,.5,.5])
    set(h(1),'Color',[.5,.5,.5])
    h(1).MarkerSize=20;
    h(2).LineWidth=3;
    hold on;
    h=ploterr(xRange(xRealCoords),maxLStr(xRealCoords),[],{strengthsCI(xRealCoords,1),strengthsCI(xRealCoords,2)},'k.');
end
h(1).MarkerSize=20;
h(2).LineWidth=3;

% fit constant to maxL strength values 
if expData
    % comapre to y-1 as the constant fitting gives a p-value for this
    % hypothesis
    P=fitlm(xRange,maxLStr-1,'y~1'); 
else
    P=fitlm(xRange(xRealCoords),maxLStr(xRealCoords)-1,'y~1');
end
yfit=P.Fitted+1; % adjust the fitted constant (see above)
% plot the fitted constant
if expData
    plot(xRange,yfit,'k--','LineWidth',2);
else
    plot(xRange(xRealCoords),yfit,'k--','LineWidth',2);
end
% display p-value of constant fit
text(50,1.85,sprintf('p-value=%.4f',P.Coefficients.pValue),'FontSize',22);
% modify x and y axes
xlabel('Labelling interval \Deltat [h]')
ylabel({'Strength'})
xlim([-1,76])
ylim([0.7,2.1])
% display random line at y=1
hl=hline(1);
hl.LineWidth=2;
hl.Color='k';
set(gca,'FontSize',22)
%adjust subplot position
h2_pos=get(h2,'Position');
set(h2,'Position',[h2_pos(1) h1_pos(2)-h1_pos(4)-0.1 h2_pos(3:end)])