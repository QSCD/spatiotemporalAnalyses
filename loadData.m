function [D,NSCs,sPhase1,sPhase2,DLS,redivs]= loadData(name,folder,onlyCells)
%% read in distance matrix and cell cooradinates and divide cells into the respective groups
if ~exist('onlyCells','Var')
    onlyCells=0;
end
if ~onlyCells
D=readmatrix(sprintf('%s\\matrix_%s.xlsx',folder,name));
else
    D=[];
end
cells=readmatrix(sprintf('%s\\cells_%s.xlsx',folder,name));
NSCs=cells;
sPhase1=cells(cells(:,4)==1,1:3);
sPhase2=cells(cells(:,4)==2,1:3);
DLS=cells(cells(:,4)==3,1:3);
redivs=cells(cells(:,4)==4,1:3);