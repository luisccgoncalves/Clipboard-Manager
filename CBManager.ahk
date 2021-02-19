#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global ClipHistory :=[]
global CBxpos := 0
global CBypos := 0
startupLnk := A_Startup . "\" . SubStr(A_ScriptName, 1, -4) . ".lnk"
scriptAdress := A_ScriptDir . "\" . A_ScriptName

Menu, Tray, NoStandard
Menu, Tray, Add, &Open, CBManager
Menu, Tray, Add, Start With Windows, StartWithWin
	if(FileExist(startupLnk))
		Menu, Tray, ToggleCheck, Start With Windows
Menu, Tray, Add, E&xit, ButtonExit
Menu, Tray, Tip, CBManager
if (!A_IsCompiled)
	Menu, Tray, Icon, CB.ico
Return

ButtonExit:
	ExitApp
return

StartWithWin:
	if(FileExist(startupLnk))
		FileDelete, %startupLnk%
	else 
		FileCreateShortcut, %scriptAdress%, %startupLnk%

	Menu, Tray, ToggleCheck, Start With Windows
return

~^x::
~^c::
	Sleep 200
	if (ClipBoard != ClipHistory[1].content)
	{
	FormatTime, TimeString, , HH:mm:ss dd/MM/yyyy
	ClipHistory.InsertAt(1,{content:ClipBoard, timestamp:TimeString})
	if ClipHistory.Length() > 10
		ClipHistory.RemoveAt(11)
	}
return

>#c::
CBManager:
	Gui, CB:New
	Gui Add, Tab3, vTabNumber x0 y0 w430 h255 -Wrap, 1|2|3|4|5|6|7|8|9|10
		loop, 10
	{
		Gui Tab, %A_Index%
		Gui Add, Button, x8 y23 w80 h24 gCBHCopy, &Copy
		Gui Add, Button, x100 y23 w80 h24 gCBHDelete, &Delete
		Gui Add, Text, x300 y23 w120 h23 +0x200 vCBHTimestamp%A_Index%
		Gui Font,, Consolas
		Gui Add, Edit, x8 y50 w415 h195 +Multi +ReadOnly vCBHContent%A_Index%
		Gui Font
		fcontent := ClipHistory[A_Index].content
		GuiControl,, CBHContent%A_Index%,%fcontent%
		ftimestamp := ClipHistory[A_Index].timestamp
		GuiControl,, CBHTimestamp%A_Index%,%ftimestamp%
	}

	if(!CBxpos)
		CBxpos := (A_ScreenWidth/2)-(428/2)
	if(!CBypos)
		CBypos := (A_ScreenHeight/2)-(255/2)
	Gui CB:Show, w428 h255 x%CBxpos% y%CBypos%, ClipBoard History
	onMessage( 0x0047, Func("WM_WINDOWPOSCHANGED") )

return

CBGuiEscape:
CBGuiClose:
	fcontent := ""
	ftimestamp := ""
	Gui, CB:Destroy
return

CBHCopy:
	GuiControlGet, CurrentTab,, TabNumber
	GuiControlGet, fCont,, CBHContent%CurrentTab%
	if (fcont != "")
	{
		ClipBoard := fCont
		fCont := ""
	}
return

CBHDelete:
	GuiControlGet, CurrentTab,, TabNumber
	ClipHistory.RemoveAt(CurrentTab)
	GuiControl, CB:, CBHContent%CurrentTab%,
	GuiControl, CB:, CBHTimestamp%CurrentTab%,
return

WM_WINDOWPOSCHANGED() {
  WinGetPos, CBxpos, CBypos
}
