#!/usr/bin/env bash
set -euf -o pipefail

GHCI=${GHCI:-"ghci"}
TIDAL_DATA_DIR=$($GHCI -e Paths_tidal.getDataDir | sed 's/"//g')
TIDAL_BOOT_PATH=${TIDAL_BOOT_PATH:-"$TIDAL_DATA_DIR/BootTidal.hs"}

# Run GHCI and load Tidal bootstrap file
$GHCI -ghci-script $TIDAL_BOOT_PATH "$@"
