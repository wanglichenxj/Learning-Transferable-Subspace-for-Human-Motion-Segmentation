function plotClusters( clusters )

    scrsz = get(0,'ScreenSize');

    if (size(clusters,1) > size(clusters,2))
        clusters = clusters';
    end

    figure('position',[100,scrsz(4)/2,800,100]);
    h = axes;
    set(h,'position',[0,0.2,0.987,0.8]);
    imagesc(clusters);
    set(gca,'YTick',[]);

end

