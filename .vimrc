" to remove the garbage from last line
" (https://github.com/vim/vim/issues/3197#issuecomment-549086639)
set t_RB= t_RF= t_RV= t_u7=

" basics
syntax on                   " syntax highlighting
filetype on                 " try to detect filetypes
filetype plugin indent on   " enable loading indent file for filetype
set showmatch               " show matching brackets
set nofoldenable            " disable folding
set ttimeoutlen=50          " delay in milliseconds after (Esc) key press
"colors paramount            " stored in .vim/colors
"colors delek

" space settings: spaces instead of tabs, looks the same in all editors
set expandtab       " insert space(s) when tab key is pressed
set tabstop=4       " number of spaces inserted
set shiftwidth=4    " number of spaces for indentation

" per language settings
" (https://github.com/zdr1976/dotfiles/blob/master/vim/vimrc#L170)
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType go,godoc setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType html,htmldjango setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd BufNewFile,BufRead *.kubeconfig setlocal filetype=yaml
autocmd FileType c,go,python autocmd BufWritePre <buffer> :%s/\s\+$//e

" Where to store swap (*.swp) and backup (~) files. The double slash at the
" end ensures that there is no conflict in case of two files having the same
" name. The ,. allow vim to use the current directory if the former doesn't
" exist.
set directory=$HOME/.vim//,.
set backupdir=$HOME/.vim//,.

" don't bell or blink
set noerrorbells
set vb t_vb=

" search
set ignorecase  " case-insensitive search
set smartcase   " overide ignorecase when search includes uppercase letters

" stop vim from messing up my indentation on comments
" (https://unix.stackexchange.com/questions/106526/stop-vim-from-messing-up-my-indentation-on-comments)
set cinkeys-=0#
set indentkeys-=0#

" show only cursor column (in bytes), right aligned
"set rulerformat=%=%c

" toggle paste to retain indentation of the pasted text
set pastetoggle=<F2>

" toggle coding mode
nnoremap <F3> :call CodeMode()<CR>
function! CodeMode()
if &textwidth == 0
    set textwidth=79
    set colorcolumn=80
    set nu
    set ruler
    set cursorline
    let s:highlightcursor=1
else
    set textwidth=0
    set colorcolumn=0
    set nu!
    set ruler!
    set cursorline!
    unlet s:highlightcursor
endif
endfunction

" reset the cursor on start (for older versions of vim, usually not required)
"augroup myCmds
"au!
"autocmd VimEnter * silent !echo -ne "\e[2 q"
"augroup END

" change the cursor between normal and insert mode
"let &t_SI = "\e[6 q"
"let &t_EI = "\e[2 q"

" vim-go plugin
let g:go_auto_type_info = 1 " show info on identifiers (:GoInfo)
let g:go_auto_sameids   = 0 " automatically highlight identifiers (:GoSameIds[Clear])
