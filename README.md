# Gimsa-2024-MATLAB-DATA_PROCESSING
Supplement to Gimsa, J., Fritz, M. & Lantuit, H. (2024). Nearshore Hydrodynamics and Sediment Dispersal Along Eroding Permafrost Coasts—Insights From Acoustic Doppler Current Profiler Measurements Around Herschel Island–Qikiqtaruk (Yukon, Canada). DOI: 10.1002/ppp.2258. 

Code was written in MATLAB R2023b
with the help of the following toolboxes:

Image Toolbox 
Statistics Toolbox
Mapping Toolbox

In order to smoothly process the data start the Matlab scripts in the following order: 

%% First Figure 1: 
Add CMOCEAN to path.
Load the "Shore_and_Bathy.mat" object. (It is also used to provide baseline information for figure 4 and 5)
Run 'Figure_1.m'

%% Second Figure 2 and the results for the MSCB section: 
Make sure you added MB183.mat and MB217.mat to your path. 
Run 'Results_MSCB_and_Fig_2.m'
You get figure_2.jpg according to the paper figure and the results from the calculations into the command window. 

%% Third Figure 3 and the results for the timeseries figure:
Make sure you added MB183.mat, MB217.mat, YC_2015_ADCP.tab, YC_2018_ADCP.tab, and Gimsa_etal_24_ERA_1991-2020.mat to your path. 
Run 'Results_TimeSeries_ADCP_and_Fig_3.m'
You get Timeseriesleft.jpg and Timeseriesright.jpg as output. 

%% Fourth Figure 4 and the results of the cumulative vector plot:
