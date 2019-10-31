% Plot time-series of NDVI, SIF, and VOD for each node

syear = 2007;
eyear = 2015;

load ./data/global_phenology_som.mat;
prcp = ncread('D:/Data_Analysis/CRU/cru_ts4.01.1901.2016.pre.dat.nc', 'pre');
tavg = ncread('D:/Data_Analysis/CRU/cru_ts4.01.1901.2016.tmp.dat.nc', 'tmp');
clat = ncread('D:/Data_Analysis/CRU/cru_ts4.01.1901.2016.pre.dat.nc', 'lat'); ny = length(clat);
clon = ncread('D:/Data_Analysis/CRU/cru_ts4.01.1901.2016.pre.dat.nc', 'lon'); nx = length(clon);
cyr = 1901:2016;

prcp = reshape(permute(prcp, [2 1 3]), ny, nx, 12, []);
tavg = reshape(permute(tavg, [2 1 3]), ny, nx, 12, []);

mprcp = flipud(mean(prcp(:,:,:,cyr>=syear & cyr<=eyear), 4));
mprcp(lat<0, :, :) = mprcp(lat<0, :, [7:12 1:6]);
mprcp = reshape(mprcp, [], 12);
mprcp = mprcp(Didx, :);
mtavg = flipud(mean(tavg(:,:,:,cyr>=syear & cyr<=eyear), 4));
mtavg(lat<0, :, :) = mtavg(lat<0, :, [7:12 1:6]);
mtavg = reshape(mtavg, [], 12);
mtavg = mtavg(Didx, :);

% Plot
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 4];

clr = wesanderson('fantasticfox1');

ax = tight_subplot(nrows,ncols,0.05,[0.1 0.05], [0.08 0.08]);
set(h,'defaultAxesColorOrder',[clr(4,:).^2; clr(2,:)]);

for i=1:12
    
    axes(ax(i))
    
    Psub = mprcp(Bmus==i, :);
    Psub_mean = nanmean(Psub);
    Psub_std = nanstd(Psub);
    
    Tsub = mtavg(Bmus==i, :);
    Tsub_mean = nanmean(Tsub);
    Tsub_std = nanstd(Tsub);
    
    yyaxis left;
    fill([1:12 fliplr(1:12)], [Psub_mean-Psub_std fliplr(Psub_mean+Psub_std)], clr(4,:), 'FaceAlpha',0.2, 'EdgeColor','none');
    hold on;
    pl3 = plot(1:12, Psub_mean, '-', 'Color',clr(4,:), 'LineWidth',2);
    if rem(i, ncols)~=1
        set(gca, 'YTickLabels','')
    else
        ylabel('Precipitation (mm)');
    end
    set(gca, 'XLim',[1 12], 'YLim',[0 400], 'TickDir','out', 'TickLength',[0.04 0.05], 'XTick',1:12)
    
    yyaxis right;
    fill([1:12 fliplr(1:12)], [Tsub_mean-Tsub_std fliplr(Tsub_mean+Tsub_std)], clr(2,:), 'FaceAlpha',0.2, 'EdgeColor','none');
    hold on;
    pl2 = plot(1:12, Tsub_mean, '-', 'Color',clr(2,:), 'LineWidth',2);
    set(gca, 'XLim',[1 12], 'YLim',[-30 40], 'TickDir','out', 'TickLength',[0.04 0.05], 'XTick',1:12)
    if rem(i, ncols)~=0
        set(gca, 'YTickLabels','')
    else
        ylabel(['Temperature (',char(176),'C)']);
    end
    
    box off;
    
    
    if i<=(ncols * (nrows-1))
        set(gca, 'xTickLabels','')
    else
        set(gca, 'XTickLabels',{'J','F','M','A','M','J','J','A','S','O','N','D'});
    end
    
    text(1.5, 40, ['Phenoregion: ', num2str(i)], 'FontSize',9, 'VerticalAlignment','top');
    
    
end

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/climate-som-plot.tif')
close all;

