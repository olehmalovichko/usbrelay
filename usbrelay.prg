************************************************
* Oleh Malovichko
* Github
* https://github.com/olehmalovichko/usbrelay
***********************************************

*CLEAR
*SET PROCEDURE TO log ADDITIVE

PROCEDURE USBRelaySetup
* ���� �� USB_RELAY_DEVICE.DLL ����'������ �������
SET DEFA TO D:\Develop\USBRelay\

* ���������� ������� ��� �����䳿 � USB_RELAY_DEVICE.DLL

* ����������� ��� ��������
DECLARE INTEGER usb_relay_device_enumerate IN USB_RELAY_DEVICE.dll

* ³������� �������� �� ������� �������
DECLARE INTEGER usb_relay_device_open_with_serial_number IN USB_RELAY_DEVICE.dll STRING serial_number, INTEGER h

* ��������� ������� ���� �� �������
DECLARE INTEGER usb_relay_device_get_num_relays IN USB_RELAY_DEVICE.dll INTEGER h

* ��������� ID �������� �� �����
DECLARE STRING usb_relay_device_get_id_string IN USB_RELAY_DEVICE.dll INTEGER h

* ��������� ���������� �������� � �������
DECLARE INTEGER usb_relay_device_next_dev IN USB_RELAY_DEVICE.dll INTEGER h

* ��������� ����� ��� ���� �� ������� � ������ ����� �����
DECLARE INTEGER usb_relay_device_get_status_bitmap IN USB_RELAY_DEVICE.dll INTEGER h

* ³������� ������ ������ ���� �� �������
DECLARE INTEGER usb_relay_device_open_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* �������� ������ ������ ���� �� �������
DECLARE INTEGER usb_relay_device_close_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* �������� �������� (������� �� ������)
DECLARE INTEGER usb_relay_device_close IN USB_RELAY_DEVICE.dll INTEGER h

* �������� ��� ������ ���� �� �������
DECLARE INTEGER usb_relay_device_close_all_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h

ENDPROC


********************************************************************************************************

* ³������� �������� �� ������ ID
FUNCTION openDevById(idstr)
    * ��������� ����������� ��� ������ �������� ��������
    WriteToLog("Opening " + idstr)
    
    * ������������ ����� � ������, ��������� ��� ������� DLL
    idstrp = stringToCharp(idstr)
    
    * ³������� �������� �� ������ ID
    h = usb_relay_device_open_with_serial_number(idstrp, 5)
    
    IF h = 0
        * ���� �� ������� ������� �������, �������� �������
        fail("Cannot open device with id=" + idstr)
    ENDIF
    
    * ��������� ������� ���� �� �������
    numch = usb_relay_device_get_num_relays(h)
    
    IF numch <= 0 OR numch > 8
        * ���� ������� ���� �� ������� �������� 1-8, �������� �������
        fail("Bad number of channels, can be 1-8")
    ENDIF
    
    * ���������� ����������� �������� � ��������� �����
    hdev = h
    
    * ��������� ������� ���� �� �������
    WriteToLog("Number of relays on device with ID=" + idstr + ": " + ALLTRIM(STR(numch)))
ENDFUNC


* ������� ��� �������� ��������
FUNCTION closeDevice(hdev)
    * �������� ����������� ��� ������ �������� ��������
    WriteToLog("Closing device")
    
    * ��������� �������
    result = usb_relay_device_close(hdev)
    
    IF result != 0
        * ���� ������� �� ������� �������, �������� �������
        fail("Failed to close device")
    ENDIF
    
    * ���� ������� ������ ��������, �������� �����������
    WriteToLog("Device closed successfully")
ENDFUNC

* ������� ��� ������� �������
FUNCTION fail(message)
    * �������� ������� � ���������� ���������
    WriteToLog(message)
    CANCEL
ENDFUNC

* ������� ��� �������� ��� ������ ���� �� �������
FUNCTION closeAllRelayChannels(hdev)
    * �������� ����������� ��� ������ �������� ��� ������ ����
    WriteToLog("Closing all relay channels on device")
    
    * ��������� �� ������ ���� �� �������
    result = usb_relay_device_close_all_relay_channel(hdev)
    
    IF result != 0
        * ���� ������ �� ������� �������, �������� �������
        fail("Failed to close all relay channels on device")
    ENDIF
    
    * ���� ������ ������ ������, �������� �����������
    WriteToLog("All relay channels closed successfully on device")
ENDFUNC

* ������������ ����� � ������, ��������� ��� ������� DLL
FUNCTION stringToCharp(str)
    * ���������� ����� � ������, ���������� ��� DLL
    * ���� ���������, ����� ������ �������� ����� ��� ������������
    RETURN str
ENDFUNC

* ������� ��� �������� ������ ������ ����
FUNCTION openRelayChannel(hdev, channel)
    * �������� ����������� ��� ������ �������� ������ ����
    WriteToLog("Opening relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * ³�������� ����� ���� �� �������
    result = usb_relay_device_open_one_relay_channel(hdev, channel)
    
    IF result != 0
        * ���� ����� �� ��������, �������� �������
        fail("Failed to open relay channel " + ALLTRIM(STR(channel)) + " on device")
    ENDIF
    
    * ���� ����� ������ ��������, �������� �����������
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " opened successfully")
ENDFUNC


* ������� ��� �������� ������ ������ ����
FUNCTION closeRelayChannel(hdev, channel)
    * �������� ����������� ��� ������ �������� ������ ����
    WriteToLog("Closing relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * ��������� ����� ���� �� �������
    result = usb_relay_device_close_one_relay_channel(hdev, channel)
    
    IF result != 0
        * ���� ����� �� ��������, �������� �������
        fail("Failed to close relay channel " + ALLTRIM(STR(channel)) + " on device")
    ENDIF
    
    * ���� ����� ������ ��������, �������� �����������
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " closed successfully")
ENDFUNC

FUNCTION usb_relay_device_get_status(hdev)
   result = usb_relay_device_get_status_bitmap(hdev)
   WriteToLog("Relay status " + STR(result))
   RETURN result
ENDFUNC 
 
