augroup foldsetting
    " au BufWinEnter * setlocal foldmethod=indent | if &fdm == 'indent' | setlocal foldmethod=manual | endif
    au BufNewFile,BufRead * setlocal foldmethod=syntax | endif
    " au BufWinEnter * setlocal foldmethod=indent
    " au BufWinEnter * setlocal foldmethod=manual
augroup END
