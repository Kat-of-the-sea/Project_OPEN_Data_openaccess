clear all
close all

datafile_T='FRIS_IA_CORE_cav-15_1995_2009_T.nc'
datafile_U='FRIS_IA_CORE_cav-15_1995_2009_U.nc'
datafile_V='FRIS_IA_CORE_cav-15_1995_2009_V.nc'

deptht=getnc(datafile_T,'deptht');

time_counter=getnc(datafile_T,'time_centered');

temp=getnc(datafile_T,'tpot');

sal=getnc(datafile_T,'salprac');

melt=getnc(datafile_T,'iceshelf_cav');

V_velocity=getnc(datafile_V,'vo');

U_velocity=getnc(datafile_U,'uo');

nav_lat=getnc(datafile_T,'nav_lat');

nav_lon=getnc(datafile_T,'nav_lon');


datafile='/Users/user/Documents/MATLAB/eORCA1_output/NEMO42beta/domain_cfg_files/FRIS_domain_cfg.nc';

bathy=getnc(datafile,'bathy_meter')
isf_draft=getnc(datafile,'isf_draft')

e1t  = getnc(datafile,'e1t');
e1u = getnc(datafile,'e1u');
e1v = getnc(datafile,'e1v');

e2t  = getnc(datafile,'e2t');
e2u = getnc(datafile,'e2u');
e2v = getnc(datafile,'e2v');

e3t  = getnc(datafile,'e3t_0');
e3u  = getnc(datafile,'e3u_0');
e3v  = getnc(datafile,'e3v_0');

glamt= getnc(datafile,'glamt');
gphit= getnc(datafile,'gphit');

bottom_level=getnc(datafile,'bottom_level');

x=cumsum(e1t(1,:))/1000;
y=cumsum(e2t(:,1))/1000;

figure
pcolor(bathy)
colorbar
hold on
contour(isf_draft,[0 100 200],'w')
title('sanity check bathy')


save 'eORCA1_FRIS'
