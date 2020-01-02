"
" Options
"

set autoindent
set autoread
set backspace=indent,start
set colorcolumn=100
set expandtab
set ignorecase
set mouse=a
set number
set pastetoggle=<F2>
set relativenumber
set shiftwidth=4
set smartcase
set smartindent
set splitbelow
set splitright
set tabstop=4
set wildmenu
set wildmode=list:full

autocmd BufRead *.py set nosmartindent

"
" Mappings
"

let mapleader = ','
nnoremap ; :

" Up/Down with wrapped lines
nnoremap j gj
nnoremap k gk

" Home/End
nnoremap B ^
nnoremap E $

nnoremap D dd
nnoremap Y yy
nnoremap C cc

inoremap <C-l> <Del>

" Search
nnoremap n nzz
nnoremap N Nzz
nnoremap # #zz
nnoremap * *zz

" Clear search
nnoremap <silent> <leader>/ :nohlsearch<cr>

" Select last pasted
nnoremap gp `[v`]

" Save/Exit
nnoremap <silent> <leader>x :x<cr>
nnoremap <silent> <leader>q :q!<cr>
nnoremap <silent> <leader>s :w<cr>
nnoremap <silent> W :w<cr>

" Swap lines
nnoremap <silent> <leader>j ddp
nnoremap <silent> <leader>k <up>ddp<up>
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" Pane navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Tab navigation
nnoremap <Tab> gt
nnoremap <S-Tab> gT

"
" Functions
"

let headers=[ 'h', 'h',   'hh' ]
let sources=[ 'c', 'cpp', 'cpp' ]
" Header/Source
function! s:OpenHeaderSource()
    let filename = expand('%:.:r')
    let extension = expand('%:e')
    let otherfile = ''
    let left=0
    let headers = g:headers
    let sources = g:sources
    for i in range(0, len(headers) - 1)
        if extension == headers[i]
            let otherfile = filename . '.' . sources[i]
            if filereadable(otherfile)
                break
            endif
        elseif extension == sources[i]
            let left=1
            let otherfile = filename . '.' . headers[i]
            if filereadable(otherfile)
                break
            endif
        endif
    endfor

    if otherfile == ''
        echo 'Other file not found'
        return
    endif

    if left == 1
        set nosplitright
    endif
    execute "vs" otherfile
    if left == 1
        set splitright
    endif
endfunction
command! Vss call <SID>OpenHeaderSource()

"
" Plugins
"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Autopair
Plugin 'jiangmiao/auto-pairs'
let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"'}

" Surround
Plugin 'tpope/vim-surround'

" Commentary
Plugin 'tpope/vim-commentary'

" Vim-better-whitespace
Plugin 'ntpeters/vim-better-whitespace'

call vundle#end()
filetype plugin indent on

hi CursorLine cterm=none ctermbg=0

augroup testgroup
   autocmd!
   autocmd BufNewFile,BufRead * syn match OverColLimit /\%>85v.\+/
   autocmd BufNewFile,BufRead * syn match MergeMarker /\(>>>>\|====\|<<<<\).*$/
   autocmd BufNewFile,BufRead * syn match ExtraLines /^$\n^$/

   set hlsearch
   set incsearch
   autocmd BufNewFile,BufRead * hi LineNr ctermfg=Grey
   autocmd BufNewFile,BufRead * hi Visual ctermbg=White ctermfg=Black
   autocmd BufNewFile,BufRead * hi Search ctermbg=White ctermfg=DarkRed cterm=bold
   autocmd BufNewFile,BufRead * hi Statement ctermfg=DarkYellow cterm=none
   autocmd BufNewFile,BufRead * hi String ctermfg=DarkGreen cterm=none
   autocmd BufNewFile,BufRead * hi Constant ctermfg=DarkMagenta cterm=none
   autocmd BufNewFile,BufRead * hi Comment ctermfg=DarkCyan cterm=none
   autocmd BufNewFile,BufRead * hi Function ctermfg=DarkBlue cterm=none
   autocmd BufNewFile,BufRead * hi Special ctermfg=DarkMagenta cterm=none
   autocmd BufNewFile,BufRead * hi Type ctermfg=DarkBlue cterm=none
   autocmd BufNewFile,BufRead * hi ColorColumn ctermbg=DarkGrey
   autocmd BufNewFile,BufRead * hi WildMenu ctermbg=DarkYellow ctermfg=Black cterm=bold
   autocmd BufNewFile,BufRead * hi diffAdded ctermfg=DarkGreen cterm=none
   autocmd BufNewFile,BufRead * hi diffRemoved ctermfg=DarkRed cterm=none
   autocmd BufNewFile,BufRead * hi diffFile ctermfg=DarkCyan cterm=none
   autocmd BufNewFile,BufRead *.c,*.cpp,*.h,*.tac,*.tin,*.py hi OverColLimit ctermfg=DarkRed cterm=bold
   autocmd BufNewFile,BufRead * hi MergeMarker ctermfg=DarkMagenta cterm=bold
   autocmd BufNewFile,BufRead * hi ExtraLines ctermbg=DarkRed
augroup END

syntax enable
syntax on
