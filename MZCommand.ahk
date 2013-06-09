#SingleInstance,Force
#NoTrayIcon
DetectHiddenWindows On
SetTitleMatchMode 2
If 0 > 0
{
	Mode = %1%
	SendMZC := "MZCommand:" Mode
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
