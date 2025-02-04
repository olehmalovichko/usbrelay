************************************************
* Oleh Malovichko
* Github
* https://github.com/olehmalovichko/usbrelay
***********************************************

PROCEDURE USBRelaySetup
* Specify the path to USB_RELAY_DEVICE.DLL
SET DEFA TO D:\Develop\USBRelay\

* Declare functions for interacting with USB_RELAY_DEVICE.DLL

* Enumerate all devices
DECLARE INTEGER usb_relay_device_enumerate IN USB_RELAY_DEVICE.dll

* Open device by serial number
DECLARE INTEGER usb_relay_device_open_with_serial_number IN USB_RELAY_DEVICE.dll STRING serial_number, INTEGER h

* Get the number of relays on the device
DECLARE INTEGER usb_relay_device_get_num_relays IN USB_RELAY_DEVICE.dll INTEGER h

* Get the device ID as a string
DECLARE STRING usb_relay_device_get_id_string IN USB_RELAY_DEVICE.dll INTEGER h

* Get the next device in the list
DECLARE INTEGER usb_relay_device_next_dev IN USB_RELAY_DEVICE.dll INTEGER h

* Get the status of all relays on the device as a bitmap
DECLARE INTEGER usb_relay_device_get_status_bitmap IN USB_RELAY_DEVICE.dll INTEGER h

* Open a single relay channel on the device
DECLARE INTEGER usb_relay_device_open_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* Close a single relay channel on the device
DECLARE INTEGER usb_relay_device_close_one_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h, INTEGER relay_channel

* Close the device (closes all channels)
DECLARE INTEGER usb_relay_device_close IN USB_RELAY_DEVICE.dll INTEGER h

* Close all relay channels on the device
DECLARE INTEGER usb_relay_device_close_all_relay_channel IN USB_RELAY_DEVICE.dll INTEGER h

ENDPROC

********************************************************************************************************

* Open a device by a known ID
FUNCTION openDevById(idstr)
    * Log the attempt to open the device
    WriteToLog("Opening " + idstr)
    
    * Convert the string to a format suitable for DLL calls
    idstrp = stringToCharp(idstr)
    
    * Open the device by a known ID
    h = usb_relay_device_open_with_serial_number(idstrp, 5)
    
    IF h = 0
        * Log an error if the device cannot be opened
        WriteToLog("Cannot open device with id=" + idstr)
    ENDIF
    
    * Get the number of relays on the device
    numch = usb_relay_device_get_num_relays(h)
    
    IF numch <= 0 OR numch > 8
        * Log an error if the number of relays is out of range (1-8)
        WriteToLog("Bad number of channels, can be 1-8")
    ENDIF
    
    * Save the device handle to a global variable
    hdev = h
    
    * Log the number of relays on the device
    WriteToLog("Number of relays on device with ID=" + idstr + ": " + ALLTRIM(STR(numch)))
ENDFUNC

* Function to close the device
FUNCTION closeDevice(hdev)
    * Log the attempt to close the device
    WriteToLog("Closing device")
    
    * Close the device
    result = usb_relay_device_close(hdev)
    
    IF result != 0
        * Log an error if the device cannot be closed
        WriteToLog("Failed to close device")
    ENDIF
    
    * Log a success message if the device is closed successfully
    WriteToLog("Device closed successfully")
ENDFUNC

* Function to close all relay channels on the device
FUNCTION closeAllRelayChannels(hdev)
    * Log the attempt to close all relay channels
    WriteToLog("Closing all relay channels on device")
    
    * Close all relay channels on the device
    result = usb_relay_device_close_all_relay_channel(hdev)
    
    IF result != 0
        * Log an error if channels cannot be closed
        WriteToLog("Failed to close all relay channels on device")
        RETURN result 
    ENDIF
    
    * Log a success message if all channels are closed successfully
    WriteToLog("All relay channels closed successfully on device")
    RETURN result
ENDFUNC

* Convert a string to a format suitable for DLL calls
FUNCTION stringToCharp(str)
    * Return the string in a format suitable for DLL
    * Additional conversion steps can be added if necessary
    RETURN str
ENDFUNC

* Function to open a single relay channel
FUNCTION openRelayChannel(hdev, channel)
    * Log the attempt to open a relay channel
    WriteToLog("Opening relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * Open the relay channel on the device
    result = usb_relay_device_open_one_relay_channel(hdev, channel)
    
    IF result != 0
        * Log an error if the channel cannot be opened
        WriteToLog("Failed to open relay channel " + ALLTRIM(STR(channel)) + " on device")
        RETURN result 
    ENDIF
    
    * Log a success message if the channel is opened successfully
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " opened successfully")
    RETURN result 
ENDFUNC

* Function to close a single relay channel
FUNCTION closeRelayChannel(hdev, channel)
    * Log the attempt to close a relay channel
    WriteToLog("Closing relay channel " + ALLTRIM(STR(channel)) + " on device")
    
    * Close the relay channel on the device
    result = usb_relay_device_close_one_relay_channel(hdev, channel)
    
    IF result != 0
        * Log an error if the channel cannot be closed
        WriteToLog("Failed to close relay channel " + ALLTRIM(STR(channel)) + " on device")
        RETURN result 
    ENDIF
    
    * Log a success message if the channel is closed successfully
    WriteToLog("Relay channel " + ALLTRIM(STR(channel)) + " closed successfully")
    RETURN result 
ENDFUNC

FUNCTION usb_relay_device_get_status(hdev)
   result = usb_relay_device_get_status_bitmap(hdev)
   WriteToLog("Relay status " + STR(result))
   RETURN result
ENDFUNC


FUNCTION getNumberOfRelays(hdev)
    * Log the attempt to get the number of relays
    WriteToLog("Getting number of relays on the device")
    
    * Call the DLL function to get the number of relays
    numRelays = usb_relay_device_get_num_relays(hdev)
    
    IF numRelays <= 0
        * Log an error if the number of relays is invalid
        WriteToLog("Failed to get the number of relays or no relays found on device")
        RETURN 0
    ENDIF
    
    * Log the number of relays found
    WriteToLog("Number of relays on the device: " + ALLTRIM(STR(numRelays)))
    
    * Return the number of relays
    RETURN numRelays
ENDFUNC
