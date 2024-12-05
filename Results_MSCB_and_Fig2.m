%% Load data from MSC50 DFO source

% Get the data from: 
% https://www.meds-sdmm.dfo-mpo.gc.ca/isdm-gdsi/request-commande/form-eng.asp
% https://meds-sdmm.dfo-mpo.gc.ca/isdm-gdsi/waves-vagues/MSC50-eng.html

%% Get and load the data
load("MB183.mat");
load("MB217.mat");
Date_183 =  datetime('1970-01-01 00:00') +hours(1:height(MB000183)-26); % Remove first lines of no information
Date_217 =  datetime('1970-01-01 00:00') +hours(1:height(MB000217));
TT183 = table2timetable(MB000183(27:end,:),"RowTimes",Date_183); % Create hourly timetable 
TT217 = table2timetable(MB000217(1:end,:),"RowTimes",Date_217); % Create hourly timetable

clear Date_217 Date_183 MB000217 MB000183
%% PAPER Numbers  
% UTC = 2015-07-28T00:15:00 + 6h 
TT217_Aug2015_HS = TT217((datetime(2015,07,28,06,00,00):hours:(datetime(2015,8,13,21,00,00))),"HS");
disp(['Mean and Maximum Significant Wave Height location A - 217 during the field study'])
mean(TT217_Aug2015_HS.HS)
max(TT217_Aug2015_HS.HS)

% UTC = 2018-08-04T01:15:00 + 6h 
TT183_Aug2018_HS = TT183((datetime(2018,08,4,07,00,00):hours:(datetime(2018,8,18,19,00,00))),"HS");
disp(['Mean and Maximum Significant Wave Height location B - 183 during the field study'])

mean(TT183_Aug2018_HS.HS)
max(TT183_Aug2018_HS.HS)

%% Mean, Max 183 Wave Height

ifp = ismember(month(TT183.Time),[6,7,8,9,10]); % Only June to September months
TT183_ifp = TT183.*ifp;
TT183_ifp.HS(TT183_ifp.HS==0) = NaN;
disp(['Mean and Maximum Significant Wave Height location B - 183'])
mean(TT183_ifp.HS,'omitnan')
max(TT183_ifp.HS)
%% Mean, Max 217 Wave Height
ifp = ismember(month(TT217.Time),[6,7,8,9,10]); % Only June to September months
TT217_ifp = TT217.*ifp;
TT217_ifp.HS(TT217_ifp.HS==0) = NaN;

disp(['Mean and Maximum Significant Wave Height location A - 217'])
mean(TT217_ifp.HS,'omitnan')
max(TT217_ifp.HS)

%% Seasonality 183 Wave Height
disp(['Seasonality of Significant Wave Height location B - 183'])
for i = 6:10
ifp = ismember(month(TT183.Time),[i]); % Only June to September months
TT183_ifp_m = TT183.*ifp;
TT183_ifp_m.HS(TT183_ifp_m.HS==0) = NaN;
disp ([i "=" mean(TT183_ifp_m.HS,'omitnan')])
end

%% Seasonality 217 Wave Height
disp(['Seasonality of Significant Wave Height location A - 217'])
for i = 6:10
ifp = ismember(month(TT217.Time),[i]); % Only June to September months
TT217_ifp_m = TT217.*ifp;
TT217_ifp_m.HS(TT217_ifp_m.HS==0) = NaN;
disp ([i "=" mean(TT217_ifp_m.HS,'omitnan')])
end
%%
%% PAPER Numbers  
% UTC = 2015-07-28T00:15:00 + 6h 
TT217_Aug2015_CSt = TT217((datetime(2015,07,28,06,00,00):hours:(datetime(2015,8,13,21,00,00))),"CSt");
disp(['Mean and Maximum currents location A - 217 during the field study'])
mean(TT217_Aug2015_CSt.CSt)
max(TT217_Aug2015_CSt.CSt)

% UTC = 2018-08-04T01:15:00 + 6h 
TT183_Aug2018_CSt = TT183((datetime(2018,08,4,07,00,00):hours:(datetime(2018,8,18,19,00,00))),"CSt");
disp(['Mean and Maximum currents location B - 183 during the field study'])
mean(TT183_Aug2018_CSt.CSt)
max(TT183_Aug2018_CSt.CSt)

%% Mean, Max 183 Current Speed

disp(['Mean and Maximum Currents location B - 183'])
ifp = ismember(month(TT183.Time),[6,7,8,9,10]); % Only June to September months
TT183_ifp = TT183.*ifp;
TT183_ifp.CSt(TT183_ifp.CSt==0) = NaN;
mean(TT183_ifp.CSt,'omitnan')
max(TT183_ifp.CSt)

%% Mean, Max 217 Current Speed

disp(['Mean and Maximum Currents location A - 217'])
ifp = ismember(month(TT217.Time),[6,7,8,9,10]); % Only June to September months
TT217_ifp = TT217.*ifp;
TT217_ifp.CSt(TT217_ifp.CSt==0) = NaN;
mean(TT217_ifp.CSt,'omitnan')
max(TT217_ifp.CSt)

%% Seasonality 183 Current Speed
disp(['Seasonality of Current Speed location B - 183'])
for i = 6:10
ifp = ismember(month(TT183.Time),[i]); % Only June to September months
TT183_ifp_m = TT183.*ifp;
TT183_ifp_m.CSt(TT183_ifp_m.CSt==0) = NaN;
disp ([i "=" mean(TT183_ifp_m.CSt,'omitnan')])
end

