%% scan_baseline2.m - sensitivity of the double integral to baseline order and window end
folder = pwd;  file = 'sample.asc';
sigWin = [850 3700];  fitMax = 4500;
orders = [1 2 3];     ends = [3500 3700 4000];

DI = nan(numel(orders), numel(ends));  dr = DI;
for i = 1:numel(orders)
    for j = 1:numel(ends)
        S = doubleIntegral(fullfile(folder,file), sigWin, fitMax, [350 ends(j)], orders(i));
        DI(i,j) = S.DI;  dr(i,j) = S.drift;
    end
end
disp('Double integral (rows: order 1,2,3; columns: window ends)'); disp(DI)
disp('Drift fraction'); disp(dr)
fprintf('Spread = %.0f%% of the mean\n', 100*(max(DI(:))-min(DI(:)))/mean(DI(:)));
