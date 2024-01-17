#SingleInstance Force
FileEncoding "UTF-8"

DetectHiddenWindows true

IniFile := "StartEmacs.ini"

PathEmacs := ReadIniFile(IniFile)

StartEmacs(PathEmacs)
Sleep 600

for n, param in A_Args
{
    if !(FileExist(param))
    {
        MsgBox Format("{1}が見つかりません。`nプログラムを終了します", param)
        ExitApp
    }
    PostMessage(0x233, HDrop(param), 0,,"ahk_class Emacs")
    Sleep 100
}

ReadIniFile(inifile)
{
    if !(FileExist(inifile))
    {
        MsgBox Format("{1}が見つかりません。`nプログラムを終了します", inifile)
        ExitApp
    }

    try
    {
        PathEmacs := IniRead(inifile, "path", "emacs")
    }
    catch Error {
          MsgBox Format("{1}ファイル中に以下のキーが見つかりません。`n`n[path]`nemacs=myemacs.bat`n`nプログラムを終了します", inifile)
          ExitApp
    }

    return PathEmacs
}

StartEmacs(path)
{
    if WinExist("ahk_class Emacs")
    {
        WinActivate
        return
    }
    Run path
    return
}

; My Scripts
; http://lukewarm.s101.xrea.com/myscripts/
; ファイルドロップ関数
;     指定ウィンドウに改行区切りで指定されたファイルをドロップする
; #17 [Make AHK drop files into other applications: post #17] - Posted 19 March 2014 - 07:54 AM
; http://autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/?p=638376

; #Include DragDrop.ahk

HDrop(fname, x:=0, y:=0)
{
    characterSize := 2
    fns:=RegExReplace(fname,"\n$")
    fns:=RegExReplace(fns,"^\n")
    hDrop:=DllCall("GlobalAlloc","UInt",0x42,"UInt",20+(StrLen(fns)*characterSize)+characterSize*2)
    p:=DllCall("GlobalLock","UInt",hDrop)
    NumPut "UInt", 20, p+0 ;offset
    NumPut "UInt", x, p+4  ;pt.x
    NumPut "UInt", y, p+8  ;pt.y
    NumPut "UInt", 0, p+12 ;fNC
    NumPut "UInt", 1, p+16 ;fWide

    p2:=p+20
    Loop parse, fns, "`n", "`r"
    {
        DllCall("RtlMoveMemory","UInt",p2,"Str",A_LoopField,"UInt",StrLen(A_LoopField)*characterSize)
        p2+=StrLen(A_LoopField)*characterSize + characterSize
    }
    DllCall("GlobalUnlock","UInt",hDrop)
    return hDrop
}
