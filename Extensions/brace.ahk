
;出处   http://www.autohotkey.com/board/topic/71363-script-formatting-script/

;  整理排版用的 .

;使用方法    整理花括号        ={func:brace}   
brace()
{

	i = 0
	ListeNeu:=
	; 获取当前选择的内容
	Select := ReturnTypeString(SaveString)
	String := Select.String
	; 获取当前选择的内容完毕
	loop,Parse,String,`n
	{
		IfInString, A_Loopfield,`{
		          	{
				i := i + 1
				Tabs = ;
				loop, % i - 1
 {
					Tabs = %Tabs%`;.`;
				}    
				Result :=  Trim(A_Loopfield)
			                       	ListeNeu = %ListeNeu%%Tabs%%Result%`n
				Tabs = ;
				loop, % i
			                   	{
					Tabs = %Tabs%`;.`;
			                      	}
				continue
			}
		IfInString, A_Loopfield,`}
		{
			i := i - 1    
			Tabs = ;
			loop, % i
			{
				Tabs = %Tabs%`;.`;
			}
		}
		Result :=  Trim(A_Loopfield)
		ListeNeu = %ListeNeu%%Tabs%%Result%`n
	}
	StringReplace, ListeNeu, ListeNeu, `;.`;,%A_TAB%,All 
	Clipboard := ListeNeu
	Send,^v
}



