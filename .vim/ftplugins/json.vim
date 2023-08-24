set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set foldmethod=syntax

" Some bindings for json comprehending
au FileType json noremap <buffer> <silent> <leader>d :call jsonpath#echo()<CR>
au FileType json noremap <buffer> <silent> <leader>g :call jsonpath#goto()<CR>
