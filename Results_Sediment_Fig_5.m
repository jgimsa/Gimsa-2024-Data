%% Plotting figure 5 from Gimsa et al., 2024
% 

%% Plot - Paper Figure
% Get the data 
load("Sediments_Gimsa_etal_24.mat")
load("Sediments_Radosavljevic_etal_2016.mat")

% Specify the Region of Interest for the data from (Radosavljevic, 2016)
Radosavljevic2016.Latitude(Radosavljevic2016.Latitude<69.5178) =NaN;
Radosavljevic2016.Longitude(Radosavljevic2016.Longitude<-139.083) =NaN;
% Calculate the number of samples used
NumRadoSamples = isnan(Radosavljevic2016.Longitude) + isnan(Radosavljevic2016.Latitude);
% All values that were not set to NaN
NumRadoSamples = sum(NumRadoSamples == 0, 'all');



%%
% Get the shoreline and bathymetry from the mat-file
load("Shore_and_Bathy.mat")

figure()
geoplot(HIQlat,HIQlon,"Color","black")
hold on
set(gcf, 'Color','w')
geobasemap none
title('Grain Size')
geolimits([69.4611 69.5815],[-139.1075 -138.7769])

% Bathymetric data 
cmap = cmocean('deep',15);
geoscatter(BathLat(BathDepth == 70),BathLon(BathDepth == 70),50,[cmap(15,:)],'.','DisplayName','70 m')
text(69.484,-138.824,' 70 m')
geoscatter(BathLat(BathDepth == 60),BathLon(BathDepth == 60),50,[cmap(14,:)],'.','DisplayName','60 m')
text(69.5288,-138.88,' 60 m')
geoscatter(BathLat(BathDepth == 50),BathLon(BathDepth == 50),50,[cmap(13,:)],'.','DisplayName','50 m')
text(69.5296,-138.904,' 50 m')
geoscatter(BathLat(BathDepth == 40),BathLon(BathDepth == 40),50,[cmap(12,:)],'.','DisplayName','40 m')
text(69.5282,-138.928,'   40 m')
geoscatter(BathLat(BathDepth == 30),BathLon(BathDepth == 30),50,[cmap(12,:)],'.','DisplayName','30 m')
text(69.5268,-138.942,' 30 m')
geoscatter(BathLat(BathDepth == 20),BathLon(BathDepth == 20),50,[cmap(10,:)],'.','DisplayName','20 m')
text(69.5238,-138.964,'  20 m')
geoscatter(BathLat(BathDepth == 18),BathLon(BathDepth == 18),50,[cmap(9,:)],'.','DisplayName','16 m')
text(69.5219,-138.973,'  18 m')
geoscatter(BathLat(BathDepth == 16),BathLon(BathDepth == 16),50,[cmap(8,:)],'.','DisplayName','16 m')
text(69.5207,-138.983,'  16 m')
geoscatter(BathLat(BathDepth == 14),BathLon(BathDepth == 14),50,[cmap(6,:)],'.','DisplayName','14 m')
text(69.5194,-138.996,'  14 m')
geoscatter(BathLat(BathDepth == 12),BathLon(BathDepth == 12),100,[cmap(5,:)],'.','DisplayName','12 m')
text(69.5179,-139.013,'  12 m')
geoscatter(BathLat(BathDepth == 10),BathLon(BathDepth == 10),50,[cmap(4,:)],'.','DisplayName','10 m')
text(69.516,-139.029,' 10 m')
geoscatter(BathLat(BathDepth == 8),BathLon(BathDepth == 8),50,[cmap(3,:)],'.','DisplayName','8 m')
text(69.5137,-139.042,' 8 m')
geoscatter(BathLat(BathDepth == 6),BathLon(BathDepth == 6),50,[cmap(2,:)],'.','DisplayName','6 m')
text(69.5117,-139.053,' 6 m')
geoscatter(BathLat(BathDepth == 4),BathLon(BathDepth == 4),50,[cmap(1,:)],'.','DisplayName','4 m')
text(69.5062,-139.094,' 4 m')


% Mean Grain Size
title('Mean Grain Size')
geoscatter(Sediment_Gimsa_etal_24.Latitude,Sediment_Gimsa_etal_24.Longitude,Sediment_Gimsa_etal_24.MeanGrainSizeIn_m*5,'red',"o","filled",'DisplayName',char(Sediment_Gimsa_etal_24.OriginalVariableNames))
geoscatter(Radosavljevic2016.Latitude,Radosavljevic2016.Longitude,Radosavljevic2016.GrainSizeMeanmFolkAndWardMethodGraphic*5,[0.5 0.5 0.5],"o");

% Location Instruments
geoscatter(69.46583,-139.03055,'x','DisplayName','YC18\_ADCP')
geoscatter(69.558393,-138.914445,'x','DisplayName','YC15\_ADCP')
text(69.46583,-139.02555,"ADCP 2018") 
text(69.558393,-138.913445,"ADCP 2015")

% Lines hypothetical transects 
geoplot([69.4647 69.5041],[-139.052 -138.916],'red','DisplayName','Transect A') 
text(69.5494,-138.954,"Transect A") 
geoplot([69.5178 69.5754],[-138.897 -138.94],'red','DisplayName','Transect B')
text(69.4808,-138.973,"Transect B") 

