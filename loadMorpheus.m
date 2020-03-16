function [gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, rand)

if rand
 input=dlmread(sprintf('%s/preprocessedData/morpheus_random_logger.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
divs=dlmread(sprintf('%s/preprocessedData/morpheus_random_cell_division.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
tp2=144000;%define the one time point to plot      
else
input=dlmread(sprintf('%s/preprocessedData/morpheus_redivision_logger.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
divs=dlmread(sprintf('%s/preprocessedData/morpheus_redivision_cell_division.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
tp2=148800;%define the one time point to plot
end

input=input(input(:,7)==0,:);% exclude progenitors
sPhase=1700; % define a roughly S-phase length
 
allCells2= input(input(:,1)==tp2,:);
div2Idx=(find(divs(:,1)>tp2-sPhase&divs(:,1)<=tp2)); %index of first division going back "sPhase" tps
div2=allCells2(ismember(allCells2(:,2),[divs(div2Idx,2);divs(div2Idx,3);divs(div2Idx,4)]),[4,5,2,9]);


tp1= tp2-48*100; % define the timepoint 1 by substracting the labelling interval
allCells1=input(input(:,1)==tp1,:);
div1Idx=find((divs(:,1)>=tp1-(sPhase))&divs(:,1)<min(tp1,tp2-(sPhase))); %index of first division going back "sPhase" tps
div1=allCells1(ismember(allCells1(:,2),[divs(div1Idx,2);divs(div1Idx,3);divs(div1Idx,4)]),[4,5,2,9]);

[div1,div2,~]=removeRedivs(div1,div2,divs(1:div2Idx(end),:),allCells2); %merge redivs with S-phase 1 cells
divLoc2= getMidpoints(div2);


div1=allCells2(ismember(allCells2(:,2),div1(:,3)),[4,5,2,9]);
divLoc1= getMidpoints(div1);
gfp= allCells2(~ismember(allCells2(:,2),[div1(:,3);div2(:,3)]),[4,5]);