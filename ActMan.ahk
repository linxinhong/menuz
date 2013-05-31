#SingleInstance,Force
#NoTrayIcon
;FileEncoding,UTF-8
Global urllink
Global Apps
Setworkingdir,A_ScriptDir 
Coordmode,Tooltip,Screen
If 0 > 0
{
	Loop,%0%
	{
		param := %A_Index%
		If A_Index = 1
		{
			If RegExMatch(param,"i)/g")
			{
				IsGUI := True   ;打开ActMan的GUI界面
				Continue
			}
	 		If RegExMatch(param,"i)/v")
			{
				IsView := True  ;查看MZA的信息
				Continue
			}
			If RegExMatch(param,"i)/a")
			{
				IsAdd := True   ;安装MZA（静默，无显示）
				Continue
			}
			If RegExMatch(param,"i)/s")
			{
				IsSelect := True ;选择MZA包，并查看
				Continue
			}
			If RegExMatch(param,"i)/p")
			{
				IsSelect := True ;传入MZA包列表，批量安装
				Continue
			}
			If RegExMatch(param,"i)/u")
			{
				IsSelect := True ;卸载某MZA包 可以用 | 分隔
				Continue
			}
		}
		ParamString .= param A_Space
	}
	IsParam := True
	ParamString := Substr(ParamString,1,Strlen(ParamString)-1)
}
ExtensionsAHK := A_ScriptDir "\Extensions\Extensions.ahk"
If IsParam AND (IsView OR IsAdd)
{
	MZA_Temp := A_Temp "\MenuZapp\"
	7za := A_ScriptDir "\apps\7zip\7za.exe"
	If FileExist(ParamString) And RegExMatch(ParamString,"i)\.mza$")
	{
		Mousegetpos,x,y
		Tooltip,加载中,%x%,%y%,10
		Fileremovedir,%MZA_Temp%,1
		Runwait %7za% x "%ParamString%" -o%MZA_Temp% -tzip -r ,,Hide UseErrorLevel
		If ErrorLevel
			Msgbox 安装失败 `n %7za% x %ParamString% -o%MZA_Temp% -tzip -r
		InstallAppINI := MZA_Temp "installapps.ini"
		Tooltip,,,,10
	}
}
Else
	InstallAppINI:= A_ScriptDir "\installapps.ini"
MenuZINI := A_ScriptDir "\Menuz.ini"
MenuZINIBak:= A_ScriptDir "\Menuz_bak.ini"
If IsParam
{
If FileExist(InstallAppINI) 
{
	apps := IniReadValue(InstallAppINI)
	If strlen(apps) > 0
	{
		Installapp_name := IniReadValue(InstallAppINI,"apps","name")
		Installapp_Author := IniReadValue(InstallAppINI,"apps","Author")
		urlname := IniReadValue(InstallAppINI,"apps","urlname")
		urllink := IniReadValue(InstallAppINI,"apps","urladdr")
		Dest := IniReadValue(InstallAppINI,"Dest")
		Installapp_url := "<a href=""" urllink """>" urlname "</a>"
		Gui,Installapp:New 
		GUi,Installapp:+hwndInstallid
		Gui,Installapp:Add,Text,x5 y10 w50 h20,插件名:
		Gui,Installapp:Add,Text,x60 y10 w400 h20,%Installapp_name%
		Gui,Installapp:Add,Text,x5 y40 w50 h20,打  包:
		Gui,Installapp:Add,Text,x60 y40 w400 h20 ,%Installapp_Author%
		Gui,Installapp:Add,Text,x5 y70 w50 h20,链  接:
		Gui,Installapp:Add,Link,x60 y70 w400 h20 ,%Installapp_URL%
		Gui,Installapp:Add,Edit,x5 y100 w390 h100 readonly,%Dest%
		Gui,Installapp:Add,Button,x200 y210 w70 gaddtomenuz,添加(&Y)
		Gui,Installapp:Add,Button,x290 y210 w70 gexitapp,取消(&X)
		GUi,Show,w400 h245,MenuZ App
	}
}
Else
	Msgbox 此扩展包无效
}
If Not FileExist(ExtensionsAHK)
	FileAppend,,%ExtensionsAHK%
FileRead,Extensions,%ExtensionsAHK%
; 验证Extensions里Include的插件是否存在
Loop,Parse,Extensions,`n,`r
{
	If Not RegExMatch(A_LoopField,"i)^#include")
			Continue
	If FileExist(RegExReplace(A_LoopField,"i)^#include\s%A_ScriptDir%\\"))
	{
		
		Match := "\t" ToMatch(SubStr(A_LoopField,35)) "\t"
		If Not RegExMatch(ExtensionsNames,Match)
			NewExtensions .= A_LoopField "`r`n"
		ExtensionsNames .= A_Tab Substr(A_LoopField,35) A_Tab
	}
}
; 清理无用#include
Filedelete,%ExtensionsAHK%
FileAppend,%NewExtensions%,%ExtensionsAHK%
; 查询是否有新插件加入
Loop,%A_ScriptDir%\Extensions\*.ahk
{
	If RegExMatch(A_LoopFileName,"i)^Extensions\.ahk$")
		Continue
	Else
	{
		Match := "\t" ToMatch(A_LoopFileName) "\t"
		If Not RegExMatch(ExtensionsNames,Match)
			FileAppend,#include `%A_ScriptDir`%\Extensions\%A_LoopFileName%`n , %ExtensionsAHK%
	}
}
; 保存修改时间
SaveTime := "/*`r`n[ExtensionsTime]`r`n" 
Loop,%A_ScriptDir%\Extensions\*.ahk
{
	If RegExMatch(A_LoopFileName,"i)^Extensions.ahk$")
		Continue
	FileGetTime,ExtensionsTime,%A_LoopFileFullPath%,M
	SaveTime .= RegExReplace(A_LoopFileName,"i)\.ahk$") "=" ExtensionsTime "`r`n"
}
SaveTime .= "*/`r`n"
FileAppend,%SaveTime%,%ExtensionsAHK%
FileRead,Extensions,%ExtensionsAHK%

