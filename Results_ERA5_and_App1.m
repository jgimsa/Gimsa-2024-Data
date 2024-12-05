%% Start here to load the subdivided ERA5 Wind data 
load('Gimsa_etal_24_ERA_1991-2020.mat')

% clc 
% clear

%% Calculate mean values for the results section

mean(StudyERAtable_ICEFREE.wsHI,'omitmissing')
[max_value,indexmax] = max (StudyERAtable_ICEFREE.wsHI)
StudyERAtable_ICEFREE.time(indexmax)

% 2015 field study period
StudyERAtable_ICEFREE_15 = StudyERAtable_ICEFREE(timerange('2015-07-28T06:00:00','2015-08-13T21:00:00'),["u10HI","v10HI","wsHI","spHI","t2mHI"]);
mean(StudyERAtable_ICEFREE_15.wsHI)
max(StudyERAtable_ICEFREE_15.wsHI)

% 2018 field study period
StudyERAtable_ICEFREE_18 = StudyERAtable_ICEFREE(timerange('2018-08-04T07:00:00','2018-08-18T19:00:00'),["u10HI","v10HI","wsHI","spHI","t2mHI"]);
mean(StudyERAtable_ICEFREE_18.wsHI)
max(StudyERAtable_ICEFREE_18.wsHI)
%% ERA5 climate normal 1991 - 2020
% Statistics for each month 
% June 
ifp = ismember(month(StudyERAtable_ICEFREE.time),[6]);
StudyERAtable_ICEFREEJun = StudyERAtable_ICEFREE.*ifp;
StudyERAtable_ICEFREEJun.wsHI(StudyERAtable_ICEFREEJun.wsHI==0) = NaN;
mean(StudyERAtable_ICEFREEJun.wsHI,'omitnan')

% Jul
ifp = ismember(month(StudyERAtable_ICEFREE.time),[7]);
StudyERAtable_ICEFREEJul = StudyERAtable_ICEFREE.*ifp;
StudyERAtable_ICEFREEJul.wsHI(StudyERAtable_ICEFREEJul.wsHI==0) = NaN;
mean(StudyERAtable_ICEFREEJul.wsHI,'omitnan')

% Aug
ifp = ismember(month(StudyERAtable_ICEFREE.time),[8]);
StudyERAtable_ICEFREEAug = StudyERAtable_ICEFREE.*ifp;
StudyERAtable_ICEFREEAug.wsHI(StudyERAtable_ICEFREEAug.wsHI==0) = NaN;
mean(StudyERAtable_ICEFREEAug.wsHI,'omitnan')

% Sept
ifp = ismember(month(StudyERAtable_ICEFREE.time),[9]);
StudyERAtable_ICEFREESep = StudyERAtable_ICEFREE.*ifp;
StudyERAtable_ICEFREESep.wsHI(StudyERAtable_ICEFREESep.wsHI==0) = NaN;
mean(StudyERAtable_ICEFREESep.wsHI,'omitnan')

% Oct
ifp = ismember(month(StudyERAtable_ICEFREE.time),[10]);
StudyERAtable_ICEFREEOct = StudyERAtable_ICEFREE.*ifp;
StudyERAtable_ICEFREEOct.wsHI(StudyERAtable_ICEFREEOct.wsHI==0) = NaN;
mean(StudyERAtable_ICEFREEOct.wsHI,'omitnan')


%% ERA Convention for Wind direction visualization
% The meteorological convention for winds is that U component is positive
% for a west to east flow (eastward wind) and the V component is positive
% for south to north flow (northward wind).

%The wind components are eastward and northward wind vectors that are
%represented by the variables "U” and “V” respectively.The U wind component
%is parallel to the x-axis (i.e. longitude). A positive U wind comes from
%the west, and a negative U wind comes from the east. The V wind component
%is parallel to the y- axis (i.e. latitude). A positive V wind comes from
%the south, and a negative V wind comes from the north. 
% Formula of the mod - operation from : "https://sgichuki.github.io/Atmo/"

% 2015
StudyERAtable_ICEFREE_15.wdirHI= mod((270-rad2deg(atan2(StudyERAtable_ICEFREE_15.v10HI,StudyERAtable_ICEFREE_15.u10HI))),360);
% 2018
StudyERAtable_ICEFREE_18.wdirHI= mod((270-rad2deg(atan2(StudyERAtable_ICEFREE_18.v10HI,StudyERAtable_ICEFREE_18.u10HI))),360);
% 1991-2020
StudyERAtable_ICEFREE.wdirHI= mod((270-rad2deg(atan2(StudyERAtable_ICEFREE.v10HI,StudyERAtable_ICEFREE.u10HI))),360);


