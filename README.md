打开安装目录的MenuZ.ini，可以看到下面一小段

    [Hotkey]
    !`={mode}
    !1={mode:网络搜索}
    !2={mode:翻译}

> 第一个快捷键表示Alt+`，这是全局激发Menuz的快捷键 
> 
> 第二个快捷键表示Alt+1，全局激发网络搜索菜单
> 
> 第三个快捷键表示Alt+2，全局激发有道词典翻译页面

试着选中一个文件，然后按快捷键体验一下吧。
还可以选中一段文本，用快捷键激活体验。


MenuZ支持开关

	{run} 运行模式

    {run:max}  最大化
    
    {run:min}  最小化
    
    {run:hide} 隐藏运行
    
    {run:none} 不运行
    
    {mode} 模式
    
    {mode:xxxx} xxxx模式
    
    {mode:xxxx:all}　循环运行带有{mode:xxxx}的菜单项
    
    {hide} 隐藏菜单项，但是｛mode:xxx:all} 可以正常运行之
    
    {icon} 图标
    
    {icon:icon\baidu.ico} 设置为icon目录下的baidu.ico
    
    {class} AHK类
    
    {class:=notepad|TXGuiFoundation} 菜单只在AHK类Notepad或者QQ中有效
    
    {class:!vim} 只要当前AHK类不是Vim，菜单有效
    
    {file:path} 全路径
    
    {file:name} 文件名
    
    {file:dir} 目录名
    
    {file:ext} 扩展名
    
    {file:namenoext} 不带扩展名的文件名
    
    {file:driver} 驱动器名
    
    {file:content} 文件内容
    
    {mfile: "file" } 多文件列表，解释比较麻烦。。。
    
    {select} 选择内容
    
    {select:regex} 以Env段中定义的RegEx正则来获取选择内容
    
    {box:input:提示内容}  提供一个输入窗口
    
    {box:password:提示内容}  提供一个密码输入窗口
    
    {box:file:提示内容}  提供一个文件选择窗口
    
    {box:fileopen:提示内容}  提供一个文件选择窗口（用{box:file}就行了）
    
    {box:filesave:提示内容}  提供一个文件保存窗口（暂时没有用）
    
    {box:dir:提示内容}  提供一个文件夹选择窗口
    
    {date:日期格式｝ 提供的日期多种格式
    
    {func:扩展脚本｝调用扩展脚本
    
    {clip} 替换为剪切板里的内容
    
    {save:clipall} 将原始的选择内容保存到剪切板中，此选项预留用来与其它扩展使用
    
    {save:clip} 将替换完毕的内容不运行，而是保存到剪切板里。
    
    {save:ahk}  保存为ahk文件，并返回相应文件的路径，默认在 A_Temp \ MenuZ.ahk
    
    {SendMsg}  举例{sendmsg,1075,2924,0} 在TC里运行这个菜单，会打开TC的选择命令窗口
    
    {PostMsg}  同上，只是会将PostMsg返回的内容替换掉{PostMsg}
    
    {send} 发送文本内容，不会将{down}转义
    
    {send:key}  发送热键 ，{down} 这类的会被转义成向下移动
