@echo off
set filter_path=^
   ! -path "*git*" ^
   ! -path ".*bt16*" ^
   ! -path ".*br16*" ^
   ! -path ".*br20*" ^
   ! -path ".*br21*" ^
   ! -path ".*bm21*" ^
   ! -path "*build*" ^
   ! -path "*CMakeFiles*" ^
   ! -path "*doc"

set file_format=".*\.\(c\|h\|s\|S\|ld\|s51\|conf\)"
set win32_find=%~dp0\win32\find_linux32
set win64_find=%~dp0\win64\find_linux64

del tags cscope.out filenametags
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
    rem echo "x86"
    set win_find=%win32_find%
) else (
    rem echo "x64"
    set win_find=%win64_find%
)
rem echo cur_find=%win_find%

rem %win_find% %filter_path% -regex %file_format% | ctags -R --fields=+lS --languages=+Asm
ctags -R --fields=+lS --languages=+Asm
%win_find% %filter_path% -regex %file_format% > cscope.input
cscope -b -i cscope.input
del cscope.input
%win_find% . %filter_path% -not -regex ".*\.\(doc\|pdf\|o\|d\|obj\|lst\|swp\|png\)" -type f -printf "%1" | %~dp0\win32\sort_linux32 -f>>filenametags

