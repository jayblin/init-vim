require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
        disable = function(lang, bufnr)
            -- return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
            -- return "markdown" == lang or not ("vimdoc" == lang or "lua" == lang )
            return "markdown" == lang
        end,
        additional_vim_regex_highlighting = false,
	}
}
