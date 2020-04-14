REM ECHO WARNING: This script will erase and recreate any ahk-generated .exe files in this directory! If you understand this and wish to have it do so, comment out (with REM) the line in this batch file which produces this warning, and the two lines that follow it.
REM PAUSE
REM GOTO END

SET CURRDIR=%CD%
SET CURRDRIVE=%cd:~0,2%
SET WINROOT=%WINDIR:~0,2%
SET SYS64PROGSFOLDER=%ProgramFiles%
REM SYS64PROGSFOLDER will be automatically redirected by Windows 7 to the (x86) program files directory, if necessary. Except that it won't always.
	REM ECHO CURRDIR IS %CURRDIR%
	REM ECHO CURRDRIVE IS %CURRDRIVE%
	REM ECHO WINROOT IS %WINROOT%
	REM ECHO SYS64PROGSFOLDER IS %SYS64PROGSFOLDER%
	REM PAUSE

REM DEL %CURRDIR%\%1.exe
%WINROOT%

REM STANDARD AHK OPTION:
SET EXEDIR=%SYS64PROGSFOLDER%\AutoHotkey\Compiler

REM IRONAHK OPTION (I HAVE NOT GOTTEN THIS TO PRODUCE WORKING EXECUTABLES):
REM SET EXEDIR=%SYS64PROGSFOLDER%\IronAHK

CD %EXEDIR%

REM STANDARD AHK OPTION:
Ahk2exe.exe /in %CURRDIR%\%1.ahk /out %CURRDIR%\%1.exe /icon %CURRDIR%\iconConverter\networksettings.ico

REM IRONAHK COMPILE OPTION:
REM ironahk /out %CURRDIR%\%1.exe %CURRDIR%\%1.ahk

REM Re http://maul-esel.github.io/ahkbook/en/Compiling.html

GOTO END

:END

REM if you call this batch via START, uncomment the following line:
REM EXIT

REM For password protection, append:
REM password /pass 0X2024&VdXeZJ@32r90^qd&QcbX%AJeI4i7FM@N4U^&gbiVmZ7T6x0NEvIwdU&f& password

REM To prevent decompilation, append: /NoDecompile
