% Make sammon map

load ./data/global_phenology_som.mat;
cd somtoolbox;
P = sammon(sM,2);
cd ..;

neighbors = [1 2
    2 3
    3 4
    5 6
    6 7
    7 8
    9 10
    10 11
    11 12
    1 5
    5 9
    2 6
    6 10
    3 7
    7 11
    4 8
    8 12];

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 3.5 3];

for i = 1:size(neighbors, 1)
    plot(P(neighbors(i,:),2), P(neighbors(i,:),1), 'k-')
    hold on;
end
scatter(P(:,2), P(:,1), 250, 'MarkerEdgeColor', 'k', 'MarkerFaceColor',[0.8 0.8 0.8])
set(gca, 'XColor','w', 'YColor','w', 'YLim',[-1.25 1.]);
for i=1:size(P, 1)
    text(P(i,2), P(i,1), num2str(i), 'HorizontalAlignment','center','VerticalAlignment','middle');
end

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/phenoregion-sammon-map.tif')
close all;


