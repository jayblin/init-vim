if has('win32')
	call plug#begin('~/AppData/Local/nvim/plugged')
endif
if has('unix')
	call plug#begin('~/.nvim/plugged')
endif
" below are some vim plugins for demonstration purpose.
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'

Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Plug 'williamboman/nvim-lsp-installer'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':tsupdate'}
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'nvim-treesitter/playground'
Plug 'akinsho/toggleterm.nvim'
Plug 'savq/melange'
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'RRethy/nvim-base16'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'nvim-lua/lsp-status.nvim'
call plug#end()

" command! Scratch lua require'tools'.makeScratch()
lua <<EOF
local home_path = os.getenv('HOME')

if home_path == nil then home_path = "" end

local is_linux = string.find(home_path, '/home')

-- then assume i'm on Windows
if is_linux == nil then
	package.path = package.path .. '~/AppData/Local/nvim/plugged/nvim-lsp/lua;'
end

require("user.lsp")
require("user.treesitter")
require("user.toggleterm")
require("user.tabline")
require("user.snippets")
require("user.airline")
require("user.indent")
require("user.bufferline")
require("user.statusline")
require("user.formating")

local telescope = require("telescope")
local t_actions = require("telescope.actions")

telescope.setup{
	defaults = {
		layout_strategy = 'horizontal',
		layout_config = { height = 0.99, width = 0.99 },
	}
}

-- my plugin. dont use.
--require("file-search")

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menu,menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

syntax on

set conceallevel=3

set hidden

set mouse=nv

set number
set relativenumber

" set listchars=tab:\|\ 
" set list

set autoindent
" set softtabstop=0
set tabstop=4
set shiftwidth=4
set noexpandtab

set foldlevel=8
set foldmethod=indent
set foldnestmax=20

set lazyredraw

set splitbelow
set splitright

set encoding=utf-8

set cursorline

let g:typescript_indent_disable = 1

" Показывать табы, даже когда открыт всего один таб
set showtabline=2

nnoremap <silent> `` :nohlsearch<CR>

" Навигация по сплитам
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-j>
nnoremap <C-j> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

nnoremap j k
nnoremap k j

vnoremap j k
vnoremap k j

" Боковая панель NERDTree
nnoremap <leader>b :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<CR>

" Поиск по названиям файлов
" nnoremap <silent> <C-p> <cmd>Telescope find_files<cr>
" nnoremap <silent> <C-f> <cmd>Telescope live_grep<cr>
nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>h <cmd>Telescope buffers<cr>
nnoremap <leader>g <cmd>Telescope git_status<cr>

set termguicolors

colorscheme codedark
" colorscheme melange
" colorscheme base16-woodland
" colorscheme base16-atelier-dune
" colorscheme base16-atelier-plateau
" colorscheme base16-atelier-savanna
" colorscheme base16-darkmoss
" colorscheme base16-dirtysea " light
" colorscheme base16-equilibrium-gray-dark

hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE

set colorcolumn=81
set signcolumn=yes

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
	exec 'autocmd FileType nerdtree highlight ' . a:extension  . ' ctermfg=' . a:fg . ' ctermbg=' . a:bg
	exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'.  a:extension .'$#'
endfunction

call NERDTreeHighlightFile('ts', 'red', 'none')
call NERDTreeHighlightFile('js', 'darkred', 'none')
call NERDTreeHighlightFile('json', 'magenta', 'none')
call NERDTreeHighlightFile('html', 'blue', 'none')

" SNIPPETS
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
" SNIPPETS END

" OSCYank
vnoremap <leader>c :OSCYank<CR>
nmap <leader>o <Plug>OSCYank
" OSCYank

" nnoremap <leader>f <cmd>lua vim.api.nvim_exec('clang-format -i style=file ' .. vim.api.nvim_buf_get_name(0), false)<cr>
" nnoremap <leader>f <cmd>!{clang-format -i style=file} expand('%:p')<cr>