%% Seasonality 217 Current Speed
disp(['Seasonality of Current Speed location A - 217'])
for i = 6:10
ifp = ismember(month(TT217.Time),[i]); % Only June to September months
TT217_ifp_m = TT217.*ifp;
TT217_ifp_m.CSt(TT217_ifp_m.CSt==0) = NaN;
disp ([i "=" mean(TT217_ifp_m.CSt,'omitnan')])
end
%%
%%
%% Script to recreate Figure 2 from Gimsa et al., 2024
% 
% Calcations baded on the formulas from 
%
% Davidson-Arnott (2019) p. 113-115 
%% Calculate Maximum Horizontal Bed Velocity for Simpson Point (MSCB Grid Point 217)

umax_bed217 = []; 
cspd217 = [];
% loop per month (j) over all hours (i)
for j = 6:10 % Filter for ice-free month 6 (Jun) to 10 (Oct)
idx = ismember(month(TT217.Time),j); 
TT217_monfilt = TT217(idx,:);

for i=1:height(TT217_monfilt) 
Hs = TT217_monfilt.HS(i); % Sig Wave height from the MSCB output
T0 = TT217_monfilt.TP(i); % Peak period from the MSCB output
h = 20.5; %defined waterdepth from MSCB;
Lo = (9.81*(T0*T0))/(2*pi); % calculate initial wavelength
L = ((9.81*(T0*T0))/(2*pi))*(tanh((2*pi*h)/Lo)); % calculate wavelength

while abs(L-Lo) > 0.001 % calculate until approximation limit is reached

Lo = L;
L = ((9.81*(T0*T0))/(2*pi))*(tanh((2*pi*h)/Lo)); % calculate wave length

end

k= (2*pi)/(L); % Angular wave number
sig = ((2*pi)/T0); % Angular wave frequency;
umax_bed217(i,j) = (sig*(Hs/2)*(1/(sinh(k*h))))*100; %maximum horizonal bed velocity in cm/s;
end 
cspd217(j) = mean(TT217_monfilt.CSt(j)); 
end
clear Hs j k h sig L Lo T0 TT217_monfilt TT217 idx i 
figure('Color',[1 1 1]);
t = tiledlayout("horizontal");
nexttile
boxplot(umax_bed217(:,6:10),'whisker', inf,'Colors','k')
hold on 
plot(cspd217(1,6:10),'o-',"Color","#77AC30","MarkerEdgeColor","#77AC30","LineWidth",1.5)
ylim([-5 140])
xticklabels(['Jun';'Jul';'Aug';'Sep';'Oct'])
xlabel(t,'Monthly average from 1970 to 2018')
ylabel(t,'Velocity (cm/s)','FontSize',12)
%title(t,'Statistics of MSCB-based maximum horizontal bed velocities')
%subtitle(t,'Green Line: Vertical averaged current speed from the ADCIRC module')
title('MSCB Point A (20.5 m water depth)')
grid minor
%% Calculate Maximum Horizontal Bed Velocity for Catton Point (MSCB Grid Point 183)
umax_bed183 = []; 
cspd183 = [];

% loop per month (j) over all hours (i)

for j = 6:10 % Filter for ice-free month 6 (Jun) to 10 (Oct)
idx = ismember(month(TT183.Time),j); 
TT183_monfilt = TT183(idx,:);

for i=1:height(TT183_monfilt)
Hs = TT183_monfilt.HS(i); % Sig Wave height from the MSCB output
T0 = TT183_monfilt.TP(i); % Peak period from the MSCB output
h = 5; %defined waterdepth from MSCB;
Lo = (9.81*(T0*T0))/(2*pi); % calculate initial wavelength 
L = ((9.81*(T0*T0))/(2*pi))*(tanh((2*pi*h)/Lo)); % Wavelength 

while abs(L-Lo) > 0.001 % Iterativ calculation of the wavelength 
Lo = L;
L = ((9.81*(T0*T0))/(2*pi))*(tanh((2*pi*h)/Lo));
end

k= (2*pi)/(L); % Angular wave number
sig = ((2*pi)/T0); % Angular wave frequency;
umax_bed183(i,j) = (sig*(Hs/2)*(1/(sinh(k*h))))*100; %maximum horizonal bed velocity in cm/s;

end 
cspd183(j) = mean(TT183_monfilt.CSt(j)); 
end

clear Hs j k h sig L Lo T0 TT183_monfilt TT183 idx i 
%%

nexttile
boxplot(umax_bed183(:,6:10),'whisker', inf,'Colors','k')
hold on 
plot(cspd183(1,6:10),'o-',"Color","#77AC30","MarkerEdgeColor","#77AC30","LineWidth",1.5)
xticklabels(['Jun';'Jul';'Aug';'Sep';'Oct'])
ylim([-5 140])
ylabel('Velocity (cm/s)','FontSize',12)

title('MSCB Point B (5.0 m water depth)')
grid minor
set(gcf, 'Position',[1000 776 1184 462])
pause(2)
%% Export to paper Graphic
exportgraphics(gcf, 'output-1.jpg','Resolution',1200)
% apply white margin around the initial figure
im = imread('output-1.jpg');
im2 = padarray(im, [100, 100, 0], 255);
imwrite(im2, 'figure_2.jpg');
delete output-1.jpg

