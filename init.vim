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
Plug 'wfxr/minimap.vim'
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
-- require('lspconfig').clangd.setup{}
-- require('nvim_lsp').tsserver.setup{}
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
	-- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>Q', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	--v:lua.vim.lsp.omnifunc

	-- Set some keybinds conditional on server capabilities
	-- if client.resolved_capabilities.document_formatting then
	-- 	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	-- elseif client.resolved_capabilities.document_range_formatting then
	-- 	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	-- end

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

	--if client.resolved_capabilities.completion then
	--	lsp_completion.on_attach(client, bufnr)
	--end

	require'completion'.on_attach(client, bufnr)
end
-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
-- local servers = {}
-- if is_linux == nil then 
-- 	servers['clangd'] = {}
-- else
-- 	servers['clang'] = {}
-- end
-- servers['tsserver'] = {}
-- servers['pyls'] = {
-- 	filetypes = { 'py', 'python' }
-- }
-- servers['vuels'] = {
-- 	cmd = {"vls.cmd"}
-- }

require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()

-- for serverName, serverConfig in pairs(servers) do
-- 	print(serverName)
-- 	if nvim_lsp[serverName] ~= nil then
-- 		local config = {on_attach = on_attach}
-- 
-- 		for key in pairs(serverConfig) do
-- 			print(key)
-- 			config[key] = serverConfig[key]
-- 		end
-- 
-- 		-- print(vim.inspect(config));
-- 
-- 		nvim_lsp[serverName].setup(config)
-- 	end
-- end

for _, server in pairs(servers) do
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local config = {
		capabilities = capabilities,
		on_attach = on_attach,
		root_dir = function() return vim.loop.cwd() end
	}
	-- local config = {on_attach = on_attach}

	-- nvim_lsp[server]['on_attach'] = on_attach
	-- nvim_lsp[server].setup{}

	if server == "php" then
		config.filetypes = {"php"}
	end

	if server == "typescript" then
		config.filetypes = {"ts", "tsx", "js", "jsx", "typescript", "typescriptreact"}
	end

	-- nvim_lsp[server].setup(config)
	require'lspconfig'[server].setup(config)
end

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true
	}
}

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" let g:completion_enable_auto_popup = 1
let g:completion_trigger_keyword_length = 3
" let g:completion_enable_snippet = 'vim-vsnip'
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

set autoindent

let g:typescript_indent_disable = 1

let g:airline_powerline_fonts = 1

let g:minimap_width=10
let g:minimap_auto_start=1
let g:minimap_auto_start_win_enter=0
let g:minimap_highlight_range=1
" hi MinimapCurrent ctermfg=Green guifg=#50FA7B guibg=#32302f
let g:minimap_highlight='Keyword'
" hi MinimapCurrentLine ctermfg=121 ctermbg=121
" let g:minimap_base_highlight='IncSearch'
let g:minimap_git_colors=1
let g:minimap_git_color_priority=200

nnoremap <silent> `` :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>

" map <C-H> ggi#ifndef <CR>#define <CR><CR>#endif // <Esc>

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

" Theme plactic.vim
" set background=dark
" colorscheme plastic
" Lightline
" let g:lightline = { 'colorscheme': 'plastic' }
" Theme plactic.vim

" Theme Edge
" The configuration options should
" be placed before `colorscheme edge`.
"let g:edge_style = 'aura'
"let g:edge_enable_italic = 1
"let g:edge_disable_italic_comment = 1
"colorscheme edge
" Theme Edge

colorscheme codedark

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
	" exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='.  a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd FileType nerdtree highlight ' . a:extension  . ' ctermfg=' . a:fg . ' ctermbg=' . a:bg
	exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'.  a:extension .'$#'
endfunction

call NERDTreeHighlightFile('ts', 'red', 'none')
call NERDTreeHighlightFile('js', 'darkred', 'none')
call NERDTreeHighlightFile('json', 'magenta', 'none')
call NERDTreeHighlightFile('html', 'blue', 'none')

" COC Config

" COC Config

" Настройка нумерации табов
set tabline=%!MyTabLine()

function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		let s .= '%' . (i + 1) . 'T'
		let s .= ' ' . (i + 1) . ' %{MyTabLabel(' . (i + 1) . ')} '
	endfor

	let s .= '%#TabLineFill#%T'

	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999Xclose'
	endif

	return s
endfunction

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)

	return bufname(buflist[winnr - 1])
endfunction

