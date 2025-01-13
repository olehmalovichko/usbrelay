
PUBLIC devids, enuminfo 
PUBLIC hdev

SET DEFAULT TO d:\develop\usbrelay\

* ведення логу
SET PROCEDURE TO log.prg 

* функции роботи з USB Relay модулем 
SET PROCEDURE TO usbrelay ADDITIVE

* видаляємо лог
IF FILE("log.txt")    
 ERASE ("log.txt") 
ENDIF 

* Налаштуємо USB модуль
USBRelaySetup()

* Ініціалізація змінної для зберігання ідентифікаторів пристроїв
devids = CREATEOBJECT("Collection")

* Перебір всіх пристроїв
enuminfo = usb_relay_device_enumerate()

DO FORM mainform