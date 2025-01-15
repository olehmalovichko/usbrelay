* Logging to a text file
* Example
* WriteToLog("Program started", "application_log.txt", 500000)  && 500 KB
* WriteToLog("User logged in", "application_log.txt")
* WriteToLog("Test")

PROCEDURE WriteToLog
    LPARAMETERS cLogMessage, cLogFile, nMaxSize
    * Parameters:
    * cLogMessage - the text message to be added to the log.
    * cLogFile - the path to the log file (e.g., "log.txt").
    * nMaxSize - the maximum size of the log file in bytes (default is 1 MB).

    * Default values
    IF EMPTY(cLogFile)
        cLogFile = "log.txt" && Default log file
    ENDIF

    IF EMPTY(nMaxSize)
        nMaxSize = 1048576 && 1 MB
    ENDIF

    * Create an entry with a timestamp for the log
    cLogEntry = TTOC(DATETIME()) + " - " + cLogMessage + CHR(13) + CHR(10)

    * Check the file size using ADIR()
    LOCAL aFileInfo[1]
    LOCAL nFileSize
    nFileSize = 0

    IF FILE(cLogFile)
        =ADIR(aFileInfo, cLogFile)
        nFileSize = aFileInfo[1, 2]  && File size in bytes
    ENDIF

    * Perform rotation if the file size exceeds the specified limit
    IF nFileSize > nMaxSize
        * Delete the previous backup file if it exists
        IF FILE("log_backup.txt")
            ERASE "log_backup.txt"
        ENDIF

        * Rename the current log file to a backup
        RENAME (cLogFile) TO "log_backup.txt"
    ENDIF

    * Add a new entry to the log file
    STRTOFILE(cLogEntry, cLogFile, .T.)
ENDPROC
