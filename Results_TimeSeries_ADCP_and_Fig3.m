%% Script to produce Figure 3 of Gimsa et al., 2024 

% clc 
% clear

%% ERA model output -> UTC
load("Gimsa_etal_24_ERA_1991-2020.mat")

StudyERAtable_ICEFREE_15 = StudyERAtable_ICEFREE((datetime(2015,07,28,06,00,00):hours:(datetime(2015,8,13,21,00,00))),"wsHI");
StudyERAtable_ICEFREE_18 = StudyERAtable_ICEFREE((datetime(2018,08,4,07,00,00):hours:(datetime(2018,8,18,19,00,00))),"wsHI");


%% MSCB model ouput -> UTC
load("MB183.mat");
load("MB217.mat");
Date_183 =  datetime('1970-01-01 00:00') +hours(1:height(MB000183)-26); % Remove first lines of no information
Date_217 =  datetime('1970-01-01 00:00') +hours(1:height(MB000217));
TT183 = table2timetable(MB000183(27:end,:),"RowTimes",Date_183); % Create hourly timetable 
TT217 = table2timetable(MB000217(1:end,:),"RowTimes",Date_217); % Create hourly timetable

clear Date_217 Date_183 MB000217 MB000183
% Data only for the FieldStudy period 
TT217_FS2015_HS = TT217((datetime(2015,07,28,06,00,00):hours:(datetime(2015,8,13,21,00,00))),"HS");
TT183_FS2018_HS = TT183((datetime(2018,08,4,07,00,00):hours:(datetime(2018,8,18,19,00,00))),"HS");
TT217_FS2015_CSt = TT217((datetime(2015,07,28,06,00,00):hours:(datetime(2015,8,13,21,00,00))),"CSt");
TT183_FS2018_CSt = TT183((datetime(2018,08,4,07,00,00):hours:(datetime(2018,8,18,19,00,00))),"CSt");
 
%% ADCP data in UTC-6h 

%% Download the data from the PANGAEA 
% Mooring 2018
% Gimsa et al., (2021) https://doi.org/10.1594/PANGAEA.931908
% https://doi.pangaea.de/10.1594/PANGAEA.931908?format=textfile

% Mooring 2015
% Gimsa et al., (2021) https://doi.org/10.1594/PANGAEA.931914
% https://doi.pangaea.de/10.1594/PANGAEA.931914?format=textfile

