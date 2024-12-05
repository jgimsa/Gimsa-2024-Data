%% Script for cum vec plot


load('Shore_and_Bathy.mat')
%%
figure

geoplot(HIQlat,HIQlon,"Color","black")
hold on 

geolimits([69.42 69.58],[-139.10 -138.66])

%% Include Bathymetry from OConnor 1984
cmap = cmocean('deep',15);
geoscatter(BathLat(BathDepth == 70),BathLon(BathDepth == 70),25,[cmap(15,:)],'.','DisplayName','70 m')
text(69.484,-138.824,' 70 m')
geoscatter(BathLat(BathDepth == 60),BathLon(BathDepth == 60),25,[cmap(14,:)],'.','DisplayName','60 m')
text(69.5288,-138.88,' 60 m')
geoscatter(BathLat(BathDepth == 50),BathLon(BathDepth == 50),25,[cmap(13,:)],'.','DisplayName','50 m')
text(69.5296,-138.904,' 50 m')
geoscatter(BathLat(BathDepth == 40),BathLon(BathDepth == 40),25,[cmap(12,:)],'.','DisplayName','40 m')
text(69.5282,-138.928,'   40 m')
geoscatter(BathLat(BathDepth == 30),BathLon(BathDepth == 30),25,[cmap(12,:)],'.','DisplayName','30 m')
text(69.5268,-138.942,' 30 m')
geoscatter(BathLat(BathDepth == 20),BathLon(BathDepth == 20),25,[cmap(10,:)],'.','DisplayName','20 m')
text(69.5238,-138.964,'  20 m')
geoscatter(BathLat(BathDepth == 10),BathLon(BathDepth == 10),25,[cmap(4,:)],'.','DisplayName','10 m')
text(69.516,-139.029,' 10 m')
geoscatter(BathLat(BathDepth == 8),BathLon(BathDepth == 8),25,[cmap(3,:)],'.','DisplayName','8 m')
text(69.5137,-139.042,' 8 m')
geoscatter(BathLat(BathDepth == 6),BathLon(BathDepth == 6),25,[cmap(2,:)],'.','DisplayName','6 m')
text(69.5117,-139.053,' 6 m')
geoscatter(BathLat(BathDepth == 4),BathLon(BathDepth == 4),25,[cmap(1,:)],'.','DisplayName','4 m')
text(69.5062,-139.094,' 4 m')
%%
text(69.558393,-138.913445,"Study Site A - 2015")
text(69.46583,-139.02555,"Study Site B - 2018") 
%% Include CUMVECPLOTS 
% Load the data from the pangaea database 
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
Surf18_U = table2array(YC2018ADCP(YC2018ADCP.Heightm == 4.6, "CurVelUcms"));
Surf18_V = table2array(YC2018ADCP(YC2018ADCP.Heightm == 4.6, "CurVelVcms"));
Surf18_U(isnan(Surf18_U))=0;
Surf18_V(isnan(Surf18_V))=0; % set the few NaNs to zeros
Surf18_U_cum(1:2,1)= -139.03055; 
 % initial point is the sensor location 
Surf18_V_cum(1:2,1) = 69.465833; % initial point is the sensor location 

% Define Scale Factor for plotting 
n = 25 % scaling factor;

for i = 2:height(Surf18_V)
Surf18_U_cum(end+1,:) = Surf18_U_cum(i,1) + (km2deg(Surf18_U(i)*(0.0006)))/n; % initial unit cm/s give in kilometer/min
Surf18_V_cum(end+1,:) = Surf18_V_cum(i,1) + (km2deg(Surf18_V(i)*(0.0006)))/n; % initial unit cm/s give in kilometer/min
end 

clear Bot18_V_cum Bot18_U_cum Bot18_V Bot18_U
Bot18_U = table2array(YC2018ADCP(YC2018ADCP.Heightm == 1.6, "CurVelUcms"));
Bot18_V = table2array(YC2018ADCP(YC2018ADCP.Heightm == 1.6, "CurVelVcms"));
Bot18_U(isnan(Bot18_U))=0;
Bot18_V(isnan(Bot18_V))=0; % set the few NaNs to zeros
Bot18_U_cum(1:2,1)= -139.03055; 
 % initial point is the sensor location 
Bot18_V_cum(1:2,1) = 69.465833; % initial point is the sensor location 

for i = 2:height(Bot18_V)
Bot18_U_cum(end+1,:) = Bot18_U_cum(i,1) + (km2deg(Bot18_U(i)*(0.0006)))/n; % initial unit cm/s give in kilometer/min
Bot18_V_cum(end+1,:) = Bot18_V_cum(i,1) + (km2deg(Bot18_V(i)*(0.0006)))/n; % initial unit cm/s give in kilometer/min
end 
%%
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
% This method is adapted from J Lilly provec toolbox plot
clear Surf15_V_cum Surf15_U_cum Surf15_V Surf15_U
Surf15_U = table2array(YC2015ADCP(YC2015ADCP.Heightm == 10.1, "CurVelUcms"));
Surf15_V = table2array(YC2015ADCP(YC2015ADCP.Heightm == 10.1, "CurVelVcms"));
Surf15_U(isnan(Surf15_U))=0;
Surf15_V(isnan(Surf15_V))=0; % set the few NaNs to zeros
Surf15_U_cum(1:2,1)= -138.914445; 
 % initial point is the sensor location 
