@echo off

:: 设置当前 cmd 的编码格式为 UTF-8, 即可以用 echo 输出中文
:: >nul 表示屏蔽操作成功显示的信息, 但是出错还是会显示
chcp 65001 >nul

:: 管理员模式安装
pushd .
call .\vimfiles\tools\admin.bat WindowsInstall.bat
popd
