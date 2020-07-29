" set the real name of selfdom directory which clone from github
let Selfdom_dir_name='g-vim-OnePunch'

" reset the path of $vim
let $vim='$VIMRUNTIME/../'.Selfdom_dir_name

" customize the path of vimfiles and add to the runtimepath, input "set rtp?" to print it
set rtp+=$vim/vimfiles/

function! Copy_vimrc_file()
    let $Current_path=getcwd()
    " echo $Current_path
    cd $vim
    " 方法一：肉眼可见弹出cmd窗口
    " silent !copy .\..\_vimrc .\vimrc
    " 方法二：terminal插件瞬间闪屏
    " terminal ++close
    " call term_sendkeys('',"copy /y .\\..\\_vimrc .\\vimrc && exit\<cr>")
    " 方法三：无感，效果最好
    call system("copy .\\..\\_vimrc .\\vimrc")
    cd $Current_path
endfunction

" sync the new _vimrc to the directory which control by git
autocmd BufWritePost _vimrc call Copy_vimrc_file()

" use the hackable _vimrc which config by user
source $vim/_vimrc_hackable