Surf15_V_cum(1:2,1) = 69.558393; % initial point is the sensor location 

for i = 2:height(Surf15_V)
Surf15_U_cum(end+1,:) = Surf15_U_cum(i,1) + (km2deg(Surf15_U(i)*(0.009)))/n; % initial unit cm/s give in kilometer/min
Surf15_V_cum(end+1,:) = Surf15_V_cum(i,1) + (km2deg(Surf15_V(i)*(0.009)))/n; % initial unit cm/s give in kilometer/min
end 
% 0.009 -> Distance factor to calculate for 15-minutly values in cm/s to get
% the distance in kilometer
clear Bot15_V_cum Bot15_U_cum Bot15_V Bot15_U
Bot15_U = table2array(YC2015ADCP(YC2015ADCP.Heightm == 1.6, "CurVelUcms"));
Bot15_V = table2array(YC2015ADCP(YC2015ADCP.Heightm == 1.6, "CurVelVcms"));
Bot15_U(isnan(Bot15_U))=0;
Bot15_V(isnan(Bot15_V))=0; % set the few NaNs to zeros
Bot15_U_cum(1:2,1)= -138.914445; 
 % initial point is the sensor location 
Bot15_V_cum(1:2,1) = 69.558393; % initial point is the sensor location 

for i = 2:height(Bot15_V)
Bot15_U_cum(end+1,:) = Bot15_U_cum(i,1) + (km2deg(Bot15_U(i)*(0.009)))/n; % initial unit cm/s give in kilometer/min
Bot15_V_cum(end+1,:) = Bot15_V_cum(i,1) + (km2deg(Bot15_V(i)*(0.009)))/n; % initial unit cm/s give in kilometer/min
end 
%%
Scale_U_cum = [];
Scale_V_cum = [];
Scale_U = [];
Scale_V = [];

n=25;
Scale_U_cum(1:2,1)= -1.388587399969906e+02; 
Scale_V_cum(1:2,1) = 69.553769998769970; % initial point is the sensor location 
Scale_U = repelem(40,60*24)'; % in cm/s
Scale_V = repelem(0,60*24)';
for i = 2:height(Scale_U)
% 0.0006 -> Distance factor to calculate for minutly values in cm/s to get
% the distance in kilometer
Scale_U_cum(end+1,:) = Scale_U_cum(i,1) + km2deg((Scale_U(i)*(0.0006))/n); % initial unit cm/s give in kilometer/min
Scale_V_cum(end+1,:) = Scale_V_cum(i,1) + km2deg((Scale_V(i)*(0.0006))/n); % initial unit cm/s give in kilometer/min
end 

% Plot Scale
geoplot(Scale_V_cum,Scale_U_cum,'g.-','MarkerSize',5)
% Scale -> constant eastward flow of 10 cm/s

geoplot(Surf18_V_cum,Surf18_U_cum,'b.-','MarkerSize',5)
hold on
geoplot(Bot18_V_cum,Bot18_U_cum,'r.-','MarkerSize',5)
geoplot(Surf15_V_cum,Surf15_U_cum,'b.-','MarkerSize',5)
geoplot(Bot15_V_cum,Bot15_U_cum,'r.-','MarkerSize',5)


gx = gca;
geobasemap none
co = gx.LatitudeAxis.Color;
gx.LatitudeAxis.Visible = "on";
gx.LongitudeAxis.Visible = "on";
gx.GridColor ="black";
gx.GridAlpha = 0.3;
set(gcf, 'Color','w')
%%
%exportgraphics(gcf, 'output-currs3.jpg','Resolution',900)
% apply white margin around the initial figure

%%
%% Distance calculation 

% [arclen,az] = distance(lat1,lon1,lat2,lon2)
Start18Lat = 69.465833;
Start18Lon = -139.03055;

Start15Lat = 69.558393;
Start15Lon = -138.914445;



Surf18endLat = 68.627;
Surf18endLon = -139.731;
[arclen,~] = distance(Start18Lat,Start18Lon,Surf18endLat,Surf18endLon);
dist18surf = deg2km(arclen)
Bot18endLat = 70.0996;
Bot18endLon = -138.708;
[arclen,~] = distance(Start18Lat,Start18Lon,Bot18endLat,Bot18endLon);
dist18bot = deg2km(arclen)

Surf15endLat = 68.1777;
Surf15endLon = -137.995;
[arclen,~] = distance(Start15Lat,Start15Lon,Surf15endLat,Surf15endLon);
dist15surf = deg2km(arclen)
Bot15endLat = 69.4501;
Bot15endLon = -138.71;
[arclen,~] = distance(Start15Lat,Start15Lon,Bot15endLat,Bot15endLon);
dist15bot = deg2km(arclen)