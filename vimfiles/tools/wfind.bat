@echo off

set win32_find=%~dp0\win32\find_linux32
set win64_find=%~dp0\win64\find_linux64

if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
    rem echo "x86"
    set win_find=%win32_find%
) else (
    rem echo "x64"
    set win_find=%win64_find%
)

%win_find% %1 %2
