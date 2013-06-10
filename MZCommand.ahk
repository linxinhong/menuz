#SingleInstance,Force
#NoTrayIcon
DetectHiddenWindows On
SetTitleMatchMode 2
Global ParamString := Object()
If 0 > 0
{
	Idx := 0
	Loop,%0%
	{
		Param := %A_Index%	
		If A_Index = 1
		{
			MZC_Mode(Param)
			If RegExMatch(param,"i)/m")
			{
				IsMode := True   ;Mode
				Continue
			}
			If RegExMatch(param,"i)/d")
			{
				IsDebugGUI := True   ;Debug
				Continue
			}
		}
		idx++
		ParamString[idx] := param
	}
	ParamString[0] := idx
	If IsMode
		MZC_Mode(ParamString[1])
	If IsDebugGUI
		MZC_DebugGUI()
}
MZC_Mode(Mode)
{
	If RegExMatch(Mode,"^\{[^\{\}]*\}$")
	{
		SendMZC := "MZCommand:" Mode
		Send_WM_COPYDATA(SendMZC)
		exit
	}
}
MZC_DebugGUI()
{
	Count := ParamString[0]
	Loop,%Count%
		DebugString .= ParamString[A_Index]
	SendMZC := "MZCommand:DebugGUI:" DebugString
	Send_WM_COPYDATA(SendMZC)
	exit
}
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle="MenuZ.ahk ahk_class AutoHotkey")
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  
    DetectHiddenWindows %Prev_DetectHiddenWindows%  
    SetTitleMatchMode %Prev_TitleMatchMode% 
    return ErrorLevel  
}
