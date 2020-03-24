function [D,NSCs,sPhase1,sPhase2,DLS,redivs]= loadData(name,folder,onlyCells)
%% read in distance matrix and cell cooradinates and divide cells into the respective groups
%%%
%%% D: distance matrix between all cell coordinates
%%% NSCs: all neural stem cells (NSCs) with x,y,z coordinates
%%% sPhase1: all NSCs being in S-phase at the first time point
%%% sPhase2: all NSCs being in S-phase at the second time point
%%% redivs: all NSCs being in (different) S-phases at both time points
%%% DLS: all NSCs sharing the same S-phase (double labelled S-phases)
%%%

if ~exist('onlyCells','Var')
    onlyCells=0;
end
% perform expensive distance matrix calculation only if needed
if ~onlyCells
D=readmatrix(sprintf('%s/matrix_%s.xlsx',folder,name));
else
    D=[];
end
% read data and save it into respective variables
cells=readmatrix(sprintf('%s/cells_%s.xlsx',folder,name));
NSCs=cells;
sPhase1=cells(cells(:,4)==1,1:3);
sPhase2=cells(cells(:,4)==2,1:3);
DLS=cells(cells(:,4)==3,1:3);
redivs=cells(cells(:,4)==4,1:3);