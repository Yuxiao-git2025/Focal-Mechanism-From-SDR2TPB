% =========================================================================
% Plot nodal lines of multiple focal mechanisms from SDR
%
% Usage:
%   MEC_PlotBall2D(strike,dip,rake)
%   MEC_PlotBall2D(strike,dip,rake,N)
%   MEC_PlotBall2D(strike,dip,rake,N,ax)
%
%   MEC_PlotBall2D(sdr)
%   MEC_PlotBall2D(sdr,N)
%   MEC_PlotBall2D(sdr,N,ax)
%
% Inputs:
%   strike,dip,rake are in degrees.
%   They can be scalars or arrays with the same number of elements.
%
%   sdr is an Nx3 array:
%       [strike, dip, rake]
%
%   N controls the number of samples on each great circle.
%
% Coordinate convention:
%   Internal vectors use NEU:
%       N: north
%       E: east
%       U: up
%
%   Lower-hemisphere Wulff projection is used:
%       U <= 0
%
% Main formulas:
%   n1 is the fault-plane normal vector.
%   d1 is the slip vector.
%   The auxiliary plane normal is:
%       n2 = d1
%
%   Therefore, each focal mechanism contributes two nodal great-circle arcs
% =========================================================================
function h=MEC_PlotBall2DMore(varargin)
% -------------------------------------------------------------------------
% Input parsing
% -------------------------------------------------------------------------
[strike,dip,rake,N,ax,isNewFigure]=MEC_ParsePlotInput(varargin{:});
strike=strike(:);
dip=dip(:);
rake=rake(:);
[strike,dip,rake]=MEC_LocalExpandScalars(strike,dip,rake);
Neve=numel(strike);
% -------------------------------------------------------------------------
% Figure and axis
% -------------------------------------------------------------------------
if isempty(ax)
    figure;
    ax=gca;
    isNewFigure=true;
else
    axes(ax);
end
hold(ax,'on');
axis tight;
axis equal;
axis off;
% -------------------------------------------------------------------------
% Outer circle
% -------------------------------------------------------------------------
theta=linspace(0,2*pi,N).';
cirX=sin(theta);
cirY=cos(theta);
h.circle=plot(ax,cirX,cirY,'k-','LineWidth',1.5);

% -------------------------------------------------------------------------
% Plot nodal lines
% -------------------------------------------------------------------------
h.plane1=gobjects(Neve,1);
h.plane2=gobjects(Neve,1);
lineColor=[0,0,0];
lineWidth=1.5;
cols=flip(slanCM('RdYlGn',Neve)); % green to red
for i=1:Neve
    if any(isnan([strike(i),dip(i),rake(i)]))
        continue
    end
    % First nodal plane: fault-plane normal
    n1=MEC_StrikeDip2Norm(strike(i),dip(i));
    % Second nodal plane: auxiliary-plane normal equals slip vector
    d1=MEC_SDR2Slip(strike(i),dip(i),rake(i));
    n2=d1;
    % Plot Plane-lines
    [planeX1,planeY1]=MEC_CircleWulffNEU(n1,N);
    [planeX2,planeY2]=MEC_CircleWulffNEU(n2,N);
    h.plane1(i)=plot(ax,planeX1,planeY1,'-','Color',cols(i,:),'LineWidth',lineWidth);
    h.plane2(i)=plot(ax,planeX2,planeY2,'-','Color',cols(i,:),'LineWidth',lineWidth);
end
% xlim(ax,[-1.05,1.05]);
% ylim(ax,[-1.05,1.05]);
Fun_Decorat;
hold(ax,'off');
if isNewFigure
    set(gcf,'Color','w');
    set(gcf,'Position',[400,85,600,580]);
end

end






function [strike,dip,rake,N,ax,isNewFigure]=MEC_ParsePlotInput(varargin)
% =========================================================================
% Parse inputs
% =========================================================================
narginchk(1,5);

N=600;
ax=[];
isNewFigure=false;
first=varargin{1};
if isnumeric(first) && ismatrix(first) && size(first,2)==3 && ...
        (nargin==1 || nargin<=3)

    sdr=first;

    strike=sdr(:,1);
    dip=sdr(:,2);
    rake=sdr(:,3);

    if nargin>=2 && ~isempty(varargin{2})
        N=varargin{2};
    end

    if nargin>=3 && ~isempty(varargin{3})
        ax=varargin{3};
    end

else
    if nargin<3
        error('MEC_PlotBall2D:badInput', ...
            'Use MEC_PlotBall2D(strike,dip,rake) or MEC_PlotBall2D(sdr).');
    end

    strike=varargin{1};
    dip=varargin{2};
    rake=varargin{3};

    if nargin>=4 && ~isempty(varargin{4})
        N=varargin{4};
    end

    if nargin>=5 && ~isempty(varargin{5})
        ax=varargin{5};
    end
end

if ~isnumeric(strike) || ~isreal(strike) || ...
   ~isnumeric(dip) || ~isreal(dip) || ...
   ~isnumeric(rake) || ~isreal(rake)
    error('MEC_PlotBall2D:badInput', ...
        'strike, dip and rake must be real numeric arrays.');
end
if ~isscalar(N) || N<10
    error('MEC_PlotBall2D:badInput', ...
        'N must be a scalar integer larger than or equal to 10.');
end
N=round(N);
end

function [a,b,c]=MEC_LocalExpandScalars(a,b,c)
% =========================================================================
% Expand scalar inputs to match the common non-scalar length
% =========================================================================
na=numel(a);
nb=numel(b);
nc=numel(c);
num=[na,nb,nc];
nonScalar=num(num~=1);
if isempty(nonScalar)
    return
end
N=nonScalar(1);
if any(nonScalar~=N)
    error('MEC_PlotBall2D:badInput', ...
        'Non-scalar strike, dip and rake must have the same number of elements.');
end
if na==1
    a=repmat(a,N,1);
end
if nb==1
    b=repmat(b,N,1);
end
if nc==1
    c=repmat(c,N,1);
end

end

