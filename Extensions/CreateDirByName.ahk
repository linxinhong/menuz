CreateDirByName()
{
	Select := ReturnTypeString(SaveString)
	If RegExMatch(Select.Type,"i)^\.")
	{
		path := Select.String
		Splitpath,path,,OutDir,,OutNameNoExt
		newDir := OutDir "\" OutNameNoExt
		FileCreateDir,%newDir%
	}
	If RegExMatch(Select.Type,"i)^Folder$")
	{
		newDir :=  Select.String "_1"
		FileCreateDir,%newDir%
	}
	Return
}
