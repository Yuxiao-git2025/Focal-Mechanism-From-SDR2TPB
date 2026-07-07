% =========================================================================
% XA.,Yu (2026/07/07)
% In this function, we wrote a method to obtain the T/P/B axis from the
% source parameter S/D/R, combined with Zhang's codes for determining the
% maximum horizontal principal stress (Lund 2007). The R value was not
% inverted here, as it would require additional mechanism solutions to
% complete
% =========================================================================
% Input:
%   strike - fault strike in degrees, clockwise from North
%   dip    - fault dip in degrees, positive downward
%   rake   - rake angle in degrees, measured in the fault plane
% Theory:
%   For a double-couple source, the principal axes are obtained from
%   the fault normal vector n and slip vector s:
%
%       T || n+s
%       P || n-s
%       B || n x s
%
%   In this program, vectors are first computed in the NEU coordinate
%   system, where N is North, E is East, and U is Up. The output axes
%   are represented as [value,plunge,azimuth], where plunge is positive
%   downward and azimuth is clockwise from North.
%
%   Mechanism classification follows the common P/T/B plunge-based
%   style used in World Stress Map and Zoback-type descriptions.
%
%   SH is estimated using the Lund and Townend (2007) horizontal
%   stress projection method. Here P,T,B axes are used as approximate
%   principal stress directions:
%
%       sigma1 ~ P axis
%       sigma2 ~ B axis
%       sigma3 ~ T axis
%
%   The stress ratio R is set to 0.5 by default because a single focal
%   mechanism cannot uniquely determine the regional stress ratio
% =========================================================================
function Result=MEC_AnalFocal(strike,dip,rake)
% >> Parameter checking
narginchk(3,3);
MEC_CheckSDR(strike,dip,rake);

% >> T/P/B Axis in VPA and NEU
[t,p,b,tvec,pvec,bvec]=MEC_SDR2TPB(strike,dip,rake);

% >> Find AuxPlane
plane2=MEC_AuxPlane(strike,dip,rake);    % Method-1
% plane2=MEC_AuxPlane2(strike,dip,rake);  % Method-2

% >> Stress Ratio
R=MEC_StressRatio(pvec,tvec,bvec);       % R=0.5

% >> Maximum horizontal principal stress (SH)
S1=MEC_VPA2NED(p);
S2=MEC_VPA2NED(b);
S3=MEC_VPA2NED(t);                                      
SH=MEC_CalculateSHmax(S1,S2,S3,R);
if SH==-999
    sh=-999;
else
    sh=mod(SH+90,180);
end

% >> Classification and info
[class]=MEC_ClassifyMechanism(-p(2),-t(2),-b(2));       % based plunge(-)
info=MEC_DynamicsInterpretation(class,rake,dip,SH);     % some information
% amb=MEC_FaultPlaneAmbiguity([strike,dip,rake],plane2,-p(2),-t(2));

% >> Results Save
Result=struct();
Result.plane1=[strike,dip,rake];
Result.plane2=plane2;
Result.Taxis=t;
Result.Paxis=p;
Result.Baxis=b;
Result.Tvec=tvec;
Result.Pvec=pvec;
Result.Bvec=bvec;
Result.class=class;
Result.SH=SH;
Result.sh=sh;
Result.StressRatio=R;
if exist('info','var') 
    Result.info=info;
end
if exist('amb','var') 
    Result.amb=amb;
end
% fprintf('#      Calculation Finished \n');
end
