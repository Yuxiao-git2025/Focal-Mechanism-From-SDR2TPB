%% Loads
clc;
strike=120;
dip=45;
rake=120;
Result=MEC_AnalFocal(strike,dip,rake); 
MEC_PrintFocalResult(Result);

%% Plots
MEC_PlotBall2D(strike,dip,rake,'full');


%% Tests
% Base focal mechanism
strike0=0;
dip0=45;
rake0=90;
MEC_PlotBall2D(strike0,dip0,rake0,'full');
MEC_PlotBall2DVary(strike0,dip0,rake0);

