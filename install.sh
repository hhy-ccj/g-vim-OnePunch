# 为原来文件备份
mv $HOME/.vim                           $HOME/.vim_backup
mv $HOME/.vimrc                         $HOME/.vimrc_backup
# 在 $HOME 下创建快捷方式
tool_path=$(cd "$(dirname "$0")"; pwd)
ln -s $tool_path/vimfiles               $HOME/.vim
ln -s $tool_path/_vimrc                 $HOME/.vimrc
# 在 $HOME 下创建 undo 历史保存目录
if [ -x "$HOME/.undo_history" ]; then
    echo "rm .undo_history"
    rm -rf	$HOME/.undo_history
fi
mkdir 	$HOME/.undo_history
