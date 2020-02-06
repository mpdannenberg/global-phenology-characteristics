% Make map of spectral density results

load ./output/spectraldensity;
load ./data/global_phenology_som.mat;
[nt,nm,ny,nx] = size(sif);

% Map
latlim = [-75 75];
lonlim = [-180 180];
worldland = shaperead('landareas','UseGeoCoords', true);

h = figure('Color','w');
h.Units = 'inches';
h.Position = [1 1 7 2.5];

clr = wesanderson('fantasticfox1');

% Annual
temp = NaN(size(Didx));
temp(Didx) = totAnnual(:,1);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,1)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(1,:).^2);
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.08;
pos(2) = 0.5;
set(gca, 'Position',pos);
text(-2.5,1.2,'A', 'FontSize',12)
title('NDVI', 'FontSize',12)
text(-3.6,0,'1 cycle/year','HorizontalAlignment','center',...
    'VerticalAlignment','middle','Rotation',90,'FontSize',10);

temp = NaN(size(Didx));
temp(Didx) = totAnnual(:,2);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,2)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(2,:));
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.385;
pos(2) = 0.5;
set(gca, 'Position',pos);
text(-2.5,1.2,'B', 'FontSize',12)
title('SIF', 'FontSize',12)

temp = NaN(size(Didx));
temp(Didx) = totAnnual(:,3);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,3)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(3,:).^2);
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.69;
pos(2) = 0.5;
set(gca, 'Position',pos);
text(-2.5,1.2,'C', 'FontSize',12)
title('VOD', 'FontSize',12)

% BiAnnual
temp = NaN(size(Didx));
temp(Didx) = totBiAnnual(:,1);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,4)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(1,:).^2);
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.08;
pos(2) = 0.03;
set(gca, 'Position',pos);
text(-2.5,1.2,'D', 'FontSize',12)
text(-3.6,0,'2 cycles/year','HorizontalAlignment','center',...
    'VerticalAlignment','middle','Rotation',90,'FontSize',10);

temp = NaN(size(Didx));
temp(Didx) = totBiAnnual(:,2);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,5)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(2,:));
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.385;
pos(2) = 0.03;
set(gca, 'Position',pos);
text(-2.5,1.2,'E', 'FontSize',12)

temp = NaN(size(Didx));
temp(Didx) = totBiAnnual(:,3);
temp = reshape(temp, ny, nx);
temp(temp == 0) = NaN;
subplot(2,3,6)
ax = axesm('winkel','MapLatLimit',latlim,'MapLonLimit',lonlim,'grid',...
        'on','PLineLocation',30,'MLineLocation',60,'MeridianLabel','off',...
        'ParallelLabel','off','GLineWidth',0.5,'Frame','on','FFaceColor',...
        'none', 'FontName', 'Helvetica','GColor',[0.6 0.6 0.6],...
        'FLineWidth',1, 'FontColor',[0.5 0.5 0.5], 'MLabelParallel',min(latlim)+0.11);
axis off;
axis image;
geoshow(worldland,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
surfm(lat, lon, temp)
caxis([0.5 1.5])
colormap(gca, clr(3,:).^2);
subplotsqueeze(gca, 1.25);
pos = get(gca, 'Position');
pos(1) = 0.69;
pos(2) = 0.03;
set(gca, 'Position',pos);
text(-2.5,1.2,'F', 'FontSize',12)

set(gcf,'PaperPositionMode','auto')
print('-dtiff','-f1','-r300','./output/cycles-per-year-map.tif')
close all;

