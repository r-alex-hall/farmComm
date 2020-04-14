'CTRLWOL.vbs 
'version 1.04

'This script can be used to disable or enable power management options 
'of all Ethernet devices listed in strAdap.

'Note: Option A: "Only allow management stations to bring the computer out of standby."
'      Option B: "Allow this device to bring the computer out of standby." 

'When you need to run this on a system with new Ethernet Device, just update strAdap with the Ethernet device name.


Const Version 				="1.07"
Dim colNetworkAdapters
Dim objNetworkAdapter

Dim strDevInstanceName
Dim strNetworkAdapterID
Dim counter

Const strEnable				= "ENABLE"		' check both A and B (for reference see Note above)
Const strDisable			= "DISABLE"		' always disable both A and B (for reference see Note above)
Const strManaged 			= "MANAGED"             ' check B only when A is checked else do nothing (for reference see Note above)

Const EnableRequest			= 0
Const DisableRequest			= 1
Const ManagedRequest			= 2

Dim RequestCmd							' Any of EnableRequest/DisableRequest/QueryRequest
Dim MagicEnable 
MagicEnable= 0
Dim  AdapCount

	
strAdap = Array("Intel(R) PRO/1000","Intel(R) 82566","Broadcom NetXtreme","Broadcom NetLink","Realtek RTL8139/810x","Intel(R) 82567","Realtek RTL8168","Intel(R) 82577", "Realtek PCIe GBE","Intel(R) 82579")

Set WSHShell = WScript.CreateObject( "WScript.Shell" )
AdapCount = Ubound(strAdap) + 1     

'
' Check arguments
'
If WScript.Arguments.Count = 0 Then
	'RequestCmd = QueryRequest
        WScript.Echo "CTRLWOL.vbs  v."& version
        WScript.Echo "Run script with ENABLE|MANAGED|DISABLE option"
        WScript.Quit              
Else
	If UCase( WScript.Arguments.Item(0)) = strEnable Then
		RequestCmd = EnableRequest
       	ElseIf UCase(WScript.Arguments.Item(0)) = strDisable Then
		RequestCmd = DisableRequest
        ElseIf UCase(WScript.Arguments.Item(0)) = strManaged Then
		RequestCmd = ManagedRequest               
	ElseIf Instr( WScript.Arguments.Item(0), "/?" ) Then	
       	        WScript.Echo "CTRLWOL.vbs  v."& version	
		WScript.Echo "This script will enable or disable Power Management of Ethernet device."
		WScript.Echo "Note: This must be ran on an evelated command prompt."
		WScript.Echo "CTRLWOL.vbs [ENABLE|MANAGED|DISABLE]"	
             	WScript.Quit	
	Else
		
                WScript.Echo "CTRLWOL.vbs  v."& version
                WScript.Echo "Invalid Request: " + UCase( WScript.Arguments.Item(0) )
		WScript.Echo "This script will enable or disable Power Management of Ethernet device."
		WScript.Echo "Note: This must be ran on an evelated command prompt."
		WScript.Echo "CTRLWOL.vbs [ENABLE|MANAGED|DISABLE]"	
		WScript.Quit
	End If
End If


'Query for all of the Win32_NetworkAdapters that are wired Ethernet (AdapterTypeId=0 corresponds to Ethernet 802.3)
Set colNetworkAdapters = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/Cimv2")_
.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE AdapterTypeId=0")

'WScript.Echo "Enabling WoL for the following adapters:"

