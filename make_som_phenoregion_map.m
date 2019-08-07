% Map SOM "phenoregions"
load ./data/global_phenology_som.mat;

% Map
latlim = [-75 75];
lonlim = [-180 180];
worldland = shaperead('landareas','UseGeoCoords', true);

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 3.5];

clr = wesanderson('fantasticfox1');
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



