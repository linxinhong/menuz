GetModuleFileNameEx( )      ;------------------------------Â·¾¶»ñÈ¡--------------------------------
{
	MouseGetPos,,,KDE_id
    WinGet ,p_PID ,PID ,ahk_id %KDE_id%  ;
	If A_OSVersion in WIN_95,WIN_98,WIN_ME
	{
		MsgBox, This Windows version (%A_OSVersion%) is not supported.
		Return
	}
	h_Process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
	If ( ErrorLevel or h_Process = 0 )
		Return
	name_size = 255
	VarSetCapacity( name, name_size )
	result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_Process, "uint", 0, "str", name, "uint", name_size )
	DllCall( "CloseHandle", h_Process )
	strA := StrGet(&name, "cp0") 
	Return, strA
}

