************************************************
* Oleh Malovichko
* Github
* https://github.com/olehmalovichko/usbrelay
***********************************************

*CLEAR
*SET PROCEDURE TO log ADDITIVE

PROCEDURE USBRelaySetup
* Шлях до USB_RELAY_DEVICE.DLL обов'язково вказати
SET DEFA TO D:\Develop\USBRelay\

* Оголошення функцій для взаємодії з USB_RELAY_DEVICE.DLL

* Перерахунок всіх пристроїв
DECLARE INTEGER usb_relay_device_enumerate IN USB_RELAY_DEVICE.dll

* Відкриття пристрою за серійним номером
DECLARE INTEGER usb_relay_device_open_with_serial_number IN USB_RELAY_DEVICE.dll STRING serial_number, INTEGER h

* Отримання кількості реле на пристрої
DECLARE INTEGER usb_relay_device_get_num_relays IN USB_RELAY_DEVICE.dll INTEGER h

* Отримання ID пристрою як рядка
DECLARE STRING usb_relay_device_get_id_string IN USB_RELAY_DEVICE.dll INTEGER h

* Отримання наступного пристрою в переліку
DECLARE INTEGER usb_relay_device_next_dev IN USB_RELAY_DEVICE.dll INTEGER h

* Отримання стану всіх реле на пристрої у вигляді бітової карти
DECLARE INTEGER usb_relay_device_get_status_bitmap IN USB_RELAY_DEVICE.dll INTEGER h

* Відкриття одного канала реле на пристрої
DECLARE INTEGER usb_relay_device_open_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* Закриття одного канала реле на пристрої
DECLARE INTEGER usb_relay_device_close_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* Закриття пристрою (закриває всі канали)
DECLARE INTEGER usb_relay_device_close IN USB_RELAY_DEVICE.dll INTEGER h

* Закриття всіх каналів реле на пристрої
DECLARE INTEGER usb_relay_device_close_all_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h

ENDPROC


********************************************************************************************************

* Відкриття пристрою за відомим ID
FUNCTION openDevById(idstr)
    * Виведення повідомлення про спробу відкриття пристрою
    WriteToLog("Opening " + idstr)
    
    * Перетворення рядка в формат, придатний для виклику DLL
    idstrp = stringToCharp(idstr)
    
    * Відкриття пристрою за відомим ID
    h = usb_relay_device_open_with_serial_number(idstrp, 5)
    
    IF h = 0
        * Якщо не вдалося відкрити пристрій, виводимо помилку
        fail("Cannot open device with id=" + idstr)
    ENDIF
    
    * Отримання кількості реле на пристрої
    numch = usb_relay_device_get_num_relays(h)
    
    IF numch <= 0 OR numch > 8
        * Якщо кількість реле не відповідає діапазону 1-8, виводимо помилку
        fail("Bad number of channels, can be 1-8")
    ENDIF
    
    * Збереження дескриптора пристрою у глобальну змінну
    hdev = h
    
    * Виведення кількості реле на пристрої
    WriteToLog("Number of relays on device with ID=" + idstr + ": " + ALLTRIM(STR(numch)))
ENDFUNC


* Функція для закриття пристрою
FUNCTION closeDevice(hdev)
    * Виводимо повідомлення про спробу закриття пристрою
    WriteToLog("Closing device")
    
    * Закриваємо пристрій
    result = usb_relay_device_close(hdev)
    
    IF result != 0
        * Якщо пристрій не вдалося закрити, виводимо помилку
        fail("Failed to close device")
    ENDIF
    
    * Якщо пристрій успішно закритий, виводимо повідомлення
    WriteToLog("Device closed successfully")
ENDFUNC

* Функція для обробки помилок
FUNCTION fail(message)
    * Виводимо помилку і припиняємо виконання
    WriteToLog(message)
    CANCEL
ENDFUNC

* Функція для закриття всіх каналів реле на пристрої
FUNCTION closeAllRelayChannels(hdev)
    * Виводимо повідомлення про спробу закриття всіх каналів реле
    WriteToLog("Closing all relay channels on device")
    
    * Закриваємо всі канали реле на пристрої
    result = usb_relay_device_close_all_relay_channel(hdev)
    
    IF result != 0
        * Якщо канали не вдалося закрити, виводимо помилку
        fail("Failed to close all relay channels on device")
    ENDIF
    
    * Якщо канали успішно закриті, виводимо повідомлення
    WriteToLog("All relay channels closed successfully on device")
ENDFUNC

* Перетворення рядка в формат, придатний для виклику DLL
FUNCTION stringToCharp(str)
    * Повернення рядка у форматі, придатному для DLL
    * Якщо необхідно, можна додати додаткові кроки для перетворення
    RETURN str
ENDFUNC

* Функція для відкриття одного канала реле
FUNCTION openRelayChannel(hdev, channel)
    * Виводимо повідомлення про спробу відкриття канала реле
    WriteToLog("Opening relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * Відкриваємо канал реле на пристрої
    result = usb_relay_device_open_one_relay_channel(hdev, channel)
    
    IF result != 0
        * Якщо канал не відкрився, виводимо помилку
        fail("Failed to open relay channel " + ALLTRIM(STR(channel)) + " on device")
    ENDIF
    
    * Якщо канал успішно відкритий, виводимо повідомлення
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " opened successfully")
ENDFUNC


* Функція для закриття одного канала реле
FUNCTION closeRelayChannel(hdev, channel)
    * Виводимо повідомлення про спробу закриття канала реле
    WriteToLog("Closing relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * Закриваємо канал реле на пристрої
    result = usb_relay_device_close_one_relay_channel(hdev, channel)
    
    IF result != 0
        * Якщо канал не закрився, виводимо помилку
        fail("Failed to close relay channel " + ALLTRIM(STR(channel)) + " on device")
    ENDIF
    
    * Якщо канал успішно закритий, виводимо повідомлення
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " closed successfully")
ENDFUNC

FUNCTION usb_relay_device_get_status(hdev)
   result = usb_relay_device_get_status_bitmap(hdev)
   WriteToLog("Relay status " + STR(result))
   RETURN result
ENDFUNC 
 
