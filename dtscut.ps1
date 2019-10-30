$curdir = Convert-Path .

$desktop = [Environment]::GetFolderPath('Desktop')
$wsshell = New-Object -ComObject WScript.Shell
$emacssc = $wsshell.CreateShortcut($desktop + "\emacs.lnk")
$emacssc.TargetPath = $curdir + "\StartEmacs.exe"
$emacssc.Save()
