clear all
close all

run='core_cav_15'

load eORCA1_FRIS.mat

load('eORCA1_FRIS_isf.mat')

% temperature at isf
sec=1; 

salt=MODEL_sections(sec).vecs;
temp=MODEL_sections(sec).vect;
lvect=(MODEL_sections(sec).lvect)/1000;

lont=MODEL_grid(sec).lont;
latt=MODEL_grid(sec).latt;

veci=MODEL_sections(sec).veci;
vecj=MODEL_sections(sec).vecj;

for i=1:length(veci);
lon(i)=lont(vecj(i),veci(i));
end


salt_jan=squeeze(nanmean(salt(2:3,:,:,:),1)) % note that 1st index of loaddata extractions is always full of NaNs
temp_jan=squeeze(nanmean(temp(2:3,:,:,:),1))

figure    
pcolor(lon,deptht,salt_jan)
axis ij
ylim([0 1200])
t=colorbar
set(t,'Location','SouthOutside')
caxis([34.2 35])
cmocean('haline')
xlabel('Longitude (\circE)','fontsize',12)
ylabel('Depth (m)','fontsize',12)
shading flat
xlim([-61 -35])
 caption=sprintf('OPENCAV: Salinity across FRIS ice shelf front mean Feb-March 1995')
 title(caption,'FontWeight','bold','FontSize',12)
set(gca,'fontsize',12)
set(gca,'position',[0.1300    0.2804    0.7750    0.6590])
print('-r300','-dpng','salt_isf_febmarch_1995')


figure
pcolor(lon,deptht,temp_jan)
axis ij
ylim([0 1200])
t=colorbar
set(t,'Location','SouthOutside')
caxis([-2.5 -1])
cmocean('thermal')
xlabel('Longitude (\circE)','fontsize',12)
ylabel('Depth (m)','fontsize',12)
shading flat
xlim([-61 -35])
 caption=sprintf('OPENCAV: temperature across FRIS ice shelf front mean Feb-March 1995')
 title(caption,'FontWeight','bold','FontSize',12)
set(gca,'fontsize',12)
set(gca,'position',[0.1300    0.2804    0.7750    0.6590])
print('-r300','-dpng','temp_isf_febmarch_1995')


veci=MODEL_sections(sec).veci;
vecj=MODEL_sections(sec).vecj;

for i=1:length(vecj);
lat_isf(i)=latt(vecj(i),veci(i));
lon_isf(i)=lont(vecj(i),veci(i))
end

save 'coords_section_isf' lat_isf lon_isf

save 'variables_cav_15_isf'