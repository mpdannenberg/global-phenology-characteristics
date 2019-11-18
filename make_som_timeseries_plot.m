% Plot time-series of NDVI, SIF, and VOD for each node
load ./data/global_phenology_som.mat;

% Plot
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 4];

clr = wesanderson('fantasticfox1');

ax = tight_subplot(nrows,ncols,0.05,[0.1 0.05], [0.1 0.05]);

for i=1:12
    
    axes(ax(i))
    
    Dsub = D(Bmus==i, :);
    Dsub_mean = nanmean(Dsub);
    Dsub_std = nanstd(Dsub);
    
    fill([1:12 fliplr(1:12)], [Dsub_mean(1:12)-Dsub_std(1:12) fliplr(Dsub_mean(1:12)+Dsub_std(1:12))], clr(1,:), 'FaceAlpha',0.4, 'EdgeColor','none');
    hold on;
    fill([1:12 fliplr(1:12)], [Dsub_mean(13:24)-Dsub_std(13:24) fliplr(Dsub_mean(13:24)+Dsub_std(13:24))], clr(2,:), 'FaceAlpha',0.2, 'EdgeColor','none');
    fill([1:12 fliplr(1:12)], [Dsub_mean(25:36)-Dsub_std(25:36) fliplr(Dsub_mean(25:36)+Dsub_std(25:36))], clr(3,:), 'FaceAlpha',0.2, 'EdgeColor','none');
    pl1 = plot(1:12, Dsub_mean(1:12), '-', 'Color',clr(1,:).^2, 'LineWidth',2);
    pl2 = plot(1:12, Dsub_mean(13:24), '-', 'Color',clr(2,:), 'LineWidth',2);
    pl3 = plot(1:12, Dsub_mean(25:36), '-', 'Color',clr(3,:).^2, 'LineWidth',2);
    
    set(gca, 'XLim',[1 12], 'YLim',[0 2], 'TickDir','out', 'TickLength',[0.04 0.05], 'XTick',1:12)
    
    box off;
    
    if rem(i, ncols)~=1
        set(gca, 'YTickLabels','')
    end
    if i<=(ncols * (nrows-1))
        set(gca, 'xTickLabels','')
    else
        set(gca, 'XTickLabels',{'1','2','3','4','5','6','7','8','9','10','11','12'});
        xlabel('Month');
    end
    if i == 1
        lgd = legend([pl1 pl2 pl3], 'NDVI','SIF','VOD', 'Location','northeast');
        legend('boxoff');
        lgd.Position = [0.105    0.8    0.1101    0.1146];
    end
    if i == 5
        ylabel({'NDVI (unitless), VOD (unitless), and SIF (mW m^{-2} nm^{-1} sr^{-1})';''})
    end
    
    text(1.5, 1.9, ['Phenoregion: ', num2str(i)], 'FontSize',9);
    
    
end

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/ndvi-sif-vod-som-plot.tif')
close all;

