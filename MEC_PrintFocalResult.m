function MEC_PrintFocalResult(Result)
% Print focal mechanism analysis result
fprintf('\n%s\n',repmat('=',1,50));
fprintf('            Focal Mechanism Analysis\n');
fprintf('%s\n',repmat('=',1,50));

fprintf('\n[Nodal Planes]\n');
% fprintf('%s\n',repmat('-',1,50));
fprintf('Plane 1: strike=%6.1f   dip=%5.1f   rake=%7.1f \n',Result.plane1(1),Result.plane1(2),Result.plane1(3));
fprintf('Plane 2: strike=%6.1f   dip=%5.1f   rake=%7.1f \n',Result.plane2(1),Result.plane2(2),Result.plane2(3));

fprintf('\n[Principal Axes]\n');
% fprintf('%s\n',repmat('-',1,50));
fprintf('T axis: value=%4.1f  plunge=%5.1f   azimuth=%6.1f \n',Result.Taxis(1),Result.Taxis(2),Result.Taxis(3));
fprintf('P axis: value=%4.1f  plunge=%5.1f   azimuth=%6.1f \n',Result.Paxis(1),Result.Paxis(2),Result.Paxis(3));
fprintf('B axis: value=%4.1f  plunge=%5.1f   azimuth=%6.1f \n',Result.Baxis(1),Result.Baxis(2),Result.Baxis(3));

fprintf('\n[Stress Field]\n');
% fprintf('%s\n',repmat('-',1,50));
fprintf('Mechanism type: %s\n',Result.class);

if Result.SH~=-999
    fprintf('SHmax: %.1f deg clockwise from North\n',Result.SH);
    fprintf('Shmin: %.1f deg clockwise from North\n',Result.sh);
else
    fprintf('SHmax: undefined\n');
end


end
