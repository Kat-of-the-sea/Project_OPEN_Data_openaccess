clear all
close all

run='eOR1 CORE-cav-15'

datafile=('/Users/user/Documents/MATLAB/eORCA1_output/NEMO42beta/eOR1v42b-IA-CORE-cav-15/WEDsec-IA-CORE-cav-15-1981-2009_grid_T.nc');

salinity=getnc(datafile,'salprac');
nav_lat=getnc(datafile,'nav_lat');
nav_lon=getnc(datafile,'nav_lon');
olevel=getnc(datafile,'deptht');
time=getnc(datafile,'time_counter');
temperature=getnc(datafile,'tpot');

fill=find(salinity>40);
salinity(fill)=NaN;
temperature(fill)=NaN;
fill=find(salinity<20);
salinity(fill)=NaN;
temperature(fill)=NaN;


badlon=find(nav_lon==-1);
nav_lon(badlon)=NaN;
nav_lat(badlon)=NaN;

datafile2=('/Users/user/Documents/MATLAB/eORCA1_output/NEMO42beta/domain_cfg_files/mask_WSsec.nc')

bathy=getnc(datafile2,'bathy_meter')
isf=getnc(datafile2,'isf_draft')

index_land=find(bathy==0);
index_isf=find(isf>0);

bathy(index_land)=NaN;
bathy(index_isf)=NaN;

lon=nav_lon;
lat=nav_lat;

x=1:1:length(nav_lon(1,:));
y=1:1:length(nav_lat(:,1));

depth_level=olevel;

depth_10m=find((abs(depth_level-10))==min(abs(depth_level-10)));
depth_200m=find((abs(depth_level-200))==min(abs(depth_level-200)));

for time=1:length(time)
for i=1:length(x)
    for ii=1:length(y)
        
  density(time,:,ii,i)=sw_dens(squeeze(salinity(time,:,ii,i)),squeeze(temperature(time,:,ii,i)),0);
  
  index_mld=find(squeeze((density(time,:,ii,i))-squeeze(density(time,depth_10m,ii,i)))>=0.03);
  
    if length(index_mld)>=1
  mld(time,ii,i)=depth_level(index_mld(1));
    
  else
  mld(time,ii,i)=bathy(ii,i);
    end
    
    end 
end
end


date=nan([length(time) 1]);

t=1;

for year=1981:2009
    
    for month=1:12
    
    date(t)=datenum(year,month,01);
 
    t=t+1;
    end

end

date_official=datestr(date);
date_yearmonth=datevec(date);

months=1:length(time);

index_Jan_March=find(date_yearmonth(:,2)>=1 & date_yearmonth(:,2)<=3);
mld_Jan_March=squeeze(nanmean(mld(index_Jan_March,:,:),1));

index_July_Sept=find(date_yearmonth(:,2)>=7 & date_yearmonth(:,2)<=9);
mld_July_Sept=squeeze(nanmean(mld(index_July_Sept,:,:),1));


figure
hold on
m_proj('lambert','long',[-65 20],'lat',[-82 -60])
hold on
%[C,h]=m_contourf(lon,lat,temp,[-2:0.01:0.5])
set(gca,'Color',[0.7 0.7 0.7])
m_pcolor(lon,lat,mld_Jan_March)
[cs h]=m_contour(lon,lat,bathy,[0:500:3000],'k')
clabel(cs,h)
shading flat
%set(h,'LineColor','none')
hold on
h=colorbar
set(h,'location','southoutside')
set(get(h,'xlabel'),'string','(m)')
%m_grid('box','fancy','xtick',8,'ytick',8,'tickdir','out','xaxisloc','top','yaxisloc','left','fontsize',12);
%m_grid('BackgroundColor', [0.7 0.7 0.7]);
m_grid('linestyle','none','linewidth',2,'tickdir','out',...
           'xtick',8,'ytick',8,...
           'xaxisloc','top','yaxisloc','left','fontsize',12,...
           'BackgroundColor', [0.7 0.7 0.7]);m_coast('patch',[0.8 0.8 0.8])
[h,lats,lons] = outlineashelf('larsen c');
t=m_patch(lons,lats,[0.9    1    1])
[h,lats,lons] = outlineashelf('fris');
t=m_patch(lons,lats,[0.9    1    1])
uistack(t,'top')
caption=sprintf('%s: Summer MLD  Wed 1981-2009',run)
t=title(caption,'FontWeight','bold','fontsize',14)
set(gca,'position',[0.1300    0.2000    0.7750    0.6976])
set(t,'Position',[4.4269e-07 0.23 0]) %original:[4.4269e-07 0.1958 0] 
 load('rt_colormaps.mat');
%colormap(rt_colormaps.lionel);

caxis([0 500]) 

cmap=cmocean('deep')
colormap(cmap)

print('-r300','-djpeg','mld_summer_wed')

figure
hold on
m_proj('lambert','long',[-65 20],'lat',[-82 -60])
hold on
%[C,h]=m_contourf(lon,lat,temp,[-2:0.01:0.5])
set(gca,'Color',[0.7 0.7 0.7])
m_pcolor(lon,lat,mld_July_Sept)
[cs h]=m_contour(lon,lat,bathy,[0:500:3000],'k')
clabel(cs,h,[500 1000 2000 3000])
shading flat
%set(h,'LineColor','none')
hold on
h=colorbar
set(h,'location','southoutside')
set(get(h,'xlabel'),'string','(m)')
%m_grid('box','fancy','xtick',8,'ytick',8,'tickdir','out','xaxisloc','top','yaxisloc','left','fontsize',12);
%m_grid('BackgroundColor', [0.7 0.7 0.7]);
m_grid('linestyle','none','linewidth',2,'tickdir','out',...
           'xtick',8,'ytick',8,...
           'xaxisloc','top','yaxisloc','left','fontsize',12,...
           'BackgroundColor', [0.7 0.7 0.7]);m_coast('patch',[0.8 0.8 0.8])
[h,lats,lons] = outlineashelf('larsen c');
t=m_patch(lons,lats,[0.9    1    1])
[h,lats,lons] = outlineashelf('fris');
t=m_patch(lons,lats,[0.9    1    1])
uistack(t,'top')
caption=sprintf('%s: Winter Statification Wed 1981-2009',run)
t=title(caption,'FontWeight','bold','fontsize',14)
caption=sprintf('%s: Winter MLD Wed 1970-2009',run)
t=title(caption,'FontWeight','bold','fontsize',14)
set(gca,'position',[0.1300    0.2000    0.7750    0.6976])
set(t,'Position',[4.4269e-07 0.23 0]) %original:[4.4269e-07 0.1958 0] 
 load('rt_colormaps.mat');
%colormap(rt_colormaps.lionel);

caxis([0 1000]) 

cmap=cmocean('deep')
colormap(cmap)

print('-r300','-djpeg','mld_winter_wed')


save mld_cav15_1981_2009_weddell