%% Load the surface coloumn and the bottom coloumn of the measurements 
% For more info see the above data publications
opts = delimitedTextImportOptions("NumVariables", 4);
% Specify range and delimiter
opts.DataLines = [44, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["DateTime", "Heightm", "CurVelUcms", "CurVelVcms"];
opts.VariableTypes = ["datetime", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "DateTime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss");
opts = setvaropts(opts, ["Heightm", "CurVelUcms", "CurVelVcms"], "ThousandsSeparator", ",");
% Import the data
YC2015ADCP = readtable("\YC_2015_ADCP.tab", opts);
clear opts

clear Surf15_V_cum Surf15_U_cum Surf15_V Surf15_U
Time_15 = table2array(YC2015ADCP(YC2015ADCP.Heightm == 4.6, "DateTime")); % to only get one time step
Surf15_U = table2array(YC2015ADCP(YC2015ADCP.Heightm == 10.1, "CurVelUcms"));
Surf15_V = table2array(YC2015ADCP(YC2015ADCP.Heightm == 10.1, "CurVelVcms"));
Surf15_U(isnan(Surf15_U))=0;
Surf15_V(isnan(Surf15_V))=0; % set the few NaNs to zeros
%
Bot15_U = table2array(YC2015ADCP(YC2015ADCP.Heightm == 1.6, "CurVelUcms"));
Bot15_V = table2array(YC2015ADCP(YC2015ADCP.Heightm == 1.6, "CurVelVcms"));
Bot15_U(isnan(Bot15_U))=0;
Bot15_V(isnan(Bot15_V))=0; % set the few NaNs to zeros
%% Make a one-hour timetable for 2015 data 
% 2015 Mooring
TTADCP15 = timetable(Time_15,Surf15_U, Surf15_V, Bot15_U, Bot15_V);
TTADCP15_1h = retime(TTADCP15,'hourly','mean');

% Create a mean value for the current speed averaged through the whole
% water coloumn 
clear Avg15
n=0; 
for i = 1.6:0.5:10.1
    n = n+1;
Avg15(:,n) = (sqrt( (table2array(YC2015ADCP(YC2015ADCP.Heightm == i, "CurVelVcms")).^2) + (table2array(YC2015ADCP(YC2015ADCP.Heightm == i, "CurVelUcms")).^2))) ;
end 
meanavg15 = mean(Avg15,2);

TTADCP15verticalavg = timetable(Time_15,meanavg15);
TTADCP15_1h_verticalavg = retime(TTADCP15verticalavg,'hourly','mean');

%% Load the data from the pangaea database 
% 
opts = delimitedTextImportOptions("NumVariables", 4);
% Specify range and delimiter
opts.DataLines = [45, Inf];
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["DateTime", "Heightm", "CurVelUcms", "CurVelVcms"];
opts.VariableTypes = ["datetime", "double", "double", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, "DateTime", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss");
opts = setvaropts(opts, ["Heightm", "CurVelUcms", "CurVelVcms"], "ThousandsSeparator", ",");
% Import the data
YC2018ADCP = readtable("\YC_2018_ADCP.tab", opts);
clear opts

% This method is adapted from J Lilly provec toolbox plot
% Lilly, J. M. (2019), jLab: A data analysis package for Matlab, v. 1.6.6, http://www.jmlilly.net/jmlsoft.html. 
clear Surf18_V_cum Surf18_U_cum Surf18_V Surf18_U
Time_18 = table2array(YC2018ADCP(YC2018ADCP.Heightm == 4.6, "DateTime")); % to only get one time step
Surf18_U = table2array(YC2018ADCP(YC2018ADCP.Heightm == 4.6, "CurVelUcms"));
Surf18_V = table2array(YC2018ADCP(YC2018ADCP.Heightm == 4.6, "CurVelVcms"));
Surf18_U(isnan(Surf18_U))=0;
Surf18_V(isnan(Surf18_V))=0; % set the few NaNs to zeros



Bot18_U = table2array(YC2018ADCP(YC2018ADCP.Heightm == 1.6, "CurVelUcms"));
Bot18_V = table2array(YC2018ADCP(YC2018ADCP.Heightm == 1.6, "CurVelVcms"));
Bot18_U(isnan(Bot18_U))=0;
Bot18_V(isnan(Bot18_V))=0; % set the few NaNs to zeros


%% Make an one-hour timetable for 2018 data 
% 2018 Mooring

TTADCP18 = timetable(Time_18,Surf18_U, Surf18_V, Bot18_U, Bot18_V);
TTADCP18_1h = retime(TTADCP18,'hourly','mean');


%%
% Create a mean value for the current speed averaged through the whole
% water coloumn 
 clear Avg18
n=0; 
for i = 1.6:0.5:4.6
    n = n+1;
Avg18(:,n) = (sqrt( (table2array(YC2018ADCP(YC2018ADCP.Heightm == i, "CurVelVcms")).^2) + (table2array(YC2018ADCP(YC2018ADCP.Heightm == i, "CurVelUcms")).^2))) ;
end 
meanavg18 = mean(Avg18,2);

TTADCP18verticalavg = timetable(Time_18,meanavg18);
TTADCP18_1h_verticalavg = retime(TTADCP18verticalavg,'hourly','mean');


%% Put all data together for 2015 field study period


ERA5Wind = StudyERAtable_ICEFREE_15.wsHI;
MSCBWave = TT217_FS2015_HS.HS;
MSCBCurr = TT217_FS2015_CSt.CSt;
ADCPSurf = sqrt((TTADCP15_1h.Surf15_U.^2)+(TTADCP15_1h.Surf15_V.^2));
ADCPBot = sqrt((TTADCP15_1h.Bot15_U.^2)+(TTADCP15_1h.Bot15_V.^2));
ADCPvert = TTADCP15_1h_verticalavg.meanavg15;

MeasurementTime = TTADCP15_1h.Time_15;
TT_15_alldata = timetable(MeasurementTime,ERA5Wind,MSCBWave,MSCBCurr,ADCPSurf,ADCPBot,ADCPvert);

%% Put all data together for the 2018 field study period

ERA5Wind18 = StudyERAtable_ICEFREE_18.wsHI;
MSCBWave18 = TT183_FS2018_HS.HS;
MSCBCurr18 = TT183_FS2018_CSt.CSt;
ADCPSurf18 = sqrt((TTADCP18_1h.Surf18_U.^2)+(TTADCP18_1h.Surf18_V.^2));
ADCPBot18 = sqrt((TTADCP18_1h.Bot18_U.^2)+(TTADCP18_1h.Bot18_V.^2));
ADCPvert18 = TTADCP18_1h_verticalavg.meanavg18;

MeasurementTime18 = TTADCP18_1h.Time_18;
TT_18_alldata = timetable(MeasurementTime18,ERA5Wind18,MSCBWave18,MSCBCurr18,ADCPSurf18,ADCPBot18,ADCPvert18);


%% 2015
figure("WindowState","maximized")
% ADCP Surf  
sgtitle('Field Study - Site A - 2015')
subplot(6,1,1); 
plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.ADCPSurf)
ticks = TT_15_alldata.Properties.RowTimes(1):TT_15_alldata.Properties.RowTimes(end);
ticks(18) = '14-Aug-2015';
xticks(ticks)
xticklabels([])
ylabel({'ADCP Surf Velocity'; '(cm/s)'})
ylim([0 70])
grid minor

% ADCP Bot  
subplot(6,1,2); 
plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.ADCPBot)
xticks(ticks)
xticklabels([])
ylabel({'ADCP Bot Velocity'; '(cm/s)'})
ylim([0 70])
grid minor

