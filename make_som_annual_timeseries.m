% Plot (and map) land surface proportions in each node per year

load ./data/global_phenology_som.mat;

[LON, LAT] = meshgrid(lon, lat);
e = referenceEllipsoid('World Geodetic System 1984');
garea = areaquad(reshape(LAT-0.25,[],1),reshape(LON-0.25,[],1),reshape(LAT+0.25,[],1),reshape(LON+0.25,[],1),e);
garea = garea(Didx); 
clear LON LAT e;

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
    for j = 1:size(Bmus_ByYear, 2)
    %nodeProps(i, :) = sum(Bmus_ByYear == nodeOrder(i)) / size(Bmus_ByYear,1);
    nodeProps(i, j) = sum(garea(Bmus_ByYear(:, j) == nodeOrder(i))) / sum(garea);
    end
end

har = area(years,nodeProps', 'LineStyle','none');
for i=1:length(nodeOrder)
    
    har(i).FaceColor = clr2(nodeOrder(i),:);
    
end

ax = gca;
set(ax, 'YLim', [0 1], 'TickDir','out');
xlabel('Year');
ylabel('Proportion of land area');

hold on;
plot([2007 2015], [0.2 0.2], 'k-')
plot([2007 2015], [0.4 0.4], 'k-')
plot([2007 2015], [0.6 0.6], 'k-')
plot([2007 2015], [0.8 0.8], 'k-')

ax.Position(1) = 0.08;
ax.Position(3) = 0.72;

xst = 0.82;
yst = 0.86;
xsz = 0.032;
ysz = 0.06;
idx = 1;
for i = 1:nrows
    for j = 1:ncols
        annotation('textbox',[xst+(j-1)*xsz yst-(i-1)*ysz xsz ysz],...
            'String', num2str(idx), 'EdgeColor','k', 'BackgroundColor',clr2(idx,:),...
            'HorizontalAlignment','center', 'VerticalAlignment','middle')
        idx = idx+1;
    end
end
annotation('textbox',[xst yst+ysz+0.03 4*xsz ysz], 'EdgeColor','none',...
    'String','\bfPhenoregion', 'HorizontalAlignment','center', 'FontSize',11)
annotation('arrow', [xst+xsz*4+0.017 xst+xsz*4+0.017], [yst-2*ysz yst+ysz])
text(2017.02,0.88, 'Seasonality', 'HorizontalAlignment','center','VerticalAlignment','middle','Rotation',90)
annotation('arrow',[xst xst+4*xsz], [yst-2*ysz-0.03 yst-2*ysz-0.03])
annotation('textbox',[xst yst-3*ysz-0.03 4*xsz ysz], 'EdgeColor','none',...
    'String','Productivity', 'HorizontalAlignment','center', 'VerticalAlignment','top')


set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/som-trends.tif')
close all;

