-- return nil
return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    -- root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json'}
    root_markers = { 'package.json' },
}