% ADCP Avg  
subplot(6,1,3); 

plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.ADCPvert)
xticks(ticks)
xticklabels([])
ylim([0 70])
grid minor
ylabel({'ADCP Vertical'; 'Mean Current'; '(cm/s)'})

% ERA5 Wind
subplot(6,1,4);

plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.ERA5Wind)
xticks(ticks)
xticklabels([])
ylim([0 13])
ylabel({'ERA5 Wind Speed'; '(m/s)'})

grid minor

% MSCB Wave Height 
subplot(6,1,5);
plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.MSCBWave)
xticks(ticks)
xticklabels([])
ylim([0 1])
ylabel({'MSCB Wave Height'; '(m)'})
grid minor

% MSCB Current 
subplot(6,1,6);
plot(TT_15_alldata.Properties.RowTimes,TT_15_alldata.MSCBCurr)
xticks(ticks)
xtickangle(300)
xtickformat('MMM d')
ylim([0 70])
ylabel({'MSCB Vertical'; 'Mean Current'; '(cm/s)'})
grid minor

ylim([0 70])
set(gcf,'color','w');
lineHandles = findobj(gcf, 'Type', 'Line');
set(lineHandles, 'LineWidth', 1.5) % Change line width to 1.5
set(lineHandles, 'LineStyle', '-') 
%%
exportgraphics(gcf, 'output-1.jpg','Resolution',1200)
% apply white margin around the initial figure
im = imread('output-1.jpg');
im2 = padarray(im, [100, 100, 0], 255);
imwrite(im2, 'Timeseries_left.jpg');
delete output-1.jpg
%% 2018 Data
figure("WindowState","maximized")
sgtitle('Field Study - Site B - 2018')



% ADCP Surf  
subplot(6,1,1); 
plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.ADCPSurf18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xticklabels([])
ylabel({'ADCP Surf Velocity'; '(cm/s)'})
ylim([0 70])
grid minor

% ADCP Bot  
subplot(6,1,2); 
plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.ADCPBot18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xticklabels([])
ylabel({'ADCP Bot Velocity'; '(cm/s)'})
ylim([0 70])
grid minor

% ADCP Avg  
subplot(6,1,3); 

plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.ADCPvert18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xticklabels([])
grid minor
ylim([0 70])
ylabel({'ADCP Vertical'; 'Mean Current'; '(cm/s)'})

% ERA5 Wind
subplot(6,1,4);
plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.ERA5Wind18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xticklabels([])
ylim([0 13])
ylabel({'ERA5 Wind Speed'; '(m/s)'})

grid minor

% MSCB Wave Height 
subplot(6,1,5);
plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.MSCBWave18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xticklabels([])
ylim([0 1])
ylabel({'MSCB Wave Height'; '(m)'})
grid minor

% MSCB Current 
subplot(6,1,6);
plot(TT_18_alldata.Properties.RowTimes,TT_18_alldata.MSCBCurr18)
ticks = TT_18_alldata.Properties.RowTimes(1):TT_18_alldata.Properties.RowTimes(end);
xticks(ticks)
xtickangle(300)
xtickformat('MMM d')
ylim([0 70])
ylabel({'MSCB Vertical'; 'Mean Current'; '(cm/s)'})
grid minor

ylim([0 70])
set(gcf,'color','w');
lineHandles = findobj(gcf, 'Type', 'Line');
set(lineHandles, 'LineWidth', 1.5) % Change line width to 2
set(lineHandles, 'LineStyle', '-') % Change line width to 2
%%

exportgraphics(gcf, 'output-1.jpg','Resolution',1200)
% apply white margin around the initial figure
im = imread('output-1.jpg');
im2 = padarray(im, [100, 100, 0], 255);
imwrite(im2, 'Timeseries_right.jpg');
delete output-1.jpg
