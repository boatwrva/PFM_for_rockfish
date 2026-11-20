"""
check_forcing_inputs.py

Prints what ROMS will care about in your existing LV4 input files, so you can
set boat_model_info_devel.py correctly before submitting anything:

  * grid:      xi_rho / eta_rho  ->  Lm, Mm for the .in file
  * any file:  s_rho (Nz) and theta_s, theta_b, Tcline, hc if stored
  * any file:  every *time variable: units, number of records, first/last value

Usage (activate the grib2io venv first, it has netCDF4):
    python check_forcing_inputs.py GRID.nc BC.nc IC.nc river.nc atm/*.nc ...
"""
import sys
import glob
import netCDF4 as nc

SCALARS = ["theta_s", "theta_b", "Tcline", "hc"]


def is_time_var(name, var):
    return name.endswith("time") or name == "ocean_time" or "time" in name.lower() and var.ndim == 1


def describe(path):
    print("=" * 78)
    print(path)
    ds = nc.Dataset(path)
    d = ds.dimensions
    for k in ("xi_rho", "eta_rho", "s_rho"):
        if k in d:
            print(f"  dim {k} = {len(d[k])}")
    if "xi_rho" in d and "eta_rho" in d:
        print(f"  -> Lm = {len(d['xi_rho']) - 2}, Mm = {len(d['eta_rho']) - 2}")
    for s in SCALARS:
        if s in ds.variables:
            print(f"  {s} = {ds.variables[s][:]}")
    for name, var in ds.variables.items():
        if var.ndim == 1 and is_time_var(name, var) and len(var) > 0:
            vals = var[:]
            units = getattr(var, "units", "(no units attribute)")
            print(f"  {name:28s} n={len(vals):6d}  first={float(vals[0]):.4f}  "
                  f"last={float(vals[-1]):.4f}  units={units}")
    ds.close()


if __name__ == "__main__":
    paths = []
    for arg in sys.argv[1:]:
        paths.extend(sorted(glob.glob(arg)) or [arg])
    if not paths:
        print(__doc__)
        sys.exit(1)
    for p in paths:
        try:
            describe(p)
        except Exception as e:
            print(f"could not read {p}: {e}")