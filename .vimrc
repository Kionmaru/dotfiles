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
" Not compatible with neovim
" Plugin 'govim/govim'
Plugin 'rust-lang/rust.vim'
if has('nvim')
  Plugin 'neovim/nvim-lspconfig'
  " Completion framework
  Plugin 'hrsh7th/nvim-cmp'
  Plugin 'hrsh7th/cmp-buffer'
  " LSP completion
  Plugin 'hrsh7th/cmp-nvim-lsp'
  " inlay hints, extra features of rust-analyzer
  Plugin 'simrat39/rust-tools.nvim'
  " snippet stuff
  Plugin 'quangnguyen30192/cmp-nvim-ultisnips'
  " support signatures
  Plugin 'ray-x/lsp_signature.nvim'
endif


call vundle#end()
" End Vundle stuff

" neovim lsp stuff
if has('nvim')
" TODO: Make this suck less. Factor it into multiple files?
" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local opts = {
		tools = {
				autoSetHints = true,
				hover_with_actions = true,
				runnables = {
						use_telescope = true
				},
				inlay_hints = {
						show_parameter_hints = false,
						parameter_hints_prefix = "",
						other_hints_prefix = "",
				},
		},

		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
		server = {
				-- on_attach is a callback called when the language server attachs to the buffer
				-- on_attach = on_attach,
				settings = {
						-- to enable rust-analyzer settings visit:
						-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
						["rust-analyzer"] = {
								-- enable clippy on save
								checkOnSave = {
										command = "clippy"
								},
						}
				}
		},
}

require('rust-tools').setup(opts)
EOF

" Code navigation shortcuts
" as found in :help lsp
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

" Quick-fix
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
				-- vim.fn["vsnip#anonymous"](args.body)
        vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		-- Add tab support
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		})
	},

	-- Installed sources
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' },
		{ name = 'path' },
		{ name = 'buffer' },
	},
})
require('lsp_signature').setup({
  bind = true,
  handler_opts = {
    border = "rounded"
    }
  })
require'lspconfig'.gopls.setup{}
EOF

autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
endif
" end neovim lsp stuff

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

" nvim doesn't have ttymouse
if exists(':ttymouse')
  set ttymouse=sgr
endif

" This may be plugin dependent
if exists(':balloondelay')
  set balloondelay=250
endif

set updatetime=100

if has("patch-8.1.1904") || has('nvim')
  set completeopt+=menuone,noinsert,noselect
endif

if has("patch-8.1.1904")
  set completepopup=align:menu,border:off,highlight:Pmenu
endif

" This is more generic but still found doing golang stuff so
" Remapt C-x (switch to completion mode) C-o
inoremap <C-@> <C-x><C-o>
inoremap <C-Space> <C-x><C-o>
" This is for terminals that use null for C-space.
" End govim stuff

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

" I like mundo, and it's GPL2 so I can use it here!
nnoremap <F5> :MundoToggle<CR>


" Set a colorscheme... and use truecolor.
" For some reason tgc isn't working right on macos? Investigate more
" later.
" set termguicolors
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
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

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
