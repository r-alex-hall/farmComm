ECHO OFF

REM COPY _temp\*.txt ..\
REM (Those had been some text files used in development.)

SET CURRDIR=%CD%
SET CURRDRIVE=%cd:~0,2%

REM REBUILD TARGETS
ECHO OFF
FOR %%A IN (%CURRDIR%\*.ahk) DO (
ahkrip.bat %%~nA
%CURRDRIVE%
CD %CURRDIR%
MOVE /Y %CURRDIR%\%%~nA.exe ..\
)