%% Wind rose for field study 2015

WindDirInputin2pirad = (deg2rad(StudyERAtable_ICEFREE_15.wdirHI));
WindDirInputin2pirad(WindDirInputin2pirad == 0) = NaN;
WindSpdInputms = StudyERAtable_ICEFREE_15.wsHI;
WindSpdInputms(WindSpdInputms == 0) = NaN;
WindRoseTitle = {'Field Study Period 2015'};
n = 16; % number of bins
binTheta = 360 / n;
edges = (0:binTheta:360) + binTheta/2;
edges = deg2rad(edges);
clearvars n
plotted_elements_omitnan = length(WindDirInputin2pirad(~isnan(WindDirInputin2pirad)))-sum(WindSpdInputms==0);
% Plotting

figure('Color',[1 1 1]);

pax = polaraxes;
polarhistogram(WindDirInputin2pirad,edges,'FaceColor','#7E2F8E','FaceAlpha',1,'DisplayName','>15 (>44)')
hold on 
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=15),edges,'FaceColor','#D95319','FaceAlpha',1,'DisplayName','10 to 15 (36 to 44) ')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=10),edges,'FaceColor','#0072BD','FaceAlpha',1,'DisplayName','5 to 10 (18 to 36)')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=5),edges,'FaceColor','#77AC30','FaceAlpha',1,'DisplayName','0 to 5 (0 to 18)')
% Figure Settings
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
labels = {'N','NNE','NE','ENE','E','SES','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW'};
legend('Show')
title(WindRoseTitle)
title(legend,'Wind speed in m/s (km/h)','FontSize',10);
pax.ThetaTickLabels = labels;
pax.ThetaTick = 0:binTheta:360;
pax.RTick = [0 plotted_elements_omitnan/20 2*(plotted_elements_omitnan/20) 3*(plotted_elements_omitnan/20)]; % devide the total number of elements for the percentage display at the R axis
pax.RTickLabel = {'' '5%' '10%' '15%'};
%pax.RLim = [0 650]
pax.RAxisLocation = 22.5;
% Create legend
legend1 = legend(pax,'show');
set(legend1,...
    'Position',[0.296220123384411 0.267568659265242 0.215878194671017 0.148687214611872]);
title(legend1,'Wind speed in m/s (km/h)');

%% Wind rose for field study 2015

StudyERAtable_ICEFREE_18.wdirHI= mod((270-rad2deg(atan2(StudyERAtable_ICEFREE_18.v10HI,StudyERAtable_ICEFREE_18.u10HI))),360);
StudyERAtable_ICEFREE_18.wsHI;

WindDirInputin2pirad = (deg2rad(StudyERAtable_ICEFREE_18.wdirHI));
WindDirInputin2pirad(WindDirInputin2pirad == 0) = NaN;
WindSpdInputms = StudyERAtable_ICEFREE_18.wsHI;
WindSpdInputms(WindSpdInputms == 0) = NaN;
WindRoseTitle = {'Field Study Period 2018'};
n = 16; % number of bins
binTheta = 360 / n;
edges = (0:binTheta:360) + binTheta/2;
edges = deg2rad(edges);
clearvars n
plotted_elements_omitnan = length(WindDirInputin2pirad(~isnan(WindDirInputin2pirad)))-sum(WindSpdInputms==0);
% Plotting

figure('Color',[1 1 1]);


pax = polaraxes;
polarhistogram(WindDirInputin2pirad,edges,'FaceColor','#7E2F8E','FaceAlpha',1,'DisplayName','>15 (>44)')
hold on 
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=15),edges,'FaceColor','#D95319','FaceAlpha',1,'DisplayName','10 to 15 (36 to 44) ')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=10),edges,'FaceColor','#0072BD','FaceAlpha',1,'DisplayName','5 to 10 (18 to 36)')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=5),edges,'FaceColor','#77AC30','FaceAlpha',1,'DisplayName','0 to 5 (0 to 18)')
% Figure Settings
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
labels = {'N','NNE','NE','ENE','E','SES','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW'};
 legend('Show')
