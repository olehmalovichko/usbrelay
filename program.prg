
PUBLIC devids, enuminfo 
PUBLIC hdev

SET DEFAULT TO d:\develop\usbrelay\

* ������� ����
SET PROCEDURE TO log.prg 

* ������� ������ � USB Relay ������� 
SET PROCEDURE TO usbrelay ADDITIVE

* ��������� ���
IF FILE("log.txt")    
 ERASE ("log.txt") 
ENDIF 

* ��������� USB ������
USBRelaySetup()

* ������������ ����� ��� ��������� �������������� ��������
devids = CREATEOBJECT("Collection")

* ������ ��� ��������
enuminfo = usb_relay_device_enumerate()

DO FORM mainform