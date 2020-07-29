@echo off

:: 为原来文件备份
set cur_timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
set vimrc_path=.\..
if exist "%vimrc_path%\_vimrc" (
    :: 以当前时间戳备份原文件
    copy /y %vimrc_path%\_vimrc %vimrc_path%\_vimrc_%cur_timestamp%
)
copy /y .\vimrc %vimrc_path%\_vimrc

:: 创建 undo 历史保存目录
set undo_path=.\..\undo_history
if exist "%undo_path%" (
    :: 先删除再创建文件夹
    rd /s /q %undo_path%
)
md %undo_path%

:: 安装依赖字体

:: 将 vimfiles/tools 加入全局环境变量，用于全局调用 sync.bat
