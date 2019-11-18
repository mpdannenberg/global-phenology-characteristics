% Make nested phenoregions and map/plot

load ./data/global_phenology_som.mat;

nrows = 2;
ncols = 3;
samples = 720;
lines = 360;

% Map
latlim = [-75 75];
lonlim = [-180 180];
worldland = shaperead('landareas','UseGeoCoords', true);

clr = wesanderson('fantasticfox1');
gld = make_cmap([1,1,1;clr(1,:).^2], nrows+1);
rd = make_cmap([1,1,1;clr(2,:)], nrows+1);
grn = make_cmap([1,1,1;clr(3,:).^2], nrows+1);
% prpl = make_cmap([1,1,1;clr(4,:)], nrows+1);
clr2 = NaN(ncols,nrows,3); clr2(1,:,:) = rd(2:end, :); clr2(2,:,:) = gld(2:end, :); clr2(3,:,:) = grn(2:end, :); %clr2(4,:,:) = prpl(2:end, :);
clr2 = reshape(clr2, ncols*nrows, 3);

% Assign each Level 1 phenoregion to a Level 2 region
n = length(unique(Bmus));
Bmus_L2 = NaN(size(Bmus));

for i = 1:n
    Dsub = D(Bmus==i, :);
    
    cd somtoolbox;
    sM=som_make(Dsub,'msize',[ncols nrows],'rect','sheet');
    [bmus,~]=som_bmus(sM,Dsub);
    cd ..;
    
    Bmus_temp = NaN(size(Bmus));
    Bmus_temp(Bmus==i) = bmus;
    b = NaN(lines*samples, 1);
    b(Didx) = Bmus_temp;
    b = reshape(b, lines, samples);
    
    h = figure('Color','w');
    h.Units = 'inches';
    h.Position = [1 0 7 8];
    
    subplot(4,3,1:6)
    ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
            'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
            'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
            'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
            'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
    axis off;
    axis image;
    surfm(lat, lon, b)
    caxis([0.5 nrows*ncols+0.5])
    colormap(clr2);
    geoshow(worldland,'FaceColor','none','EdgeColor',[0.6 0.6 0.6])
    set(gca, 'Position',[0.1125    0.6    0.7750    0.3768]);
    
    cb = colorbar('southoutside');
    cb.Position = [0.1625    0.57    0.6751    0.0278];
    cb.TickLength = 0;
    
    labs = cell(1,ncols*nrows);
    for j = 1:(nrows*ncols)
        labs{j} = [num2str(i),'.',num2str(j)];
        
        subplot(4,3,j+6)
        Dtemp = Dsub(bmus==j, :);
        
        Dsub_mean = nanmean(Dtemp);
        Dsub_std = nanstd(Dtemp);

        fill([1:12 fliplr(1:12)], [Dsub_mean(1:12)-Dsub_std(1:12) fliplr(Dsub_mean(1:12)+Dsub_std(1:12))], clr(1,:), 'FaceAlpha',0.4, 'EdgeColor','none');
        hold on;
        fill([1:12 fliplr(1:12)], [Dsub_mean(13:24)-Dsub_std(13:24) fliplr(Dsub_mean(13:24)+Dsub_std(13:24))], clr(2,:), 'FaceAlpha',0.2, 'EdgeColor','none');
        fill([1:12 fliplr(1:12)], [Dsub_mean(25:36)-Dsub_std(25:36) fliplr(Dsub_mean(25:36)+Dsub_std(25:36))], clr(3,:), 'FaceAlpha',0.2, 'EdgeColor','none');
        pl1 = plot(1:12, Dsub_mean(1:12), '-', 'Color',clr(1,:).^2, 'LineWidth',2);
        pl2 = plot(1:12, Dsub_mean(13:24), '-', 'Color',clr(2,:), 'LineWidth',2);
        pl3 = plot(1:12, Dsub_mean(25:36), '-', 'Color',clr(3,:).^2, 'LineWidth',2);

        set(gca, 'XLim',[1 12], 'YLim',[0 2], 'TickDir','out', 'TickLength',[0.04 0.05], 'XTick',1:12)

        box off;

        if rem(j, ncols)~=1
            set(gca, 'YTickLabels','')
        end
        if j<=(ncols * (nrows-1))
            set(gca, 'xTickLabels','')
        else
            set(gca, 'XTickLabels',{'1','2','3','4','5','6','7','8','9','10','11','12'});
            xlabel('Month');
        end
        if j == 1
            lgd = legend([pl1 pl2 pl3], 'NDVI','SIF','VOD', 'Location','northeast');
            legend('boxoff');
            lgd.Position = [0.14    0.41    0.1101    0.05];
        end
        if j == 1
            text(-3, -0.5, 'NDVI (unitless), VOD (unitless), and SIF (mW m^{-2} nm^{-1} sr^{-1})', 'FontSize',9, 'Rotation',90, 'HorizontalAlignment','center')
        end

        text(1.5, 1.9, ['Phenoregion: ', labs{j}, ' ({\itn} = ', num2str(sum(bmus==j)),')'], 'FontSize',8);
    end
    
    cb.TickLabels = labs;
    cb.FontSize = 11;
    
    Bmus_L2(Bmus==i) = (i*10)+bmus;
    
    set(gcf,'PaperPositionMode','auto')
    print('-dtiff','-f1','-r300',['./output/phenoregion-l2-map-',num2str(i),'.tif'])
    close all;

end

B_L2 = NaN(lines*samples, 1);
B_L2(Didx) = Bmus_L2;
B_L2 = reshape(B_L2, lines, samples);

R = georasterref('RasterSize',size(B_L2), ...
    'LatitudeLimits',[-90 90],'LongitudeLimits',[-180 180]);
geotiffwrite('./output/world_phenoregions_L2.tif', flipud(B_L2), R);
geotiffwrite('./output/world_phenoregions_L1.tif', flipud(B), R);



