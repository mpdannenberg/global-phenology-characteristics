% Make example plot of spectral density

% Plot time-series of NDVI, SIF, and VOD for each node
load ./data/global_phenology_som.mat;
[nt,nm,ny,nx] = size(sif);

% Fill missing values with seasonal means
ndvim = repmat(nanmean(ndvi, 1), 9, 1,1,1); ndvi(isnan(ndvi)) = ndvim(isnan(ndvi));
sifm = repmat(nanmean(sif, 1), 9, 1,1,1); sif(isnan(sif)) = sifm(isnan(sif));
vodm = repmat(nanmean(vod, 1), 9, 1,1,1); vod(isnan(vod)) = vodm(isnan(vod));

idx = reshape(Didx, ny, nx);

i = 10;
k = 1751;

Dsub = reshape(permute(ndvi(:,:,idx),[2 1 3]), nt*nm, []);
Dsub = Dsub(:, Bmus==i)';
Dsub = fillmissing(Dsub,'spline',2, 'endvalues','nearest');

x = Dsub(k,:);
m = mean(x);
s = std(x);
cn = dsp.ColoredNoise('Color','pink', 'SamplesPerFrame',length(x), 'NumChannels',1000);
noiseOut = cn();
xn = (noiseOut - repmat(mean(noiseOut), length(x), 1)) ./ repmat(std(noiseOut), length(x), 1);
xn = (xn * std(x)) + mean(x);

[pxxn, fn] = pmtm(xn, [], [], 12);
[pxx, f, pxxc] = pmtm(x, [], [], 12, 'ConfidenceLevel',0.95);
pxxnup = quantile(pxxn',0.99);
pxxnlow = min(pxxn');

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 3.5 4];

subplot(2,1,1)
y = reshape(repmat(2007:2015, 12, 1), [], 1);
m = reshape(repmat(1:12, 9, 1)', [], 1);
t = datenum(y,m,15);
plot(t', x, 'k-', 'LineWidth',1.5);
datetick;
set(gca, 'XLim',[datenum(2007,1,1) datenum(2016,1,1)], 'TickDir','out', 'TickLength',[0.025 0.05])
box off;
ylabel('NDVI');
xlabel('Date');
text(datenum(2007,3,15), 0.6, 'A', 'FontSize',12)

subplot(2,1,2)
fill([fn' fliplr(fn')], [log(pxxnup) fliplr(log(pxxnlow))], [0.8 0.8 0.8], 'EdgeColor','none')
hold on;
plot(f, log(pxx), 'k-', 'LineWidth',1.5)

set(gca, 'TickDir','out', 'TickLength',[0.025 0.05], 'YLim',[-12 0])
box off;
ylabel('Log power density');
xlabel('Number of annual cycles');
legend('Noise','Observed', 'Location','northeast');
legend('boxoff')
text(0.15, 0., 'B', 'FontSize',12)

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/cycles-per-year-example-power-density.tif')
close all;



