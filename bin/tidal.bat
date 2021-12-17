@ECHO OFF

REM Store the directory containing the script in a variable
SET "source=%~dp0"

REM Get path to vim-tidal bootfile
SET "TIDAL_BOOT_PATH=%SOURCE%\..\Tidal.ghci"

REM Launch Tidal Cycles
ghci -ghci-script "%TIDAL_BOOT_PATH%"