% Plotting of the Scale
geoscatter(69.5739,-138.872,250*5,'black','filled')
text(69.5739,-138.872,"Medium Sand")
geoscatter(69.5699,-138.872,125*5,'black','filled')
text(69.5699,-138.872,"Fine Sand")
geoscatter(69.5659,-138.872,63*5,'black','filled')
text(69.5659,-138.872,"Very Fine Sand")
geoscatter(69.5599,-138.872,31*5,'black','filled')
text(69.5599,-138.872,"Very Coarse Silt")
geoscatter(69.5539,-138.872,16*5,'black','filled')
text(69.5539,-138.872,"Coarse Silt")
geoscatter(69.5479,-138.872,8*5,'black','filled')
text(69.5479,-138.872,"Medium Silt")
geoscatter(69.5419,-138.872,4*5,'black','filled')
text(69.5419,-138.872,"Fine Silt")

%%
%% Plot - Paper Figure

figure()
set(gcf, 'Color','w')
geoplot(HIQlat,HIQlon,"Color","black")
hold on
geobasemap none

geolimits([69.4611 69.5815],[-139.1075 -138.7769])
hold on

% Bathymetric data 
cmap = cmocean('deep',15);
geoscatter(BathLat(BathDepth == 70),BathLon(BathDepth == 70),50,[cmap(15,:)],'.','DisplayName','70 m')
text(69.484,-138.824,' 70 m')
geoscatter(BathLat(BathDepth == 60),BathLon(BathDepth == 60),50,[cmap(14,:)],'.','DisplayName','60 m')
text(69.5288,-138.88,' 60 m')
geoscatter(BathLat(BathDepth == 50),BathLon(BathDepth == 50),50,[cmap(13,:)],'.','DisplayName','50 m')
text(69.5296,-138.904,' 50 m')
geoscatter(BathLat(BathDepth == 40),BathLon(BathDepth == 40),50,[cmap(12,:)],'.','DisplayName','40 m')
text(69.5282,-138.928,'   40 m')
geoscatter(BathLat(BathDepth == 30),BathLon(BathDepth == 30),50,[cmap(12,:)],'.','DisplayName','30 m')
text(69.5268,-138.942,' 30 m')
geoscatter(BathLat(BathDepth == 20),BathLon(BathDepth == 20),50,[cmap(10,:)],'.','DisplayName','20 m')
text(69.5238,-138.964,'  20 m')
geoscatter(BathLat(BathDepth == 18),BathLon(BathDepth == 18),50,[cmap(9,:)],'.','DisplayName','16 m')
text(69.5219,-138.973,'  18 m')
geoscatter(BathLat(BathDepth == 16),BathLon(BathDepth == 16),50,[cmap(8,:)],'.','DisplayName','16 m')
text(69.5207,-138.983,'  16 m')
geoscatter(BathLat(BathDepth == 14),BathLon(BathDepth == 14),50,[cmap(6,:)],'.','DisplayName','14 m')
text(69.5194,-138.996,'  14 m')
geoscatter(BathLat(BathDepth == 12),BathLon(BathDepth == 12),100,[cmap(5,:)],'.','DisplayName','12 m')
text(69.5179,-139.013,'  12 m')
geoscatter(BathLat(BathDepth == 10),BathLon(BathDepth == 10),50,[cmap(4,:)],'.','DisplayName','10 m')
text(69.516,-139.029,' 10 m')
geoscatter(BathLat(BathDepth == 8),BathLon(BathDepth == 8),50,[cmap(3,:)],'.','DisplayName','8 m')
text(69.5137,-139.042,' 8 m')
geoscatter(BathLat(BathDepth == 6),BathLon(BathDepth == 6),50,[cmap(2,:)],'.','DisplayName','6 m')
text(69.5117,-139.053,' 6 m')
geoscatter(BathLat(BathDepth == 4),BathLon(BathDepth == 4),50,[cmap(1,:)],'.','DisplayName','4 m')
text(69.5062,-139.094,' 4 m')

%  Sorting
title('Sorting')
geoscatter(Sediment_Gimsa_etal_24.Latitude,Sediment_Gimsa_etal_24.Longitude,Sediment_Gimsa_etal_24.Sorting*50,'red',"^","filled",'DisplayName',char(Sediment_Gimsa_etal_24.OriginalVariableNames))
geoscatter(Radosavljevic2016.Latitude,Radosavljevic2016.Longitude,Radosavljevic2016.SortFolkAndWardMethodGraphic*50,[0.5 0.5 0.5],"^");

% Plotting of the Scale
geoscatter(69.5659,-138.872,4*50,'black',"^",'filled')
text(69.5659,-138.872,"Very poorly sorted")
geoscatter(69.5599,-138.872,2*50,'black',"^",'filled')
text(69.5599,-138.872,"Poorly sorted")
geoscatter(69.5539,-138.872,1.62*50,'black',"^",'filled')
text(69.5539,-138.872,"Moderately sorted")
geoscatter(69.5479,-138.872,1.41*50,'black',"^",'filled')
text(69.5479,-138.872,"Moderately well sorted")
geoscatter(69.5419,-138.872,1.27*50,'black',"^",'filled')
text(69.5419,-138.872,"Well sorted")

% Location Instruments
geoscatter(69.46583,-139.03055,'x','DisplayName','YC18\_ADCP')
geoscatter(69.558393,-138.914445,'x','DisplayName','YC15\_ADCP')
text(69.46583,-139.02555,"ADCP 2018") 
text(69.558393,-138.913445,"ADCP 2015")

% Lines hypothetical transects 
geoplot([69.4647 69.5041],[-139.052 -138.916],'red','DisplayName','Transect A') 
text(69.5494,-138.954,"Transect A") 
geoplot([69.5178 69.5754],[-138.897 -138.94],'red','DisplayName','Transect B')
text(69.4808,-138.973,"Transect B") 



