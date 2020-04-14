#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

	;Read text files COMM1.txt, COMM2.txt, and COMM3.txt into variables, then execute the variables as commands (they must be formatted as commands). Why from AutoHotkey and not a batch? A batch pops up on the screen obnoxiously. AutoHotkey can run without showing a console, and spawn "invisible" commands.

	;NOTE: The commands will be prepended with whatever the current directory or %A_WorkingDir% of this script is (or of an executable compiled from this script); the commands must therefore only state the relative path and executable name of that executable which it is desired to invoke. Meaning, if a command should be run from two subfolders down, like so:

	;currency\cpuminer\minerd.exe

	; -- all you need to do is write exactly that in COMM1.txt: currency\cpuminer\minerd.exe, into the first line of COMM1.txt. See COMM1.txt and COMM2.txt for examples.

;Global that controls whether the processes invoked are hidden or not. Set this value to show to show processes, hide to hide them.
whetherHide = hide

;========EXECUTABLE INVOCATION ONE
FileRead, comm1Command, %A_WorkingDir%\localComm\COMM1.txt
	;Get the directory of the executable given in the command; this will be appended to %A_WorkingDir% (the absolute directory in which this script/executable resides).
exeOneDir := comm1Command
stringsplit, exeOneDir, exeOneDir, \,
num = 0
loop, % exeOneDir0
	{
	num += 1
	}
num -= 1
	exeOnePath := exeOneDir%num%
	;For testing:
	;Msgbox, %exeOnePath%
comm1Command = %A_WorkingDir%\%comm1Command%
exeOnePath = %A_WorkingDir%\%exeOnePath%
	;For testing:
	;Msgbox, comm1Command is %comm1Command% AND the working path will be %exeOnePath%
Run, %comm1Command%, %exeOnePath%, %whetherHide% UseErrorLevel, comm1processID

;========EXECUTABLE INVOCATION TWO
FileRead, comm2Command, %A_WorkingDir%\localComm\COMM2.txt
		;Get the executable's directory re the comment above.
exeTwoDir := comm2Command
stringsplit, exeTwoDir, exeTwoDir, \,
num = 0
loop, % exeTwoDir0
	{
	num += 1
	}
num -= 1
	exeTwoPath := exeTwoDir%num%
	;For testing:
	;Msgbox, %exeTwoPath%
comm2Command = %A_WorkingDir%\%comm2Command%
exeTwoPath = %A_WorkingDir%\%exeTwoPath%
	;For testing:
	;Msgbox, comm2Command is %comm2Command% AND the working path will be %exeTwoPath%
Run, %comm2Command%, %exeTwoPath%, %whetherHide% UseErrorLevel, comm2processID

;========EXECUTABLE INVOCATION THREE
FileRead, comm3Command, %A_WorkingDir%\localComm\COMM3.txt
		;Get the executable's directory re the comment above.
exeThreeDir := comm3Command
stringsplit, exeThreeDir, exeThreeDir, \,
num = 0
loop, % exeThreeDir0
	{
	num += 1
	}
num -= 1
	exeThreePath := exeThreeDir%num%
	;For testing:
	;Msgbox, %exeThreePath%
comm3Command = %A_WorkingDir%\%comm3Command%
exeThreePath = %A_WorkingDir%\%exeThreePath%
	;For testing:
	;Msgbox, comm3Command is %comm3Command% AND the working path will be %exeThreePath%
Run, %comm3Command%, %exeThreePath%, %whetherHide% UseErrorLevel, comm3processID

Sleep, 375