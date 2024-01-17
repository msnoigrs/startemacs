if (!(Test-Path -Path .\emacs.ico)) {
    wget https://github.com/emacs-mirror/emacs/raw/master/nt/icons/emacs.ico -OutFile emacs.ico
}

$ahk2exe = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
$arg = "/in StartEmacs.ahk /out StartEmacs.exe /icon emacs.ico /base `"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`" /cp 65001"

$ahk2exep = Start-Process -FilePath $ahk2exe -ArgumentList $arg -Wait -PassThru

#if ($ahk2exep.ExitCode -ne 0) {
#    exit
#}
