function MEC_PlotBall2DVary(strike0,dip0,rake0)
% Parameter variations
strikeList=[60,120,150];
dipList=[30,60,90];
rakeList=[60,120,150];
mode='full';
N=600;
figure;
arr=tiledlayout(3,3);
arr.TileSpacing='compact'; arr.Padding='compact';
% Row 1: vary strike
for i=1:3
    ax=nexttile(i);
    MEC_PlotBall2D(strikeList(i),dip0,rake0,mode,N,ax);
    title(ax,sprintf('Strike = %d^\\circ',strikeList(i)), ...
        'FontSize',18,'FontWeight','bold');
end

% Row 2: vary dip
for i=1:3
    ax=nexttile(i+3);
    MEC_PlotBall2D(strike0,dipList(i),rake0,mode,N,ax);
    title(ax,sprintf('Dip = %d^\\circ',dipList(i)), ...
        'FontSize',18,'FontWeight','bold');
end

% Row 3: vary rake
for i=1:3
    ax=nexttile(i+6);
    MEC_PlotBall2D(strike0,dip0,rakeList(i),mode,N,ax);
    title(ax,sprintf('Rake = %d^\\circ',rakeList(i)), ...
        'FontSize',18,'FontWeight','bold');
end

sgtitle(sprintf('Base Model: Strike = %d^\\circ, Dip = %d^\\circ, Rake = %d^\\circ', ...
    strike0,dip0,rake0), ...
    'FontSize',22,'FontWeight','bold');

set(gcf,'Position',[300,50,900,800]);


end