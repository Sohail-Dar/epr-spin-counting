%% spin_count.m  - relative spin counting of derivative EPR spectra
% Run from the folder that holds your data. Edit sections 0-2 (and 6 for a reference).
clear; clc; close all
folder = pwd;

%% 0) Files ----------------------------------------------------------
fileSamp = 'sample.asc';
fileRef  = '';            % optional reference spectrum, e.g. 'reference.asc'

%% 1) Instrument settings of the SAMPLE (from the .par file) ----------
nu = 9.38e9;   % Hz   (MF)
G  = 200;      % receiver gain, linear (RRG)
Bm = 10;       % modulation amplitude / G (RMA)
P  = 0.1;      % microwave power / mW (MP)
nS = 1;        % number of scans
T  = 7;        % K

%% 2) Baseline and integration (G) - check on the plots ---------------
sigWin = [850 3700];   % signal region, excluded from baseline fit
fitMax = 4500;         % baseline fitted only below this field
intWin = [350 3700];   % double-integration window
order  = 3;            % baseline polynomial order

%% 3) Process the sample ----------------------------------------------
S = doubleIntegral(fullfile(folder,fileSamp), sigWin, fitMax, intWin, order);
fprintf('Sample double integral = %.4g (arb. units)\n', S.DI);

%% 4) g values of the main features ------------------------------------
ys = smoothdata(S.yc, 'movmean', 5);
gf = @(Bx) nu ./ (1.399624e6 * Bx);
B1 = localZero(S.B, ys, 1000, 1300);
B2 = localZero(S.B, ys, 3050, 3250);
fprintf('Zero crossing %.0f G -> g = %.2f\n', B1, gf(B1));
fprintf('Zero crossing %.0f G -> g = %.2f\n', B2, gf(B2));

%% 5) Diagnostic plots -------------------------------------------------
figure('Color','w')
ax1 = subplot(3,1,1); plot(S.B,S.y,S.B,S.yc); legend('raw','baseline-corrected');
ylabel('dI/dB'); title('Derivative spectrum'); xline(intWin,'r--','HandleVisibility','off');
ax2 = subplot(3,1,2); plot(S.Bs,S.A1); ylabel('absorption'); yline(0,'k:','HandleVisibility','off');
ax3 = subplot(3,1,3); plot(S.Bs,S.A2); ylabel('2nd integral'); xlabel('B / G');
set([ax1 ax2 ax3],'Box','on','TickDir','in','Layer','top');

%% 6) Reference (optional) ---------------------------------------------
ref.G = NaN; ref.Bm = NaN; ref.P = NaN; ref.nS = NaN; ref.T = NaN;
ref.conc = NaN;            % reference concentration (mM)
avg = true;                % true: spectrometer averages scans; false: it sums them

if ~isempty(fileRef)
    R = doubleIntegral(fullfile(folder,fileRef), sigWin, fitMax, intWin, order);
    nsS = nS; nsR = ref.nS; if avg, nsS = 1; nsR = 1; end
    normS = S.DI/(G*Bm*sqrt(P)*nsS);
    normR = R.DI/(ref.G*ref.Bm*sqrt(ref.P)*nsR);
    ratio = (normS/normR) * (T/ref.T);
    fprintf('Intensity ratio sample/reference = %.3f\n', ratio);
    fprintf('Sample concentration = %.3g mM (assumes equal volume, same species and line shape)\n', ratio*ref.conc);
else
    disp('No reference set: only the double integral was computed.');
end
