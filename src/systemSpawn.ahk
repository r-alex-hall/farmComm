#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
#Persistent

	;Stay out of the way for a while to avoid a clogged load up if launched at system boot or user logon.
Sleep, 23000

CHECK:

Process, Exist, farmComm.exe
farmCommProcID = %ErrorLevel%
if (%ErrorLevel% == 0)	{
	;MsgBox, 0, ErrorLevel value, ErrorLevel is %ErrorLevel% or zero if this is working properly. farmComm not running. Will launch it . . .,5
Run, %A_WorkingDir%\PaExec.exe -s -x -d -i 0 %A_WorkingDir%\farmComm.exe, %A_WorkingDir%, hide UseErrorLevel, farmCommProcessID
Sleep, 3500
						}
else
						{
	;MsgBox, 0, erorlevel != 0, ErrorLevel is %ErrorLevel% or nonzero if this is working properly. farmComm is apparently running. Will do nothing., 5
						}

Sleep, 5000

GOTO, CHECK

;DEVELOPERS: See the DEVELOPER NOTES section of README.md about PaExec usage quirks.