highlight clear

if exists("syntax_on")
	syntax reset
endif

set background=dark
let g:colors_name="myscheme"

hi Constant ctermfg=DarkRed cterm=None
hi String ctermfg=DarkGreen cterm=None
hi Number ctermfg=DarkMagenta cterm=None
hi Statement ctermfg=Yellow cterm=None
hi Type ctermfg=DarkBlue cterm=None
hi PreProc ctermfg=DarkMagenta cterm=None
hi Comment ctermfg=DarkCyan cterm=italic
hi link Identifier Normal

set cursorline
hi clear CursorLine
hi CursorLineNr ctermfg=Green cterm=None
hi LineNr ctermfg=Grey cterm=None
hi MatchParen ctermfg=Black ctermbg=Magenta
hi SignColumn ctermbg=None

hi Search ctermfg=Black ctermbg=Blue

hi TabLineFill ctermbg=Grey
hi TabLine ctermfg=Grey ctermbg=Black cterm=None
hi TabLineSel ctermfg=White ctermbg=DarkBlue cterm=bold,underline

hi diffAdded ctermfg=DarkGreen cterm=None
hi diffRemoved ctermfg=DarkRed cterm=None
hi diffChanged ctermfg=Yellow cterm=None
hi diffFile ctermfg=DarkCyan cterm=None
hi diffLine ctermfg=DarkMagenta cterm=None

hi ColorColumn ctermbg=DarkGrey ctermfg=White

hi SpecialKey ctermfg=237 cterm=None

hi Pmenu ctermbg=236 ctermfg=White
hi PmenuSel ctermbg=White ctermfg=Black

" Gitgutter
hi GitGutterAdd ctermfg=Green
hi GitGutterChange ctermfg=Yellow
hi GitGutterDelete ctermfg=Red
