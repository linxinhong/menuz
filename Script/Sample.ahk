; 正常AHK脚本示例，以下为Msgbox显示传给本脚本的参数
; {ahk:Script\sample.ahk}
; 会被替换为 "A_AHKPath" "script\sample.ahk" 
; 如我电脑里的Autohotkey.exe路径为C:\Autohotkey.exe
; 则替换为 "C:\Autohotkey.exe" "Script\sample.ahk"
; 1、简化写ahk脚本的方法
; 不需要在菜单里用 "%a_ahkpath%" "c:\xxxx\xxxxxx.ahk" 这样冗长的写法
; 只需要 {ahk:xxxx.ahk} 就行
; 2、以后MZ会做成便携版，所以这种方式很有必要

If 0 > 0
{
	Loop,%0%
	{
		Param := %A_Index%
		Msgbox % Param
	}
}
