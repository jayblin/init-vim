
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup()

local u_cmp = require("user.cmp")

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
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
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

	-- require'completion'.on_attach(client, bufnr)
end

require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    capabilities = u_cmp.capabilities,
}

require('lspconfig')['intelephense'].setup{
    on_attach = on_attach,
    capabilities = u_cmp.capabilities,
}

require('lspconfig')['cssls'].setup{
    on_attach = on_attach,
    capabilities = u_cmp.capabilities,
}

-- local lsp_installer = require("nvim-lsp-installer")

-- lsp_installer.on_server_ready(function(server)
-- 	-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- 	local opts = {
-- 		capabilities = u_cmp.capabilities,
-- 		on_attach = on_attach,
-- 		root_dir = function() return vim.loop.cwd() end
-- 	}

-- 	if server.name == "sumneko_lua" then
-- 		local runtime_path = vim.split(package.path, ';')
-- 		table.insert(runtime_path, "lua/?.lua")
-- 		table.insert(runtime_path, "lua/?/init.lua")

-- 		opts.settings = {
-- 			Lua = {
-- 				runtime = {
-- 					version = 'LuaJIT',
-- 					path = runtime_path,
-- 				},
-- 				diagnostics = {
-- 					globals = { "vim" },
-- 				},
-- 				workspace = {
-- 					-- library = {
-- 					-- 	[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 					-- },
-- 					-- library = vim.api.nvim_get_runtime_file("", true),
-- 				},
-- 			},
-- 		}
-- 	end

--     server:setup(opts)
-- end)

vim.diagnostic.config({
	virtual_text = false,
	float = {
		focusable = true,
		source = "always",
	},
})

