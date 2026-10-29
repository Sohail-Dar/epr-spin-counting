# epr-spin-counting

MATLAB scripts to baseline-correct and double-integrate derivative (first-harmonic) cw-EPR spectra, and to compare the intensity of a sample with a reference of known concentration.

Developed for high-spin Fe(III) porphyrin spectra (g ~ 6 and g ~ 2) recorded at 7 K on a Bruker X-band spectrometer. Tested with MATLAB R2025a.

## Files

| File | Purpose |
|---|---|
| `convert_spc_to_asc.m` | Convert a Bruker ESP binary `.spc` file (little-endian float32) to a two-column text file |
| `doubleIntegral.m` | Polynomial baseline fit, first and second integral, drift diagnostic |
| `localZero.m` | Zero-crossing field, used for g values |
| `spin_count.m` | Main script: integrate a sample, optionally compare with a reference |
| `scan_baseline2.m` | Sensitivity of the double integral to baseline order and window end |
| `make_integration_figure.m` | Three-panel figure (spectrum, absorption, second integral) |

## Usage

1. Put your spectra (text files with a header line, then field in G and intensity) in a working folder. Data files are not included in this repository.
2. Open MATLAB in that folder and add the repository folder to the path (`addpath('path/to/epr-spin-counting')`).
3. Edit the settings in `spin_count.m` (file names, frequency, gain, modulation, power, scans, temperature) and run it.

The baseline is a polynomial fitted outside the signal region (`sigWin`); the double integral is taken over `intWin` after the absorption curve is forced back to zero at the window end. The printed drift correction should be small (a few percent); a large value means the baseline or window is poor. Check the spread with `scan_baseline2.m` before trusting a number.

## Concentration from a reference

Intensities are normalised by gain x modulation amplitude x sqrt(microwave power) (x scans if the spectrometer sums them), multiplied by temperature (Curie law), and compared with the reference of known concentration. This gives a **relative** concentration only.

## Assumptions and limitations

- Scans are averaged by the spectrometer (set `avg = false` if they are summed).
- Neither spectrum is power-saturated (the sqrt(P) scaling would then fail).
- Sample and reference have similar line shapes and the same volume and tube position; otherwise an anisotropy (effective-spin) correction is needed.
- Spectra recorded in different sessions can differ by 10-20% in intensity.
- The reference is assumed to be fully EPR-active at its nominal concentration.
