Print()
{
	Select := ReturnTypeString(SaveString)
	If RegExMatch(Select.Type,"(^\.)|(^Folder$)|(^Drive$)|(^NoExt$)")
	{
		ThisFile := "Print """ Select.string """"
		Run %ThisFile%,,UseErrorLevel
		If ErrorLevel
			Msgbox % 文件所关联的程序无有效的打印功能
		Return
	}
	If RegExMatch(Select.Type,"^Multifiles$")
	{
		FilesString := Select.String
		Loop,Parse,FilesString,`n,`r
		{
			Files := ReturnTypeString(A_LoopField)
			If RegExMatch(Files.Type,"^\.")
			{
				If Strlen(Files.String) > 0
				{ 
					ThisFile := "Print """ Files.string """"
					Msgbox % ThisFile
					Run %ThisFile%,,UseErrorLevel
					If ErrorLevel
						Msgbox % 文件所关联的程序无有效的打印功能
				}
			}
		}
	}
}
