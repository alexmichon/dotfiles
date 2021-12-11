setlocal noexpandtab
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8
setlocal smarttab
setlocal cindent
setlocal cinoptions=:0,l1,t0,g0
setlocal colorcolumn=100

syn keyword cType uint ubyte ulong
syn keyword cType uint64_t uint32_t uint16_t uint8_t boolean_t int64_t int32_t int16_t int8_t
syn keyword cType u_int64_t u_int32_t u_int16_t u_int8_t
syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
syn keyword cOperator likely unlikely

syn match ErrorWhitespace / \+\ze\t/

hi ErrorWhitespace ctermbg=Red ctermfg=White

augroup ExtraWhitespace
  autocmd! * <buffer>
  autocmd BufEnter    <buffer> match ErrorWhitespace /\s\+$/
  autocmd InsertEnter <buffer> match ErrorWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave <buffer> match ErrorWhitespace /\s\+$/
augroup END

hi clear cTypeTag
hi clear cPreProcTag
hi clear cFunctionTag
hi clear cEnumTag

" function! g:CtagsUpdate()
"   echom "Updating ctags"
"   exec "AsyncStop"
"   try
"     exec "AsyncRun ctags -R --fields=+iaS --extra=+q"
"   catch
"   endtry
" endfunction

" function! g:CscopeDone()
"   exec "cs reset"
"   exec "call g:CtagsUpdate()"
" endfunc

" function! g:CscopeUpdate()
"   try | exec "cs kill " | catch | endtry
"   exec "AsyncStop"
"   try
"     exec "AsyncRun -post=call\\ g:CscopeDone() ".
"           \ "cscope -b -R -q"
"   catch
"   endtry
" endfunc

function! g:CscopeUpdate()
  exec "Start! gencscope"
endfunction

function! g:CtagsUpdate()
  exec "Start! genctags"
endfunction

function! g:UpdateTags()
  exec "silent call g:CscopeUpdate()"
  exec "silent call g:CtagsUpdate()"
  echom "Tags are up to date !"
endfunction

augroup UpdateTags
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> :silent call g:UpdateTags()
augroup END

" Cscope
nnoremap <silent> <Leader>cs :exec("Cscope0 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :exec("Cscope1 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :exec("Cscope2 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :exec("Cscope3 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :exec("Cscope4 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :exec("Cscope6 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :exec("Cscope7 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :exec("Cscope8 ".expand('<cword>'))<CR>
nnoremap <silent> <Leader>ca :exec("Cscope9 ".expand('<cword>'))<CR>

nnoremap <silent> <Leader>Cs :CscopeQuery0<CR>
nnoremap <silent> <Leader>Cg :CscopeQuery1<CR>
nnoremap <silent> <Leader>Cd :CscopeQuery2<CR>
nnoremap <silent> <Leader>Cc :CscopeQuery3<CR>
nnoremap <silent> <Leader>Ct :CscopeQuery4<CR>
nnoremap <silent> <Leader>Ce :CscopeQuery6<CR>
nnoremap <silent> <Leader>Cf :CscopeQuery7<CR>
nnoremap <silent> <Leader>Ci :CscopeQuery8<CR>
nnoremap <silent> <Leader>Ca :CscopeQuery9<CR>

" noremap <silent> <F5> :!cscope -Rbq<cr>:cs reset<cr>:!ctags -R --fields=+iaS --extra=+q<cr><cr>
noremap <silent> <F5> :call g:UpdateTags()<cr>

nnoremap <silent> <leader>pp Ofprintf(stderr, "%s\n", __func__);<esc>==
