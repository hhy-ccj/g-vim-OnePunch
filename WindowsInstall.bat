@echo off

::--------------------------------------
:: 为原来文件备份
::--------------------------------------
set cur_timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
set vimrc_path=.\..
if exist "%vimrc_path%\_vimrc" (
    :: 以当前时间戳备份原文件
    copy /y %vimrc_path%\_vimrc %vimrc_path%\_vimrc_%cur_timestamp% 1<nul 2<nul
)
copy /y .\vimrc %vimrc_path%\_vimrc 1<nul 2<nul

::--------------------------------------
:: 创建 undo 历史保存目录
::--------------------------------------
set undo_path=.\..\undo_history
if exist "%undo_path%" (
    :: 先删除再创建文件夹
    rd /s /q %undo_path%
)
md %undo_path%

::--------------------------------------
:: 安装依赖字体
::--------------------------------------
:: -- 分号";"表四powershell一行执行多个命令
powershell Set-ExecutionPolicy Bypass; .\vimfiles\fonts\install.ps1

::-------------------------------------------------------
:: 将 vimfiles/tools 加入全局环境变量，用于全局调用 sync.bat
::-------------------------------------------------------
:: -- 设置延迟变量
REM setlocal enabledelayedexpansion
:: -- 获取环境变量 Path 的值
set path_remain=%path%
REM echo %path_remain%
set current_path=%~dp0
:: -- 要添加到Path的新路径
REM %current_path:~0,-1% 表示 从该变量的值的0位置开始取总长度减1 的值
set target_path=%current_path:~0,-1%\vimfiles\tools\
REM echo %target_path%

:: -- color，详细颜色参考 cmd 命令 help color
set bBlack_fRed="0C"
set bRed_fWhite="4F"
set bBlack_fPurple="0D"
set bBlack_fBlue="09"
set bBlue_fWhite="1F"
:: -- 该 project 自带的显示辅助脚本
set text_color=.\vimfiles\tools\text_color.bat
set echo_n_space=.\vimfiles\tools\echo_n_space.bat

:: -- 查找要添加到Path的路径是否已存在于Path
:loop_path
REM "tokens=1*" 1表示第一列字符用%%a保存，*表示剩余字符用%%b保存
REM "delims=;" 表示以;作为字符串分隔符
    for /f "tokens=1* delims=;" %%a in ("%path_remain%") do (
        REM echo %%a
        if "%%a" == "%target_path%" (
            call :printf "The new path has already exist in the system path" %bBlack_fRed%
            goto install_end
        )
        REM 获取分隔符后面剩余字符串
        set path_remain=%%b
        REM 如果变量非空就继续循环
        if defined path_remain (
            goto loop_path
        )
    )
    goto path_add

:: -- 以“call :printf”方式调用，由于带传参，所以必须定义在“被调用处”的下方(因为 %1 %2 默认为脚本传参)
REM 带格式输出打印函数
:printf
    echo=
    call %echo_n_space% 4
    REM %1 %2 为函数传参，由调用 :printf 处传入
    call %text_color% %1 %2
    call %echo_n_space% 1
    REM 如果调用 setlocal enabledelayedexpansion，应设置为 set /p="^!" <nul，其中 ^ 为转义字符
    set /p="!" <nul
    echo=
goto :eof

:: -- 在 环境变量->系统变量->Path 开头增加新路径
:path_add
    call :printf "Add new path to the system path" %bBlack_fPurple%
    :: 1<nul表示屏蔽成功信息, 2<nul表示屏蔽失败信息
    setx /m "path" "%target_path%;%path%" 1<nul 2<nul
:: -- 安装成功
:install_end
    call :printf "Install gvim in Windows successfully" %bBlue_fWhite%
    echo=
    echo=

pause
