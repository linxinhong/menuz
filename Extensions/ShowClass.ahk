; 使用GUI显示当前窗口
ShowClass()
{
	WinGetClass,Class,AHK_ID %SaveID%
	Gui,ShowClass:Destroy
	GUi,ShowClass:Font,s11
	Gui,ShowClass:Add,Edit,w300 h50,%Class%
	GUi,ShowClass:Show,,当前窗口Class
}
