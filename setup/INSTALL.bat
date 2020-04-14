ECHO OFF
REM You may bypass the following warning by passing any parameter to this batch script.
IF [%1] NEQ [] GOTO INSTALL ELSE GOTO INSTALL_COUNTDOWN

:CAUTION
ECHO -                                                 
ECHO -                                                 
ECHO -                                                 
ECHO =======================================================================
ECHO =============================== CAUTION ===============================
ECHO -----------------------------------------------------------------------
ECHO -
ECHO If you have not read the comments in this batch file (via a text editor)
ECHO and understood them, please close this console window. If you have read,
ECHO understood, and followed those instructions, please . . .
ECHO -
ECHO -----------------------------------------------------------------------
ECHO =======================================================================
ECHO =======================================================================
ECHO -                                                 
ECHO -                                                 
ECHO -                                                 
PAUSE
GOTO INSTALL

:INSTALL_COUNTDOWN
ECHO -                                                 
ECHO -                                                 
ECHO -                                                 
ECHO =======================================================================
ECHO =============================== INSTALL ===============================
ECHO -----------------------------------------------------------------------
ECHO -
ECHO I will terminate any necessary processes, uninstall any previous setup configuration, then install the configuration for this version of farmComm.
ECHO -
ECHO -----------------------------------------------------------------------
ECHO =======================================================================
ECHO =======================================================================
ECHO -                                                 
ECHO -                                                 
ECHO -                                                 
ECHO PROCEEDING (CLOSE THIS WINDOW TO CANCEL!) . . .
TIMEOUT /T 13
GOTO INSTALL

:INSTALL

REM You may probably need to run this batch at an elevated command prompt.
REM The default setting for this batch is to install farmComm to run as a service, as "NT AUTHORITY\SYSTEM." (The creation of the service is accomplished via a very useful, free tool which can run a program as a service, called LaunchServe.exe.)

REM The installation options are delineated with # signs below. Whichever installation method you'd like to use, "uncomment" the line below the numbered listing for it, by removing the word "REM" (and the space after that) from the start of that line. ("REM" means "Remark," or a line of the batch file which the command interpreter ignores).

REM Also note that you may be able to change the username in quotes after the /RU switch--in the SCHTASKS command, which creates a "Windows Task Scheduler" scheduled task via the command line--you may be able to change that to the username of an account local to the machine (and/or on a domain) by expressing the username as "LOCALCOMPUTERNAME\UsernameWithAdminRights," or for a Domain, "DOMAIN\Username." In those cases, you may need to provide a password, which you can do by adding this switch: /RP "ThePassword."

REM ======================= PREINSTALLATION ITEMS ===========================
REM Uninstillation of any previous setup items may be necessary; call UNINSTALL.bat. If you have never installed farmComm before, you may comment out the following four lines.
START UNINSTALL.bat
CLS
ECHO Please wait for the window which opened to finish its work, then . . .
TIMEOUT /T 15

REM OPTIONAL: Open the following registry settings import file in a text editor to see whether you consider the uncommented items desirable. I sure do.
REG IMPORT farmCommGeneralRegSettings.reg

REM OPTIONAL, can be used with every installation type; not presently pertinent to this toolset . . . Enable Wake On Lan, via a vbscript (doesn't work for every computer):
CTRLWOL.vbs ENABLE
REM ===================== END PREINSTALLATION ITEMS ==========================

REM ===== INSTALLATION OPTIONS -- UNCOMMENT ONLY ONE OF THE BELOW LINES =====

SET CURRDIR=%CD%

REM OPTION #; SYSTEM SERVICE: loads to session 0 (Secure Desktop) to run when users are logged out OR in!
START service\Install-farmCommSysServe.bat %CURRDIR%\service
CLS
ECHO Please wait for the window which opened to finish its work, then . . .
TIMEOUT /T 15

REM OPTION #; SYSTEM AT LOGON: install as a Scheduled Task (in Windows Task Scheduler), which runs at log on of any user as "NT AUTHORITY\SYSTEM":
REM SCHTASKS /CREATE /RU "NT AUTHORITY\SYSTEM" /TN "systemSpawn" /XML "systemSpawn.xml"

REM OPTION #; USER REGISTRY AT LOGON: Registry startup item "USER" install; run at user logon, as the user who logs on: ============
REM REG IMPORT farmCommUserRegStartupItem.reg

REM OPTION #; USER TASK AT LOGON: Task Scheduler "USER" setup option; (same effect as option #3)
REM SCHTASKS /CREATE /RU "YourComputerName\AnAdministrator" /RP "ThatUsersPassword" /TN "systemSpawn" /XML "userSpawn.xml"

REM ===================== END INSTALLATION OPTIONS ===========================