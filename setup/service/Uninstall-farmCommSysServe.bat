REM ECHO OFF
ECHO ====================================================================
ECHO Stopping Launcher Service with command: %1\LaunchServ.exe -stop
ECHO ====================================================================
%1%\LaunchServ.exe -stop
ECHO ====================================================================
ECHO Uninstalling Launcher Service with command: %1\LaunchServ.exe -uninstall
ECHO ====================================================================
%1%\LaunchServ.exe -uninstall
ECHO The work of this batch is done, will automatically exit in . . .
TIMEOUT /T 15
EXIT