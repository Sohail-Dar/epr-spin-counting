function S = doubleIntegral(fname, sigWin, fitMax, intWin, order)
% Baseline-correct a derivative EPR spectrum and double-integrate it.
%   fname  : text file, two columns (field in G, intensity), one header line
%   sigWin : [lo hi] rows (G) containing signal, excluded from the baseline fit
%   fitMax : baseline fitted only at fields <= fitMax (G)
%   intWin : [lo hi] integration window (G)
%   order  : baseline polynomial order

    if ~isfile(fname), error('File not found: %s', fname); end
    if intWin(2) <= intWin(1), error('intWin must be [low high].'); end

    D = readmatrix(fname,'NumHeaderLines',1);
    D = D(all(isfinite(D),2),:);
    B = D(:,1);  y = D(:,2);

    mask = B <= fitMax;
    for k = 1:size(sigWin,1)
        mask = mask & ~(B >= sigWin(k,1) & B <= sigWin(k,2));
    end
    if nnz(mask) < order + 3
        error('Too few baseline points: widen fitMax or narrow sigWin.');
    end
    [p,~,mu] = polyfit(B(mask), y(mask), order);
    yc = y - polyval(p, B, [], mu);

    sel = B >= intWin(1) & B <= intWin(2);
    Bs  = B(sel);  ys = yc(sel);

    A1raw = cumtrapz(Bs, ys);
    DIraw = trapz(Bs, A1raw);                 % without drift removal
    ramp  = A1raw(end) * (Bs - Bs(1)) / (Bs(end) - Bs(1));
    A1    = A1raw - ramp;                     % absorption forced to zero at window end
    A2    = cumtrapz(Bs, A1);
    DI    = A2(end);

    drift = abs(A1raw(end)) / max(abs(A1raw));
    if drift > 0.2
        warning('doubleIntegral:drift', ...
            ['Drift correction is %.0f%% of the absorption peak. ' ...
             'Baseline or window is probably poor.'], 100*drift);
    end
    fprintf('Drift correction = %.1f%% of peak;  DI = %.4g (uncorrected %.4g)\n', ...
            100*drift, DI, DIraw);

    S = struct('B',B,'y',y,'yc',yc,'Bs',Bs,'A1',A1,'A1raw',A1raw, ...
               'A2',A2,'DI',DI,'DIraw',DIraw,'drift',drift);
end
