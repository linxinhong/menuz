; Version  : 0.1
; Time     : 2013-05-22 19:05
; 感谢万能的AHK
; 感谢Candy(万年书妖)的理念，才有MenuZ的出现。MenuZ是由Candy演化而来的。
; 感谢Sunwind的大力支持和推动。
; 感谢小古、璀璨dē陽光、Evil、没什么大不了、汐潮等网友的意见和建议
; Init {{{1
#NoEnv
#SingleInstance,Force
Setworkingdir,%A_ScriptDir%
SetKeyDelay,-1
Scriptdir := A_ScriptDir
Coordmode,Menu,Screen
Coordmode,Mouse,Screen
;Fileencoding,UTF-8
Global INI := ScriptDir "\menuz.ini" ; 配置文件
Global ALLINI ; 每次读取INI时，会对ALLINI的文件列表进行遍历读取，默认只有INI
Global TempINI := INI ; 临时调用的INI
Global SaveString ;全局变量SaveString，在哪里都可以被读取
Global SaveClip   ;全局变量SaveClip，保存剪切板原始数据
Global SaveID ;保存当前选择的AHK_ID
Global SaveCtrl ;保存当前选择的Ctrl
Global ItemString ;保存执行的菜单内容
Global IconState 
Global RunOnce := ""
Global RunMode := ""
Global MenuZPos := Object()
Global MenuZItem := Object()
Global MenuZTextType := Object()
Global SystemEnv ; 用于保持所有系统变量名
Global AHK_BIEnv ; 用于保持所有系统变量名
Menu, Tray, UseErrorLevel ;来阻止显示对话框和终止线程,并启用ErrorLevel
;Menu, Tray, NoStandard
Menu, Tray, Add,显示变量(&S),OpenListLines
Menu, Tray, Add,调试窗口(&D),debuggui
Menu, Tray, Add,隐藏运行列表(&H),debuggui
Menu, Tray, Add,重启(&R),ScriptReload
Menu, Tray, Add,退出(&X),Quit
Menu, Tray, icon,%A_Scriptdir%\icons\menuz.ico
Inidelete,%INI%,Hide
/*
IniRead,DebugMode,%IN%,Config,Debug
If DebugMode = 1
	GoSub,debuggui
*/
MenuZTextType()
; 有参数时为只运行一次
if 0 = 1 
{
	RunOnce = %1%
	if RegExMatch(RunOnce,"i)\{mode[^\{\}]*\}")  ; 参数必须为{mode}或者{mode:xxxx}
		MeunzRun()
	Else
		Return
}
Else
	MenuZHotkey() ; 无参数时加载热键
; 加载所有可用的INI文件
MenuZLoadINI()
; 用于保持所有系统变量名
SystemEnv := A_Tab "ALLUSERSPROFILE" A_Tab "APPDATA" A_Tab "CD" A_Tab "CMDCMDLINE" A_Tab "CMDEXTVERSION" A_Tab "COMPUTERNAME" A_Tab "COMSPEC" A_Tab "DATE" A_Tab "ERRORLEVEL" A_Tab "HOMEDRIVE" A_Tab "HOMEPATH" A_Tab "HOMESHARE" A_Tab "LOGONSERVER" A_Tab "NUMBER_OF_PROCESSORS" A_Tab "OS" A_Tab "PATH" A_Tab "PATHEXT" A_Tab "PROCESSOR_ARCHITECTURE" A_Tab "PROCESSOR_IDENTFIER" A_Tab "PROCESSOR_LEVEL" A_Tab "PROCESSOR_REVISION" A_Tab "PROMPT" A_Tab "RANDOM" A_Tab "SYSTEMDRIVE" A_Tab "SYSTEMROOT" A_Tab "TEMP" A_Tab "TIME" A_Tab "USERDOMAIN" A_Tab "USERNAME" A_Tab "USERPROFILE" A_Tab "WINDIR" A_Tab
AHK_BIEnv := A_Tab "A_WorkingDir" A_Tab "A_ScriptDir" A_Tab "A_ScriptName" A_Tab "A_ScriptFullPath" A_Tab "A_ScriptHwnd" A_Tab "A_LineNumber" A_Tab "A_LineFile" A_Tab "A_ThisFunc" A_Tab "A_ThisLabel" A_Tab "A_AhkVersion" A_Tab "A_AhkPath" A_Tab "A_IsUnicode" A_Tab "A_IsCompiled" A_Tab "A_ExitReason" A_Tab "A_YYYY" A_Tab "A_MM" A_Tab "A_DD" A_Tab "A_MMMM" A_Tab "A_MMM" A_Tab "A_DDDD" A_Tab "A_DDD" A_Tab "A_WDay" A_Tab "A_YDay" A_Tab "A_YWeek" A_Tab "A_Hour" A_Tab "A_Min" A_Tab "A_Sec" A_Tab "A_MSec" A_Tab "A_Now" A_Tab "A_NowUTC" A_Tab "A_TickCount" A_Tab "A_IsSuspended" A_Tab "A_IsPaused" A_Tab "A_IsCritical" A_Tab "A_BatchLines" A_Tab "A_TitleMatchMode" A_Tab "A_TitleMatchModeSpeed" A_Tab "A_DetectHiddenWindows" A_Tab "A_DetectHiddenText" A_Tab "A_AutoTrim" A_Tab "A_StringCaseSense" A_Tab "A_FileEncoding" A_Tab "A_FormatInteger" A_Tab "A_FormatFloat" A_Tab "A_KeyDelay" A_Tab "A_WinDelay" A_Tab "A_ControlDelay" A_Tab "A_MouseDelay" A_Tab "A_DefaultMouseSpeed" A_Tab "A_RegView" A_Tab "A_IconHidden" A_Tab "A_IconTip" A_Tab "A_IconFile" A_Tab "A_IconNumber" A_Tab "A_TimeIdle" A_Tab "A_TimeIdlePhysical" A_Tab "A_Gui" A_Tab "A_GuiControl" A_Tab "A_GuiWidth" A_Tab "A_GuiHeight" A_Tab "A_GuiX" A_Tab "A_GuiY" A_Tab "A_GuiEvent" A_Tab "A_EventInfo" A_Tab "A_ThisHotkey" A_Tab "A_PriorHotkey" A_Tab "A_PriorKey" A_Tab "A_TimeSinceThisHotkey" A_Tab "A_TimeSincePriorHotkey" A_Tab "A_Temp" A_Tab "A_OSType" A_Tab "A_OSVersion" A_Tab "A_Is64bitOS" A_Tab "A_PtrSize" A_Tab "A_Language" A_Tab "A_ComputerName" A_Tab "A_UserName" A_Tab "A_WinDir" A_Tab "A_ProgramFiles" A_Tab "A_AppData" A_Tab "A_AppDataCommon" A_Tab "A_Desktop" A_Tab "A_DesktopCommon" A_Tab "A_StartMenu" A_Tab "A_StartMenuCommon" A_Tab "A_Programs" A_Tab "A_ProgramsCommon" A_Tab "A_Startup" A_Tab "A_StartupCommon" A_Tab "A_MyDocuments" A_Tab "A_IsAdmin" A_Tab "A_ScreenWidth" A_Tab "A_ScreenHeight" A_Tab "A_IPAddress1" A_Tab "A_IPAddress2" A_Tab "A_IPAddress3" A_Tab "A_IPAddress4" A_Tab "A_Cursor" A_Tab "A_CaretX" A_Tab "A_CaretY" A_Tab 
return
OpenListLines:
	Listlines
return
Quit:
	ExitApp
Return
ScriptReload:
	Reload
return
; Core {{{1
;/======================================================================/
; MenuZHotkey() {{{2
; 注册热键ini文件的Hotkey段
MenuZHotkey()
{
	;Iniread,hotkeys,%INI%,Hotkey
	HotKeys := IniReadValue(INI,"Hotkey")
	If Not Strlen(Hotkeys)
	{
		INIWrite,{mode},%INI%,Hotkey,!``
		HotKeys := IniReadValue(INI,"Hotkey")
	}
	Loop,Parse,Hotkeys,`n,`r
	{
		If RegExMatch(A_LoopField,"=")
			MZKey := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
		Else
			MZKey := A_LoopField
		Value := IniReadValue(INI,"Hotkey",MZKey,"{mode}")
		If Not RegExMatch(Value,"\{mode[^\{\}]*\}")
			INIWrite,{mode},%INI%,Hotkey,%MZKey%
		Hotkey,%MZKey%,<MenuZRun>,On,UseErrorLevel
		If ErrorLevel
			Msgbox % mzKey "热键定义有误"
	}
}
; MenuZLoadINI() {{{2
MenuZLoadINI()
{
	ALLINI := INI "`n"
	If IniReadValue(INI,"Config","ReadALLINI",0)
	{
		ConfigDir := A_ScriptDir "\Config"
		If FileExist(ConfigDir)
		{
			Loop,%ConfigDir%\*.*,0,1
			{
				If RegExMatch(A_LoopFileName,"i)\.ini$")
					ALLINI .= A_LoopFileFullPath "`n" 
			}
		}
	}
	ALLINI .= ReplaceVar(IniReadValue(INI,"Inifiles"),True)
	Return ALLINI
}
;/======================================================================/
; MenuZTextType() {{{2
; 读取自定义文本类型
MenuZTextType()
{
	IniRead,TextTypes,%INI%,TextType
	Loop,Parse,TextTypes,`n,`r
	{
		If RegExMatch(A_LoopField,"=")
		{
			TypeName := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
			TypeRegEx := Substr(A_LoopField,RegExMatch(A_LoopField,"=")+1)
			MenuZTextType[TypeName] := TypeRegEx
		}
	}
}
;/======================================================================/
<MenuZRun>:
	MeunzRun()
return
; MeunzRun() {{{2
MeunzRun()
{
	MenuZPos["MenuZ"] := 1
	If Select()
	{
		Type := GetType(SaveString)
		MenuZInit(Type)
		MenuZLoadINI()
		CreateMenu(Type,"MenuZ",ReadToMenuZItem(Type,ALLINI))
		If  MenuZItem[0] = 1  And ( Not RegExMatch(MenuZItem["MenuMode"],"i)\{mode\}") )
		{
			Item := MenuZItem[1]
			Interpreter(Item)
		}
		Else
			MenuZShow(Type)
	}
	
}
; MenuZInit(type) {{{2
MenuZInit(Type)
{
	;一级菜单清空
	Menu,MenuZ,Add
	Menu,MenuZ,DeleteAll
	; MenuZItem 数组清空
	MenuzItem := Object()
	MenuZItem["Default"] := ""
	; 多文件处理
	If Type = CLASS
	{
		Class := Substr(SaveString,7)
		Type := IniReadValue(INI,Class,"ClassName")
		WinGetTitle,ItemKey,AHK_CLASS %Class%
		ItemKey := AdjustString(ItemKey,16)
	}
	Else
	{
		MenuZItem["Default"] := "copy={save:clipall}"
		If RegExMatch(Type,"^Multifiles$")
		{
			idx_D := 0
			idx_F := 0
			Loop,Parse,SaveString,`n
			{
				If RegExMatch(GetType(A_LoopField),"^Folder$")
					idx_D++
				If RegExMatch(GetType(A_LoopField),"^(\..*)|(NoExt)")
					idx_F++
			}
			ItemKey := "共有目录" idx_D "个，文件" idx_F "个"
		}
		Else
		{
			m := "^" ToMatch(Type) "\|"
    		; 限定不长于20个字符
			ItemKey := AdjustString(Regexreplace(SaveString,m),16)
		}
	}
	Menu,MenuZ,Add,%ItemKey%,<Interpreter>
	Menu,MenuZ,Add
	SetTypeIcon("MenuZ",ItemKey,Type,True)
}
; MenuZShow(type) {{{2
MenuZShow(type)
{
	MenuZAddL("MenuZ")
	If Type = CLASS
	{
		Class := Substr(SaveString,7)
		Type := IniReadValue(INI,Class,"ClassName")
	}
	AddMenu := BeforeConfig "管理" Type "关联菜单"
	If RegExMatch(Type,"^Drive$")
		AddMenu := BeforeConfig "管理磁盘关联菜单"
	If RegExMatch(Type,"^Folder$")
		AddMenu := BeforeConfig "管理目录关联菜单"
	If RegExMatch(Type,"^Text$")
		AddMenu := BeforeConfig "管理文本关联菜单"
	If RegExMatch(Type,"^Multifiles$")
		AddMenu := BeforeConfig "管理多文件关联菜单"
	Menu,MenuZ,Add,%AddMenu%,<Config>
	Menu,MenuZ,Icon,%AddMenu%,%A_ScriptDir%\Icons\setting.ico
	ShowMenu(2)
	
}
ShowMenu(Max)
{
/*
	Count := MenuZItem[0]
	Loop,% Count
	{
		If RegExMatch(MenuZItem[A_Index],"^\[MenuZ\]")
			idx++
	}
	idx+=2
*/
	MouseGetPos,PosX,PosY
	;If Idx <= %Max% ; 短菜单
	;{
		xp := PosX - 50 > 0 ? PosX - 50 : 0
		yp := PosY - 12 > 0 ? PosY - 12 : 0
	;}
	;Else  ;长菜单
	;{
	;	xp := PosX - 50 > 0 ? PosX - 50 : 0
	;	yp := PosY - ((A_OSVersion=WIN_7?40:30)*(idx/2)) - (A_OSVersion=WIN_7?40:0)
	;}
	Menu,MenuZ,Show,%xp%,%yp%
}
<config>:
	Run %INI%
return
; 限制文本长度为Count,不够的话，补充空格
AdjustString(String,Count)
{
	String := RegExReplace(String,"(\t|\n|\r)"," ")
	If Strlen(String) <= Count
	{
		AddSpaceCount := Count - Strlen(String)
		Loop,% AddSpaceCount+2
			String .= A_Space
	}
	Else
		String := SubStr(String,1,Count/2) "..." Substr(String,-(count/2)+1)
	Return String
}
;/=======================================================================/
; MenuZAddL() {{{2
MenuZAddL(MenuName)
{
	If Strlen(MenuZPos[MenuName]) = 0
		MenuZPos[MenuName] := 2
	If MenuZPos[MenuName] > 1
		Menu,%MenuName%,Add
}
;/=======================================================================/
; Select() {{{2
; 获取数据,并根据数据内容返回相应的格式
; 如果是单文件，会保存扩展名加文件完全路径的形式
; Ex :  .lnk|D:\Desktop\word 2012.lnk
; 如果是单文件夹，会保存Folder加文件夹路径的形式
; Ex :  Folder|D:\Desktop\
; 如果是单文件夹，会保存Drive加文件夹路径的形式
; Ex :  Drive|D:\Desktop\
; 如果是单文件夹，会保存NoExt加文件夹路径的形式
; Ex :  NoExt|D:\Desktop\
; 多文件或者多文件夹的时候，就是叠加而已，回车换行
; Ex :  .lnk|D:\Desktop\word 2012.lnk
;       .lnk|D:\Desktop\notepad.lnk
;       .lnk|D:\Desktop\exploer.lnk
Select()
{
	WinGet,SaveID,ID,A
	ControlGetFocus,SaveCtrl,A
	MaxTimeWait := INIReadValue(INI,"Config","SelectOverTime",4)
	ClipSaved := ClipboardAll 
	Clipboard =
	Send ^c
	While(!Clipboard)
	{
		ClipWait,0.1,1
		If A_Index > %MaxTimeWait%
			Break
	}
	Select = %Clipboard% ; 强制转换为纯文本
	;Select := Clipboard
	SaveClip := ClipboardAll
	IsFile := DllCall("IsClipboardFormatAvailable","int",15)
	Clipboard := ClipSaved   
	ClipSaved =  
	If Strlen(Select) = 0 ; 如果选择无效，根据Class调用菜单
	{
		WinGetClass,Class,AHK_ID %SaveID%
		SaveString :=  "CLASS|" Class 
		Ifwinexist,MenuZ Debug
		{
			ControlSetText,Edit1,,MenuZ Debug
			ControlSetText,Edit1,%SaveString%,MenuZ Debug
		}
		Return SaveString
	}
	SaveString :=  ; 如果选择有效，清空当前保存的选择(SaveString)
	If RegExMatch(Select,"(^.:\\.*)|(^\\\\.*)") And IsFile ;文件或文件夹
	{
		If RegExMatch(Select,"\n") ;多文件
		{
			Loop,Parse,Select,`n,`r
			{
				If RegExMatch(A_LoopField,"[a-zA-Z]:\\$")
				{
					SaveString .= "Drive|" . A_LoopField . "`r`n"
					Continue	
				}
				Select_Attr := FileExist(A_LoopField)
				If RegExMatch(Select_Attr,"D") ;如果为目录时，用D加|，再加路径名
					SaveString .= "Folder|" . A_LoopField . "`r`n"
				Else
				{
					Splitpath,A_LoopField,,,Select_Extension
					;如果为文件时，以".扩展名"加|，再加路径，无扩展名时，只带"."，识别为文本文件
					If Select_Extension
						SaveString .= "." . Select_Extension . "|" . A_LoopField . "`r`n"
					Else
						SaveString .= "NoExt|" . A_LoopField . "`r`n"
				}
			}
		}
		Else ; 单文件
		{
			If RegExMatch(Select,"[a-zA-Z]:\\$")
				SaveString .= "Drive|" . Select ;. "`r`n"
			Else
			{
				Select_Attr := FileExist(Select)
				If RegExMatch(Select_Attr,"D") ;如果为目录时，用D加|，再加路径名
					SaveString .= "Folder|" . Select
				Else
				{
					Splitpath,Select,Select_Name,,Select_Extension
					If RegExMatch(Select_Extension,"i)^mza$")
					{
						Msgbox,4,,检测到MZA包，是否安装？
						IfMsgbox Yes
						{
							Run %A_ScriptDir%\Actman.ahk /a %Select%
							Return
						}
					}
					If Select_Extension
						SaveString .= "." . Select_Extension . "|" . Select
					Else
						SaveString .= "NoExt|" . Select ;. "`r`n"
				}
			}
		}
	}
	Else
		SaveString := TextType(Select) 
	Ifwinexist,MenuZ Debug
	{
		ControlSetText,Edit1,%SaveString%,MenuZ Debug
		ControlSetText,Edit2,,MenuZ Debug
		ControlSetText,Edit3,,MenuZ Debug
	}
	Return SaveString
}
;/=======================================================================/
; Interpreter() {{{2
; 替换内置变量
<Interpreter>:
	Interpreter()
return
Interpreter(Item="")
{
	If A_ThisMenuItemPos = 1  And RegExMatch(A_ThisMenu,"MenuZ")
		Item := MenuZItem["Default"]
	; 如果无相应的Item传入，则Loop获取当前Item的菜单内容
	If Strlen(Item) = 0 
	{
		Match := "^\[" ToMatch(A_ThisMenu) "\]" ToMatch(A_ThisMenuItem) "=.*"
		DelMatch := "\[" ToMatch(A_ThisMenu) "\]"
		For,index,key in MenuZItem
		{
			If RegExMatch(Key,Match)
				Item := RegExReplace(Key,DelMatch)
		}
	}
	ItemString := SubStr(Item,RegExMatch(Item,"=")+1)
	; 如果全局变量RunOnce存在，则设定MenuMode为RunOnce保存的模式来执行
	If RunOnce
		MenuMode := RunOnce
	Else
	{
    	; 读取模式
		IniRead,MenuMode,%INI%,Hotkey,%A_ThisHotkey%
		If RegExMatch(MenuMode,"i)^\{mode\}") OR RegExMatch(MenuMode,"^ERROR$")
			MenuMode := ""
	}
	; 定义执行所有Item的正则
	If Strlen(MenuMode) = 0 
		ModeAll := "i)\{mode:all\}"
	Else
		ModeAll := "i)" ToMatch(Substr(MenuMode,1,strlen(MenuMode)-1)) ":all\}"
	; 满足{mode:xxxx:all}时，执行所有当前模式的Item
	; 可以得出菜单项ItemString
	If RegExMatch(ItemString,ModeALL)
	{
		Loop, % MenuZItem[0]
		{
			LoopItemString := Substr(MenuZItem[A_Index],RegExMatch(MenuZIte[A_Index],"=")+1)
			LoopItemValue  := ReplaceSwitch(LoopItemString)
			Ifwinexist,MenuZ Debug
			{
				ControlGetText,Edit2_str,Edit2,MenuZ Debug
				Edit2_str .= "`n`n`n" LoopItemString
				ControlSetText,Edit2,%Edit2_str%,MenuZ Debug
				ControlGetText,Edit3_str,Edit3,MenuZ Debug
				Edit3_str .= "`n`n`n" LoopItemValue
				ControlSetText,Edit3,%Edit3_str%,MenuZ Debug
				Continue
			}
			Pos := RegExMatch(LoopItemValue,"i)\{send[^\}\{]*\}",Switch)
			If Pos
			{
				Block1 := SubStr(LoopItemValue,1,Pos-1)
				Pid := ToRun(Block1,RunMode)
				If Pid
					WinWaitActive,AHK_PID %PID%,,1
				If Not ErrorLevel OR Not Pid
				{	
					Block2 := Substr(LoopItemValue,Pos+strlen(Switch)+1)
					If RegExMatch(Switch,"i)\{send:key\}")
						Send %Block2%
					Else
						SendRaw,%Block2%
				}
			}
			Else
				ToRun(LoopItemValue,RunMode)
		}
	}
	Else
	{
		ItemValue := ReplaceSwitch(ItemString)
		Ifwinexist,MenuZ Debug
		{
			ControlSetText,Edit2,,MenuZ Debug
			ControlSetText,Edit2,%ItemString%,MenuZ Debug
			ControlSetText,Edit3,,MenuZ Debug
			ControlSetText,Edit3,%ItemValue%,MenuZ Debug
		}
		ELse
		{
			Pos := RegExMatch(ItemValue,"i)\{send[^\}\{]*\}",Switch)
			If Pos
			{
				Block1 := SubStr(ItemValue,1,Pos-1)
				Pid := ToRun(Block1,RunMode)
				If pid
					WinWaitActive,AHK_PID %PID%,,1
				If Not ErrorLevel OR Not Pid
				{	
					Block2 := Substr(ItemValue,Pos+strlen(Switch)+1)
					If RegExMatch(Switch,"i)\{send:key\}")
						Send %Block2%
					Else
						SendRaw %Block2%
				}
			}
			Else
				ToRun(ItemValue,RunMode)
		}
	}
	If Strlen(RunOnce)
		ExitApp
	SaveClip =
}
; ToRun(str,Mode="") {{{2
ToRun(str,Mode="")
{
	If RegExMatch(Mode,"i)^none$")
		return
	If RegExMatch(Mode,"i)^max$")
	{
    	Run %str%,,Max UseErrorLevel,runpid
		If ErrorLevel
			Traytip,错误,"运行"%str%"有误，请检查",10,3
		WinGet,m,MinMax,AHK_PID %runpid%
		If m = 1
			Return
		Else
			Winmaximize,AHK_PID %runpid%
	}
	If RegExMatch(Mode,"i)^min$")
	{
    	Run %str%,,min UseErrorLevel,runpid
		If ErrorLevel
			Traytip,错误,"运行"%str%"有误，请检查",10,3
		WinGet,m,MinMax,AHK_PID %runpid%
		If m = -1
			Return
		Else
			Winminimize,AHK_PID %runpid%
	}
	If RegExMatch(Mode,"i)^hide$")
	{
    	Run %str%,,hide UseErrorLevel,runpid
		If ErrorLevel
			Traytip,错误,"运行"%str%"有误，请检查",10,3
		WinGetPos,x,y,,,AHK_PID %runpid%
		If (x = "") and (y = "")
			return
		Else
			Winhide,AHK_PID %runpid%
		IniWrite,1,%INI%,Hide,%runpid%
	}
	If Not RegExMatch(Mode,"i)(max)|(min)|(hide)")
	{
    	Run %str%,,UseErrorLevel,runpid
		If ErrorLevel
			Traytip,错误,"运行"%str%"有误，请检查",10,3
	}
	If IniReadValue(INI,"Config","TrayTip",1)
		Traytip,运行结果,%Str%,10,1
	EmptyMem()
	return,runpid
}
;/======================================================================/
; ReadToMenuZItem(Type,INI,OnlyType=False) {{{2
; 要获取的Section段，一般为Type、子菜单名
; INI为INI文件列表
; 保存为多行字符串
ReadToMenuZItem(Type,INIFiles,OnlyType=False)
{
	IsClass := RegExMatch(Type,"^CLASS$")
	Select  := ReturnTypeString(SaveString)
	WinGetClass,ThisClass,AHK_ID %SaveID%
	ControlGetFocus,ThisControl,AHK_ID %SaveID%
	IconState := IniReadValue(INI,"config","HideIcon",0)
	MatchThisClass := ToMatch(ThisClass)
	MatchThisControl := ToMatch(ThisControl)
	MatchThisType  := ToMatch(Select.Type)
	MatchClass := "i)(^" MatchThisClass "\|)|(\|" MatchThisClass "\|)|(\|" MatchThisClass "$)|(^" MatchThisClass "$)"
	MatchControl := "i)(^" MatchThisControl "\|)|(\|" MatchThisControl "\|)|(\|" MatchThisControl "$)|(^" MatchThisControl "$)"
	MatchType := "i)(^" MatchThistype "\|)|(\|" MatchThistype "\|)|(\|" MatchThisType "$)|(^" MatchThistype "$)"
	MenuMode := Strlen(RunOnce) ? RunOnce : IniReadValue(INI,"Hotkey",A_Thishotkey,"{Mode}")
	MenuZItem["MenuMode"] := MenuMode
	MatchMode    := ToMatch(MenuMode)  ; 用于后继的正则比较
	MatchModeALL := "i)" ToMatch(Substr(MenuMode,1,strlen(MenuMode)-1)) ":all\}" ; 用于后继的ModeALL正则比较
	Match := ToMatch(Type)
	InMatch := "i)(^" Match "\|)|(\|" Match "\|)|(\|" Match "$)"  ; 模糊匹配
	If IsClass
		Type := SubStr(SaveString,7)   ;如果是CLASS的话，Type为CLASS| 后的内容
	Loop,Parse,INIFiles,`n,`r
	{
		LoopINI := A_LoopField
		If FileExist(LoopINI) 
		{
			TypeItem .= IniReadValue(LoopINI,Type) "`n" ; 最佳匹配优先
			If OnlyType 
				Continue
			ALLSection := IniReadValue(LoopINI) ; 读取当前循环INI的值
			Loop,Parse,ALLSection,`n,`;r
			{
				LoopSection := A_LoopField
				If RegExMatch(LoopSection,InMatch)
					FuzzyItem .= IniReadValue(LoopINI,LoopSection) "`n"
			}
			; 分类AnyFile,AnyText,AnyClass,Mfile
			If IsClass
				CategoryItem .= IniReadValue(LoopINI,"AnyClass") "`n"  ; 根据对象所属大类匹配
			Else
			{
				If RegExMatch(Type,"(^\.)|(^Folder$)|(^Drive$)|(^NoExt$)")
					CategoryItem .= IniReadValue(LoopINI,"AnyFile") "`n"
				Else
					If Not RegExMatch(Type,"^Multifiles$")   
						CategoryItem .= IniReadValue(LoopINI,"AnyText") "`n"
			}
			AnyItem .= IniReadValue(LoopINI,"Any") "`n"
		}
	}
	If OnlyType
		ALLItem := TypeItem
	Else
		ALLItem := TypeItem . FuzzyItem . CategoryItem . AnyItem
	Loop,Parse,ALLItem,`n,`r
	{
		LoopString := ReplaceVar(A_LoopField)
		If Not RegExMatch(LoopString,"[^\s\t]") OR ( RegExMatch(LoopString,"i)^ClassName=") And IsClass )
			Continue
		;Msgbox % A_LoopField "`n" LoopString "`n" ReplaceVar("%vim%")
		If Not RegExMatch(MenuMode,"i)\{mode\}")
			If ( Not RegExMatch(LoopString,MatchMode) ) And  ( Not RegExMatch(LoopString,MatchModeAll) )
				Continue
		If RegExMatch(LoopString,"i)\{default}",Switch)
		{
			LoopString := RegExReplace(LoopString,ToMatch(Switch))
			MenuZItem["Default"] := LoopString
		}
		; 根据 Class 类进行分辨
		If RegExMatch(LoopString,"i)\{class:[^\{\}]*\}",Switch)
		{
			LoopString := RegExReplace(LoopString,ToMatch(Switch))
			Mode := SubStr(Switch,8,1)
			Class := Substr(Switch,9,strlen(Switch)-9)
			If ( Not RegExMatch(Class,MatchClass) And RegExMatch(Mode,"=") ) OR ( RegExMatch(Mode,"!") AND  RegExMatch(Class,MatchClass) )
				Continue
		}
		; 根据control 来决定要哪个菜单
		If RegExMatch(LoopString,"i)\{control:[^\{\}]*\}",Switch)
		{
			LoopString := RegExReplace(LoopString,ToMatch(Switch))
			Mode := SubStr(Switch,10,1)
			Control := Substr(Switch,11,strlen(Switch)-11)
			If ( Not RegExMatch(Control,MatchControl) And RegExMatch(Mode,"=") ) OR ( RegExMatch(Mode,"!") AND  RegExMatch(Control,MatchControl) )
				Continue
		}
		; 根据 type 来决定要哪个菜单
		If RegExMatch(LoopString,"i)\{type:[^\}]*\}",Switch)
		{
			LoopString := RegExReplace(LoopString,ToMatch(Switch))
			Mode := SubStr(Switch,7,1)
			thistype := Substr(Switch,8,strlen(Switch)-8)
			If ( Not RegExMatch(thistype,MatchType) And RegExMatch(Mode,"=") ) OR ( RegExMatch(Mode,"!") AND  RegExMatch(thistype,MatchType) )
				Continue
		}
		; 根据 name 来决定要哪个菜单
		If RegExMatch(LoopString,"i)\{name:[^\}]*\}",Switch) AND RegExMatch(Select.Type,"(^\.)|(^Folder$)|(^Drive$)|(^NoExt$)")
		{
			LoopString := RegExReplace(LoopString,ToMatch(Switch))
			Mode := SubStr(Switch,7,1)
			MatchThisName  := Substr(Switch,8,strlen(Switch)-8)
			thisname := SplitpathNameOnly(Select.String)
			MatchName := ""
			Loop,Parse,MatchThisName,|
				MatchName .= "(" ToMatch(A_LoopField) ")|"
			MatchName := "i)" SubStr(MatchName,1,Strlen(MatchName)-1)
			If ( Not RegExMatch(thisname,MatchName) And RegExMatch(Mode,"=") ) OR ( RegExMatch(Mode,"!") AND  RegExMatch(thisname,MatchName) )
				Continue
		}
		NewALLItem .= LoopString "`n"
	}
	Return NewALLItem
}
; 根据数组内容创建Menu
; CreateMenu(Type,MenuName,ALLItem="") {{{2
CreateMenu(Type,MenuName,ALLItem="",Enforcement=False)
{
	RunMode := ""
	MatchItem := "i)\t" ToMatch(MenuName) "\t"
	If RegExMatch(MenuZItem["Menus"],MatchItem) And ( Not Enforcement )
		return False
	Else
		MenuZItem["Menus"] .= A_Tab MenuName A_Tab
	If Not RegExMatch(MenuName,"i)MenuZ")
	{
		Menu,%MenuName%,Add
		Menu,%MenuName%,DeleteAll
	}
	Loop,Parse,ALLItem,`n,`r
	{
		LoopString := A_LoopField
		If Not RegExMatch(LoopString,"[^\s\t]") 
			Continue
		;If RegExMatch(LoopString,">>[^=]*=")
		If RegExMatch(LoopString,"^[^=]*\\[^=]*=")
		{
			OLkey := Substr(LoopString,1,RegExMatch(LoopString,"\\")-1)
			SubMenuName := OLKey
			LoopString := OLKey
			MatchOLKey := "^" ToMatch(OLKey) "\\"
			SubMenuItems := ""
			Loop,Parse,ALLItem,`n,`r
			{
				If RegExMatch(A_LoopField,MatchOLKey)
					SubMenuItems .= RegExReplace(A_LoopField,MatchOLKey) "`n"
			}
			If CreateMenu(Type,SubMenuName,SubMenuItems,True)
				IsSubMenuName := True
			Else
				Continue
		}
		If RegExMatch(LoopString,"i)\{SubMenu:[^\{\}]*\}",Switch)
		{
			SubMenuName := ReplaceVar(Substr(Switch,10,strlen(Switch)-10))
			If CreateMenu(Type,SubMenuName,ReadToMenuZItem(SubMenuName,TempINI,True))
				IsSubMenuName := True
			Else
				Continue
		}
		If RegExMatch(LoopString,"i)\{inifile:[^\{\}]*\}",Switch)
		{
			INIFile := ReplaceVar(Substr(Switch,10,strlen(Switch)-10))
			SubMenuName := SubStr(LoopString,1,RegExMatch(LoopString,"=")-1)
			If Not RegExMatch(INIFile,"(^.:\\.*)|(^\\\\.*)")
				INIFile := A_ScriptDir "\" INIFile
			Splitpath,INIFile,,,,INIType
			SaveALLINI := TempINI
			TempINI := INIFile
			;Msgbox % SubMenuName  "`n" ReadToMenuZItem(INIType,INIFile,True)
			If CreateMenu(Type,SubMenuName,ReadToMenuZItem(INIType,INIFile,True),True)
			{
				IsSubMenuName := True
				TempINI := SaveALLINI
			}
			Else
				Continue
		}
		If RegExMatch(LoopString,"=")
			ItemKey := SubStr(LoopString,1,RegExMatch(LoopString,"=")-1)
		Else
			ItemKey := LoopString
		ItemValue := SubStr(LoopString,RegExMatch(LoopString,"=")+1)
		If RegExMatch(ItemKey,"^-$")
			MenuZAddL(MenuName)
		Else
		{
			If Not RegExMatch(LoopString,"i)\{hide\}")
			{
				If IsSubMenuName 
				{
					Menu,%MenuName%,Add,%ItemKey%,:%SubMenuName%
					IsSubMenuName := False
				}
				Else
					Menu,%MenuName%,Add,%ItemKey%,<Interpreter>
				If ErrorLevel
					Continue
				Else
					SetTypeIcon(MenuName,ItemKey,ItemValue)
			}
			Pos := MenuZItem[0]
			Pos++
			MenuZItem[0] := Pos
			MenuzItem[Pos] := "[" MenuName "]" LoopString
			MenuZPos[MenuName]++
		}
	}
	Return True
}
; TextType(Text) {{{2
; 根据正则式返回相应的文本类型
; 内置正则式，及INI定义正则式
TextType(Text)
{
	;http://www.baidu.com
	;ftp://192.168.1.1
	If RegExMatch(Text,"^\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))")
		Return "URL|" Text
	;If RegExMatch(Text,"i)ftps?://.*")
	;	Return "FTP|" Text
	;If RegExMatch(Text,"i)\\\\.*")
	;	Return "SHARE|" Text
	;If RegExMatch(Text,"i)\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*")
	;	Return "EMAIL|" Text
	For,TypeName,TypeRegEx IN MenuZTextType
	{
		If RegExMatch(Text,TypeRegEx)
			Return TypeName "|" Text
	}
	Return "Text|" Text
}
;/=======================================================================/
; GetType(str) {{{2
; 返回获取数据的类型
; 1、文件：根据后缀返回类型，如.lnk .doc .docx 等
; 2、文件夹：返回D
; 3、多文件（夹）:返回M
; 4、文本：根据正则式返回相应的文本类型，如果无相关定义，返回Type
GetType(str)
{
	If RegExMatch(str,"^((\..*)|(Folder)|(NoExt)|(Drive))\|")
	{
		If RegExMatch(str,"\n")
			Return "Multifiles"
	}
	Return SubStr(str,1,RegExMatch(str,"\|")-1)
}
;/=======================================================================/
; SetTypeIcon(MenuName,ItemKey,ItemValue,Ext=False) {{{2
; 当Ext为True时，寻找ItemValue对应后缀名的Icon，并应用到MenuZItem上
SetTypeIcon(MenuName,ItemKey,ItemValue,Ext=False)
{
	If Ext
	{
		If RegExMatch(ItemValue,"^Multifiles$")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"135")
		If RegExMatch(ItemValue,"^Drive$")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"9")
		If RegExMatch(ItemValue,"^Folder$")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"4")
		If RegExMatch(ItemValue,"i)^\.lnk$")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"264")
		If RegExMatch(ItemValue,"^NoExt$")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"291")
		If RegExMatch(ItemValue,"^[^\.]")
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"268")
		If RegExMatch(ItemValue,"i)\.exe")
		{
			Match := ToMatch(ItemValue) "\|"
			Path := RegExReplace(SaveString,Match)
			Return ReturnIcon(MenuName,ItemKey,Path,1)
		}
		RegRead,file,HKEY_CLASSES_ROOT,%ItemValue%
		RegRead,IconString,HKEY_CLASSES_ROOT,%file%\DefaultIcon
		If ErrorLevel
			Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%systemroot%\system32\Shell32.dll"),"291")
		If RegExMatch(IconString,"%1")
		{
			RegRead,IconPath,HKCR,%file%\Shell\Open\Command
			tm = `"
			IconPath := LTrim(ReplaceVar(IconPath),tm)
			Loop,% Strlen(IconPath)
			{
				Loop_exec := SubStr(IconPath,1,strlen(IconPath)-A_Index)
				If FileExist(Loop_exec)
					Break
			}
			IconPath := Loop_exec
			IconIndex := 2
			Return ReturnIcon(MenuName,ItemKey,IconPath,IconIndex)
		}
		Else
		{
			IconPath := RegExReplace(ReplaceVar(IconString),",-?\d*","")
			IconIndex := RegExReplace(IconString,".*,","")
		}
		If Not RegExMatch(IconIndex,"^-?\d*$")
			IconIndex := ""
		Else
		{
			If IconIndex >= 0
				IconIndex++
		}
		Return ReturnIcon(MenuName,ItemKey,IconPath,IconIndex)
	}
	If IconState = 2
		Return
	; {icon:icons\google.ico|2|16}
	If RegExMatch(ItemValue,"i)\{icon:[^\}]*\}",Icon) And ( IconState <> 1 )
	{
		Icon := SubStr(icon,7,strlen(icon)-7)
		Loop,Parse,Icon,|
			Icon%A_Index% := A_LoopField
		Return ReturnIcon(MenuName,ItemKey,Icon1,Icon2,Icon3)
	}			
	Loop,% Strlen(ItemValue)
	{
		Executable := SubStr(ItemValue,1,strlen(ItemValue)-A_Index+1)
		If Strlen(ItemValue) = %A_Index%
			Break
		If FileExist(Executable)
		{	
			Executable := Trim(Executable)
			If RegExMatch(Executable,"i).*\.exe$")
			{
				IconPath := Executable
				IconIndex := 0
			}
			Else
			{
				RegExMatch(Executable,"\.[^\.]*$",OutType)
				IconValue := SetTypeIcon(MenuName,"",OutType,True)
				IconPath := SubStr(IconValue,1,RegExMatch(IconValue,"\|")-1)
				IconIndex := SubStr(IconValue,RegExMatch(IconValue,"\|")+1)
			}
			Return ReturnIcon(MenuName,ItemKey,IconPath,IconIndex)
		}
	}
	If IniReadValue(INI,"config","DefaultIcon",1) And ( IconState <> 1 )
		Return ReturnIcon(MenuName,ItemKey,ReplaceVar("%Icons%\default.ico"),1)
	else
		Return 
}
;/=======================================================================/
ReturnIcon(MenuName,ItemKey,IconPath,IconIndex,Iconsize="")
{
	If ItemKey
	{
		IconPath := ReplaceVar(IconPath)
		Menu,%MenuName%,Icon,%ItemKey%,%IconPath%,%IconIndex%,%Iconsize%
		If ErrorLevel
		{
			If FileExist(IconPath) 
			{
				IconPath := ReplaceVar("%systemroot%\system32\Shell32.dll")
				IconIndex := 3
				Menu,%MenuName%,Icon,%ItemKey%,%IconPath%,%IconIndex%,%Iconsize%
			}
		}
	}
	return IconPath "|" IconIndex
}
;/=======================================================================/
; GetOpenWithList(Type) {{{2
; 根据注册表获取当前扩展名的对应打开列表，并保存到MeunZ.auto文件中
GetOpenWithList(Type,AutoINI)
{
/*
	IniRead,sid,%AutoINI%,%Type%,sid
	If RegExMatch(sid,"\d{8}") And substr(sid,1,1)
	{
		sid := "1" . Substr(sid,2)
		Return
	}
	Else
	{
		sid := "10000000"
		IniWrite,10000000,%AutoINI%,%Type%,sid
	}
*/
	RegRead,exec,HKCR,%Type%
	RegRead,exec,HKCR,%exec%\Shell\Open\Command
	m .= exec "`n"
	Loop,HKCR,%Type%\OpenWithList,1,1
	{
		RegRead,exec
		If RegExMatch(exec,"i).*\..*$")
		{
			RegRead,exec_path,HKCR,Applications\%exec%\shell\Open\Command\,
			If exec_path
				m .= exec_path "`n"
			Else
			{
				RegRead,exec_path,HKCR,Applications\%exec%\shell\Edit\Command\,
				If exec_path
					m .= exec_path "`n"
			}
		}
	}
	Loop,HKCU,Software\Classes\%Type%\OpenWithList,1,1
	{
		RegRead,exec
		If RegExMatch(exec,"i).*\..*$")
		{
			RegRead,exec_path,HKCR,Applications\%exec%\shell\Open\Command\,
			If exec_path
				m .= exec_path "`n"
			Else
			{
				RegRead,exec_path,HKCR,Applications\%exec%\shell\Edit\Command\,
				If exec_path
					m .= exec_path "`n"
			}
		}
	}
	Loop,HKCU,Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\%Type%\OpenWithList,1,1
	{
		RegRead,exec
		If RegExMatch(exec,"i).*\..*$")
		{
			RegRead,exec_path,HKCR,Applications\%exec%\shell\Open\Command\,
			If exec_path
				m .= exec_path "`n"
			Else
			{
				RegRead,exec_path,HKCR,Applications\%exec%\shell\Edit\Command\,
				If exec_path
					m .= exec_path "`n"
			}
		}
	}
	Loop,Parse,m,`n
	{
		If A_LoopField
		{
			Loop_str := RegExReplace(ReplaceVar(A_LoopField),"""","",outvar,1)
			Loop,% Strlen(Loop_str)
			{
				Loop_exec := SubStr(Loop_str,1,strlen(Loop_str)-A_Index)
				If FileExist(Loop_exec)
					Break
			}
			If FileExist(Loop_exec)
				k := FileGetVersionInfo_AW(Loop_exec,"FileDescription")
			Else
				Continue
			If RegExMatch(Loop_Str,"%1")
				s := RegExReplace(Loop_Str,"%1","{file:path}")
			Else
				s := Loop_Str . " {file:path}"
			;If s and k
			;IniWrite,%s%,%AutoINI%,%Type%,%k%
		}
	}
	Return S
}
;/======================================================================/
; ReplaceVar(str){{{2
; 替换变量
ReplaceVar(str,OnlyINI=False)
{
	Pos := 1
	If OnlyINI
		LoopINI := INI
	Else
		LoopINI := MenuZLoadINI()
	Loop
	{
		Pos := RegExMatch(str,"i)%[^%]*%",UserVar,Pos)
		If Pos
		{
			var := SubStr(UserVar,2,Strlen(UserVar)-2)
			If Strlen(var) = 0
				Break
			IsUserVar := False
			Loop,Parse,LoopINI,`n,`r
			{
				INIRead,Env,%A_LoopField%,Env,%Var%
				IF Env <> ERROR
				{
					IsUserVar := True
					Break
				}
			}
			If IsUserVar ; 用户变量最大
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			Else If RegExMatch(var,"i)^apps$")  ; MZ内置变量
			{
				Env := A_ScriptDir "\apps"
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else If RegExMatch(var,"i)^config$")
			{
				Env := A_ScriptDir "\config"
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else If RegExMatch(var,"i)^Extensions$")
			{
				Env := A_ScriptDir "\Extensions"
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else If RegExMatch(var,"i)^icons$")
			{
				Env := A_ScriptDir  "\icons"
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else If RegExMatch(var,"i)^Scriptdir$")
			{
				Env := A_ScriptDir 
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else
			{
				; AHK内置变量
				; 系统变量
				MatchVar := "i)\t" ToMatch(Var) "\t"
				If RegExMatch(AHK_BIEnv,MatchVar)
				{
					Env := %Var%
					Str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
				}
				Else If RegExMatch(SystemEnv,MatchVar)
				{
					EnvGet,Env,%var%
					Str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
				}
			}
		}
		Else
			Break
		Pos += Strlen(Env)
	}
	Return str
}
; ReplaceSwitch(MenuString) {{{2
; 清除预处理的开关
ClearRealSwitch(String)
{
	; 以下开关全部用于预处理
	; {run} {{{3
	If RegExMatch(String,"i)\{run:[^\}\}]*\}",MatchRun)
		RunMode := SubStr(MatchRun,6,strlen(MatchRun)-6)
	String := RegExReplace(String,"i)\{run:[^\}\}]*\}")
	; {hide} {{{3
	String := RegExReplace(string,"i)\{hide}")
	; {icon} {{{3
	String := RegExReplace(String,"i)\{icon:[^\}]*\}")
	; {class} {{{3
	String := RegExReplace(String,"i)\{class:[^\}]*\}")
	; {mode} {{{3
	String := RegExReplace(String,"i)\{mode:[^\}]*\}")
	; {type} {{{3
	String := RegExReplace(String,"i)\{type:[^\}]*\}")
	; {Default} {{{3
	String := RegExReplace(String,"i)\{default\}")
	; {control} {{{3
	String := RegExReplace(String,"i)\{control:[^\}]*\}")
	; {name} {{{3
	String := RegExReplace(String,"i)\{name:[^\}]*\}")
	Return String
}
ReplaceSwitch(MenuString)
{
	Global SaveString
	; 如果无内容不进行多余处理
	If RegExMatch(MenuString,"^[\s\t\n\r]*$")
		Return
	Select := Object()
	Select := ReturnTypeString(SaveString)
	; 清除所有用于预处理的开关
	MenuString := ClearRealSwitch(MenuString)
	; 查看设置里是否需要将Lnk文件读取成目标而不是Lnk本身
	LnkToDest := IniReadValue(INI,"config","LnkToDest",0)
	; 单文件预处理
	file := RegExReplace(Select.String,"[\n\r\t]*")
	If FileExist(file)
	{
		If RegExMatch(Select.Type,"i)^\.lnk$") And LnkToDest
			FileGetShortcut,%file%,file
		Splitpath,file,Name,Dir,Ext,NameNoExt,Drive
		Drive .= "\"
		DirName := SplitpathNameOnly(Dir)
	}
	Else
		File := ""
	; 多文件预处理
	MfileArray := Object()
	If RegExMatch(Select.Type,"i)^Multifiles$")
	{
		MfileArray["All"]  := ""
		MfileArray["File"] := ""
		MfileArray["Dir"]  := ""
		MfileArray["AllName"]  := ""
		MfileArray["FileName"] := ""
		MfileArray["DirName"]  := ""
		; 对多文件列表进行循环，分类出文件列表和文件夹列表以及文件（夹）名列表
		AllString := Select.String
		Loop,Parse,AllString,`n,`r
		{
			If Strlen(A_LoopField) = 0
				Continue
			; 如果当前选择内容为多文件时,没有进行单文件预处理，file变量为空
			; 而菜单内容里的{file}类开关，只对当前选择的首个文件有效
			If Strlen(file) = 0
			{
				file := Substr(A_LoopField,RegExMatch(A_LoopField,"\|")+1)
				Splitpath,file,Name,Dir,Ext,NameNoExt,Drive
				Drive .= "\"
				DirName := SplitpathNameOnly(Dir)
			}
			Mfile_ThisOne := ReturnTypeString(A_LoopField)
			If RegExMatch(Mfile_ThisOne.Type,"i)^Folder$")
			{
				MfileArray["Dir"] .= Mfile_ThisOne.String "`r`n"
				MfileArray["All"] .= Mfile_ThisOne.String "`r`n"
				MdirName := SplitpathNameOnly(Mfile_ThisOne.String) "`r`n"
				MfileArray["DirName"] .= MdirName
				MfileArray["AllName"] .= MdirName
			}
			Else
			{
				If RegExMatch(Mfile_ThisOne.Type,"i)^\.lnk") And LnkToDest
				{
					lnkfile := Mfile_ThisOne.String
					FileGetShortcut,%lnkfile%,lnkfile
					Mfile_ThisOne.String := lnkfile
				}
				MfileArray["File"] .= Mfile_ThisOne.String "`r`n"
				MfileArray["All"] .= Mfile_ThisOne.String "`r`n"
				MfileName := SplitpathNameOnly(Mfile_ThisOne.String) "`r`n"
				MfileArray["FileName"] .= MfileName 
				MfileArray["AllName"] .= MfileName
			}
		}
	}
	Pos := 1
	While Pos
	{
		Pos := RegExMatch(MenuString,"i)\{[^\{\}]*\}",Switch,Pos)
		RString := Switch
		If Not Pos
			Break
		; {mfile} {{{3
		If RegExMatch(Switch,"i)\{mfile[^\{\}]*\}",mfileSwitch)
		{
			If RegExMatch(Select.Type,"^Multifiles$")
				RString := StringByMfile(mfileSwitch,MfileArray)
			Else
				RString := file
		}
		; {file} {{{3
		If RegExMatch(Switch,"i)\{file[^\{\}]*\}",fileSwitch)
		{
			Path := File
			RString := SubStr(fileswitch,7,strlen(fileswitch)-7)
			If RegExMatch(RString,"i)^content$")
			{
				Size := IniReadValue(INI,"config","MaxContentSize",1)
				FileGetSize,OutSize,%file%,M
				If OutSize < size
					FileRead,RString,%file%
				Else
					RString := ""
			}
			Else
				If RegExMatch(RString,"i)^(path)|(name)|(dir)|(ext)|(namenoext)|(drive)|(Content)$")
					RString := %RString%
		}
		; {Select} {{{3
		If RegExMatch(Switch,"i)\{select[^\{\}]*}",SelectSwitch)
		{
			If RegExMatch(SelectSwitch,"i)\{select\}")
				RString := Select.String
			Else 
				If RegExMatch(SelectSwitch,"i)\{Select\[[^\[\]]*\]\}")
				{
					EncodeMode := SubStr(SelectSwitch,9,strlen(SelectSwitch)-10)
					RString := SksSub_UrlEncode(Select.String,EncodeMode)
				}
			/*
			Else
			{
				; {Select:RegEx} {{{3
				var := "%" SubStr(SelectSwitch,9,strlen(SelectSwitch)-9) "%"
				RegExMatch(Select.String,ReplaceVar(var),RString)
			}
			*/
		}
		; {box} {{{3
		If RegExMatch(Switch,"i)\{box:[^\{\}]*\}")
		{
			; {box:input} {{{4
			If RegExmatch(Switch,"i)\{box:input[^\{\}]*\}")
			{
				InputPrompt := SubStr(Switch,12,Strlen(Switch)-12)
				Inputbox,RString,请输入内容,`n`n`t%InputPrompt%
				If ErrorLevel
					Return
			}
			; {box:password} {{{4
			If RegExmatch(Switch,"i)\{box:password[^\{\}]*\}")
			{
				PwdPrompt := SubStr(Switch,15,Strlen(Switch)-15)
				Inputbox,RString,请输入内容,`n`n`t%PwdPrompt%,Hide
				If ErrorLevel
					Return
			}
			; {box:file} {{{4
			If RegExMatch(Switch,"i)\{box:file\}",bm)
			{
				FileSelectFile,RString,M11,,查找文件
				If ErrorLevel
					Return
			}
			If RegExmatch(Switch,"i)\{box:file((open)|(save))[^\{\}]*\}")
			{
				; Box:fileopen:Prompt,Filter,Openfile,RootDir
				Opt := SubStr(Switch,15,Strlen(Switch)-15)
				Loop,Parse,Opt,`,
				{
					If A_Index = 1
						fPrompt := A_LoopField
					If A_Index = 2
						Filter := A_LoopField
					If A_Index = 3
						Openfile := A_LoopField
					If A_Index = 4
						RootDir := A_LoopField
				}
				If RegExmatch(Switch,"i)\{box:fileopen")
					option := "M11"
				If RegExmatch(Switch,"i)\{box:filesave")
					option := "S25"
				FileSelectFile,RString,%option%,%OpenRootDir% %Openfile%,%fPrompt%,%Filter%
				If ErrorLevel
					Return
				Else
					If option = S25
						FileAppend,"",%RString%
			}
			; {box:dir} {{{4
			If RegExMatch(Switch,"i)\{box:dir\}")
			{
				FileSelectFolder,RString,,3,查找文件夹
				If ErrorLevel
					Return
			}
			If RegExMatch(Switch,"i)\{box:dir:.*\}")
			{
				; box:dir:Prompt,StartingFolder
				Opt := SubStr(Switch,10,Strlen(Switch)-10)
				Loop,Parse,Opt,`,
				{
					If A_Index = 1
						dPrompt := A_LoopField
					If A_Index = 2
						StartingFolder := A_LoopField
				}
				FileSelectFolder,RString,%StartingFolder%,3,%dPrompt%
			}
		}
		; {date} {{{3
		If RegExMatch(Switch,"i)\{date\:?[^\{\}]*\}")
		{
			TimeString := RegExReplace(Switch,"i)^(\{date\:?)|(\}$)")
			Loop,Parse,TimeString,`,
				Time%A_index% := A_LoopField
			If Time2
				FormatTime,RString,,%Time1%,%Time2%
			Else
				If Time1
					FormatTime,RString,,%Time1%
				Else
					FormatTime,RString
		}
		; {func} {{{3
		If RegExMatch(Switch,"i)\{Func:[^\{\}]*\}")
		{
			Func := Substr(Switch,7,strlen(Switch)-7)
			RString := CheckExtension(Func) 
		}
		If RegExMatch(Switch,"i)\{clip\}")
			RString := Clipboard
		; {save} {{{3
		If RegExMatch(Switch,"i)\{save:[^\{\}]*\}")
		{
			; {save:ClipAll}  {{{4
			; 将原始的选择内容保存到剪切板中
			If RegExMatch(Switch,"i)\{save:clipAll\}")
			{
				MatchClipAll := Switch
				RString := ""
			}
			; {save:clip}  {{{4
			; 将替换完毕的内容保存到剪切板中
			Else If RegExMatch(Switch,"i)\{save:clip\}")
				{
					MatchClip := Switch
					RString := ""
				}
			; {save:assc} {{{4
				Else
					If RegExMatch(Switch,"i)\{save:[^\{\}]*\}")
					{
						SavePath := A_Temp "\MenuZ." Substr(Switch,7,strlen(Switch)-7)
						If RegExMatch(Select.Type,"^Multifiles$")
							SaveString := MfileArray["ALL"]
						Else
							SaveString := Select.String
						If FileExist(SavePath)
							FileDelete,%SavePath%
						FileAppend,%SaveString%,%SavePath% ;,UTF-8
						RString := SavePath
					}
		}
		; {SendMsg} {{{3
		If RegExMatch(Switch,"i)\{sendmsg:[^\{\}]*\}")
		{
			;SendMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
			MsgString := SubStr(Switch,10,Strlen(Switch)-10)
			S_Msg := S_wParam := S_lParam := S_Mode := SendMsgHwnd := ""
			Loop,Parse,MsgString,`,
			{
				If A_Index = 1
					S_Msg := A_LoopField
				If A_Index = 2
					S_wParam := A_LoopField
				If A_Index = 3
					S_lParam := A_LoopField
				If A_Index = 4
					S_Mode := A_LoopField
			}
			If S_Mode = 1
				ControlGet,SendMsgHwnd,hwnd,,%SaveCtrl%,AHK_ID %SaveID%
			Else
				SendMsgHwnd := SaveID
			SendMessage, %S_Msg% , %S_wParam% , %S_lParam% , , AHK_ID %SendMsgHwnd%
			If ErrorLevel = FAIL
			{
				RString := ""
				Msgbox % "SendMessage出错"
			}
			Else
				RString := ErrorLevel
		}
		; {PostMsg} {{{3
		If RegExMatch(Switch,"i)\{Postmsg:[^\{\}]*\}")
		{
			;PostMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]
			MsgString := SubStr(Switch,10,Strlen(Switch)-10)
			P_Msg := P_wParam := P_lParam := P_Mode := PostMsgHwnd := ""
			Loop,Parse,MsgString,`,
			{
				If A_Index = 1
					P_Msg := A_LoopField
				If A_Index = 2
					P_wParam := A_LoopField
				If A_Index = 3
					P_lParam := A_LoopField
				If A_Index = 4
					P_Mode := A_LoopField
			}
			If S_Mode = 1
				ControlGet,PostMsgHwnd,hwnd,,%SaveCtrl%,AHK_ID %SaveID%
			Else
				PostMsgHwnd := SaveID
			PostMessage, %P_Msg% , %P_wParam% , %P_lParam% , , AHK_ID %PostMsgHwnd%
			If ErrorLevel
				Msgbox % "PostMessage出错"
			RString := ""
		}
/*
		; {Send} {{{3
		If RegExMatch(Switch,"i)\{Send\}")
		{
			MatchSend := Switch
			RString := ""
		}
		; {send:key} {{{4
		If RegExMatch(Switch,"i)\{Send:Key\}")
		{
			MatchSendKey := Switch
			RString := ""
		}
*/
		MenuString := RegExReplace(MenuString,ToMatch(Switch),ToReplace(RString),"",1,Pos)
		Pos += Strlen(RString)
	}
	If Strlen(MatchClipAll)
	{
		Clipboard := SaveClip
		MatchClipAll := ""
	}
	If Strlen(MatchClip)
	{
		Clipboard := MenuString
		MatchClip := ""
	}
/*
	If Strlen(MatchSend)
	{
		SendRaw,%MenuString%
		MatchSend := ""
	}
	If Strlen(MatchSendKey)
	{
		Send,%MenuString%
		MatchSendKey := ""
	}
*/
	Return MenuString
}
; StringByMfile(Switch,MfileArray) {{{2
StringByMfile(Switch,MfileArray)
{
	opt := Strlen(Switch) <> 7 ? ":" SubStr(Switch,8,Strlen(Switch)-8) : ""
	If Strlen(Opt) = 0
		Return MfileArray["All"]
	; 如果没有加:  则{mfile:=aaa}识别的选项就是=aaa，需要加冒号，以便进行循环分析
	opt := RegExReplace(opt,"mfile")
	If RegExMatch(opt,"i)(:((filename)|(file)|(dirname)|(dir)|(allname)|(all))$)|(:((filename)|(file)|(dirname)|(dir)|(allname)|(all))(?=:))",List)
	{
		RString := MfileArray[RegExReplace(List,":")]
		opt := RegExReplace(opt,ToMatch(List),"",outputvar,1)
	}
	Else
		RString := MfileArray["ALL"]
	If RegExMatch(opt,":=[^:]*",In) 
	{
		IsInClude := True
		opt := RegExReplace(opt,ToMatch(In))
		In := Substr(In,3)
		Loop,Parse,In,|
			Include .= "(" RegExReplace(RegExReplace(A_LoopField,"\s"),"\+|\?|\.|\*|\{|\}|\(|\)|\||\[|\]|\\","\$0") ")|"
		InClude := "i)" SubStr(Include,1,Strlen(Include)-1)
	}
	Else
		IsInClude := False
	If RegExMatch(opt,":![^:]*",Ex) 
	{
		IsExClude := True
		opt := RegExReplace(opt,ToMatch(Ex))
		Ex := Substr(Ex,3)
		Loop,Parse,Ex,|
			Exclude .= "(" RegExReplace(RegExReplace(A_LoopField,"\s"),"\+|\?|\.|\*|\{|\}|\(|\)|\||\[|\]|\\","\$0") ")|"
		ExClude := "i)" SubStr(Exclude,1,Strlen(Exclude)-1)
	}
	Else
		IsExClude := False
	If RegExMatch(opt,":-\d*",ChrNum)
	{
		Opt := RegExReplace(opt,ToMatch(ChrNum))
		ChrNum := Substr(ChrNum,3)
	}
	Else
		ChrNum := 0
	If RegExMatch(opt,":\$\d*",MfileIndex)
	{
		IsIndex := True
		Opt := RegExReplace(opt,ToMatch(MfileIndex))
		MfileIndex := SubStr(MfileIndex,3)
	}
	Else
		IsIndex := False
	If RegExMatch(opt,":.*")
	{
		IsTemplate := True
		Template := Substr(opt,2)
	}
	Else
		IsTemplate := False
	idx := 0
	MatchTemplate := "i)(\bindex\b)|(\bfile\b)|(\bdir\b)|(\bext\b)|(\bNameNoExt\b)|(\bName\b)|(\bdrive\b)|(<br>)|(<tab>)"
	Loop,Parse,RString,`n,`r
	{
		If Strlen(A_LoopField) = 0
			Continue
		Name := SplitpathNameOnly(A_LoopField)
		IF IsInClude AND (Not RegExMatch(name,Include))
			Continue
		IF IsExClude AND RegExMatch(name,Exclude)
			Continue
		If IsTemplate
		{
			Splitpath,A_LoopField,Name,Dir,Ext,NameNoExt,Drive
			Pos := 1
			Index := A_Index
			NewRString := Template
			Loop
			{
				Pos := RegExMatch(NewRString,MatchTemplate,Switch,Pos)
				If Not Pos
					Break
				else If RegExMatch(Switch,"i)^file$")
					RString := A_LoopField
				else If RegExMatch(Switch,"i)^index$")
					RString := Index 
				else If RegExMatch(Switch,"i)^name$")
					RString := Name
				else If RegExMatch(Switch,"i)^dir$")
					RString := Dir
				else If RegExMatch(Switch,"i)^ext$")
					RString := Ext
				else If RegExMatch(Switch,"i)drive")
					RString := Drive
				else If RegExMatch(Switch,"i)<br>")
					RString := "`r`n"
				else If RegExMatch(Switch,"i)<tab>")
					RString := A_Tab
				NewRString := RegExReplace(NewRString,ToMatch(Switch),ToReplace(RString),"",1,Pos)
				Pos += strlen(RString)
			}
/*
			NewRString := Template
			NewRString := RegExReplace(NewRString,"i)file",A_LoopField)
			NewRString := RegExReplace(NewRString,"i)Index",A_Index)
			NewRString := RegExReplace(NewRString,"i)NameNoExt",NameNoExt)
			NewRString := RegExReplace(NewRString,"i)name",name)
			NewRString := RegExReplace(NewRString,"i)dir",dir)
			NewRString := RegExReplace(NewRString,"i)ext",ext)
			NewRString := RegExReplace(NewRString,"i)drive",Drive)
			NewRString := RegExReplace(NewRString,"i)<br>","`r`n")
			NewRString := RegExReplace(NewRString,"i)<tab>",A_Tab)
*/
		}
		Else
			NewRString := A_LoopField
		LoopString .= NewRString
		If Idx =  %MfileIndex%
			Return Substr(NewRString,1,Strlen(NewRString)-ChrNum)
		Idx++
	}
	RString := Substr(LoopString,1,Strlen(LoopString)-ChrNum)
	Return RString
}

; 格式化并返回MenuZ格式的类型和选择内容
; 注意!返回的是对象Object
ReturnTypeString(String)
{
	ReturnArray := Object()
	If RegExMatch(String,"\n") And RegExMatch(String,"^(\.|(Folder))")
	{
		ReturnArray.Type := "Multifiles"
		ReturnArray.String := String
	}
	Else
	{
		ReturnArray.Type := Substr(String,1,RegExMatch(String,"\|")-1)
		Match := ToMatch(ReturnArray.Type) "\|"
		ReturnArray.String := RegExReplace(String,Match,"",Out,1)
	}
	Return ReturnArray
}
; SplitpathNameOnly(Path) {{{2
; 基本上与Splitpath类似，只是只返回文件名或者目录名
SplitpathNameOnly(Path)
{
	filetype := FileExist(Path)
	If filetype
	{
		If Instr(filetype,"D")
		{
			Loop,Parse,Path
			{
				If RegExMatch(Substr(Path,1-A_Index,1),"\\")
				{
					name := Substr(Path,Strlen(Path)-A_index+2)
					Break
				}
			}
		}
		Else
			Splitpath,Path,Name
		Return Name
	}
	Else
		return
}
; IniReadValue(Section="",Key="",Default="") {{{2
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
; CheckExtension(action="") {{{2
CheckExtension(func)
{
	ExtensionsAHK := A_ScriptDir "\Extensions\Extensions.ahk"
	; 检查目录下有没有Func的同名文件
	FuncAHK := A_ScriptDir "\Extensions\" Func ".ahk"
	If FileExist(FuncAHK)
	{
		; 是否Include了FuncAHK
		Match := "i)^\s*#include\s*%A_ScriptDir%\\Extensions\\" ToMatch(Func) "\.ahk"
		FileRead,Extensions,%ExtensionsAHK%
		Loop,Parse,Extensions,`n,`r
		{
			If RegExMatch(A_LoopField,Match)
			{
				FileGetTime,CheckTime,%FuncAHK%,M
				IniRead,ExtensionsTime,%ExtensionsAHK%,ExtensionsTime,%Func%
				If ExtensionsTime = %CheckTime% 
				{
					If IsFunc(Func)
						Return %Func%()
					Else
						Msgbox % "插件: Extensions\" Func ".ahk 中没有 " Func "( ) 函数,请检查!"
					Return
				}
			}
		}
		If A_IsCompiled
			Return
		Msgbox,4,,检测到 %Func% 插件修改，是否重新加载?
		IfMsgbox Yes
		{
			run %A_ScriptDir%\ActMan.ahk
			ExitApp
		}
	}
	Else
		Msgbox % Func " 插件不存在，请检查！"
	Return 
} 
; ToMatch(str) {{{2
; 正则表达式转义
ToMatch(str)
{
	str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
	Return RegExReplace(str,"\s","\s")
}
; ToReplace(str) {{{2
; 
ToReplace(str)
{
	If RegExMatch(str,"\$")
		return  Regexreplace(str,"\$","$$$$")
	Else
		Return str
}
StringReplaceF(String,SearchText,ReplaceText="",ReplaceAll="ALL")
{
	StringReplace,RString,String,SearchText,ReplaceText,ReplaceAll
	Return RString
}
;/======================================================================/
; EmptyMem() {{{2
EmptyMem(PID="AHK Rocks")
{
    pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}
;/======================================================================/
; 以下为引用函数
; FileGetVersionInfo_AW() {{{2
; 获取文件名称，用于MenuZ.auto
FileGetVersionInfo_AW( peFile="", StringFileInfo="", Delimiter="|") {    ; Written by SKAN
; FileDescription | FileVersion | InternalName | LegalCopyright | OriginalFilename
; ProductName | ProductVersion | CompanyName | PrivateBuild | SpecialBuild | LegalTrademarks
; www.autohotkey.com/forum/viewtopic.php?t=64128          CD:24-Nov-2008 / LM:28-May-2010
 Static CS, HexVal, Sps="                        ", DLL="Version\"
 If ( CS = "" )
  CS := A_IsUnicode ? "W" : "A", HexVal := "msvcrt\s" (A_IsUnicode ? "w": "" ) "printf"
 If ! FSz := DllCall( DLL "GetFileVersionInfoSize" CS , Str,peFile, UInt,0 )
   Return "", DllCall( "SetLastError", UInt,1 )
 VarSetCapacity( FVI, FSz, 0 ), VarSetCapacity( Trans,8 * ( A_IsUnicode ? 2 : 1 ) )
 DllCall( DLL "GetFileVersionInfo" CS, Str,peFile, Int,0, UInt,FSz, UInt,&FVI )
 If ! DllCall( DLL "VerQueryValue" CS
    , UInt,&FVI, Str,"\VarFileInfo\Translation", UIntP,Translation, UInt,0 )
   Return "", DllCall( "SetLastError", UInt,2 )
 If ! DllCall( HexVal, Str,Trans, Str,"%08X", UInt,NumGet(Translation+0) )
   Return "", DllCall( "SetLastError", UInt,3 )
 Loop, Parse, StringFileInfo, %Delimiter%
 { subBlock := "\StringFileInfo\" SubStr(Trans,-3) SubStr(Trans,1,4) "\" A_LoopField
  If ! DllCall( DLL "VerQueryValue" CS, UInt,&FVI, Str,SubBlock, UIntP,InfoPtr, UInt,0 )
    Continue
  Value := DllCall( "MulDiv", UInt,InfoPtr, Int,1, Int,1, "Str"  )
  Info  .= Value ? ( ( InStr( StringFileInfo,Delimiter ) ? SubStr( A_LoopField Sps,1,24 )
        .  A_Tab : "" ) . Value . Delimiter ) : ""
} StringTrimRight, Info, Info, 1
Return Info
}
; SksSub_UrlEncode(string, enc="UTF-8") {{{2
; 来自万年书妖的Candy里的函数，用于转换编码。感谢！
SksSub_UrlEncode(string, enc="UTF-8")
{   ;url编码
    enc:=trim(enc)
    If enc=
        Return string
	If Strlen(String) > 200
		string := Substr(string,1,200)
    formatInteger := A_FormatInteger
    SetFormat, IntegerFast, H
    VarSetCapacity(buff, StrPut(string, enc))
    Loop % StrPut(string, &buff, enc) - 1
    {
        byte := NumGet(buff, A_Index-1, "UChar")
        encoded .= byte > 127 or byte <33 ? "%" Substr(byte, 3) : Chr(byte)
    }
    SetFormat, IntegerFast, %formatInteger%
    return encoded
}
; =======================================================
; GUI {{{1
; DebugGUI: {{{2
Debuggui:
	Gui,Debug:Destroy
	Gui,Debug:Font,s10
	Gui,Debug:Add,Text,h12 w500,选择内容
	Gui,Debug:Add,Edit,h100 w500
	Gui,Debug:Add,Text,h12 w500,测试语句
	Gui,Debug:Add,Edit,h80 w500 gDebugSwitch
	Gui,Debug:Add,Text,h12 w500,测试结果
	Gui,Debug:Add,Edit,h200 w500
	Gui,Debug:show,,MenuZ Debug
return
DebugSwitch:
	DebugSwitch()
Return
DebugSwitch()
{
	ControlGetText,SaveString,Edit1,MenuZ Debug
	ControlGetText,Switch,Edit2,MenuZ Debug
	result := ReplaceSwitch(ReplaceVar(Switch))
	ControlSetText,Edit3,%result%,MenuZ Debug
}
; ConfigGUI {{{2


#Include %A_ScriptDir%\Extensions\Extensions.ahk
