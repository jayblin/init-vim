-- local lsp_status = require "lsp-status"

-- lsp_status.register_progress()

local mason = require("mason")
-- local mason_lspconfig = require("mason-lspconfig")
--
mason.setup({
	providers = {
		"mason.providers.client",
		"mason.providers.registry-api",
	}
})
-- mason_lspconfig.setup()

-- local u_cmp = require("user.cmp")

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
	buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format({async = false})<CR>', opts)

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

-- local lspconf = require('lspconfig')

-- vim.api.nvim_create_autocmd("LspAttach", {
--     group = vim.api.nvim_create_augroup("lsp", { clear = true }),
--     callback = function(args)
--         vim.api.nvim_create_autocmd("BufWritePre", {
--             buffer = args.buf,
--             callback = function()
--                 vim.lsp.buf.format{async = false, id = args.data.client_id}
--             end
--         })
--     end
-- })

-- lspconf['tsserver'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }
--
-- -- require('lspconfig')['intelephense'].setup{
-- lspconf['phpactor'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }
--
-- lspconf['cssls'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }
--
-- lspconf['clangd'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- 	init_options = {
-- 		clangdFileStatus = true,
-- 		compilationDatabasePath = "./build",
-- 	},
--     -- cmd = {
--     --     "clangd", "--offset-encoding=utf-16"
--     -- },
-- 	-- handlers = lsp_status.extensions.clangd.setup(),
-- }
--
-- lspconf['svelte'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }
--
-- lspconf['lua_ls'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }
--
-- lspconf['cmake'].setup{
--     on_attach = on_attach,
--     -- capabilities = u_cmp.capabilities,
-- }

-- lspconf["sourcekit"].setup{
--     on_attach = on_attach,
    -- capabilities = u_cmp.capabilities,
-- }

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
		-- source = "always",
		source = true,
	},
})


-- vim.lsp.config['luals'] = {
--     -- Command and arguments to start the server.
--     cmd = { 'lua-language-server' },
--
--     -- Filetypes to automatically attach to.
--     filetypes = { 'lua' },
--
--     -- Sets the "root directory" to the parent directory of the file in the
--     -- current buffer that contains either a ".luarc.json" or a
--     -- ".luarc.jsonc" file. Files that share a root directory will reuse
--     -- the connection to the same LSP server.
--     -- Nested lists indicate equal priority, see |vim.lsp.Config|.
--     root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
--
--     -- Specific settings to send to the server. The schema for this is
--     -- defined by the server. For example the schema for lua-language-server
--     -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
--     settings = {
--       Lua = {
--         runtime = {
--           version = 'LuaJIT',
--         }
--       }
--     }
-- }
--
vim.lsp.set_log_level("ERROR")

vim.api.nvim_create_autocmd(
    'LspAttach',
    {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
            end
            local opts = { noremap=true, silent=true }

            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(args.buf, ...) end
            buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
            buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', 'grd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap('n', 'grD', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'grf', '<cmd>lua vim.lsp.buf.format({async = false})<CR>', opts)

            -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
            if client:supports_method('textDocument/completion') then
                -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                -- client.server_capabilities.completionProvider.triggerCharacters = chars

                vim.lsp.completion.enable(
                    true,
                    client.id,
                    args.buf,
                    {
                        autotrigger = false,
                    }
                )
            end

            -- Auto-format ("lint") on save.
            -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
            -- if not client:supports_method('textDocument/willSaveWaitUntil')
            --     and client:supports_method('textDocument/formatting')
            --     then
            --     vim.api.nvim_create_autocmd(
            --         'BufWritePre',
            --         {
            --             group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
            --             buffer = args.buf,
            --             callback = function()
            --                 vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            --             end,
            --         }
            --     )
            -- end
        end,
})

-- vim.api.nvim_create_autocmd('LspNotify', {
--   callback = function(args)
--     local bufnr = args.buf
--     local client_id = args.data.client_id
--     local method = args.data.method
--     local params = args.data.params
--
--     print(method)
--   end,
-- })

-- Hide all semantic highlights
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end

vim.lsp.enable({'luals', 'cpp'})