For Each objNetworkAdapter In colNetworkAdapters
	'WScript.Echo "  " & objNetworkAdapter.Name & " [" & objNetworkAdapter.MACAddress & "]" 
        counter = 0
	While counter < AdapCount
              strFind = strAdap(counter)
              'Match Adapter Name to any of the known Ethernet Adapters 
	      If InStrB(objNetworkAdapter.Name, strFind) <> 0 Then
                       ' WScript.Echo Found
			strNetworkAdapterID = UCase(objNetworkAdapter.PNPDeviceID)
		       'WScript.Echo objNetworkAdapter.Name & strFind


			'Query for all of the MSPower_DeviceWakeEnable classes
			Dim colPowerWakeEnables
			Dim objPowerWakeEnable

			Set colPowerWakeEnables = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/wmi")_
			.ExecQuery("SELECT * FROM MSPower_DeviceWakeEnable")
	
			'Compare the PNP Device ID from the network adapter against the MSPower_DeviceEnabled instances
			For Each objPowerWakeEnable In colPowerWakeEnables
				'We have to compare the leftmost part as MSPower_DeviceEnabled.InstanceName contains an instance suffix
				strDevInstanceName = UCase(Left(objPowerWakeEnable.InstanceName, Len(strNetworkAdapterID)))
			
				'Match found, enable WOL
	
				If StrComp(strDevInstanceName, strNetworkAdapterID)=0 Then
                                     If RequestCmd = ManagedRequest Then 
					  If (objPowerWakeEnable.Enable = True) Then   'Check if "Allow this device to bring the computer out of standby." is enabled
					        MagicEnable = 1                        'Set flag to 1 
                                      '   Else  WScript.Echo "'Allow this device to bring the computer out of standby option' is not enabled."
                                          End If
                                     ElseIf RequestCmd = EnableRequest Then 
                                          objPowerWakeEnable.Enable = True
					  objPowerWakeEnable.Put_  	'Required to write the value back to the object                                     

                                     ElseIf RequestCmd = DisableRequest Then
                                                objPowerWakeEnable.Enable = False
						objPowerWakeEnable.Put_  	'Required to write the value back to the object
                                  '    ElseIf RequestCmd = Query Request Then
                                  '               WScript.Echo "Rerun script with ENABLE or DISABLE option"
                                      End	If
				End	If
			Next
	
			'Query for all of the MSNdis_DeviceWakeOnMagicPacketOnly classes
			Dim colMagicPacketOnlys
			Dim objMagicPacketOnly
	
			Set colMagicPacketOnlys = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/wmi")_
			.ExecQuery("SELECT * FROM MSNdis_DeviceWakeOnMagicPacketOnly")
	
			'Compare the PNP Device ID from the network adapter against the MSNdis_DeviceWakeOnMagicPacketOnly instances
		
			For Each objMagicPacketOnly In colMagicPacketOnlys
				'We have to compare the leftmost part as MSNdis_DeviceWakeOnMagicPacketOnly.InstanceName contains an instance suffix
				strDevInstanceName = UCase(Left(objMagicPacketOnly.InstanceName, Len(strNetworkAdapterID)))
		
				'Match found, enable WOL for Magic Packets only
				If StrComp(strDevInstanceName, strNetworkAdapterID)=0 Then
                                     If (RequestCmd = ManagedRequest) and (MagicEnable = 1) Then 
					objMagicPacketOnly.EnableWakeOnMagicPacketOnly = True  'Set to true to enable "Only allow management stations to bring the computer out of standby."
					objMagicPacketOnly.Put_  	                       'Required to write the value back to the object
                                     ElseIf RequestCmd = EnableRequest Then 
					objMagicPacketOnly.EnableWakeOnMagicPacketOnly = True  'Set to true to enable "Only allow management stations to bring the computer out of standby."
					objMagicPacketOnly.Put_  	                       'Required to write the value back to the object

                                     ElseIf RequestCmd = DisableRequest Then
					objMagicPacketOnly.EnableWakeOnMagicPacketOnly = False  'Set to false if you wish to wake on magic packets AND wake patterns
					objMagicPacketOnly.Put_  	'Required to write the value back to the object
				     End  If
				End	If
			Next
                        counter = AdapCount
		 Else   counter = counter + 1 
                     
                
		 End If
	  Wend

Next

