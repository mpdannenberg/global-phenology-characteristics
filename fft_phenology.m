% Using fast Fourier transform for modeling phenological signals 
load ./data/global_phenology_som.mat;
clr = wesanderson('fantasticfox1');

N = 12; % Length of time-series
dt = 1/N; % Sampling frequency (once-monthly)
Nyquist = 1/(2*dt); % Nyquist frequency
df = 1/(N*dt);

h1 = figure('Color','w');
h1.Units = 'inches';
h1.Position = [1 1 7 4];
ax1 = tight_subplot(nrows,ncols,0.05,[0.1 0.05], [0.1 0.05]);

h2 = figure('Color','w');
h2.Units = 'inches';
h2.Position = [1 1 7 4];
ax2 = tight_subplot(nrows,ncols,0.05,[0.1 0.05], [0.1 0.05]);

%% Fast Fourier transform (FFT) 
for i = 1:ncols*nrows
    n = sum(Bmus==i);
    Dsub = D(Bmus==i, :);
    Harm1 = NaN(n, 3);
    Harm2 = NaN(n, 3);
    Phase1 = NaN(n, 3);
    Phase2 = NaN(n, 3);
    
    for j = 1:n
        % NDVI
        tempMean = Dsub(j, 1:12);
        G = fft(tempMean); % FFT
        f = -Nyquist:df:Nyquist-df;
        G_phase = angle(G); % Phase of all frequencies
        G_mag = abs(G);
        Harm1(j, 1) = G_mag(end);
        Harm2(j, 1) = G_mag(3);
        Phase1(j, 1) = G_phase(end);
        Phase2(j, 1) = G_phase(3);
        
        % SIF
        tempMean = Dsub(j, 13:24);
        G = fft(tempMean); % FFT
        f = -Nyquist:df:Nyquist-df;
        G_phase = angle(G); % Phase of all frequencies
        G_mag = abs(G);
        Harm1(j, 2) = G_mag(end);
        Harm2(j, 2) = G_mag(3);
        Phase1(j, 2) = G_phase(end);
        Phase2(j, 2) = G_phase(3);
        
        % VOD
        tempMean = Dsub(j, 25:36);
        G = fft(tempMean); % FFT
        f = -Nyquist:df:Nyquist-df;
        G_phase = angle(G); % Phase of all frequencies
        G_mag = abs(G);
        Harm1(j, 3) = G_mag(end);
        Harm2(j, 3) = G_mag(3);
        Phase1(j, 3) = G_phase(end);
        Phase2(j, 3) = G_phase(3);
        
    end
    
    figure(h1);
    axes(ax1(i));
    p1 = polarscatter(Phase1(:,1), Harm1(:,1), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(1,:).^2,...
        'MarkerFaceAlpha',0.3); % First harmonic 
    set(gca, 'RLim',[0 7]);
    if i==1
        thetaticklabels({'1','2','3','4','5',...
            '6','7','8','9','10','11','12'});
    else
        thetaticklabels('');
    end
    hold on;
    p2 = polarscatter(Phase1(:,2), Harm1(:,2), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(2,:),...
        'MarkerFaceAlpha',0.3); % First harmonic 
    p3 = polarscatter(Phase1(:,3), Harm1(:,3), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(3,:).^2,...
        'MarkerFaceAlpha',0.3); % First harmonic 

    figure(h2);
    axes(ax2(i));
    p1 = polarscatter(Phase2(:,1), Harm2(:,1), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(1,:).^2,...
        'MarkerFaceAlpha',0.3); % First harmonic 
    set(gca, 'RLim',[0 6]);
    if i==1
        thetaticklabels({'1','2','3','4','5',...
            '6','7','8','9','10','11','12'});
    else
        thetaticklabels('');
    end
    hold on;
    p2 = polarscatter(Phase2(:,2), Harm2(:,2), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(2,:),...
        'MarkerFaceAlpha',0.3); % First harmonic 
    p3 = polarscatter(Phase2(:,3), Harm2(:,3), 2, 'filled',...
        'MarkerEdgeColor','none', 'MarkerFaceColor',clr(3,:).^2,...
        'MarkerFaceAlpha',0.3); % First harmonic 

end


