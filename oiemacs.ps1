$curdir = Convert-Path .

$regedit = "$Env:SystemRoot\REGEDIT.exe"
$regfile = $curdir + "\oiemacs.reg"
$regeditp = Start-Process -FilePath $regedit -ArgumentList "/S /I $regfile" -Wait -PassThru

if ($regeditp -ne 0) {
    "Fail"
}
