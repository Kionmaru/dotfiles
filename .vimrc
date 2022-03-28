" I like the new vim stuff.
set nocompatible

" temporarily ft off
filetype off
" Vundle stuf
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'simnalamburt/vim-mundo'
Plugin 'tpope/vim-sensible'
Plugin 'vim-syntastic/syntastic'
Plugin 'junegunn/vim-easy-align'
Plugin 'tpope/vim-flagship'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-jdaddy'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-scriptease'
Plugin 'mogelbrod/vim-jsonpath'
Plugin 'govim/govim'

call vundle#end()
" End Vundle stuff

" Don't use pathogen anymore
" execute pathogen#infect()
syntax on
filetype on " done with Vundle, turn it back on
filetype plugin indent on

" I like these.
set softtabstop=2
set shiftwidth=2
set tabstop=2
set textwidth=72
set expandtab
" set tabstop=3
" set shiftwidth=3

" Avoid command-line redraw on every entered character by turning off Arabic
" shaping (which is implemented poorly).
if has('arabic')
	set noarabicshape
endif



" I don't want vim mouse integrations.
" set mouse=""
" I might want them for go lang hints?
" In fact, you can hold shift to disable mouse integration now, so you
" can still copy/paste out of vim like it was a normal terminal!
"
"
" Settings for govim/inspired by/etc.
" See
" https://github.com/govim/govim/blob/main/cmd/govim/config/minimal.vimrc
set mouse=a
set ttymouse=sgr
set balloondelay=250
set updatetime=100


" autoindent makes life easier.
set autoindent
" Running into some problems with comment indentation
set cindent
set cinkeys-=0#

" I really really hate supertab.
let complType="no"

" I *really* want to highlight search matches.
set hlsearch

" color default

" I have no idea why backups aren't on by default
" Enable tree-undo, and backups in a private backup directory so we don't annoy
" me when working in git.
set backup
set backupdir=~/.vim/backup/
set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '-' . strftime("%s")


" Like missing backups, no idea why the hell there's no undodir/undofile
set undodir=~/.vim/undo
set undofile

" I like mundo, and it's GPL2 so I can use it here! -JMD
nnoremap <F5> :MundoToggle<CR>


" Set a colorscheme... and use truecolor.
set termguicolors
" disable background theme color - use terminal
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
colorscheme flattened_dark


" I like vim-easy-align over Align/AlignMap.
"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Handle the bulk of folding settings in ftplugins....
let ruby_foldable_groups='def #'
" So I want indent-based folds, but I also want to manually mark folds
" set fen " foldenable
" " set foldlevelstart=4 " Don't fold everything..
" " set foldmethod=indent
" augroup foldsetting
"     autocmd!
"     " au BufReadPre * setlocal foldmethod=indent
"     " au BufWinEnter * setlocal foldmethod=indent | if &fdm == 'indent' | setlocal foldmethod=manual | endif
"     au BufNewFile,BufRead * if (&ft == 'ruby' ||  &ft == 'python') | setlocal foldmethod=syntax | endif
"     " au BufWinEnter * setlocal foldmethod=indent
"     " au BufWinEnter * setlocal foldmethod=manual
" augroup END

" set fen
" Try to fix truecolor through screen
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" I want to look in parent directories for ctags.
set tags=tags;


" Rubocop changes files for me, it pisses me off. This attempts to
" piss me off less
" There was originally a bunch of shit for built-in autoread here, but
" I finally found a plugin that does it better
augroup AutoReading
    autocmd!
    set autoread
    :au CursorMoved * checktime
augroup END

" Vim needs a good statusline
set laststatus=2
set showtabline=2
set guioptions-=e
set statusline=
" I want line numbers.
set ruler

" Default line wrapping options - wrap to 80 cols, on by default.
set textwidth=72
set wrapmargin=80
" Wrap text by default
"set formatoptions+=t

" " Highlight all characters past 74th so we can see long lines
" Actually, there's a vim thing for this now.
" augroup vimrc_autocmds
"   autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"   autocmd BufEnter * match OverLength /\%74v.*/
" augroup END
set colorcolumn=80

" Bleh. Apparently this is a thing now.
" On MacOS, this was getting set to "". Also, setting it fixed absurdly slow
" vim startup... No idea why.
set backspace=indent,eol,start
set relativenumber


" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetsDir="~/.vim/snips"
let g:UltiSnipsSnippetDirectories=["snips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" let g:UltiSnipsEditSplit="vertical"

" If you want :UltiSnipsEdit to split your window.
" au! UltiSnips_AutoTrigger
"
" YAML linting~
let g:syntastic_yaml_checkers = ['yamllint']
"
"
" Some bindings for json comprehending
au FileType json noremap <buffer> <silent> <leader>d :call jsonpath#echo()<CR>
au FileType json noremap <buffer> <silent> <leader>g :call jsonpath#goto()<CR>