;Msgbox % "现在有插件列表`n" Extensions
Run MenuZ.ahk
; ToMatch(str) {{{2
; 正则表达式转义
return
addtomenuz:
	FileCopyDir,%MZA_Temp%,%A_ScriptDir%,1
	FileCopy,%MenuZINI%,%MenuZINIBak%,1
	InstallAppINI:= A_ScriptDir "\installapps.ini"
	Loop,Parse,Apps,`n,`r
	{
		If RegExMatch(A_LoopField,"i)(^apps$)|(^dest$)")
			Continue
		Section := A_LoopField
		IniItems := IniReadValue(InstallAppINI,A_LoopField)
		Loop,Parse,IniItems,`n,`r
		{
			Key := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
			Value := IniReadValue(InstallAppINI,Section,key)
			IniWrite,%Value%,%MenuZINI%,%Section%,%Key%
		}
	}
	If Not IsParam
	{
		Msgbox,4,,安装完毕，是否删除installapps.ini?
		IfMsgbox,Yes
			Filedelete,%InstallAppINI%
	}
	Else
			Filedelete,%InstallAppINI%
	exitapp
return
exitapp:
	exitapp
return
ToMatch(str)
{
	str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
	Return RegExReplace(str,"\s","\s")
}
; IniReadValue(INIFile,Section="",Key="",Default="")
IniReadValue(INIFile,Section="",Key="",Default="")
{
	IniRead,Value,%INIFile%,%Section%,%Key%
	If Value = ERROR
	{
		If Strlen(Default)
			Iniwrite,%Default%,%INIFile%,%Section%,%Key%
		Return Default
	}
	Else
		Return Value
}

