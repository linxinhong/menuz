; 利用 Send_WM_COPYDATA() 函数，可以将内容回传给MenuZ.ahk
; 当有一个菜单内容为 {ahk:return:Script\Returnsample.ahk} 时
; 会直接运行对应的 Script\Returnsample.ahk ，然后等待脚本利用Send_WM_COPYDATA函数返回内容（只能是字符串)
; 以下函数示例为返回 "cmd" 替换菜单内容里的 {ahk:return:Script\Returnsample.ahk}
; 注！！！有返回值的脚本，建议不持续运行
Msgbox 此示例将会返回cmd
Send_WM_COPYDATA("cmd")


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

