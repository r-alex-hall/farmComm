ECHO OFF
ECHO -                                                 
ECHO -                                                 
ECHO -                                                 
ECHO =======================================================================
ECHO ================== Restart farmComm SYSTEM service ====================
ECHO -----------------------------------------------------------------------
ECHO -
ECHO  . . . . . . . . . . . . . . Restarting . . . . . . . . . . . . . . . .
ECHO -
ECHO -----------------------------------------------------------------------
ECHO =======================================================================
ECHO =======================================================================
ECHO -                                                 
ECHO -                                                 
ECHO -  
ECHO Attempting stop of farmComm SYSTEM service . . .
START /WAIT SC STOP farmComm
ECHO Terminating all associated processes . . .
START /WAIT terminateAll.bat 1
ECHO Starting farmComm SYSTEM service again . . .
START /WAIT SC START farmComm
ECHO Done.