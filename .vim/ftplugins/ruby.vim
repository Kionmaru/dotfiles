"let g:syntastic_ruby_checkers = ['flog', 'mri', 'reek', 'rubocop', 'rubylint']
" rubylint isn't maintained any more, and reek just has some stone
" stupid shit in it - No more than 5 lines per method? What? I'm tired
" of fucking with it's config file.
let ruby_foldable_groups='def #'
let g:syntastic_ruby_checkers = ['flog', 'mri', 'rubocop']
set makeprg=ruby\ %
set expandtab
set softtabstop=2
set shiftwidth=2
set tabstop=2
set textwidth=72
let ruby_fold=1
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open = 1
" packadd vim-ruby
set foldmethod=syntax
set foldlevel=0
