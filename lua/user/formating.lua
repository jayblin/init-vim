function _G.j_format()

	if "cpp" == vim.bo.filetype then
		local cmd = "!clang-format -i style=file " .. vim.api.nvim_buf_get_name(0)
		vim.api.nvim_exec(cmd, false)
	end

end

vim.api.nvim_set_keymap(
	"n",
	"<leader>fm",
	"<cmd>lua _G.j_format()<CR>",
	{ noremap=true, silent=true }
)
