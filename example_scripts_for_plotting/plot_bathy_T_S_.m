
clear all
close all

load eORCA1_FRIS

run='eOR1 CORE-cav-15 1995-2009 equiv after 2 cycles'

temp_end=squeeze(temp(end,:,:,:));
salt_end=squeeze(sal(end,:,:,:));

index_land=find(bathy==0);
bathy(index_land)=NaN;

index_land=find(salt_end==0);
salt_end(index_land)=NaN;
temp_end(index_land)=NaN;

% Bathymetry

figure
pcolor(glamt,gphit,bathy)
colorbar
hold on
contour(glamt,gphit,isf_draft,[0 100 100],'w','linew',3)
title('Model Bathymetry (eORCA1)')
xlabel('Approx. longitude')
ylabel('Approx. latitude')
colormap(flipud(copper))
set(gca,'Color',[0.7 0.7 0.7])
caxis([0 2400])
set(gcf, 'InvertHardcopy', 'off')

print('-r300','-dpng','Bathymetry')

% Temp sections


% T-S plot

temp_axis=[-2.5:0.2:2];
sal_axis=[33:0.2:35.5];

for j=1:length(temp_axis)
    for i=1:length(sal_axis)

        dens_test(j,i)=sw_dens(sal_axis(i),temp_axis(j),0);
    end
end
dens_test=dens_test-1000;

figure

[c,h]=contour(sal_axis,temp_axis,dens_test,'k');
clabel(c,h,'LabelSpacing',1000);
hold on
t=plot([33 36],[-1.9 -1.9],'--c','linew',2)
set(t,'color',[0.8 0.8 0.8])

hold on

for i=1:length(x)
    for ii=1:length(y)
    
    pointsize=10;

scatter(salt_end(:,ii,i),temp_end(:,ii,i),pointsize,deptht(:));
   
    end
end

xlim([33 35.2])
ylim([-2.5 1.5])
colorbar
caxis([0 2000])
set(gca,'fontsize',12)
xlabel('Salinity','FontSize',12)
ylabel('Temperature','FontSize',12)
caption=sprintf('%s: T-S plot',run)
title(caption,'FontWeight','bold','FontSize',12)
print('-r300','-dpng','TS_plot')