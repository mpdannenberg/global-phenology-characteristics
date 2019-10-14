parpool local;

% Plot time-series of NDVI, SIF, and VOD for each node
load ./data/global_phenology_som.mat;
[nt,nm,ny,nx] = size(sif);

% Fill missing values with seasonal means
ndvim = repmat(nanmean(ndvi, 1), 9, 1,1,1); ndvi(isnan(ndvi)) = ndvim(isnan(ndvi));
sifm = repmat(nanmean(sif, 1), 9, 1,1,1); sif(isnan(sif)) = sifm(isnan(sif));
vodm = repmat(nanmean(vod, 1), 9, 1,1,1); vod(isnan(vod)) = vodm(isnan(vod));

idx = reshape(Didx, ny, nx);

pctAnnual = NaN(12,3);
pctBiAnnual = NaN(12,3);
pctBoth = NaN(12,3);

for i=1:12
    
    % NDVI
    Dsub = reshape(permute(ndvi(:,:,idx),[2 1 3]), nt*nm, []);
    Dsub = Dsub(:, Bmus==i)';
    Ann = NaN(size(Dsub,1),1);
    BiAnn = NaN(size(Dsub,1),1);
    Both = NaN(size(Dsub,1),1);
    parfor k = 1:size(Dsub, 1)
        
        x = Dsub(k,:);
        
        m = mean(x);
        s = std(x);
        
        cn = dsp.ColoredNoise('Color','pink', 'SamplesPerFrame',length(x), 'NumChannels',1000);
        noiseOut = cn();
        xn = (noiseOut - repmat(mean(noiseOut), length(x), 1)) ./ repmat(std(noiseOut), length(x), 1);
        xn = (xn * std(x)) + mean(x);
        
        [pxxn, fn] = pmtm(xn, [], [1 2], 12);
        [pxx, f, pxxc] = pmtm(x, [], [1 2], 12, 'ConfidenceLevel',0.95);
        
        pxxnup = quantile(pxxn',0.99); % One-tailed since only looking at those with spectral power greater than red-noise
        
        Ann(k) = pxx(1) > pxxnup(1) & pxx(2) <= pxxnup(2);
        BiAnn(k) = pxx(2) > pxxnup(2) & pxx(1) <= pxxnup(1);
        Both(k) = pxx(2) > pxxnup(2) & pxx(1) > pxxnup(1);
    end
    pctAnnual(i, 1) = sum(Ann) / length(Ann);
    pctBiAnnual(i, 1) = sum(BiAnn) / length(BiAnn);
    pctBoth(i, 1) = sum(Both) / length(Both);
    
    % SIF
    Dsub = reshape(permute(sif(:,:,idx),[2 1 3]), nt*nm, []);
    Dsub = Dsub(:, Bmus==i)';
    Ann = NaN(size(Dsub,1),1);
    BiAnn = NaN(size(Dsub,1),1);
    Both = NaN(size(Dsub,1),1);
    parfor k = 1:size(Dsub, 1)
        
        x = Dsub(k,:);
        
        m = mean(x);
        s = std(x);
        
        cn = dsp.ColoredNoise('Color','pink', 'SamplesPerFrame',length(x), 'NumChannels',1000);
        noiseOut = cn();
        xn = (noiseOut - repmat(mean(noiseOut), length(x), 1)) ./ repmat(std(noiseOut), length(x), 1);
        xn = (xn * std(x)) + mean(x);
        
        [pxxn, fn] = pmtm(xn, [], [1 2], 12);
        [pxx, f, pxxc] = pmtm(x, [], [1 2], 12, 'ConfidenceLevel',0.95);
        
        pxxnup = quantile(pxxn',0.99);
        
        Ann(k) = pxx(1) > pxxnup(1) & pxx(2) <= pxxnup(2);
        BiAnn(k) = pxx(2) > pxxnup(2) & pxx(1) <= pxxnup(1);
        Both(k) = pxx(2) > pxxnup(2) & pxx(1) > pxxnup(1);
    end
    pctAnnual(i, 2) = sum(Ann) / length(Ann);
    pctBiAnnual(i, 2) = sum(BiAnn) / length(BiAnn);
    pctBoth(i, 2) = sum(Both) / length(Both);
    
    % VOD
    Dsub = reshape(permute(vod(:,:,idx),[2 1 3]), nt*nm, []);
    Dsub = Dsub(:, Bmus==i)';
    Ann = NaN(size(Dsub,1),1);
    BiAnn = NaN(size(Dsub,1),1);
    Both = NaN(size(Dsub,1),1);
    parfor k = 1:size(Dsub, 1)
        
        x = Dsub(k,:);
        
        m = mean(x);
        s = std(x);
        
        cn = dsp.ColoredNoise('Color','pink', 'SamplesPerFrame',length(x), 'NumChannels',1000);
        noiseOut = cn();
        xn = (noiseOut - repmat(mean(noiseOut), length(x), 1)) ./ repmat(std(noiseOut), length(x), 1);
        xn = (xn * std(x)) + mean(x);
        
        [pxxn, fn] = pmtm(xn, [], [1 2], 12);
        [pxx, f, pxxc] = pmtm(x, [], [1 2], 12, 'ConfidenceLevel',0.95);
        
        pxxnup = quantile(pxxn',0.99); 
        
        Ann(k) = pxx(1) > pxxnup(1) & pxx(2) <= pxxnup(2);
        BiAnn(k) = pxx(2) > pxxnup(2) & pxx(1) <= pxxnup(1);
        Both(k) = pxx(2) > pxxnup(2) & pxx(1) > pxxnup(1);
    end
    pctAnnual(i, 3) = sum(Ann) / length(Ann);
    pctBiAnnual(i, 3) = sum(BiAnn) / length(BiAnn);
    pctBoth(i, 3) = sum(Both) / length(Both);
    
    
    
end

save('./output/spectraldensity.mat','pctAnnual', 'pctBiAnnual', 'pctBoth');

%% Make figure
% Plot
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 3];

clr = wesanderson('fantasticfox1');
gld = make_cmap([1,1,1;clr(1,:).^2], 4);
rd = make_cmap([1,1,1;clr(2,:)], 4);
grn = make_cmap([1,1,1;clr(3,:).^2], 4);
clr2 = NaN(3,3,3); clr2(1,:,:) = flipud(gld(2:end, :)); clr2(2,:,:) = flipud(rd(2:end, :)); clr2(3,:,:) = flipud(grn(2:end, :)); 
clr2 = reshape(clr2, 3*3, 3);

br = bar(1:12, pctAnnual+pctBiAnnual+pctBoth);
br(1).FaceColor = gld(2,:);
br(2).FaceColor = rd(2,:);
br(3).FaceColor = grn(2,:);

hold on;
br = bar(1:12, pctAnnual+pctBiAnnual);
br(1).FaceColor = gld(3,:);
br(2).FaceColor = rd(3,:);
br(3).FaceColor = grn(3,:);

br = bar(1:12, pctAnnual);
br(1).FaceColor = gld(4,:);
br(2).FaceColor = rd(4,:);
br(3).FaceColor = grn(4,:);

xlabel('Node');
ylabel('Proportion of pixels');

ax = gca;
box off;
set(ax, 'TickDir','out');
ax.Position(4) = 0.65;

xst = 0.16;
yst = 0.88;
xsz = 0.05;
ysz = 0.05;
idx = 1;
for i = 1:3
    for j = 1:3
        annotation('textbox',[xst+(j-1)*xsz yst-(i-1)*ysz xsz ysz],...
            'EdgeColor','k', 'BackgroundColor',clr2(idx,:),...
            'HorizontalAlignment','center', 'VerticalAlignment','middle')
        idx = idx+1;
    end
end
annotation('textbox',[xst yst+0.02 xsz ysz], 'EdgeColor','none',...
    'String','NDVI', 'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'FontSize',8)
annotation('textbox',[xst+xsz yst+0.02 xsz ysz], 'EdgeColor','none',...
    'String','SIF', 'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'FontSize',8)
annotation('textbox',[xst+xsz*2 yst+0.02 xsz ysz], 'EdgeColor','none',...
    'String','VOD', 'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'FontSize',8)
annotation('textbox',[xst+xsz*3 yst-ysz*2 xsz*2 ysz], 'EdgeColor','none',...
    'String','Both', 'HorizontalAlignment','left','VerticalAlignment','middle',...
    'FontSize',8)
annotation('textbox',[xst+xsz*3 yst-ysz*1 xsz*3 ysz], 'EdgeColor','none',...
    'String','2 cycles/year', 'HorizontalAlignment','left','VerticalAlignment','middle',...
    'FontSize',8)
annotation('textbox',[xst+xsz*3 yst-ysz*0 xsz*3 ysz], 'EdgeColor','none',...
    'String','1 cycle/year', 'HorizontalAlignment','left','VerticalAlignment','middle',...
    'FontSize',8)

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/cycles-per-year-bars.tif')
close all;


