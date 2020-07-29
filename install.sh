# 使用“#!/usr/bin/env bash”替换“#!/bin/sh”，防止在不同操作系统上“/bin/sh”链接到不同版本的默认shell。比如在Ubuntu 64 bits 12.04操作系统上，可能会出现“unexpected operator”的错误 (https://www.cnblogs.com/fnlingnzb-learner/p/10657285.html)
#!/usr/bin/env bash

# 运行平台
OS_name=$(uname -s)
# echo $OS_name
if \
   [ $OS_name == "Darwin" ] || \
   [ "$(expr substr $OS_name 1 5)" == "Linux" ] || \
   [ "$(expr substr $OS_name 1 5)" == "MINGW" ] || \
   false \
   ; then
    echo -e "
        Current platform: $OS_name
    "
else
    echo -e "

        You should use \"install.bat\" !!!

            --- 鼠标双击 “install.bat” 就完事了 ！！！
            --- cmd 输入 \"install.bat\" 也完事了 ！！！
    "
    exit
fi

# 预防在已安装 MINGW 的 windows 下双击"install.sh"
if [ "$1" != "Linux" ]; then
    echo -e "
        You should input \"install.sh Linux\" !!!
    "
    sleep 3
    exit
fi

# 为原来文件备份
mv $HOME/.vim                           $HOME/.vim_backup
mv $HOME/.vimrc                         $HOME/.vimrc_backup
# 在 $HOME 下创建快捷方式
tool_path=$(cd "$(dirname "$0")"; pwd)
ln -s $tool_path/vimfiles               $HOME/.vim
ln -s $tool_path/_vimrc_hackable        $HOME/.vimrc
# 在 $HOME 下创建 undo 历史保存目录
if [ -x "$HOME/.undo_history" ]; then
    echo "rm .undo_history"
    rm -rf	$HOME/.undo_history
fi
mkdir 	$HOME/.undo_history
