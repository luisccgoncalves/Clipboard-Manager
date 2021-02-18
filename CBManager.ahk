#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global ClipHistory :=[]

~^x::
~^c::
    Sleep 200
    FormatTime, TimeString, , hh:mm:ss dd/MM/yyyy
    ClipHistory.InsertAt(1,{content:ClipBoard, timestamp:TimeString})
    if ClipHistory.Length() > 10
        ClipHistory.RemoveAt(11)
return

>#c::
 
    Gui, CB:New
    Gui Add, Tab3, vTabNumber x0 y0 w430 h255 -Wrap, 1|2|3|4|5|6|7|8|9|10
        loop, 10
    {
        Gui Tab, %A_Index%
        Gui Add, Button, x8 y23 w80 h24 gCBHCopy, &Copy
        Gui Add, Text, x300 y23 w120 h23 +0x200, % ClipHistory[A_Index].timestamp
        Gui Font,, Consolas
        Gui Add, Edit, x8 y50 w415 h195 +Multi +ReadOnly vCBHContent%A_Index%
        Gui Font
        fcontent := ClipHistory[A_Index].content
        GuiControl,, CBHContent%A_Index%,%fcontent%
    }

    Gui CB:Show, w428 h255, ClipBoard History
return

CB:GuiEscape:
CB:GuiClose:
   Gui, CB:Destroy
return

CBHCopy:
    GuiControlGet, CurrentTab,, TabNumber
    GuiControlGet, fCont,, CBHContent%CurrentTab%
    ClipBoard := fCont
return
