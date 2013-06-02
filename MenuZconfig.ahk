#SingleInstance,Force
#NoTrayIcon
Setkeydelay,-1
Global INI := A_ScriptDir "\menuz.ini" ; 配置文件
Global ConfigGUI
Global TVItem 
Global SaveMenuIdx
Global SaveMenu := Object()
;Global TVLevel
Gosub,MenuSwitch
Gosub,ConfigGUIShow
return

MenuSwitch:
	Menu,Switch,Add,{mfile} 多文件,SendSwitch
	Menu,Switch,Add,{mfile:file} 多文件（仅文件）,SendSwitch
	Menu,Switch,Add,{mfile:dir} 多文件（仅文件夹）,SendSwitch
	Menu,Switch,Add,{file:path} 文件完整路径,SendSwitch
	Menu,Switch,Add,{file:name} 文件名,SendSwitch
	Menu,Switch,Add,{file:dir} 文件夹,SendSwitch
	Menu,Switch,Add,{file:ext} 后缀名,SendSwitch
	Menu,Switch,Add,{file:namenoext} 不带后缀的文件名,SendSwitch
	Menu,Switch,Add,{file:drive} 当前驱动器,SendSwitch
	Menu,Switch,Add,{file:context} 文件内容,SendSwitch
return

ConfigGUIShow:
	ConfigGUIShow()
