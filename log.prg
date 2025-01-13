
* Ведення логу у текстовий файл
* Приклад
* WriteToLog("Початок роботи програми", "application_log.txt", 500000)  && 500 KB
* WriteToLog("Користувач увійшов у систему", "application_log.txt")
* WriteToLog("Тест")

PROCEDURE WriteToLog
    LPARAMETERS cLogMessage, cLogFile, nMaxSize
    * Параметри:
    * cLogMessage - текст повідомлення, яке потрібно додати до логу.
    * cLogFile - шлях до файлу логу (наприклад, "log.txt").
    * nMaxSize - максимальний розмір файлу логу в байтах (за замовчуванням 1 MB).

    * Значення за замовчуванням
    IF EMPTY(cLogFile)
        cLogFile = "log.txt" && Файл логу за замовчуванням
    ENDIF

    IF EMPTY(nMaxSize)
        nMaxSize = 1048576 && 1 MB
    ENDIF

    * Формуємо рядок для запису з позначкою часу
    cLogEntry = TTOC(DATETIME()) + " - " + cLogMessage + CHR(13) + CHR(10)

    * Перевіряємо розмір файлу за допомогою ADIR()
    LOCAL aFileInfo[1]
    LOCAL nFileSize
    nFileSize = 0

    IF FILE(cLogFile)
        =ADIR(aFileInfo, cLogFile)
        nFileSize = aFileInfo[1, 2]  && Розмір файлу у байтах
    ENDIF

    * Виконуємо ротацію, якщо розмір файлу перевищує заданий ліміт
    IF nFileSize > nMaxSize
        * Видаляємо попередній резервний файл, якщо існує
        IF FILE("log_backup.txt")
            ERASE "log_backup.txt"
        ENDIF

        * Перейменовуємо поточний файл логу на резервний
        RENAME (cLogFile) TO "log_backup.txt"
    ENDIF

    * Додаємо новий запис до файлу логу
    STRTOFILE(cLogEntry, cLogFile, .T.)
ENDPROC
