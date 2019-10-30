@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Unrestricted .\build.ps1

set /p answer="Would you like to create a desktop shortcut? (y/N)"
if /i {%answer%}=={y} (goto :createsc)
if /i {%answer%}=={yes} (goto :createsc)

goto :step2

:createsc

powershell -NoProfile -ExecutionPolicy Unrestricted .\dtscut.ps1

:step2

set /p answer="Would you like to add a menu to the right click menu? (y/N)"
if /i {%answer%}=={y} (goto :addrc)
if /i {%answer%}=={yes} (goto :addrc)

goto :end

:addrc

powershell -NoProfile -ExecutionPolicy Unrestricted .\oiemacs.ps1

:end

pause
