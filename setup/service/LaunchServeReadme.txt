Launcher Service for Windows 2000/XP
------------------------------------
Copyright (C) 2005  Ernesto Villarroel Zapata 
		    NeToSoft (http://emutastic.emulation64.com/netosoft)

README FILE
-----------

0. Contents
------------
1. Introduction and description
2. Copyright
3. Requirements
4. Release History
5. Current features
6. How to setup/install/uninstall the service
7. Command line arguments
8. TODO
9. Acknowledgements
10. Contact Information


1. Introduction and description
-------------------------------

Launcher Service lets you run any program as a Windows Service. When executed as a
service, a program runs earlier at Windows startup, even before a user has logged on;
it isn't closed if a user ends the session, and can run silently in the background.

This service is ideal for command-line (and any other type) of programs that need to
run in the background with minimal user intervention; and don't have service features
implemented.

Launcher Service has several unique features to control how programs can run. It can:

- Restart a program if it crashes, or when the computer enters in hibernation state.
- Close the program nicely if the user stops the service.
- Keep it closed when the Internet connection is down (especially useful for p2p
  daemon programs).
- Run the program only if the user hasn't opened it before.
- Delete *.tmp files in the program's working folder that may prevent it from
  starting.

and more (read the features section below for details). 


2. Copyright
------------
This program is free software; you can redistribute it and/or modify it under 
the terms of the GNU General Public License as published by the Free Software 
Foundation; either version 2 of the License, or (at your option) any later 
version.

See the License.txt file for more details.


3. Requirements
---------------

* Launcher Service can only run on NT based Operative Systems (Windows 2000/XP, hasn't
  been tested with Windows 2003/Vista although it should work on those OSes).
* The service installation may require an Administrator account, especially if Desktop
  Interaction is to be used.


4. Release History
------------------

* 08/23/2005 Version 0.2
  - New Feature: An external program can be launched when the service is started/
                 stopped.
  - New Feature: The launched program won't be restarted if it wasn't alive for at
                 least RestartTimeMin seconds.
  - Bug Fix: The 'net start' command wasn't working correctly on some situations.
  - Bug Fix: The Service status is now correctly updated on failure.
  - Bug Fix: The delete commands weren't working in v0.1

* 08/01/2005 Version 0.1
  - Initial Release.


5. Current features
-------------------

* The service can keep track on the program's execution:
  - If the program closes, the service will stop
  - If the program crashes and ends unexpectly, the service will restart it.
  - If the user stops the service, the program will be closed nicely.
  - If the program ran only for a small amount of time, the service will be stopped
    and the user will be informed of the issue. The time interval can be set
    accordingly.

* The service can stop/start the program if internet connection goes down/up
  respectively.

* The program can be stopped/started when entering or resuming from a hibernation
  state. 

* Stop And Run Mode: If enabled, the service will leave the program running and stop
  itself, with no more checks being done. (the service will act strictly as a
  launcher.)

* The service can check if there is another instance of the program already running.
  If so, the program won't be started to avoid any possible conflicts.

* Desktop Interaction: The service can run the program in interactive mode, meaning
  that it can display a gui in the current's user session.

* A friendly name and a description can be set for the service depending on the
  program that is to be run. A startup folder different from the program's path can
  also be set.

* Another external program can be set to run before the "launched program" executes as
  a service, or before it is stopped. This could be useful, for example, if you want
  to run a configuration script before the program is launched, or if you need to send
  special commands before it closes.

  - Note: The external program should be a bat file, or a console program.
	  If the external program has a GUI it won't be shown to the user.

* The service can delete *.tmp files from the program's startup folder before running
  it.

* As a special feature, *.pid files can also be deleted from the program's folder.
  Maybe someone else besides myself can find a use on this one.

* The Settings explained above can be set editing a simple *.ini file.

* Theorically, more than one program can be run as a service using Service Launcher.
  To do so:

  - Keep several copies of the Service Launcher executable (ServLaunch.exe) and its
    settings file (ServLaunch.ini) on different folders, one copy for each program to
    be run.
  - You can then edit each settings file accordingly and install each service (setup
    instructions are in the next section). 
  - Just make sure to set different names and descriptions for each program, as that's
    the only way you and the Windows's Service Manager can differentiate one Launcher
    Service from the other.

* In my humble opinion, the best feature of all: this Service is released under 
  the GNU GPL so you can modify it as you need. If you implement some nice feature or
  fix a bug, be sure to contact me to add it to the next official release.


6. How to setup/install/uninstall the service
---------------------------------------------

* Setup:

  - Extract/copy the ServLaunch.exe, ServLaunch.ini, and the two .bat files to a
    folder of your choice. (Doesn't need to be in the folder of the program you want
    to launch).
  - Open the ServLaunch.ini file in a text editor. This is the settings file.
  - Here's a brief description on what each line of the settings file means:

	Name		-> The name you want to give to the new service.
	Description	-> A description for the new service.
	Executable	-> The full path of the program you want to launch.
	WorkDir		-> The startup folder for the program.
	RestartTimeMin	-> The minimum amount of time the program is expected to run
			   without exiting. If the program stays alive for less than
			   this amount of time, the service won't restart it, even if
			   it crashed.

	ExecAtStart	-> Path of a program to be run when the service is started.
	ExecAtStop	-> Path of a program to be run when the service is stopped.
	ExecTimeMax	-> How long to wait for the external program before the
			   service is started/stopped.

	CheckInternet	-> Start/Stop the program if the Internet connection state
			   changes.
	CheckHibernation-> Start/Stop the program when entering/resuming from
			   hibernation.
	StopAndRun	-> Run the Service in Stop and Run mode.
	CleanTmp	-> Delete *.tmp files from the startup folder
	SingleInstance	-> Run only a single instance of the program.
	Interactive	-> Enable Desktop Interaction
	Special1	-> Delete *.pid files from the startup folder
  
  - A typical settings file will look like:

        Name = Launcher Service
        Description = Launcher Service runs a program as a Windows Service.
        Executable = z:\dir1\anything.exe
        WorkDir = ""
	RestartTimeMin = 30

	ExecAtStart = ""	
	ExecAtStop = ""
	ExecTimeMax = 20

        CheckInternet = 1
        CheckHibernation = 1
        StopAndRun = 0
        CleanTmp = 0
        SingleInstance = 0
        Interactive = 0
        Special1 = 0
   
   With the exception of 'Executable', those are the default values in case you
   omit a line (only Executable is mandatory).
 
 - The ServLaunch.ini file included with this version comes already setup for
   MLDonkey (tested on v2.6.0). You only need to change the 'Executable' and
   'WorkDir' fields.

   Why MLDonkey? That is the sole reason that pushed me into making Service Launcher.
   The ability of closing it nicely and restarting it accordingly in Windows was a
   must. 


* Install:
  
  - To install the service, run the included "Install Service.bat" file, or type
    "LaunchServ.exe -install" in a command prompt.
  - You can run "services.msc" to make sure the service was correctly installed.
  - The service must be running and set to automatic in order to work as intended.

* Uninstall:
  
  - To uninstall, run the included "Uninstall Service.bat" file, or type
    "LaunchServ.exe -uninstall" in a command prompt.
  - You may need to restart the computer to complete the uninstall process.


7. Command line arguments
-------------------------

The service supports the following command line arguments:

-install
-uninstall
-start
-stop

I hope they are self-explanatory.


8. TODO
-------

* Add a logging system. This is required as there is no other way to describe any
  possible errors (and considering external programs are being launched, a lot of
  thing could go wrong).
* Attempt to implement Desktop Interaction in a more secure way. Programs should be
  launched in the context of the current user if interaction is needed.


9. Acknowledgements
-------------------

-I would like to thank Nishant Sivakumar for his service guide at
 http://www.codeproject.com/system/serviceskeleton.asp as it's a great resource to
 understand and create a basic service.

-MLDonkey. Check http://mldonkey.berlios.de/ for the official community page.

-Finally, thanks to the folks at http://www.ubuntuforums.org as it's a great community
 to share information and ask questions such as the one that gave the idea for the
 base of this program (a windows service skeleton with hibernation support).


10. Contact Information
----------------------

Homepage: http://emutastic.emulation64.com/netosoft
e-Mail: villapancho@email.com

If you have questions or comments you can write at the NeToSoft forums located at:
http://emutastic.emulation64.com/forum/index.php?a=forum&f=42
