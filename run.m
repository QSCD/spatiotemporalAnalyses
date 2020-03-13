%%% run this script to plot all calculateable subplots of all figures
%%% or run certain sections directly
%%% just define the folder in which the matrix_interval_xy.xlsx files 
%%% and cells_interval_xy.xlsx are located
%%% additionally if you want to create table1 choose an output folder
inputFolder = "D:/Nextcloud/spatialAnalysisData/Brains";
outputFolder= inputFolder;
%% create all Subplots of Figure 1
createFigure1Plots(inputFolder)

%% create all Subplots of Figure 2
createFigure2Plots(inputFolder)

%% create all Subplots of Figure 3
createFigure3Plots(inputFolder)

%% create all Subplots of Figure 4
createFigure4Plots(inputFolder)

%% create Table 1
createTable1(inputFolder,outputFolder)