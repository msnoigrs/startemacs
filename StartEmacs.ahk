#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
FileEncoding, CP65001

DetectHiddenWindows,On

ini_file = StartEmacs.ini

path_emacs := read_ini_file_path(ini_file)
files := GetArgs()
start_emacs(path_emacs)

sleep, 600
drag_and_drop_files_to_emacs(files)

ExitApp

read_ini_file_path(ini_file)
{
    Try
    {
        If not (FileExist(ini_file))
        {
            Throw "ini_file のパスが見つかりません`n設定値:" . %ini_file%
        }
        IniRead, path_emacs, %ini_file%, path, emacs
        If not (FileExist(path_emacs))
        {
            Throw "emacs起動用プログラムのパスがみつかりません`n設定値:" . %path_emacs%
        }
    }
    Catch e
    {
        MsgBox, ファイル指定のエラー`n%e%`nプログラムを終了します
        ExitApp
    }
    return path_emacs
}

GetArgs()
{
    global

    _ArgCount=%0%
    _Args := Object()

    Loop, %_ArgCount%
    {
        _Args.push(%A_Index%)
    }

    return _Args
}

start_emacs(path_emacs)
{
    hwnd := WinExist("ahk_class Emacs")
    if (hwnd)
    {
        WinActivate, ahk_id %hwnd%
        return
    }
    Run, % path_emacs
    return
}

drag_and_drop_files_to_emacs(files)
{
    Try
    {
        Loop, % files.length()
        {
            the_file := files[A_Index]
            if not (FileExist(the_file))
            {
                Throw "編集対象のファイルが見つかりません`nファイル名:" . %the_file%
            }
            PostMessage, 0x233, HDrop(the_file), 0,, ahk_class Emacs
            sleep, 100
        }
    }
    Catch e
    {
        MsgBox, ファイル指定のエラー`n%e%`nプログラムを終了します
        ExitApp
    }
    return
}

; My Scripts
; http://lukewarm.s101.xrea.com/myscripts/
; ファイルドロップ関数
;     指定ウィンドウに改行区切りで指定されたファイルをドロップする
; #17 [Make AHK drop files into other applications: post #17] - Posted 19 March 2014 - 07:54 AM
; http://autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/?p=638376

; #Include DragDrop.ahk

HDrop(fname,x=0,y=0)
{
    characterSize := 2
    fns:=RegExReplace(fname,"\n$")
    fns:=RegExReplace(fns,"^\n")
    hDrop:=DllCall("GlobalAlloc","UInt",0x42,"UInt",20+(StrLen(fns)*characterSize)+characterSize*2)
    p:=DllCall("GlobalLock","UInt",hDrop)
    NumPut(20, p+0) ;offset
    NumPut(x, p+4) ;pt.x
    NumPut(y, p+8) ;pt.y
    NumPut(0, p+12) ;fNC
    NumPut(1, p+16) ;fWide

    p2:=p+20
    Loop,Parse,fns,`n,`r
    {
        DllCall("RtlMoveMemory","UInt",p2,"Str",A_LoopField,"UInt",StrLen(A_LoopField)*characterSize)
        p2+=StrLen(A_LoopField)*characterSize + characterSize
    }
    DllCall("GlobalUnlock","UInt",hDrop)
    return hDrop
}
