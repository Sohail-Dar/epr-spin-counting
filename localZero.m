function Bz = localZero(B, y, lo, hi)
% Field of the first zero crossing of y between lo and hi (linear interpolation).
    m  = B >= lo & B <= hi;
    Bm = B(m);  ym = y(m);
    i  = find(diff(sign(ym)) ~= 0);
    if isempty(i), Bz = NaN; return; end
    i  = i(1);
    Bz = Bm(i) - ym(i) * (Bm(i+1)-Bm(i)) / (ym(i+1)-ym(i));
end
