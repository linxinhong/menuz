#SingleInstance,Force
#NoTrayIcon
Setkeydelay,-1
Global INI := A_ScriptDir "\menuz.ini" ; 配置文件
Global ConfigGUI :=
Global TVItem := 
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
ConfigGUIShow()
{
GUI,New,+HwndConfigGUI
GUI,Font,s9
GUI,Add,Button,x20 y550 w80 h30,配置文件(&E)
GUI,Add,Button,x250 y550 w80 h30,确认(&O)
GUI,Add,Button,x350 y550 w80 h30,保存(&O)
GUI,Add,Button,x450 y550 w80 h30,取消(&C)
GUI,Add,Tab2,x10 y10 w780 h520 +Theme -Background ,菜单配置|设置|关于
GUI,Tab,1
GUI,Add,Text,x20 y40 w100 h14 center BackgroundTrans,菜单类型
GUI,Add,ListBox,x20 y60 w100 h400
GUI,Add,Button,x40 y490 w20 h20,+
GUI,Add,Button,x70 y490 w20 h20,-
GUI,Add,Button,x100 y490 w20 h20,M
GUI,Add,Edit,x20 y465 w100 h20
GUI,Add,ListView,x130 y60 w400 h300
GUI,Add,Text,x130 y374,菜单名
GUI,Add,Edit,x175 y370 w200 h20 Limit20 -VScroll
GUI,Add,Button,x380 y368 w30 h24,热键
GUI,Add,Button,x480 y368 w20 h24,+
GUI,Add,Button,x510 y368 w20 h24,-
GUI,Add,Edit,x130 y400 w400 h85
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
