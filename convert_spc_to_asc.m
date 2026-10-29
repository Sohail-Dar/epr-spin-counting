%% convert_spc_to_asc.m
% Convert a Bruker ESP binary .spc file (little-endian float32) to a two-column text file.
% Edit the five lines below, then run from the folder holding the data.
pattern = '*.spc';      % file name or pattern in the current folder
npts    = 2048;         % RES in the .par file
Bstart  = 350;          % GST in the .par file (G)
Bsweep  = 6000;         % GSI in the .par file (G)
outName = 'converted.asc';

d = dir(pattern);
assert(~isempty(d), 'No file matching %s in %s', pattern, pwd)
fn = d(1).name;  fprintf('Using file: "%s"\n', fn)

fid = fopen(fn,'r','ieee-le');
y = fread(fid,npts,'float32');  fclose(fid);
B = linspace(Bstart, Bstart+Bsweep, npts)';

fid = fopen(outName,'w');
fprintf(fid,'X [G]\tIntensity\n');
fprintf(fid,'%.6f\t%.6f\n',[B y]');
fclose(fid);
fprintf('Max %.4f, min %.4f  (compare with MAX/MIN in the .par file)\n', max(y), min(y))
