% Plot (and map) land surface proportions in each node per year

load ./data/global_phenology_som.mat;

latlim = [-75 75];
lonlim = [-180 180];
worldland = shaperead('landareas','UseGeoCoords', true);
clr = wesanderson('fantasticfox1');
gld = make_cmap([1,1,1;clr(1,:).^2], 4);
rd = make_cmap([1,1,1;clr(2,:)], 4);
grn = make_cmap([1,1,1;clr(3,:).^2], 4);
prpl = make_cmap([1,1,1;clr(4,:)], 4);
clr2 = NaN(4,3,3); clr2(1,:,:) = rd(2:end, :); clr2(2,:,:) = gld(2:end, :); clr2(3,:,:) = grn(2:end, :); clr2(4,:,:) = prpl(2:end, :);
clr2 = reshape(clr2, 4*3, 3);

% Assign each year to Bmus
Bmus_ByYear = NaN(length(Bmus), length(years));
cd somtoolbox;
for i = 1:length(years)
    
    d = [reshape(ndvi(i,:,:,:), 12, [])'  reshape(sif(i,:,:,:), 12, [])' reshape(vod(i,:,:,:), 12, [])'/2]; % Divide VOD by 2 for similar dynamic range as other indices
    d = d(Didx, :);
    
    [b,~]=som_bmus(sM,d);
    Bmus_ByYear(:, i) = b;
    
end
cd ..;

% Plot proportions
h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 3.5];

nodeOrder = [1 5 9 2 6 10 3 7 11 4 8 12];
nodeProps = NaN(length(nodeOrder), length(years));

for i = 1:length(nodeOrder)
    
    nodeProps(i, :) = sum(Bmus_ByYear == nodeOrder(i)) / size(Bmus_ByYear,1);
    
end

har = area(years,nodeProps', 'LineStyle','none');
for i=1:length(nodeOrder)
    
    har(i).FaceColor = clr2(nodeOrder(i),:);
    
end

set(gca, 'YLim', [0 1], 'TickDir','out');
xlabel('Year');
ylabel('Proportion of land area');

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/som-time-series.tif')
close all;

