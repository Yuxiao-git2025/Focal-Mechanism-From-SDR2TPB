% =========================================================================
% Plot 2-D focal mechanism beachball from SDR
% We are using the NEU region for plotting, which will be quite interesting
% The corresponding plot functions can be found in the <fun_BallPlot> file
% Usage:
%   MEC_PlotBall2D(strike,dip,rake)
%   MEC_PlotBall2D(strike,dip,rake,'planes')
%   MEC_PlotBall2D(strike,dip,rake,'full')
%   MEC_PlotBall2D(strike,dip,rake,'full',600)
%
% Inputs:
%   strike,dip,rake are in degrees.
%   mode='planes' plots only the fault plane and auxiliary plane.
%   mode='full' plots nodal planes, tension quadrants, and P/B/T axes.
%   (N controls the number of sphere samples for filling tension quadrants)
%
% Coordinate convention:
%   This plotting routine uses NED coordinates:
%       N: north
%       E: east
%       D: down
%   Lower-hemisphere projection is used, so vectors are flipped to D>=0
%   before plotting when necessary
%
% Main formulas:
%   n is the fault-plane normal vector
%   d is the slip vector
%   T=(n+d)/sqrt(2)
%   P=(n-d)/sqrt(2)
%   B=cross(T,P)
%
%   The double-couple moment tensor is:
%       M=n*d'+d*n'
% =========================================================================
function h=MEC_PlotBall2D(strike,dip,rake,mode,N,ax)
Grids=600;  % Less than 2000 is OK
if nargin<4||isempty(mode)
    mode='full';
end
if nargin<5||isempty(N)
    N=Grids;
end

if nargin<6 || isempty(ax)
    figure; % Create new figure
    ax=gca;
    IsFigure=true;
else
    axes(ax); % plot in sub-figure
    IsFigure=false;
end

% Normal and slip voctor
n1=MEC_StrikeDip2Norm(strike,dip); % norm in NEU
d1=MEC_SDR2Slip(strike,dip,rake);  % slip in NEU
n2=d1; % The auxiliary plane is reverse

% T/P/B Axis
[~,~,~,tAxis,pAxis,bAxis]=MEC_SDR2TPB(strike,dip,rake); % PBT in NEU

% Tensile and compressive quadrant
[planeX1,planeY1]=MEC_CircleWulffNEU(n1,Grids);
[planeX2,planeY2]=MEC_CircleWulffNEU(n2,Grids);

% =========================================================================
hold on;
axis tight;
axis equal;
axis off;
% The outer ring of the ball
cirX=sin(linspace(0,2*pi,Grids).');
cirY=cos(linspace(0,2*pi,Grids).');
h.circle=plot(cirX,cirY,'k-','LineWidth',1.5,'LineStyle','-');

switch lower(mode)
    case 'planes'
        h.plane1=plot(planeX1,planeY1,'-','Color',[0.0000,0.3500,0.1200],'LineWidth',3.0);
        h.plane2=plot(planeX2,planeY2,'-','Color',[0.7200,0.7200,0.7200],'LineWidth',3.0);

    case 'full'
        sphere=MEC_FibonacciSphere(N);      % treated as [N,E,U]
        sphere=sphere(sphere(:,3)<=0,:);    % NEU lower hemisphere
        M=n1.'*d1+d1.'*n1;
        amp=sum((sphere*M).*sphere,2);
        tension=sphere(amp>0,:);

        % Mark the area with markers
        [tenX,tenY]=MEC_WulffNEU(tension);
        h.tension=scatter(tenX,tenY,60,[0.7000,0.7000,0.7000],'Marker','x');
        
        % Fill the tension quadrant with color in NEU
%         h.tension=MEC_FillPlane(Grids,M);

        % plot the fault plane lines
        h.plane1=plot(planeX1,planeY1,'-','Color',[0.0000,0.3500,0.1200],'LineWidth',3.0);
        h.plane2=plot(planeX2,planeY2,'-','Color',[0.7200,0.7200,0.7200],'LineWidth',3.0);

        % Mark the P/B/T position
        [pX,pY]=MEC_WulffPointNEU(pAxis);
        [bX,bY]=MEC_WulffPointNEU(bAxis);
        [tX,tY]=MEC_WulffPointNEU(tAxis);
        h.p=text(pX,pY,'$P$','Color',[0 0 0],'FontSize',22,'FontWeight','bold', ...
            'HorizontalAlignment','center','Interpreter','latex');
        h.b=text(bX,bY,'$B$','Color',[0 0 0],'FontSize',22,'FontWeight','bold', ...
            'HorizontalAlignment','center','Interpreter','latex');
        h.t=text(tX,tY,'$T$','Color',[0 0 0],'FontSize',22,'FontWeight','bold', ...
            'HorizontalAlignment','center','Interpreter','latex');
    otherwise
        error('MEC_PlotBeachball2D:badMode','mode must be ''planes'' or ''full''.');
end

% for k=0:30:330
%     x=1.12*sind(k);
%     y=1.12*cosd(k);
%     text(x,y,num2str(k),'HorizontalAlignment','center','FontSize',14);
% end

% xlim([-1.25,1.25]);
% ylim([-1.25,1.25]);
% title(sprintf('SDR = %.1f / %.1f / %.1f',strike,dip,rake));
Fun_Decorat;
hold(ax,'off');
if IsFigure
    set(gcf, 'Position', [400, 85, 600, 580]);
end
end

