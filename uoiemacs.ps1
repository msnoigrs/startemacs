function IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (IsAdmin) {
    New-PSDrive -name "HKCR" -PSProvider "Registry" -root "HKEY_CLASSES_ROOT"
    if (Test-Path -LiteralPath HKCR:\*\shell\open_emacs) {
        Remove-Item -LiteralPath HKCR:\*\shell\open_emacs -Recurse
    }
    if (Test-Path -Path HKCR:\Folder\shell\open_emacs) {
        Remove-Item -Path HKCR:\Folder\shell\open_emacs -Recurse
    }
    if (Test-Path -Path HKCR:\Directory\Background\shell\open_emacs) {
        Remove-Item -Path HKCR:\Directory\Background\shell\open_emacs -Recurse
    }
} else {
    $uoiemacs = Convert-Path .\uoiemacs.ps1
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Unrestricted $uoiemacs" -Verb RunAs
}