title(WindRoseTitle)
 title(legend,'Wind speed in m/s (km/h)','FontSize',10);
pax.ThetaTickLabels = labels;
pax.ThetaTick = 0:binTheta:360;
pax.RTick = [0 plotted_elements_omitnan/20 2*(plotted_elements_omitnan/20) 3*(plotted_elements_omitnan/20) 4*(plotted_elements_omitnan/20)]; % devide the total number of elements for the percentage display at the R axis
pax.RTickLabel = {'' '5%' '10%' '15%' '20%'};
%pax.RLim = [0 650]
pax.RAxisLocation = 22.5;

% Create legend
legend1 = legend(pax,'show');
set(legend1,...
    'Position',[0.296220123384411 0.267568659265242 0.215878194671017 0.148687214611872]);
title(legend1,'Wind speed in m/s (km/h)');

%% Wind rose for climate normal 1991 - 2020

StudyERAtable_ICEFREE.wdirHI= mod((270-rad2deg(atan2(StudyERAtable_ICEFREE.v10HI,StudyERAtable_ICEFREE.u10HI))),360);
StudyERAtable_ICEFREE.wsHI;


WindDirInputin2pirad = (deg2rad(StudyERAtable_ICEFREE.wdirHI));
WindDirInputin2pirad(WindDirInputin2pirad == 0) = NaN;
WindSpdInputms = StudyERAtable_ICEFREE.wsHI;
WindDirInputin2pirad(WindDirInputin2pirad==4.712388980384690) = NaN; % remove all NaN winds
WindSpdInputms(WindSpdInputms == 0) = NaN;
WindRoseTitle = {'ERA5 1991-2020'};
n = 16; % number of bins
binTheta = 360 / n;
edges = (0:binTheta:360) + binTheta/2;
edges = deg2rad(edges);
clearvars n
plotted_elements_omitnan = length(WindDirInputin2pirad(~isnan(WindDirInputin2pirad)))-sum(WindSpdInputms==0);
% Plotting

figure('Color',[1 1 1]);

pax = polaraxes;
polarhistogram(WindDirInputin2pirad,edges,'FaceColor','#7E2F8E','FaceAlpha',1,'DisplayName','>15 (>44)')
hold on 
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=15),edges,'FaceColor','#D95319','FaceAlpha',1,'DisplayName','10 to 15 (36 to 44) ')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=10),edges,'FaceColor','#0072BD','FaceAlpha',1,'DisplayName','5 to 10 (18 to 36)')
polarhistogram(WindDirInputin2pirad(WindSpdInputms<=5),edges,'FaceColor','#77AC30','FaceAlpha',1,'DisplayName','0 to 5 (0 to 18)')
% Figure Settings
pax.ThetaDir = 'clockwise';
pax.ThetaZeroLocation = 'top';
labels = {'N','NNE','NE','ENE','E','SES','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW'};
 legend('Show')
title(WindRoseTitle)
 title(legend,'Wind speed in m/s (km/h)','FontSize',10);
pax.ThetaTickLabels = labels;
pax.ThetaTick = 0:binTheta:360;
pax.RTick = [0 plotted_elements_omitnan/20 2*(plotted_elements_omitnan/20) 3*(plotted_elements_omitnan/20)]; % devide the total number of elements for the percentage display at the R axis
pax.RTickLabel = {'' '5%' '10%' '15%'};
%pax.RLim = [0 650]
pax.RAxisLocation = 22.5;
legend1 = legend(pax,'show');
set(legend1,...
    'Position',[0.296220123384411 0.267568659265242 0.215878194671017 0.148687214611872]);
title(legend1,'Wind speed in m/s (km/h)');
%% Calculate the duration of storm conditions per wind direction per year 1991 - 2020
% Using the interactive figure interface of the previous figure
% Definition based on the threshold from Atkinson 2005 (wind speed above
% 10 m/s
% WNW to NW conditions 
NWN = 13087-12737; % bin edges;
NW = 9616-8640; % bin edges;
% divide number of storm hours by the number of years 
Hours_of_storm_MajorComponent = (NWN+NW)/30
% SES-SE conditions 
SE = 9693 - 9614; % bin edges;
SES = 19330 - 19287; % bin edges;
% divide number of storm hours by the number of years 
Hours_of_storm_MinorComponent = (SE+SES)/30