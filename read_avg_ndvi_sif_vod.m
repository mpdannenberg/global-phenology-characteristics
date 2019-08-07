% Test SOM with NDVI, VOD, and SIF
nrows = 3;
ncols = 4;

years = 2007:2015;
months = 1:12;
samples = 720;
lines = 360;

ndvi = NaN(length(years), length(months), lines, samples);
sif = NaN(length(years), length(months), lines, samples);
vod = NaN(length(years), length(months), lines, samples);

lat = 89.75:-0.5:-89.75;
lon = -179.75:0.5:179.75;

idx = 1;
for i = 1:length(years)
    for j = 1:length(months)
        
        % NDVI
        fn = sprintf('./data/Raster_NDVI/ndvi_%d_%02d.tif.bil', years(i), months(j));
        dat = multibandread(fn, [lines, samples, 1], 'single', 0, 'bsq', 'ieee-le');
        ndvi(i, j, :, :) = dat;
        
        % SIF
        fn = sprintf('./data/Raster_SIF/SIF%d.bil', idx);
        dat = multibandread(fn, [lines, samples, 1], 'single', 0, 'bsq', 'ieee-le');
        sif(i, j, :, :) = dat;
        idx = idx+1;
        
        % VOD
        fn = sprintf('./data/Raster_VOD/VOD%d%d.bil', years(i), months(j));
        dat = multibandread(fn, [lines, samples, 1], 'single', 0, 'bsq', 'ieee-le');
        vod(i, j, :, :) = dat;
                
    end
end

ndvi_mean = squeeze(nanmean(ndvi, 1));
ndvi_mean(:, lat<0, :) = ndvi_mean([7:12 1:6], lat<0, :);
sif_mean = squeeze(nanmean(sif, 1));
sif_mean(:, lat<0, :) = sif_mean([7:12 1:6], lat<0, :);
vod_mean = squeeze(nanmean(vod, 1));
vod_mean(:, lat<0, :) = vod_mean([7:12 1:6], lat<0, :);

D = [reshape(ndvi_mean, 12, [])'  reshape(sif_mean, 12, [])' reshape(vod_mean, 12, [])'/2]; % Divide VOD by 2 for similar dynamic range as other indices
Didx = sum(isnan(D), 2) == 0;
D = D(Didx, :);

cd somtoolbox;
sM=som_make(D,'msize',[ncols nrows],'rect','sheet');
[Bmus,Qerror]=som_bmus(sM,D);
cd ..;

B = NaN(lines*samples, 1);
B(Didx) = Bmus;
B = reshape(B, lines, samples);

% Plot
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 4];

clr = wesanderson('fantasticfox1');

ax = tight_subplot(nrows,ncols,0.05,[0.1 0.05], [0.1 0.05]);

for i=1:12
    
    axes(ax(i))
    
    Dsub = D(Bmus==i, :);
    Dsub_mean = mean(Dsub);
    Dsub_std = std(Dsub);
    
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
    
    end
    if i == 1
        lgd = legend([pl1 pl2 pl3], 'NDVI','SIF','VOD', 'Location','northeast');
        legend('boxoff');
        lgd.Position = [0.18    0.84    0.1101    0.1146];
    end
    
    text(1.5, 1.9, ['Node: ', num2str(i)], 'FontSize',9);
    
    
end

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/ndvi-sif-vod-som-plot.tif')
close all;

% Map
latlim = [-75 75];
lonlim = [-180 180];
worldland = shaperead('landareas','UseGeoCoords', true);

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 3.5];

% mstrd = make_cmap([1,1,1;clr(1,:).^2], 5);
% rd = make_cmap([1,1,1;clr(2,:)], 5);
% grn = make_cmap([1,1,1;clr(3,:).^2], 5);
% clr2 = [mstrd(2:end, :); rd(2:end, :); grn(2:end, :)];

gld = make_cmap([1,1,1;clr(1,:).^2], 4);
rd = make_cmap([1,1,1;clr(2,:)], 4);
grn = make_cmap([1,1,1;clr(3,:).^2], 4);
prpl = make_cmap([1,1,1;clr(4,:)], 4);
clr2 = NaN(4,3,3); clr2(1,:,:) = rd(2:end, :); clr2(2,:,:) = gld(2:end, :); clr2(3,:,:) = grn(2:end, :); clr2(4,:,:) = prpl(2:end, :);
clr2 = reshape(clr2, 4*3, 3);

ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
surfm(lat, lon, B)
caxis([0.5 12.5])
colormap(clr2);
geoshow(worldland,'FaceColor','none','EdgeColor',[0.6 0.6 0.6])
pos = get(gca, 'Position');
pos(1) = pos(1)-0.1;
set(gca, 'Position',pos);

xst = 0.82;
yst = 0.26;
xsz = 0.04;
ysz = 0.06;
idx = 1;
for i = 1:nrows
    for j = 1:ncols
        %annotation('rectangle',[xst+(j-1)*xsz yst-(i-1)*ysz xsz ysz], 'Color','none', 'FaceColor',clr2(idx,:))
        annotation('textbox',[xst+(j-1)*xsz yst-(i-1)*ysz xsz ysz],...
            'String', num2str(idx), 'EdgeColor','k', 'BackgroundColor',clr2(idx,:),...
            'HorizontalAlignment','center', 'VerticalAlignment','middle')
        idx = idx+1;
    end
end
annotation('textbox',[xst yst+ysz+0.03 4*xsz ysz], 'EdgeColor','none',...
    'String','\bfNode', 'HorizontalAlignment','center', 'FontSize',12)
annotation('arrow', [xst-0.02 xst-0.02], [yst+ysz yst-2*ysz])
annotation('textbox',[xst-4*xsz yst-ysz*2 3.5*xsz ysz], 'EdgeColor','none',...
    'String','Seasonality', 'HorizontalAlignment','right')
annotation('arrow',[xst xst+4*xsz], [yst-2*ysz-0.03 yst-2*ysz-0.03])
annotation('textbox',[xst yst-3*ysz-0.03 4*xsz ysz], 'EdgeColor','none',...
    'String','Productivity', 'HorizontalAlignment','center', 'VerticalAlignment','top')

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/ndvi-sif-vod-som-map.tif')
close all;