return
; ConfigGUIShow() {{{1
ConfigGUIShow()
{
GUI,New,+HwndConfigGUI
GUI,Font,s10
GUI,Add,Button,x20 y550 w80 h30,配置文件(&E)
GUI,Add,Button,x250 y550 w80 h30,确认(&O)
GUI,Add,Button,x350 y550 w80 h30,保存(&O)
GUI,Add,Button,x450 y550 w80 h30,取消(&C)
GUI,Add,Tab2,x10 y10 w532 h520 +Theme -Background ,菜单配置|设置|关于
GUI,Tab,1
GUI,Add,Text,x20 y40 w100 h14 center BackgroundTrans,菜单类型
MenuType := GetMenuType()
GUI,Add,ListBox,x20 y60 w100 h400 g<SelectType>,%MenuType%
GUI,Add,Button,x40 y490 w20 h20,+
GUI,Add,Button,x70 y490 w20 h20,-
GUI,Add,Button,x100 y490 w20 h20,M
GUI,Add,Edit,x20 y465 w100 h20
GUI,Add,TreeView,x130 y60 w400 h300 Buttons g<CheckTreeView>
GUI,Add,Text,x130 y374,菜单名
GUI,Add,Edit,x175 y370 w200 h20 Limit20 -VScroll
GUI,Font,s9
GUI,Add,Button,x380 y368 w30 h24,热键
GUI,Font,s10
GUI,Add,Button,x480 y368 w20 h24,+
GUI,Add,Button,x510 y368 w20 h24,-
GUI,Add,Edit,x130 y400 w400 h85
GUI,Font,s9
GUI,Add,Button,x130 y490 w60 h20,程序列表
GUI,Add,Button,x195 y490 w60 h20,环境变量
GUI,Add,Button,x260 y490 w60 h20,情景模式
GUI,Add,Button,x340 y490 w30 h20,窗口
GUI,Add,Button,x375 y490 w30 h20,控件
GUI,Add,Button,x410 y490 w30 h20,图标
GUI,Add,Button,x445 y490 w30 h20,文件
GUI,Add,Button,x480 y490 w50 h20,文件夹
GUI,Show,w550 h600,MenuZ 配置
	Hotkey,Ifwinactive,AHK_ID %ConfigGUI%
	Hotkey,RButton,EditMenu,On
}
; GetMenuType() {{{2
GetMenuType()
{
	INIContent := IniReadValue(INI)
	Loop,Parse,INIContent,`n,`r
	{
		If RegExMatch(A_LoopField,"i)^Any$")
			Content .= "Any|"	
		Else If RegExMatch(A_LoopField,"i)^AnyFile$")
			Content .= "AnyFile|"	
		Else If RegExMatch(A_LoopField,"i)^AnyText$")
			Content .= "AnyText|"	
		Else If RegExMatch(A_LoopField,"i)^AnyClass$")
			Content .= "AnyClass|"	
		Else If RegExMatch(A_LoopField,"i)^Multifiles$")
			Content .= "Multifiles|"	
		Else If RegExMatch(A_LoopField,"i)^Folder$")
			Content .= "Folder|"	
		Else If RegExMatch(A_LoopField,"i)^Dirve$")
			Content .= "Dirve|"	
		Else If RegExMatch(A_LoopField,"i)^NoExt$")
			Content .= "NoExt|"	
		Else If RegExMatch(A_LoopField,"i)^Text$")
			Content .= "Text|"	
		Else If RegExMatch(A_LoopField,"i)^URL$")
			Content .= "URL|"
		Else If RegExMatch(A_LoopField,"^\.")
			Content .= A_LoopField "|"
		Else
		{
			ThisType := A_LoopField
			MatchLoop := ToMatch(A_LoopField) "="
			TextType := IniReadValue(INI,"TextType")
			Loop,Parse,TextType,`n,`r
			{
				If RegExMatch(A_LoopField,MatchLoop)
				{
					Content .= ThisType "|"
					Break
				}
			}
		}
	}
	Sort,Content,CL D|
	Return Content
}
<CheckTreeView>:
	CheckTreeView()
return
; CheckTreeView() {{{2
CheckTreeView()
{
	If InStr(A_GuiEvent,"S")
	{
		TV_GetText(Text,A_EventInfo)
		If Strlen(Text) = 0
			Return
		MatchItem := "\|.*" ToMatch(Text) "="
		For,Index ,Key in SaveMenu
		{
			If RegExMatch(Key,MatchItem)
			{
				returnText .= Key "`n"
				returnTextIdx++
			}
		}
		If returnTextIdx = 1
		{
			EditINI := SubStr(returnText,1,RegExMatch(returnText,"\|")-1)
			MenuValue := SubStr(returnText,RegExMatch(returnText,"\|")+1)
			MenuName := SubStr(MenuValue,1,RegExMatch(MenuValue,"=")-1)
			MenuItem := SubStr(MenuValue,RegExMatch(MenuValue,"=")+1)
			GuiControl,,Edit2,%MenuName%
			GuiControl,,Edit3,%MenuItem%
		}
	}
}
<SelectType>:
	SelectType()
return
; SelectType() {{{2
SelectType()
{
	If InStr(A_GuiEvent,"Normal")
	{
		ControlGet,Type,Choice,,ListBox1,AHK_ID %ConfigGUI%
		If Strlen(Type) = 0
			Return
		TV_Delete()
		SaveMenuIdx := 1
		SaveMenu := Object()
		MenuString := ReaeMenuByType(INI,Type,1)
		Loop,Parse,MenuString,`n
		{
			If Strlen(A_LoopField) = 0
				Continue
			Level := SubStr(A_LoopField,1,1)
			Item  := SubStr(A_LoopField,2)
			If Level = 1
			{
				If RegExMatch(Item,"\\")
				{
					LastID := 0
					Loop,Parse,Item,\
					{
						ParentID := GetIDByText(A_LoopField)
						If ParentID 
							LastID := ParentID
						Else
							LastID := TV_Add(A_LoopField,LastID)
					}
				}
				Else
					Lv1 := TV_Add(Item)
			}
			If Level = 2
				Lv2 := TV_Add(Item,Lv1)
			Else If Level = 3
				Lv3 := TV_Add(Item,Lv2)
			Else If Level = 4
				Lv4 := TV_Add(Item,Lv3)
			Else If Level = 5
				Lv5 := TV_Add(Item,Lv4)
			Else If Level = 6
				Lv6 := TV_Add(Item,Lv5)
			Else If Level = 7
				Lv7 := TV_Add(Item,Lv6)
			Else If Level = 8
				Lv8 := TV_Add(Item,Lv7)
			Else If Level = 9
				Lv9 := TV_Add(Item,Lv8)
		}
	}
/*
		For,i,k in SaveMenu
			Msgbox % k
		TypeContent := IniReadValue(INI,Type)
		;Msgbox % TypeContent
		TV_Delete()
		Loop,Parse,TypeContent,`n,`r
		{
			If RegExMatch(A_LoopField,"=")
				Key := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
			Else 
				Key := A_LoopField
			If RegExMatch(Key,"\\")
			{
				Parent := SubStr(Key,1,RegExMatch(Key,"\\")-1)
				SubItem := SubStr(Key,RegExMatch(Key,"\\")+1)
				If ParentID := GetIDByText(Parent)
					ThisID := TV_Add(SubItem,ParentID)
				Else
				{
					ParentID := TV_Add(Parent)
					ThisID := TV_Add(SubItem,ParentID)
				}
			}
			Else
				ThisID := TV_Add(Key)
			SaveMenu[ThisID] := Key
		}
	}
*/
}
; ReaeMenuByType(Type) {{{2
ReaeMenuByType(INIFile,Type,TVLevel)
{
	TypeContent := IniReadValue(INIFile,Type)
	;Msgbox % TypeContent
	Loop,Parse,TypeContent,`n,`r
	{
		If Strlen(A_LoopField) = 0
			Continue
		Key := Substr(A_LoopField,1,RegExMatch(A_LoopField,"=")-1)
		SaveMenu[SaveMenuIdx] := INIFile "|" A_LoopField
		SaveMenuIdx++
		If RegExMatch(A_LoopField,"i)\{submenu:[^\{\}]*\}",MatchSubMenu)
		{
			SubMenu := ReaeMenuByType(INIFile,SubStr(MatchSubMenu,10,Strlen(MatchSubMenu)-10),TVLevel+1)
			Key .= "`n"
			Loop,Parse,submenu,`n,`r
			{
				If Strlen(A_LoopField) = 0
					Continue
				Key .= A_LoopField "`n" 
			}
		}
		Else If RegExMatch(A_LoopField,"i)\{inifile:[^\{\}]*\}",MatchInifile)
		{
			ThisINI := ReplaceVar(MatchInifile)
			Splitpath,ThisINI,,,,SubType
			SubMenu := ReaeMenuByType(Substr(ThisINI,10,Strlen(ThisINI)-10),SubType,TVLevel+1)
			Key .= "`n"
			Loop,Parse,submenu,`n,`r
			{
				If Strlen(A_LoopField) = 0
					Continue
				Key .= A_LoopField "`n" 
			}
		}
		If Strlen(ThisKey) = 0
			LoopContent .= TVLevel Key "`n"
		Else
			LoopContent .= Key "`n"
	}
	Return LoopContent
}
ReplaceVar(string)
{
	Return string
}
; TVAddByString(string) {{{2
/*
aaaaa
	bbbbb
	ccccc
		ddddd
	eeeee
fffff
ddddd
*/
TVAddByString(string)
{
}
; GetIDByText(Text) {{{2
GetIDByText(Text)
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
/*
	Gui,New
	Gui,+HwndConfigGUI
	Gui,font,s10
	Gui,Add,TreeView,w400 h300 gTVSubmit
	Gui,Default
	TVItem := Object()
	IniRead,Context_1,%INI%
	Loop,Parse,Context_1,`n,`r
	{
		P1 := TV_Add(A_LoopField,check)
		If P1
			TVItem[P1] := "1|" A_LoopField
		IniRead,Context_2,%INI%,%A_LoopField%
		Loop,Parse,Context_2,`n,`r
		{
			P2 := TV_Add(A_LoopField,P1,check)
			If P2
				TVItem[P2] := "2|" A_LoopField
		}
	}
	Gui,Add,DropDownlist,w400,Any
	Gui,Add,edit,w400
	Gui,Add,edit,w400 h200
	Gui,Show
;	ControlGet,ConfigGUI_Edit,hwnd,,AHK_ID %ConfigGUI%
}
*/
TVSubmit:
	TVSubmit()
Return
TVSubmit()
{
	If A_GuiEvent = S
	{
		ItemID := Tv_getselection()
		ThisItem := TVItem[ItemID]
		Level := SubStr(ThisItem,1,1)
		ThisItem := RegExReplace(ThisItem,"\d\|")
		If Level = 1
		{
			ControlSetText,Edit1,%ThisItem%,AHK_ID %ConfigGUI%
			ChildID := Tv_getchild(ItemID)
			ChildItem := ""
			While(ChildID)
			{
				TV_GetText(ChildString,ChildID)
				ChildID := Tv_GetNext(ChildID)
				ChildItem .= ChildString "`r`n"
			}
			ControlSetText,Edit2,%ChildItem%,AHK_ID %ConfigGUI%
		}
		If Level = 2
		{
			MenuName := SubStr(ThisItem,1,RegExMatch(ThisItem,"=")-1)
			MenuItem := SubStr(ThisItem,RegExMatch(ThisItem,"=")+1)
			ControlSetText,Edit1,%MenuName%,AHK_ID %ConfigGUI%
			ControlSetText,Edit2,%MenuItem%,AHK_ID %ConfigGUI%
		}
	}
}
EditMenu:
	EditMenu()
return
EditMenu()
{
	ControlGetFocus,ThisControl,AHK_ID %ConfigGUI%
	If ThisControl = Edit3
	{
		Menu,Switch,show
	}
	Else
		ControlSend,%ThisControl%,{RButton},AHK_ID %ConfigGUI%
}
SendSwitch:
	SendSwitch()
return
SendSwitch()
{
	ToSend := SubStr(A_ThisMenuItem,1,RegExMatch(A_ThisMenuItem,"\}"))
	SendRaw,%ToSend%
}
GuiClose:
	ExitApp
return


;============== 外部函数 =================;
; ToolFunctions {{{1
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
