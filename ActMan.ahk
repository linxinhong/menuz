#SingleInstance,Force
#NoTrayIcon
;FileEncoding,UTF-8
Setworkingdir,A_ScriptDir 
Coordmode,Tooltip,Screen
Global ParamString := Object()
; 读取参数{{{1
If 0 > 0
{
	Idx := 0
	Loop,%0%
	{
		param := %A_Index%
		If A_Index = 1
		{
			If RegExMatch(param,"i)/a")
			{
				IsAdd := True   ;安装MZA
				Continue
			}
			If RegExMatch(param,"i)/s")
			{
				IsSilent:= True ;安装MZA(静默，无显示)
				Continue
			}
			If RegExMatch(param,"i)/u")
			{
				IsUninstall:= True ;卸载某MZA包 用空格分开
				Continue
			}
		}
		idx++
		ParamString[idx] := param
	}
	IsParam := True
	ParamString[0] := idx
}
; 执行判断和功能 {{{1
If IsParam 
{
	If IsAdd
		MZA_Add(ParamString)
	Else If IsSilent
		MZA_Add(ParamString,1)
	Else If IsUninstall 
		MZA_Del(ParamString)
}
CheckExtension()
Return
; CheckExtension() {{{1
;=============  ActMan扩展管理  ==============;
CheckExtension()
{
	ExtensionsAHK := A_ScriptDir "\Extensions\Extensions.ahk"
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
	Run MenuZ.ahk
}
;=============== MZA 管理部分 ===============;
; MZA_Add(Param,Mode=0) {{{1
MZA_Add(Param,Mode=0)
{
	MZA_Temp := A_Temp "\MenuZapp\"
	7za := A_ScriptDir "\apps\7zip\7za.exe"
	Count := Param[0]
	Loop,%Count%
	{
		ThisFile := Param[A_Index]
		If FileExist(ThisFile) And RegExMatch(ThisFile,"i)\.mza$")
		{
			Splitpath,ThisFile,,,,MZA_Name
			MZA_WorkDir := MZA_Temp MZA_Name
			Mousegetpos,x,y
			Fileremovedir,%MZA_WorkDir%,1
			Runwait %7za% x "%ThisFile%" -o"%MZA_WorkDir%" -tzip -r ,,Hide UseErrorLevel
			If ErrorLevel
			{
				Msgbox %MZA_Name% 解压失败
				Continue
			}
			Loop,%MZA_WorkDir%\*.*,1,1
			{
				FileTree .= A_LoopFileFullPath "`n"
				If RegExMatch(A_LoopFileName,"i)^installapps.ini$")
					InstallAppsINI := A_LoopFileFullPath
			}
			Splitpath,InstallAppsINI,,InstallAppsDir
			MatchAppsDir := ToMatch(InstallAppsDir)
			Idx := 0
			Loop,Parse,FileTree,`n
			{
				If Strlen(A_LoopField) = 0 
					Continue
				FilePath := RegExReplace(RegExReplace(A_LoopField,MatchAppsDir),"^\\")
				If Strlen(FilePath) = 0
					Continue
				if InStr(FileExist(A_LoopField),"D")
					FilePath .= "\"
				If RegExMatch(FilePath,"i)^((apps\\)|(icons\\)|(config\\)|(Extensions\\)|(InstallApps.INI))$")
					Continue
				idx++
				Iniwrite,%FilePath%,%InstallAppsINI%,FileTree,%idx%
			}
			Iniwrite,%idx%,%InstallAppsINI%,FileTree,0
			FileTree := ""
			If Mode
				GotoInstall(InstallAppsDir)
			Else
				ShowMZAInfo(InstallAppsDir)	
		}
	}
	;Fileremovedir,%MZA_Temp%,1
}
; GotoInstall(Dir) {{{2
GotoInstall(Dir)
{
	MenuZINI := A_ScriptDir "\MenuZ.ini"
	MenuZINIBak := A_ScriptDir "\MenuZ_Bak.ini"
	FileCopy,%MenuZINI%,%MenuZINIBak%,1
	FileCopyDir,%Dir%,%A_ScriptDir%,1
	InstallAppINI:= A_ScriptDir "\installapps.ini"
	Loop,8
	{
		If FileExist(InstallAppINI)
			Break
		Sleep,250
	}
	INIContent := IniReadValue(InstallAppINI)
	MZA_Name := IniReadValue(InstallAppINI,"Apps","Name")
	MZA_Author := IniReadValue(InstallAppINI,"Apps","Author")
	MZA_Dir := A_ScriptDir "\Apps\MZA"
	Loop,Parse,INIContent,`n,`r
	{
		If RegExMatch(A_LoopField,"i)^(apps)|(dest)|(filetree)$")
			Continue
		Section := A_LoopField
		IniItems := IniReadValue(InstallAppINI,A_LoopField)
		Loop,Parse,IniItems,`n,`r
		{
			If RegExMatch(A_LoopField,"=")
				Key := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
			Else
				Key := A_LoopField
			Value := IniReadValue(InstallAppINI,Section,key)
			IniWrite,%Value%,%MenuZINI%,%Section%,%Key%
		}
	}
	If Not InStr(FileExist(MZA_Dir),"D")
		Filecreatedir,%MZA_Dir%
	If RegExMatch(MZA_Author,"i)^Array$")
		Return
	Filemove,%InstallAppINI%,%MZA_Dir%\%MZA_Name%.ini,1
}
; ShowMZAInfo(Dir) {{{2
ShowMZAInfo(Dir)
{
	InstallAppINI := Dir "\installapps.ini"
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
	Gui,Installapp:Add,Button,x200 y210 w70 gInstallMZA,添加(&Y)
	Gui,Installapp:Add,Button,x290 y210 w70 gGuiClose,取消(&X)
	GUi,Show,w400 h245,MenuZ App
	Loop ; Block 脚本，等侍决定
	{
		IfWinExist,AHK_Id %Installid%
			Sleep,100
		Else
			Break
	}
	Return
	InstallMZA:
		GoSub,GUIClose
		GotoInstall(Dir)	
	Return
	GuiClose:
		Gui,Destroy
	Return
}
; MZA_Del(Param) {{{1
MZA_Del(Param)
{
	Count := Param[0]
	Loop,%Count%
	{
		ThisMZA := param[A_Index]
		UnInstallINI := A_ScriptDir "\Apps\MZA\" ThisMZA ".ini"
		If FileExist(UnInstallINI)
		{
			DeleteFileCount := IniReadValue(UnInstallINI,"FileTree","0",0)
			DeleteFileMsg := ""
			Loop,%DeleteFileCount%
				DeleteFileMsg .= IniReadValue(UnInstallINI,"FileTree",A_Index) "`n"
			Msgbox,4,"删除MZA", % "为免出错,MenuZ.ini中的配置内容请自行删除`n请确认要删除的内容`n" DeleteFileMsg
			IfMsgbox No
				Continue
		}
		Else
			Msgbox % "MZA """ ThisMZA """ 已经删除或不存在"
		Loop,%DeleteFileCount%
		{
			DeleteFile := IniReadValue(UnInstallINI,"FileTree",A_Index)
			If InStr(FileExist(DeleteFile),"D")
				FileRemoveDir,%DeleteFile%,1
			If FileExist(DeleteFile)
				Filedelete,%DeleteFile%
		}
		Filedelete,%UnInstallINI%
	}
}
; ToMatch(str) {{{1
ToMatch(str)
{
	str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
	Return RegExReplace(str,"\s","\s")
}
; IniReadValue(INIFile,Section="",Key="",Default="") {{{1
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

