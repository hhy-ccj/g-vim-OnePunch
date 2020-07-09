@echo off

::--------------------------------------
:: ->->->->- local variable -<-<-<-<-
::--------------------------------------
::
set SUCC=0
set FAIL=1
set Quickfix=ErrorOut
set MakeResult=MakeResult
:: -- color，详细颜色参考 cmd 命令 help color
set bBlack_fRed="0C"
set bRed_fWhite="4F"
set bBlack_fPurple="0D"
set bBlack_fBlue="09"
set bBlue_fWhite="1F"

::--------------------------------------
:: ->->->->- make -<-<-<-<-
::--------------------------------------
::
:: -- make and output compile error(2 代表 STDERR) to %MakeResult%
make %1 -j 2> %MakeResult%

::--------------------------------------
:: ->->->->- output error -<-<-<-<-
::--------------------------------------
::
del %Quickfix%
:: -- 创建新文件
rem cd. > %Quickfix%
:: -- 显示空行
echo=
:: -- 提取行
for /f "delims=" %%a in (%MakeResult%) do (
    rem echo %%i
    :: -- 根据编译输出结果格式，如果出现“error”，将出现在以 : 为分隔符的第5列
    for /f "tokens=5 delims=:::::" %%b in ("%%a") do (
        if "%%b" == " error" (
            :: -- 在文件末尾，追加写入发生error的行
            echo %%a >> %Quickfix%
            :: -- 显示错误行以空格为分隔符的第一列
            for /f "tokens=1 delims= " %%c in ("%%a") do (
                set /p="%%c " <nul
            )
            :: --红色字体显示“error”
            call text_color.bat " error" %bBlack_fRed%
            :: -- 显示“:”
            set /p=":" <nul
            :: -- 显示以 : 为分隔符的第6列
            for /f "tokens=6 delims=:::::" %%d in ("%%a") do (
                echo %%d
            )
        )
    )
)
    rem exit /B %SUCC%

del %MakeResult%
if exist "%Quickfix%" (
    rem echo %Quickfix% not empty
    :: -- 显示第一行
    echo=
    echo_n_space 4
    call text_color.bat "Compile fail" %bRed_fWhite%
    echo_n_space 1
    set /p="!" <nul
    echo=
    :: -- 显示第二行
    echo=
    echo_n_space 4
    set /p=^"You can type " " <nul
    call text_color.bat "exit" %bBlack_fRed%
    echo_n_space 1
    set /p=^"" to quit the terminal !" <nul
    echo=
    :: -- 显示第三行
    echo=
    echo_n_space 4
    set /p="After quit the terminal, you can press " <nul
    call text_color.bat "F3" %bBlack_fPurple%
    echo_n_space 1
    set /p="in normal mode to view the error !" <nul
    echo=
    set errorlevel=1
    rem exit /b
) else (
    rem echo %Quickfix% empty
    :: -- 显示第一行
    echo=
    echo_n_space 4
    call text_color.bat "Compile successfully" %bBlue_fWhite%
    echo_n_space 1
    set /p="!" <nul
    echo=
    :: -- 显示第二行
    echo=
    echo_n_space 4
    set /p=^"You can type " " <nul
    call text_color.bat "exit" %bBlack_fRed%
    echo_n_space 1
    set /p=^"" to quit the terminal !" <nul
    echo=
    set errorlevel=0
    exit
)

