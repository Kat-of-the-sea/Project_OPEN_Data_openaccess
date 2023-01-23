clear all
close all

load eORCA1_FRIS


%%% depoorter

melt_1995_2009=nansum(nansum(squeeze(nanmean(melt,1)) /1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t)) 


%% Rignot

melt_2003_2008=nansum(nansum(squeeze(nanmean(melt(97:168,:,:),1)) /1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t)) 


%% last year

melt_last_year=nansum(nansum(squeeze(nanmean(melt(end-11:end,:,:),1)) /1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t)) 

%% last 5 years

melt_last_5year=nansum(nansum(squeeze(nanmean(melt(end-59:end,:,:),1)) /1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t)) 


% melt
% 
for i=1:length(time_counter)

    melt_gt_y(i,:,:)= squeeze(melt(i,:,:)) /1000 .* 86400 .* 365 / 1e9 .* e1t .* e2t;
    
    net_melt(i)=nansum(squeeze(nansum(melt_gt_y(i,:,:),2)));

    melt_timestep=melt_gt_y(i,:,:);
    
    index_melt=find(melt_timestep<0);

    neg_melt=melt_timestep(index_melt);
    
    just_melt(i)=nansum(neg_melt);

    index_freeze=find(melt_timestep>0);
    
    pos_melt=melt_timestep(index_freeze);
    
    just_freeze(i)=nansum(pos_melt);


end

stddev_net_melt=nanstd(net_melt(:));
net_melt=nanmean(net_melt(:));
net_melt=round(net_melt);

mean_melt=nanmean(just_melt(:));
mean_melt=round(mean_melt,2);

stddev_melt=nanstd(just_melt(:));

mean_freeze=nanmean(just_freeze(:));
mean_freeze=round(mean_freeze,2);

stddev_freeze=nanstd(just_freeze(:));

