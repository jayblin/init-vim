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
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'sainnhe/edge'
Plug 'flrnprz/plastic.vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':tsupdate'}
Plug 'nvim-lua/completion-nvim'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
" Plug 'wfxr/minimap.vim'
" Plug 'jackguo380/vim-lsp-cxx-highlight'
call plug#end()

" command! Scratch lua require'tools'.makeScratch()
lua <<EOF
local is_linux = string.find(os.getenv('HOME'), '/home')

-- then assume i'm on Windows
if is_linux == nil then
	package.path = package.path .. '~/AppData/Local/nvim/plugged/nvim-lsp/lua;'
end

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>Q', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
		hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
		augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], false)
	end

	require'completion'.on_attach(client, bufnr)
end

require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()

for _, server in pairs(servers) do
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local config = {
		capabilities = capabilities,
		on_attach = on_attach,
		root_dir = function() return vim.loop.cwd() end
	}

	if server == "php" then
		config.filetypes = {"php"}
	end

	if server == "typescript" then
		config.filetypes = {"ts", "tsx", "js", "jsx", "typescript", "typescriptreact"}
	end

	if server == "html" then
		config.filetypes = {"html", "twig"}
	end

	if server == "lua" then
		-- config.capabilities.workspace.workspaceFolders = {
		-- 	"/usr/share/awesome/lib/gears"
		-- }
		-- print(vim.inspect(config))
	end

	require'lspconfig'[server].setup(config)
end

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true
	}
}

local o = vim.o

local function get_tab_number()
	return 
end


function my_tab_line()
	local tabpages = vim.api.nvim_list_tabpages()
	local line = ""
	local current_tab_number = vim.api.nvim_get_current_tabpage()

	local n = #tabpages
	for i, page_number in ipairs(tabpages) do
		local windows = vim.api.nvim_tabpage_list_wins(page_number)

		if page_number == current_tab_number then
			line = line .. "%#SpecialKey# "
		else
			line = line .. "%#TabLine# "
		end

		line = line .. "%" .. i .. "T" .. i .. " "

		for j, window in ipairs(windows) do
			local buffer = vim.api.nvim_win_get_buf(window)
			local buffer_name = vim.api.nvim_buf_get_name(buffer) or ""

			buffer_name = buffer_name:match("[^/]*.$") or ""
			
			if j > 1 then
				line = line .. " | " .. buffer_name
			else
				line = line .. buffer_name
			end
		end

		-- line = line .. "%T"
		line = line .. "%T "
	end

	-- after the last tab fill with TabLineFill and reset tab page nr
	line = line .. '%#TabLineFill#'

	return line
end

o.tabline = '%!v:lua.my_tab_line()'

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_trigger_keyword_length = 3
let g:completion_matching_ignore_case = 1
imap <silent> <C-p> <Plug>(completion_trigger)

syntax on

set conceallevel=3

set mouse=nv

set number
set relativenumber

set listchars=tab:\|\ 
set list

set tabstop=4
set softtabstop=0
set shiftwidth=4
set noexpandtab

set foldmethod=indent

set lazyredraw

set splitbelow
set splitright

set encoding=utf-8

set cursorline

" set autoindent

let g:typescript_indent_disable = 1

let g:airline_powerline_fonts = 1

" Показывать табы, даже когда открыт всего один таб
set showtabline=2

function! AirlineOverride(...)
	call a:1.add_section('airline_a', ' %{toupper(mode())} ')
	call a:1.add_section('StatusLine', ' %f ')
	call a:1.split()
	call a:1.add_section('Tag', ' %l/%L ')
	return 1
endfunction
call airline#add_statusline_func('AirlineOverride')

let g:minimap_width=10
let g:minimap_auto_start=1
let g:minimap_auto_start_win_enter=0
let g:minimap_highlight_range=1
let g:minimap_highlight='Keyword'
let g:minimap_git_colors=1
let g:minimap_git_color_priority=200

nnoremap <silent> `` :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>

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
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
nnoremap <C-b> :NERDTreeToggle<CR>

" Поиск по названиям файлов
nnoremap <silent> <C-P> :GFiles<CR>

colorscheme codedark

set colorcolumn=81

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
	exec 'autocmd FileType nerdtree highlight ' . a:extension  . ' ctermfg=' . a:fg . ' ctermbg=' . a:bg
	exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'.  a:extension .'$#'
endfunction

call NERDTreeHighlightFile('ts', 'red', 'none')
call NERDTreeHighlightFile('js', 'darkred', 'none')
call NERDTreeHighlightFile('json', 'magenta', 'none')
call NERDTreeHighlightFile('html', 'blue', 'none')

