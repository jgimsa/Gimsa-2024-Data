%% OSM Coastline
% Get OSM global coastline
% Source file
% https://osmdata.openstreetmap.de/data/coastlines.html
coast = shaperead("Coastline\osmcoast.shp");

wholelat = [coast(:).Y]';
wholelon = [coast(:).X]';
wholelon1 = wholelon;
wholelat1 = wholelat; 
clear wholelon wholelat
% Filter for the ROI Herschel Island Qikiqtaruk and adjacent regions
wholelat1(wholelat1<67|wholelat1>71)=NaN; 
wholelon1(wholelon1< -140.5 |wholelon1 > -137.5)=NaN;
HIQlat= wholelat1;
HIQlon= wholelon1;
 

%% Bathylines
% Plot them as column vectors, not row vectors.  
% Herschel Basin and Coastline Data from Hugues´ Visualisation
Bathpoints = shaperead('Bathymetry\Bathymetry_OConnor_digitalized.shp');
BathLon = [Bathpoints.X]';
BathLat = [Bathpoints.Y]';
BathDepth = [Bathpoints.Depth];

% Show the shoreline and bathymetry
figure()
geoplot(HIQlat,HIQlon,"Color","white")
geolimits([69.25 69.75],[-139.05 -138.75])
hold on
%geobasemap grayland
%geoscatter(CoastLat,CoastLon)

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
geoscatter(BathLat(BathDepth == 12),BathLon(BathDepth == 12),50,[cmap(5,:)],'.','DisplayName','12 m')
text(69.5179,-139.013,'  12 m')
geoscatter(BathLat(BathDepth == 10),BathLon(BathDepth == 10),50,[cmap(4,:)],'.','DisplayName','10 m')
text(69.516,-139.029,' 10 m')
geoscatter(BathLat(BathDepth == 8),BathLon(BathDepth == 8),50,[cmap(3,:)],'.','DisplayName','8 m')
text(69.5137,-139.042,' 8 m')
geoscatter(BathLat(BathDepth == 6),BathLon(BathDepth == 6),50,[cmap(2,:)],'.','DisplayName','6 m')
text(69.5117,-139.053,' 6 m')
geoscatter(BathLat(BathDepth == 4),BathLon(BathDepth == 4),50,[cmap(1,:)],'.','DisplayName','4 m')
text(69.5062,-139.094,' 4 m')

%% Save shoreline and bathymetry for the other figures
save("Shore_and_Bathy.mat","BathDepth","BathLat","BathLon","HIQlat","HIQlon")
