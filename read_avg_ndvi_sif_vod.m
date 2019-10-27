% Read NDVI, SIF, and VOD data and calibrate SOM from seasonal means
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
Didx = sum(D>0, 2) > 0;
D = D(Didx, :);

cd somtoolbox;
sM=som_make(D,'msize',[ncols nrows],'rect','sheet');
[Bmus,Qerror]=som_bmus(sM,D);
cd ..;

B = NaN(lines*samples, 1);
B(Didx) = Bmus;
B = reshape(B, lines, samples);

save('./data/global_phenology_som.mat', 'B','Bmus', 'D','Didx', 'lat','lon','sM','nrows','ncols', 'years','ndvi','vod','sif');
clear all;

