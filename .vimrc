" __     ___
" \ \   / (_)_ __ ___
"  \ \ / /| | '_ ` _ \  " cherrynoize
"   \ V / | | | | | | | " https://github.com/cherrynoize/dotfiles
" o  \_/  |_|_| |_| |_|rc
"     vim config file
"
" if alt key does not send esc try adding to .Xresources
"  URxvt*altSendsEscape: true
"  xterm*altSendsEscape: true
" <m-key> instead of <esc>key also works

" if using fish revert shell to sh
if &shell =~# 'fish$'
    set shell=sh
endif

" blamer
let g:blamer_enabled = 1

" appearance
""""""""""""

" syntax highlighting
syntax on
" tabline
"hi TabLineFill ctermfg=LightBlue ctermbg=DarkBlue
"hi TabLine ctermfg=Black ctermbg=White
" window counter per tab
"hi Title ctermfg=Black

" custom modes
au BufNewFile,BufRead /*.rasi setf css

" switch between hybrid/absolute line numbers with different modes
:set number
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

" don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" selection
"""""""""""

" select with shift + cursor keys
set keymodel=startsel
set keymodel=startsel,stopsel

" behaviour
"""""""""""

" make cw behave like it should
set cpoptions-=_

" search defaults to case sensitive if pattern contains
" an uppercase character
set ignorecase smartcase

" disable search highlighting
set nohlsearch

" backspace, del, c-w and c-u behavior
set backspace=indent,eol,start " run over pretty much everything
" set which characters wrap around lines
set whichwrap+=<,>,[,]

" show tab as number of spaces
"set tabstop=4
" normal mode '>' number of spaces
"set shiftwidth=4
" tab indents with spaces
set expandtab

" indentation
"""""""""""""

" auto-detect filetype and load plugin and indent files 
filetype plugin indent on

" define modes
autocmd FileType sh setlocal shiftwidth=2 tabstop=2
autocmd FileType fish setlocal shiftwidth=2 tabstop=2
autocmd FileType rasi setlocal shiftwidth=2 tabstop=2
autocmd FileType c setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=3 tabstop=3
autocmd FileType lua setlocal shiftwidth=3 tabstop=3

" configuration
nnoremap <esc>R <cmd>:so $MYVIMRC<cr>

" edit
""""""

" undo
inoremap <c-Z> <cmd>:undo<cr>

" rebind to delete instead of cut
nnoremap x i<del><c-o><cmd>stopinsert<cr>
" replicate original x keybinding (cut char)
nnoremap <esc>x vd

" paste before current line
nnoremap <c-p> 0i<cr><esc>kP
" paste after current line
nnoremap <c-n> 0ji<cr><esc>kP

" insert single character
nnoremap <esc>i i <esc>r

" insert whitespace
"nnoremap <esc><space> i<space><c-o><cmd>stopinsert<cr>
 
" insert backspace
"nnoremap <esc><bs> i<bs><c-o><cmd>stopinsert<cr>

" copy word
inoremap <c-c> <esc>yiwea
vnoremap <c-c> <esc>yiwea

" delete till the beginning of a word
" (<c-h> is <c-bs>)
"nnoremap <c-h> db
inoremap <c-h> <c-w>

" delete till the end of a word
"nnoremap <c-del> de
inoremap <c-del> <c-o>de
 
" duplicate line
inoremap <c-d> <cmd>:copy+0<cr>
noremap <esc>d <cmd>:copy+0<cr>

" append newline after current line
nnoremap <cr> o<esc>
" insert newline character at cursor
nnoremap <esc><cr> i<cr><esc>
" delete from last newline up to cursor
nnoremap <esc>o d0i<bs><c-o><cmd>stopinsert<cr>

" append to all selected lines
vnoremap A :s/$/

" search and replace
""""""""""""""""""""

" toggle search highlighting and move to next match
nnoremap <f3> :set hlsearch!<cr>

" indent
""""""""

" align on equals sign
vnoremap <esc>= :! column -t -s= -o=<cr>
nnoremap <esc>= Vk:! column -t -s= -o=<cr>2$

" buffer navigation
"""""""""""""""""""

" move to beginning/end of paragraph
noremap è {
noremap ò }

" buffer editing
""""""""""""""""

" open buffer command menu
nnoremap <f12> :buffers<cr>:buffer<space>

" workflow
""""""""""

" move between windows
nnoremap <esc>h <c-w>h
nnoremap <esc>j <c-w>j
nnoremap <esc>k <c-w>k
nnoremap <esc>l <c-w>l

" open new empty tab
nnoremap <esc>t :tabe<cr>
" move to next tab
nnoremap <esc><Tab> gt
inoremap <esc><Tab> <cmd>gt<cr>
" move to previous tab
nnoremap <S-Tab> gT
inoremap <S-Tab> <cmd>gT<cr>
" close current window
nnoremap <esc>c :clo<cr>
" close tab
nnoremap <esc>w :tabc<cr>

" session and file handling
"""""""""""""""""""""""""""

" write all files
nnoremap <c-s> :w!<cr>
inoremap <c-s> <cmd>:w<cr>
" write all and save default session
nnoremap <esc>s :w<cr>
"nnoremap <esc>s :wa!<cr>:mksession! ~/.vim/sessions/main.vim<cr>
" save and close all files
nnoremap <esc>q :qa<cr>
"nnoremap <esc>q :xa<cr>
nnoremap <esc>Q :q!<cr>

" vim: sw=2:ts=2
