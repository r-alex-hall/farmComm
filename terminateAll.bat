ECHO OFF
REM NOTE: systemSpawnServiceRestart.bat calls this batch with a paramater (it can be anything) to tell it to EXIT at the end (so that the calling batch can invoke this with START /WAIT but then resume control, as the shell this starts will exit.) If on the other hand you don't call this batch from another batch (but execute it by itself on the command line) it will not surprise you with such an EXIT. I hope.
ECHO -
ECHO -
ECHO =======================================================================
ECHO ============= Terminate all farmComm-related processes ================
ECHO -----------------------------------------------------------------------
ECHO -
ECHO . . . . . . . . . . . . . Terminating . . . . . . . . . . . . . . . . .
ECHO -
ECHO -----------------------------------------------------------------------
ECHO =======================================================================
ECHO =======================================================================
ECHO -
ECHO -
ECHO OFF
SET CURRDIR=%CD%
ECHO ON
%CURRDIR%\setup\service\LaunchServ.exe -stop
TIMEOUT /T 2
SC STOP farmComm
TIMEOUT /T 2
Process.exe -k LaunchServ.exe

ECHO OFF
FOR /F "delims=" %%A IN (allProcessesList.txt) DO (
Process.exe -q %%A.exe 2
)
FOR /F "delims=" %%A IN (allProcessesList.txt) DO (
Process.exe -k %%A.exe
)

ECHO Process termination done. If farmComm is installed as a service, and
ECHO you wish to restart it, run systemSpawnServiceRestart.bat.
ECHO OFF
IF [%1] NEQ [] ECHO ========== Variable passed to script, %1%, or paramater 1 is not empty. I will therefore execute the EXIT command . . . ============ && GOTO EXITCMD
GOTO END

:EXITCMD
REM Erase variable 1 so that future runs of this not called from another batch behave as expected.
SET 1=
EXIT

:END