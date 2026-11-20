#!/bin/bash
# setup_expanse_dirs.sh
#
# Builds the PFM-style directory tree on Expanse for a HINDCAST that reuses
# existing forcing files (no atm / hycom / river downloads).
# It mirrors the layout built in sdpm_py_util/boat_model_info_devel.py:
#   pfm_dir/{executables,grids,restart_data,LV4/{Run,His,Forc,Plots}}
#
# Safe to re-run: mkdir -p and ln -sfn are idempotent, and nothing is copied
# or deleted. Existing forcing files are SYMLINKED, not duplicated.
#
# Usage:
#   bash setup_expanse_dirs.sh
#   LEVELS="LV1 LV2 LV3 LV4" bash setup_expanse_dirs.sh   # if you ever need other levels
#   OUT_ROOT=/expanse/lustre/scratch/$USER/temp_project/PFM_out bash setup_expanse_dirs.sh

set -uo pipefail

# ----------------------------- EDIT THESE ----------------------------------
BASE=/expanse/lustre/projects/sdu151/vboatwright/boat_roms
PFM_ROOT=$BASE/PFM_dir                       # parent of simulations/ and model_forcing/
FORCING_SRC=$BASE/Forcing/LPL_LV4            # where your existing forcing files live
GRID_NAME=GRID_LV4_Bdem_r020_6river_hplus.nc # grid file name used in model_info (LPL branch)
LEVELS="${LEVELS:-LV4}"                      # levels to build folders for
# Optional: put big His/ output somewhere else (e.g. scratch). Leave empty to keep it in SIM.
OUT_ROOT="${OUT_ROOT:-}"
# Optional: path to a compiled executable to link into executables/
EXE_SRC="${EXE_SRC:-}"
# ---------------------------------------------------------------------------

SIM=$PFM_ROOT/simulations                    # = pfm_dir in the python code
MODEL_FORCING=$PFM_ROOT/model_forcing        # = forcing_dir in the python code
ECB_FORC=$BASE/Forcing/LPL_LV4_ECB           # NEW bgc files go here (originals stay untouched)

warn() { echo "WARNING: $*" >&2; }

link_if_exists() {   # link_if_exists <source> <link_path>
    if [ -e "$1" ]; then
        ln -sfn "$1" "$2"
        echo "  linked  $2 -> $1"
    else
        warn "missing source, not linked: $1"
    fi
}

echo "== Top-level folders =="
mkdir -p "$SIM/executables" "$SIM/grids" "$SIM/restart_data"
mkdir -p "$MODEL_FORCING" "$PFM_ROOT/slurm_logs" "$ECB_FORC"

echo "== Per-level folders: $LEVELS =="
for LV in $LEVELS; do
    mkdir -p "$SIM/$LV/Run" "$SIM/$LV/Forc" "$SIM/$LV/Plots"
    if [ -n "$OUT_ROOT" ]; then
        mkdir -p "$OUT_ROOT/$LV/His"
        ln -sfn "$OUT_ROOT/$LV/His" "$SIM/$LV/His"
    else
        mkdir -p "$SIM/$LV/His"
    fi
    echo "  built $SIM/$LV/{Run,His,Forc,Plots}"
done

echo "== Link existing LV4 forcing into LV4/Forc =="
# keep a single pointer to the source folder, handy for the python code
ln -sfn "$FORCING_SRC" "$MODEL_FORCING/LPL_LV4"

FILES=(
    BC_LV4_LPL_20190526_20200930_dye.nc
    BC_LV4_LPL_20192020_hp01.nc
    IC_LV4_LPL_20190601_hplus.nc
    ocean_clm_LPL_20200930.nc
    ocean_nudcoef_LPL_10day.nc
    river_6river_utc_20190601_20201001.nc
)
DIRS=( atm river swan )

for f in "${FILES[@]}"; do link_if_exists "$FORCING_SRC/$f" "$SIM/LV4/Forc/$f"; done
for d in "${DIRS[@]}";  do link_if_exists "$FORCING_SRC/$d" "$SIM/LV4/Forc/$d"; done

echo "== Grid file =="
if [ -e "$FORCING_SRC/$GRID_NAME" ]; then
    FOUND="$FORCING_SRC/$GRID_NAME"
else
    FOUND=$(find "$BASE" -maxdepth 4 -name "$GRID_NAME" -print -quit 2>/dev/null)
fi
if [ -n "${FOUND:-}" ]; then
    link_if_exists "$FOUND" "$SIM/grids/$GRID_NAME"
else
    warn "$GRID_NAME not found under $BASE. Copy it into $SIM/grids/ yourself."
fi

echo "== Executable =="
if [ -n "$EXE_SRC" ]; then
    link_if_exists "$EXE_SRC" "$SIM/executables/$(basename "$EXE_SRC")"
else
    echo "  (EXE_SRC not set; put your compiled ROMS/COAWST binary in $SIM/executables/)"
fi

echo
echo "== Done. Summary =="
echo "pfm_dir          = $SIM/"
echo "forcing_dir      = $MODEL_FORCING/"
echo "new BGC files in = $ECB_FORC/   (write modified BC/river/IC copies here)"
echo
ls -l "$SIM/LV4" "$SIM/LV4/Forc" 2>/dev/null