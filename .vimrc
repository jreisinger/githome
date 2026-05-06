" Syntax higlighting
syntax on

" Cursor
let &t_ti .= "\<Esc>[2 q" " On Vim startup (normal mode): block
let &t_SI  = "\<Esc>[6 q" " Insert mode: vertical line
let &t_EI  = "\<Esc>[2 q" " Back to normal mode: block
let &t_te .= "\<Esc>[2 q" " Leave terminal with block after quitting Vim

" Indentation
set tabstop=4    " tab is 4 columns
set autoindent
set shiftwidth=4 " for autoident

" Toggle coding mode with F3 
nnoremap <F3> :call CodeMode()<CR>

" Toggle coding mode
function! CodeMode()
    if &textwidth == 0
        set textwidth=79
        set colorcolumn=80
        set number
        set ruler
        set cursorline
    else
        set textwidth=0
        set colorcolumn=
        set nonumber
        set noruler
        set nocursorline
    endif
endfunction

" Autoformat Go code on save
autocmd BufWritePre *.go :silent! %!gofmt
