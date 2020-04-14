REM ECHO OFF
ECHO ====================================================================
ECHO Installing Launcher Service with command: %1\LaunchServ.exe -install
ECHO ====================================================================
%1\LaunchServ.exe -install
ECHO ====================================================================
ECHO Starting Launcher Service with command: %1\LaunchServ.exe -start
ECHO ====================================================================
%1\LaunchServ.exe -start
EXIT