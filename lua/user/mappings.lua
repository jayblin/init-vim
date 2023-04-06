local Terminal  = require('toggleterm.terminal').Terminal

local builder = Terminal:new({
	hidden = true,
	direction = 'vertical',
	start_in_insert = false,
	on_open = function (term)
		term:set_mode('n')
		term:resize(vim.o.columns * 0.5)
	end,
})

local opts = { noremap=true, silent=true }

function _G.build_cpp()
	-- cmake --build build --target=home_api_tests; cmake --install build
	local f = io.open('./cmake_targets', 'r')
	local target_name = ''
	local options = ''
	builder:close()

	if f ~= nil then
		f:close()

		local lines = {}

		for line in io.lines('./cmake_targets') do
			lines[#lines + 1] = line
		end

		vim.ui.select(
			lines,
			{
				prompt = 'Select target: '
			},
			function (choice)
				target_name = choice
			end
		)
	else
		vim.ui.input(
			{prompt = 'Enter target name: '},
			function (input) target_name = input  end
		)
	end
	build_cmd = 'clear; cmake --build build --target=' .. target_name .. '; cmake --install build'

	builder:open()
	builder:send(build_cmd)
end


vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua _G.build_cpp()<CR>', opts)


-- function _G.set_terminal_keymaps()
-- 	local opts = {buffer = 0}
-- 	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
-- 	-- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
-- 	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
-- 	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
-- 	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
-- 	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
-- 	-- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
-- end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
