function [gfp, divLoc1, divLoc2]= loadMorpheus(inputFolder, rand)
% returns coordinates of gfp and dividing cells

%% load preprocessed data
if rand
 input=dlmread(sprintf('%s/preprocessedData/morpheus_random_logger.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
divs=dlmread(sprintf('%s/preprocessedData/morpheus_random_cell_division.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
tp2=144000;%define the one time point to plot      
else
input=dlmread(sprintf('%s/preprocessedData/morpheus_redivision_logger.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
divs=dlmread(sprintf('%s/preprocessedData/morpheus_redivision_cell_division.txt',extractBefore(inputFolder, '/Brains')),'\t',1,0);
tp2=148800;%define the one time point to plot
end
%% extract gfp and dividing coordinates for time point 1 and timepoint 2

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
end

function divLoc=getMidpoints(divs)
% calculates the midpoints of a doublet after division or returns the input
% location in case the cell did not divide yet
divLoc=[];
secondCell=0;
for i = 1:size(divs,1)
    % if the first cell of the doublet was already processed the second
    % cell is skipped
    if secondCell
        secondCell=0;
        continue;
    end
    % check if last cell or single cell
    if i<size(divs,1) && mod(divs(i,3),2)==1 && divs(i+1,3)- divs(i,3) ==1
        % add the midpoint between this cell and the following neighboring
        % doublet cell
        divLoc(end+1).x=(divs(i,1)+divs(i+1,1))/2;
        divLoc(end).y=(divs(i,2)+divs(i+1,2))/2;
        secondCell=1;
    else % single cell - just add input coordinates
        divLoc(end+1).x=divs(i,1);
        divLoc(end).y=divs(i,2);        
    end   
end
end