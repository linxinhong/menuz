GetLink()
{
	Select := ReturnTypeString(SaveString)
	If RegExMatch(Select.Type,"i)^\.lnk")
	{
		Link := Select.String
		FileGetShortcut,%link%,file
		Return File
	}
	Return
}
