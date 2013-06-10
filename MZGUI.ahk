#SingleInstance,Force
Global INI
Global Controls := Object()
Global Options := Object()
Global SaveMenu := Object()
; Main {{{1
; GUI_LoadINI {{{2
If 0 > 0
{
	INI = %1%
	If (Not FileExist(INI)) OR (Not RegExMatch(INI,"i)\.ini$"))
		INI := A_ScriptDir "\MenuZ.ini"
}
Else
	INI := A_ScriptDir "\MenuZ.ini"
;Msgbox % INI

; GUI_Create {{{2
GUI,New,+HwndConfigGUI
GUI,+Delimiter`n
GUI,Font,s9
GUI,Add,Button,x20 y560 w80 h30,配置文件(&E)
GUI,Add,Button,x250 y560 w80 h30,帮助(&H)
GUI,Add,Button,x350 y560 w80 h30,应用(&O)
GUI,Add,Button,x450 y560 w80 h30,关闭(&C)
GUI,Add,Tab2,x10 y10 w532 h535 +Theme -Background ,菜单配置`n设置`n关于
GUI,Tab,1
GUI,Add,Text,x25 y48,INI(&I)
INI_List := CBB_GetINIList()
GUI,Add,ComboBox,x75 y45 h20 w405 R20 choose1 vGUI_INI gCBB_ChangeINI,%INI_List%
GUI,Add,Button,x490 y44 h20 w35 ,&1...
INI_Section := CBB_GetINISection(INI)
GUI,Add,Text,x25 y78,段名(&D)
GUI,Add,ComboBox,x75 y75 h20 w405 R20 choose1 vGUI_Section gCBB_ChangeSection,%INI_Section%
GUI,Add,Button,x490 y74 h20 w35 ,&2...
GUI,Font,s10
GUI,Add,TreeView,x25 y110 w500 h250 vGUI_TreeView
Options["GTV"] := True
CBB_ChangeSection()
GUI,Font,s9
GUI,Add,Text,x25 y373 ,类型搜索(&S)
GUI,Add,Edit,x100 y370 w220 h22 vGUI_Search gEdit_Search
GUI,Add,Checkbox,x330 y370 h20 vCheckBox_HideComment,隐藏备注(&J)
GUI,Add,Checkbox,x430 y370 h20 w95 gConfigMode vCheckBox_ConfigMode,骨灰模式(&G)
GUI,Add,Text,x25 y403,菜单名称(&N)
GUI,Add,Edit,x100 y400 h20 w220,
GUI,Add,Text,x330 y404,热键(&K)
GUI,Add,ComboBox,x380 y400 w40
GUI,Add,Button,x430 y400 h20 w95 gDebugGUI,调试器(&B)
GUI,Add,Text,x25 y431 vText_File,程序文件(&F)
GUI,Add,Edit,x100 y428 h20 w380 vEdit_File,
GUI,Add,Button,x490 y428 h20 w35 vButton_File,&3...
GUI,Add,Text,x25 y459 vText_Param,参    数(&A)
GUI,Add,Edit,x100 y456 h20 w380 vEdit_Param,
GUI,Add,Button,x490 y456 h20 w35 vButton_Param,&4...
GUI,Add,Text,x25 y487 vText_Icon,图    标(&Q)
GUI,Add,Edit,x100 y484 h20 w380 vEdit_Icon,
GUI,Add,Button,x490 y484 h20 w35 vButton_Icon,&5...
GUI,Add,Text,x25 y515 vText_Switch,特殊开关(&T)
GUI,Add,Edit,x100 y512 h20 w380 vEdit_Switch,
GUI,Add,Button,x490 y512 h20 w35 vButton_Switch,&6...
GUI,Add,Edit,x25 y428 h105 w500 hidden vEdit_MenuContent
GUI,Show,h600,MenuZ 配置
Return
GuiClose:
ExitApp
; Global Label {{{1
ConfigMode:
	ConfigMode()
return
; ConfigMode() {{{2
ConfigMode()
{
	GuiControlGet,Mode,,CheckBox_ConfigMode
	If Mode
	{
		GuiControl,Hide,Text_File
		GuiControl,Hide,Edit_File
		GuiControl,Hide,Button_File
		GuiControl,Hide,Text_Param
		GuiControl,Hide,Edit_Param
		GuiControl,Hide,Button_Param
		GuiControl,Hide,Text_Icon
		GuiControl,Hide,Edit_Icon
		GuiControl,Hide,Button_Icon
		GuiControl,Hide,Text_Switch
		GuiControl,Hide,Edit_Switch
		GuiControl,Hide,Button_Switch
		GuiControl,Show,Edit_MenuContent
	}
	Else
	{
		GuiControl,Show,Text_File
		GuiControl,Show,Edit_File
		GuiControl,Show,Button_File
		GuiControl,Show,Text_Param
		GuiControl,Show,Edit_Param
		GuiControl,Show,Button_Param
		GuiControl,Show,Text_Icon
		GuiControl,Show,Edit_Icon
		GuiControl,Show,Button_Icon
		GuiControl,Show,Text_Switch
		GuiControl,Show,Edit_Switch
		GuiControl,Show,Button_Switch
		GuiControl,Hide,Edit_MenuContent
	}
}
DebugGUI:
	DebugGUI()
Return
; DebugGUI() {{{2
DebugGUI()
{
	ThisMenuContent := "{file:path}"
	SendMZC := "MZCommand:DebugGUI:" ThisMenuContent
	Send_WM_COPYDATA(SendMZC)
}
; Edit {{{1
Edit_Search:
	Edit_Search()
Return
; Edit_Search() {{{2
Edit_Search()
{
	ControlGetText,NewINI,Edit1,A
	ControlGetText,NewSections,Edit3,A
	If Strlen(NewSections) = 0
	{
		ControlGetText,NewSections,Edit2,A
		MenuString := ReadMenuByType(NewINI,NewSections,1,True)
	}
	Else
	{
		If IsMainINI(NewINI)
		{
			If RegExmatch(NewSections,"i)^config$") 
			   OR RegExMatch(NewSections,"i)^hotkey$") 
			   OR RegExMatch(NewSections,"i)^env$")
			   OR RegExMatch(NewSections,"i)^TextType$")
				Return
			If RegExMatch(NewSections,"i)^Any$")
			   OR RegExMatch(NewSections,"i)^AnyFile$")
			   OR RegExMatch(NewSections,"i)^AnyText$")
			   OR RegExMatch(NewSections,"i)^AnyClass$")
			   OR RegExMatch(NewSections,"i)^Drive$")
			   OR RegExMatch(NewSections,"i)^Folder$")
			   OR RegExMatch(NewSections,"i)^MultiFiles$")
			   OR RegExMatch(NewSections,"i)^NoExt$")
				MenuString := ReadMenuByType(NewINI,NewSections,1,True)
			Else
				MenuString := ReadMenuByType(NewINI,NewSections,1)
		}
		Else
			MenuString := ReadMenuByType(NewINI,NewSections,1,True)
	}
	GTV_AddByItems(MenuString)
}
; CBB ComboBox {{{1
CBB_ChangeINI:
	CBB_ChangeINI()
Return
; CBB_ChangeINI() {{{2
CBB_ChangeINI()
{
	GuiControlGet,NewINI,,GUI_INI
	NewSections := "`n" CBB_GetINISection(NewINI)
	GuiControl,, GUI_Section, %NewSections%
	GuiControl,Choose, GUI_Section, 1
	CBB_ChangeSection()
}
CBB_ChangeSection:
	CBB_ChangeSection()
Return
; CBB_ChangeSection() {{{2
CBB_ChangeSection()
{
	GuiControlGet,NewINI,,GUI_INI
	GuiControlGet,NewSections,,GUI_Section
	If Options["GTV"]
	{
		MenuString := ReadMenuByType(NewINI,NewSections,1,True)
		Return
		GTV_AddByItems(MenuString)
	}
	Else
		Return
}
; CBB_GetINIList() {{{2
CBB_GetINIList()
{
	ALLINI := "MenuZ.ini`n"
	ConfigDir := A_ScriptDir "\Config"
	If FileExist(ConfigDir)
	{
		Loop,%ConfigDir%\*.*,0,1
		{
			If RegExMatch(A_LoopFileName,"i)^auto\.ini$")
				Continue
			If RegExMatch(A_LoopFileName,"i)\.ini$")
				ALLINI .= "Config\" A_LoopFileName "`n" 
		}
	}
	Return ALLINI
}

; CBB_GetINISection(INIfile) {{{2
CBB_GetINISection(INIfile)
{
	Sections := IniReadValue(INIfile)
	Loop,Parse,Sections,`n,`r
	{
		If IsMainINI(INIfile)
		{
			If RegExmatch(A_LoopField,"i)^config$") 
			   OR RegExMatch(A_LoopField,"i)^hotkey$") 
			   OR RegExMatch(A_LoopField,"i)^env$")
			   OR RegExMatch(A_LoopField,"i)^TextType$")
				Continue
			If RegExMatch(A_LoopField,"i)^Any$")
			   OR RegExMatch(A_LoopField,"i)^AnyFile$")
			   OR RegExMatch(A_LoopField,"i)^AnyText$")
			   OR RegExMatch(A_LoopField,"i)^AnyClass$")
			   OR RegExMatch(A_LoopField,"i)^Drive$")
			   OR RegExMatch(A_LoopField,"i)^Folder$")
			   OR RegExMatch(A_LoopField,"i)^MultiFiles$")
			   OR RegExMatch(A_LoopField,"i)^NoExt$")
				Private .= A_LoopField "`n"
			Else
				LoopSections .= A_LoopField "`n"
		}
		Else
			LoopSections .= A_LoopField "`n"
	}
	Sort,LoopSections,CL
	ReturnSections := Private LoopSections
	Return ReturnSections
}
; GTV  GuiTreeView {{{1
; GTV_AddByItems(MenuString) {{{2
GTV_AddByItems(MenuString)
{

}
; GTV_GetIDByText(Text) {{{2
GTV_GetIDByText(Text)
{
	MatchText := "i)^" ToMatch(Text) "$"
	ItemID := 0
	Loop
	{
		ItemID := Tv_GetNext(ItemID,"Full")
		If Not ItemID
			Break
		TV_GetText(ItemText,ItemID)
		If RegExMatch(ItemText,MatchText)
			Return ItemID
	}
	Return 
}
; Tools {{{1
; IniReadValue(INIFile,Section="",Key="",Default="") {{{2
IniReadValue(INIFile,Section="",Key="",Default="")
{
	;DebugCount++
	;Tooltip % DebugCount
	ErrorLevel := False
	IniRead,Value,%INIFile%,%Section%,%Key%
	If Value = ERROR
	{
		ErrorLevel := True
		If Strlen(Default)
			Iniwrite,%Default%,%INIFile%,%Section%,%Key%
		Return Default
	}
	Else
		Return Value
}
; IsMainINI(INIfile) {{{2
IsMainINI(INIfile)
{
	If RegExMatch(INI,ToMatch(INIfile))
		Return True
	Else
		Return False
}
; ReplaceVar(str) {{{2
ReplaceVar(str)
{
	
	Pos := 1
	Loop
	{
		;Tooltip % DebugCount
		;DebugCount++
		Pos := RegExMatch(str,"i)%[^%]*%",UserVar,Pos)
		If Pos
		{
			var := SubStr(UserVar,2,Strlen(UserVar)-2)
			If Strlen(var) = 0
				Break
			Env := IniReadValue(INI,"Env",Var)
			IF Not ErrorLevel
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			Else If RegExMatch(var,"i)^apps$")  ; MZ内置变量
			{
				Env := A_ScriptDir "\apps"
				str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
			}
			Else If RegExMatch(var,"i)^Script$")  ; MZ内置变量
			{
				Env := A_ScriptDir "\Script"
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
				AHK_BIEnv := A_Tab "A_WorkingDir" A_Tab "A_ScriptDir" A_Tab "A_ScriptName" A_Tab "A_ScriptFullPath" A_Tab "A_ScriptHwnd" A_Tab "A_LineNumber" A_Tab "A_LineFile" A_Tab "A_ThisFunc" A_Tab "A_ThisLabel" A_Tab "A_AhkVersion" A_Tab "A_AhkPath" A_Tab "A_IsUnicode" A_Tab "A_IsCompiled" A_Tab "A_ExitReason" A_Tab "A_YYYY" A_Tab "A_MM" A_Tab "A_DD" A_Tab "A_MMMM" A_Tab "A_MMM" A_Tab "A_DDDD" A_Tab "A_DDD" A_Tab "A_WDay" A_Tab "A_YDay" A_Tab "A_YWeek" A_Tab "A_Hour" A_Tab "A_Min" A_Tab "A_Sec" A_Tab "A_MSec" A_Tab "A_Now" A_Tab "A_NowUTC" A_Tab "A_TickCount" A_Tab "A_IsSuspended" A_Tab "A_IsPaused" A_Tab "A_IsCritical" A_Tab "A_BatchLines" A_Tab "A_TitleMatchMode" A_Tab "A_TitleMatchModeSpeed" A_Tab "A_DetectHiddenWindows" A_Tab "A_DetectHiddenText" A_Tab "A_AutoTrim" A_Tab "A_StringCaseSense" A_Tab "A_FileEncoding" A_Tab "A_FormatInteger" A_Tab "A_FormatFloat" A_Tab "A_KeyDelay" A_Tab "A_WinDelay" A_Tab "A_ControlDelay" A_Tab "A_MouseDelay" A_Tab "A_DefaultMouseSpeed" A_Tab "A_RegView" A_Tab "A_IconHidden" A_Tab "A_IconTip" A_Tab "A_IconFile" A_Tab "A_IconNumber" A_Tab "A_TimeIdle" A_Tab "A_TimeIdlePhysical" A_Tab "A_Gui" A_Tab "A_GuiControl" A_Tab "A_GuiWidth" A_Tab "A_GuiHeight" A_Tab "A_GuiX" A_Tab "A_GuiY" A_Tab "A_GuiEvent" A_Tab "A_EventInfo" A_Tab "A_ThisHotkey" A_Tab "A_PriorHotkey" A_Tab "A_PriorKey" A_Tab "A_TimeSinceThisHotkey" A_Tab "A_TimeSincePriorHotkey" A_Tab "A_Temp" A_Tab "A_OSType" A_Tab "A_OSVersion" A_Tab "A_Is64bitOS" A_Tab "A_PtrSize" A_Tab "A_Language" A_Tab "A_ComputerName" A_Tab "A_UserName" A_Tab "A_WinDir" A_Tab "A_ProgramFiles" A_Tab "A_AppData" A_Tab "A_AppDataCommon" A_Tab "A_Desktop" A_Tab "A_DesktopCommon" A_Tab "A_StartMenu" A_Tab "A_StartMenuCommon" A_Tab "A_Programs" A_Tab "A_ProgramsCommon" A_Tab "A_Startup" A_Tab "A_StartupCommon" A_Tab "A_MyDocuments" A_Tab "A_IsAdmin" A_Tab "A_ScreenWidth" A_Tab "A_ScreenHeight" A_Tab "A_IPAddress1" A_Tab "A_IPAddress2" A_Tab "A_IPAddress3" A_Tab "A_IPAddress4" A_Tab "A_Cursor" A_Tab "A_CaretX" A_Tab "A_CaretY" A_Tab 
				SystemEnv := A_Tab "ALLUSERSPROFILE" A_Tab "APPDATA" A_Tab "CD" A_Tab "CMDCMDLINE" A_Tab "CMDEXTVERSION" A_Tab "COMPUTERNAME" A_Tab "COMSPEC" A_Tab "DATE" A_Tab "ERRORLEVEL" A_Tab "HOMEDRIVE" A_Tab "HOMEPATH" A_Tab "HOMESHARE" A_Tab "LOGONSERVER" A_Tab "NUMBER_OF_PROCESSORS" A_Tab "OS" A_Tab "PATH" A_Tab "PATHEXT" A_Tab "PROCESSOR_ARCHITECTURE" A_Tab "PROCESSOR_IDENTFIER" A_Tab "PROCESSOR_LEVEL" A_Tab "PROCESSOR_REVISION" A_Tab "PROMPT" A_Tab "RANDOM" A_Tab "SYSTEMDRIVE" A_Tab "SYSTEMROOT" A_Tab "TEMP" A_Tab "TIME" A_Tab "USERDOMAIN" A_Tab "USERNAME" A_Tab "USERPROFILE" A_Tab "WINDIR" A_Tab
				MatchVar := "i)\t" ToMatch(Var) "\t"
				If RegExMatch(AHK_BIEnv,MatchVar) ; AHK内置变量
				{
					Env := %Var%
					Str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
				}
				Else If RegExMatch(SystemEnv,MatchVar) ; 系统变量
				{
					EnvGet,Env,%var%
					Str := RegExReplace(Str,ToMatch(UserVar),ToReplace(Env))
				}
				Else
					Env := UserVar
			}
		}
		Else
			Break
		Pos += Strlen(Env)
	}
	Return str
}
; ToMatch(str) {{{2
; 正则表达式转义
ToMatch(str)
{
	str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
	Return RegExReplace(str,"\s","\s")
}
; ToReplace(str) {{{2
ToReplace(str)
{
	If RegExMatch(str,"\$")
		return  Regexreplace(str,"\$","$$$$")
	Else
		Return str
}
; ReadMenuByType(INIFile,Type,TVLevel,OnlyType=False) {{{2
ReadMenuByType(INIFile,Type,TVLevel,OnlyType=False)
{

}
; Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle="MenuZ.ahk ahk_class AutoHotkey") {{{2
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
