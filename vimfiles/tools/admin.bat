@echo off

setlocal enabledelayedexpansion
set current_bat_path=%~dp0
set SourceCmdPath_file=%current_bat_path%\SourceCmdPath
set Target_bat=%1

if exist "%SourceCmdPath_file%" (
    for /f "delims=" %%a in (%SourceCmdPath_file%) do (
        set SourceCmdPath=%%a
        REM echo !SourceCmdPath!
    )
    del %SourceCmdPath_file%
) else (
    set SourceCmdPath=!cd!
    REM echo !SourceCmdPath!
    echo !SourceCmdPath! >> %SourceCmdPath_file%
)

@echo off&(cd/d "%~dp0")&(cacls "%SystemDrive%\System Volume Information" >nul 2>&1)||(start "" mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%~snx0"," %*","","runas",1^)^(window.close^)&exit /b)

:Admin
    setlocal disabledelayedexpansion
    cd/d %SourceCmdPath%
    call %Target_bat%
