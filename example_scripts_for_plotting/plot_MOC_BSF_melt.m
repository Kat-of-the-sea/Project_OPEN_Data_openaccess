
clear all
close all

load eORCA1_FRIS

run='eOR1 CORE-cav-15 1995-2009'

index_land=find(bathy==0);


% % BSF

velV=squeeze(V_velocity(end,:,:,:));

velV_vertical_integral=squeeze(nansum(velV.*e3v,1));

velV_zonal_integral=cumsum(velV_vertical_integral.*e1v,2) 

velV_bsf=velV_zonal_integral./(1.0e6)

velV_bsf(index_land)=NaN;

figure
% pcolor(glamt,gphit,velV_bsf)
% %shading flat
hold on
[C,h]=contourf(glamt,gphit,velV_bsf,[-4:0.2:4],'k')
% clabel(C,h)
colorbar
caxis([-4 4])
cmocean('curl')
set(gca,'Color',[0.7 0.7 0.7])
xlabel('Approx. longitude')
ylabel('Approx. latitude')
caption=sprintf('%s: BSF (+ve=clockwise)',run)
title(caption,'FontWeight','bold','FontSize',12)
set(gcf, 'InvertHardcopy', 'off')
print('-r300','-dpng','BSF')

% MOC

velV=squeeze(V_velocity(end,:,:,:));

threeD_e1v=meshgrid(e1v(:,1),deptht,e1v(1,:));

velV_zonal_integral=nansum(velV.*threeD_e1v.*e3v(:,:,:),3); %remember e1v is zonal thickness of cell

velV_vertical_integral=0-cumsum(velV_zonal_integral,1,'reverse') % sum vertically ** bottom up **

index_land=find(velV_zonal_integral==0);

velV_vertical_integral(index_land)=NaN;

velV_moc=velV_vertical_integral./(1.0e6);

figure
contourf(y,deptht,velV_moc,[-10:0.1:10])
colorbar
axis ij
cmocean('curl')
caxis([-5 5])
set(gca,'Color',[0.7 0.7 0.7])
xlabel('Distance (km)','FontSize',12)
ylabel('Depth','FontSize',12)
caption=sprintf('%s: MOC (+ve=clockwise)',run)
title(caption,'FontWeight','bold','FontSize',12)
set(gcf, 'InvertHardcopy', 'off')
print('-r300','-dpng','MOC')


base=datenum(1886,1,30);
date=datenum(datestr((time_counter/86400)+base));

% melt
% 
for i=1:length(time_counter)
melt_iceshelf=squeeze(melt(i,:,:))/1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t
net_melt(i)=nansum(squeeze(nansum(melt_iceshelf,2)));
end


figure
subplot(2,1,1)
plot(date,net_melt,'.-g')
caption=sprintf('%s: Net melt (-ve=melt)',run)
title(caption,'FontWeight','bold','FontSize',12)
xlabel('Equivalent year','FontSize',12)
ylabel('Total melt (Gt/year)','FontSize',12)
datetick('x','yy')
%ylim([-800 100])
print('-r300','-dpng','melt_timeseries')
% melt

melt_mean=squeeze(nanmean(melt,1));

index_land=find(bathy==0);
melt_mean(index_land)=NaN;

melt = melt_mean* 86400.0 * 365.0 / 1000.0%(melt_end*86400.0*355.0)/1000 ; % to get meters per year

load colormap_anom

figure
pcolor(glamt,gphit,melt)
t=colorbar
colormap(K)
caxis([-5 5])
%shading flat
set(t,'FontSize',20)
set(t,'position',[0.8495    0.1400    0.0286    0.75])
set(gca,'Color',[0.7 0.7 0.7])
xlabel('Approx. longitude')
ylabel('Approx. latitude')
caption=sprintf('%s: ISF melt m/yr (-ve=melt)',run)
title(caption,'FontWeight','bold','FontSize',12)
set(gcf, 'InvertHardcopy', 'off')
load('rt_colormaps.mat');
colormap(flipud(rt_colormaps.redblueclass));
set(gca,'position',[0.1181    0.1100    0.7042    0.8150])
print('-r300','-dpng','melt_anum')

save 'melt_fris_1995_2009.mat'