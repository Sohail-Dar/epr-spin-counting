%% make_integration_figure.m  -> three-panel integration figure (PNG)
folder   = pwd;
fileSamp = 'sample.asc';
outName  = 'integration_figure.png';
sigWin = [850 3700];  fitMax = 4500;  intWin = [350 3700];  order = 3;

S = doubleIntegral(fullfile(folder,fileSamp), sigWin, fitMax, intWin, order);
fprintf('Double integral = %.4g\n', S.DI);

blue = [0 0.447 0.741];  orange = [0.851 0.325 0.098];
fig = figure('Color','w','Units','inches','Position',[1 1 8 10.5]);
ax1 = subplot(3,1,1); hold on
plot(S.B,S.y,'Color',blue,'LineWidth',1,'DisplayName','raw')
plot(S.B,S.yc,'Color',orange,'LineWidth',1,'DisplayName','baseline-corrected')
xline(intWin,'r--','HandleVisibility','off'); xlim([0 7000])
ylabel('dI/dB'); title('Derivative spectrum'); legend('Location','northeast')
ax2 = subplot(3,1,2); hold on
plot(S.Bs,S.A1,'Color',blue,'LineWidth',1.2); yline(0,'k:','HandleVisibility','off')
xlim([0 4000]); ylabel('absorption')
ax3 = subplot(3,1,3);
plot(S.Bs,S.A2,'Color',blue,'LineWidth',1.2); xlim([0 4000])
ylabel('2nd integral'); xlabel('B / G')
set([ax1 ax2 ax3],'Box','on','TickDir','in','Layer','top','XMinorTick','off','LineWidth',1)
exportgraphics(fig, outName, 'Resolution', 300)
