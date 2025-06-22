if has('win32')
	call plug#begin('~/AppData/Local/nvim/plugged')
endif
if has('unix')
	call plug#begin('~/.nvim/plugged')
endif
" below are some vim plugins for demonstration purpose.
Plug 'preservim/nerdtree', { 'tag': '6.10' }
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
" Plug 'leafgarland/typescript-vim'
" Plug 'pangloss/vim-javascript'
" Plug 'maxmellon/vim-jsx-pretty'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark', { 'commit': 'd05d1ab602048fc13fd8cc70cd722c083b0fd904' }

"Plug 'neovim/nvim-lsp', { 'tag': 'v0.1.8' }
" Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.8' }
"Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': '39e2eda76828d88b773cc27a3f61d2ad782c922d' }
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/nvim-cmp', { 'commit': '5260e5e8ecadaf13e6b82cf867a909f54e15fd07' }
"Plug 'mfussenegger/nvim-dap', { 'tag': '0.7.0' }
" Plug 'rcarriga/nvim-dap-ui'

" Plug 'williamboman/nvim-lsp-installer'
Plug 'williamboman/mason.nvim', { 'tag': 'v2.0.0' }
"Plug 'williamboman/mason-lspconfig.nvim', { 'tag': 'v2.0.0' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':tsupdate', 'tag': 'v0.10.0' }
Plug 'tpope/vim-commentary', { 'tag': 'v1.3' }
Plug 'airblade/vim-gitgutter', { 'commit': 'e801371917e52805a4ceb1e93f55ed1fba712f82' }
" Plug 'nvim-treesitter/playground' deprecated use :Inspect :InspectTree
" :EditQuery (Nvim 0.10+)
Plug 'akinsho/toggleterm.nvim', { 'tag': 'v2.11.0' }
Plug 'savq/melange', { 'tag': '2024-01-27' }
Plug 'L3MON4D3/LuaSnip', { 'tag': 'v2.3.0' }
Plug 'nvim-lua/plenary.nvim', { 'tag': 'v0.1.4' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'RRethy/nvim-base16', { 'commit': '6ac181b5733518040a33017dde654059cd771b7c' }
" Plug 'lukas-reineke/indent-blankline.nvim'
"Plug 'ojroques/vim-oscyank', { 'tag': 'v2.0.0' }
" Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.12.0' }
" Plug 'nvim-lua/lsp-status.nvim'

"Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh', 'commit': '3ae92fc4fa8b82bfc70fba9d0741fdb5842e74c1' }

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
-- require("user.toggleterm")
require("user.snippets")
-- require("user.indent")
-- require("user.bufferline")
require("user.statusline")
-- require("user.dap")
-- require("dapui").setup()
require("user.mappings")

local telescope = require("telescope")
local t_actions = require("telescope.actions")

telescope.setup{
	defaults = {
		layout_strategy = 'horizontal',
		layout_config = { height = 0.99, width = 0.99 },
	},
    pickers = {
        colorscheme = {
            enable_preview = true,
        }
    },
}

-- require('tabnine').setup({
--   disable_auto_comment=true,
--   accept_keymap="<C-Space>",
--   dismiss_keymap = "<C-]>",
--   debounce_ms = 800,
--   suggestion_color = {gui = "#808080", cterm = 244},
--   exclude_filetypes = {"TelescopePrompt", "NvimTree"},
--   log_file_path = nil, -- absolute path to Tabnine log file
--   ignore_certificate_errors = false,
-- })

-- my plugin. dont use.
--require("file-search")

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menu,menuone,noselect,popup,longest,fuzzy
set pumheight=20
set pumwidth=15

" Avoid showing message extra message when using completion
set shortmess+=c

syntax on

"set conceallevel=0

set hidden

set mouse=nv

set number
set relativenumber

set list
set listchars=tab:··
" set listchars=tab:!·,trail:·

set autoindent
" set softtabstop=0
set tabstop=4
set shiftwidth=4
" set noexpandtab
set expandtab
au BufWinEnter * set autoindent

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
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" nnoremap j k
" nnoremap k j

" vnoremap j k
" vnoremap k j

" Боковая панель NERDTree
"nnoremap <leader>b :NERDTreeToggle<CR>
"nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <Space>b :NERDTreeToggle<CR>
nnoremap <Space>n :NERDTreeFind<CR>

" Поиск по названиям файлов
"nnoremap <leader>p <cmd>Telescope find_files<cr>
"nnoremap <leader>f <cmd>Telescope live_grep<cr>
"nnoremap <leader>hb <cmd>Telescope buffers<cr>
"nnoremap <leader>g <cmd>Telescope git_status<cr>
nnoremap <Space>p <cmd>Telescope find_files<cr>
nnoremap <Space>f <cmd>Telescope live_grep<cr>
nnoremap <Space>hb <cmd>Telescope buffers<cr>
nnoremap <Space>g <cmd>Telescope git_status<cr>

nnoremap <C-Left> <cmd>vertical resize +2<cr>
nnoremap <C-Right> <cmd>vertical resize -2<cr>
nnoremap <C-Up> <cmd>resize -2<cr>
nnoremap <C-Down> <cmd>resize +2<cr>

set termguicolors

 "colorscheme codedark
" colorscheme melange
" colorscheme base16-woodland
" colorscheme base16-atelier-dune
" colorscheme base16-atelier-plateau
" colorscheme base16-atelier-savanna
" colorscheme base16-darkmoss
" colorscheme base16-dirtysea " light
" colorscheme base16-equilibrium-gray-dark
" colorscheme base16-black-metal-dark-funeral
colorscheme base16-catppuccin-macchiato
" colorscheme base16-equilibrium-light
" colorscheme base16-atelier-heath-light

hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE

set colorcolumn=81
set signcolumn=yes
set wrapmargin=0
set textwidth=0
set wrap
set linebreak
" set textwidth=80
set langmap=ФA,ИB,СC,ВD,УE,АF,ПG,РH,ШI,ОJ,ЛK,ДL,ЬM,ТN,ЩO,ЗP,ЙQ,КR,ЫS,ЕT,ГU,МV,ЦW,ЧX,НY,ЯZ,фa,иb,сc,вd,уe,аf,пg,рh,шi,оj,лk,дl,ьm,тn,щo,зp,йq,кr,ыs,еt,гu,мv,цw,чx,нy,яz

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
	exec 'autocmd FileType nerdtree highlight ' . a:extension  . ' ctermfg=' . a:fg . ' ctermbg=' . a:bg
	exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'.  a:extension .'$#'
endfunction

call NERDTreeHighlightFile('ts', 'red', 'none')
call NERDTreeHighlightFile('js', 'darkred', 'none')
call NERDTreeHighlightFile('json', 'magenta', 'none')
call NERDTreeHighlightFile('html', 'blue', 'none')

" LSP
autocmd LspProgress * redrawstatus
" LSP END

" SNIPPETS
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
" SNIPPETS END

" OSCYank
vnoremap <leader>c :OSCYankVisual<CR>
" nmap <leader>o <Plug>OSCYank
" OSCYank

" nnoremap <leader>f <cmd>lua vim.api.nvim_exec('clang-format -i style=file ' .. vim.api.nvim_buf_get_name(0), false)<cr>
" nnoremap <leader>f <cmd>!{clang-format -i style=file} expand('%:p')<cr>
