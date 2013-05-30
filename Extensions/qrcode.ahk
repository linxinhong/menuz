qrcode()
{
	; 获取类型
	Type := GetType(SaveString)
	; 判断当前为文本
	If Not RegExMatch(Type,"i)^\.")
	{
		m := "^" ToMatch(Type) "\|"
		string := Regexreplace(Regexreplace(SaveString,m),"""|\\","\$0")
		qrcode := A_ScriptDir "\apps\qrcode.exe"
		option1 := " -o "
		option2 := " -s 5 -l H "
		if Fileexist(qrcode)
		{
			png := A_Temp "\qrcode.png"
			FileDelete,%png%
			Run,%qrcode%%option1%`"%png%`"%option2%`"%String%`"
			Loop
			{
				If Fileexist(png)
				{
					Gui,LoadImg:Destroy
					Gui,LoadImg:Add,Picture,,%png%
					GUi,LoadImg:Add,Text,yn hide
					Gui,LoadImg:Add,Button ,w60 h30 x+4 y+10 gLoadImgSve,保存(&S)
					Gui,LoadImg:Add,Button ,w60 h30 y+40 gLoadImgCnl,关闭(&C)
					Gui,LoadImg:Show
					Break
				}
				sleep,100
			}
		}
	}
	return
}
LoadImgSve:
	LoadImgSve()
return
LoadImgSve()
{
	pngPath := A_Temp "\qrcode.png"
	Fileselectfile,newpath,S8,%A_Desktop%,保存二维码,*.png
	newpath .= ".png"
	Filecopy,%pngPath%,%newpath%,1
	If Not ErrorLevel
		Gui,LoadImg:Destroy
}
LoadImgCnl:
	Gui,LoadImg:Destroy
return
