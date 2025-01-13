
* ������� ���� � ��������� ����
* �������
* WriteToLog("������� ������ ��������", "application_log.txt", 500000)  && 500 KB
* WriteToLog("���������� ������ � �������", "application_log.txt")
* WriteToLog("����")

PROCEDURE WriteToLog
    LPARAMETERS cLogMessage, cLogFile, nMaxSize
    * ���������:
    * cLogMessage - ����� �����������, ��� ������� ������ �� ����.
    * cLogFile - ���� �� ����� ���� (���������, "log.txt").
    * nMaxSize - ������������ ����� ����� ���� � ������ (�� ������������� 1 MB).

    * �������� �� �������������
    IF EMPTY(cLogFile)
        cLogFile = "log.txt" && ���� ���� �� �������������
    ENDIF

    IF EMPTY(nMaxSize)
        nMaxSize = 1048576 && 1 MB
    ENDIF

    * ������� ����� ��� ������ � ��������� ����
    cLogEntry = TTOC(DATETIME()) + " - " + cLogMessage + CHR(13) + CHR(10)

    * ���������� ����� ����� �� ��������� ADIR()
    LOCAL aFileInfo[1]
    LOCAL nFileSize
    nFileSize = 0

    IF FILE(cLogFile)
        =ADIR(aFileInfo, cLogFile)
        nFileSize = aFileInfo[1, 2]  && ����� ����� � ������
    ENDIF

    * �������� �������, ���� ����� ����� �������� ������� ���
    IF nFileSize > nMaxSize
        * ��������� ��������� ��������� ����, ���� ����
        IF FILE("log_backup.txt")
            ERASE "log_backup.txt"
        ENDIF

        * ������������� �������� ���� ���� �� ���������
        RENAME (cLogFile) TO "log_backup.txt"
    ENDIF

    * ������ ����� ����� �� ����� ����
    STRTOFILE(cLogEntry, cLogFile, .T.)
ENDPROC
