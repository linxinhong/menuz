#SingleInstance,Force
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
GUI,Font,s10
GUI,Add,Button,x20 y550 w80 h30,配置文件(&E)
GUI,Add,Button,x250 y550 w80 h30,确认(&O)
GUI,Add,Button,x350 y550 w80 h30,保存(&O)
GUI,Add,Button,x450 y550 w80 h30,取消(&C)
GUI,Add,Tab2,x10 y10 w532 h530 +Theme -Background ,菜单配置|设置|关于
GUI,Tab,1
GUI,Add,Text,x25 y47,INI
GUI,Add,ComboBox,x55 y45 h20 w400
GUI,Add,Button,x470 y45 h20 w20,+
GUI,Add,Button,x500 y45 h20 w20,-
GUI,Add,Text,x25 y77,段
GUI,Add,ComboBox,x55 y75 h20 w400
GUI,Add,Button,x470 y75 h20 w20,+
GUI,Add,Button,x500 y75 h20 w20,-
GUI,Add,TreeView,x25 y110 w500 h250
GUI,Add,Text,x25 y372 w30 h20,搜索
GUI,Add,Edit,x60 y370 w250 h22
GUI,Add,Checkbox,x320 y370 h20 w80,隐藏备注
GUI,Add,Button,x410 y370 h20 w20,H
GUI,Add,Button,x440 y370 h20 w20,M
GUI,Add,Button,x470 y370 h20 w20,+
GUI,Add,Button,x500 y370 h20 w20,-
GUI,Add,Text,x25 y402,菜单
GUI,Add,Edit,x60 y400 h20,
GUI,Add,Text,x25 y430,程序
GUI,Add,Edit,x60 y428 h20,
GUI,Add,Text,x25 y458,参数
GUI,Add,Edit,x60 y456 h20,
GUI,Add,Text,x25 y486,图标
GUI,Add,Edit,x60 y484 h20,
GUI,Add,Text,x25 y514,特殊
GUI,Add,Edit,x60 y512 h20,
GUI,Show
