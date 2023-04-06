local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '<F6>', '<Cmd>lua require\'dap\'.continue()<CR>', opts)
vim.api.nvim_set_keymap('n', '<F7>', '<Cmd>lua require\'dap\'.step_over()<CR>', opts)
vim.api.nvim_set_keymap('n', '<F8>', '<Cmd>lua require\'dap\'.step_into()<CR>', opts)
vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua require\'dap\'.step_out()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-b>', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>dl', '<Cmd>lua require\'dap\'.run_last()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>dr', '<Cmd>lua require\'dap\'.restart()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>dt', '<Cmd>lua require\'dap\'.terminate()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>dbc', '<Cmd>lua require\'dap\'.clear_breakpoints()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>do', '<Cmd>lua require\'dap\'.repl.toggle()<CR>', opts)

local dap = require('dap')

dap.defaults.fallback.terminal_win_cmd = 'vsplit new'
dap.defaults.fallback.focus_terminal = false

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  -- Добавить путь к exe в PATH.
  -- command = 'C:\\Users\\79678\\AppData\\Local\\nvim-data\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
  command = 'OpenDebugAD7.exe',
  options = {
      -- env?: {}              -- Set the environment variables for the command
      -- cwd?: string          -- Set the working directory for the command
    detached = false
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
		local manifest_location = (io.popen("cd"):read('*l')) .. '/build/install_manifest.txt'
		local lines = {}
		local executables = {}
		local i = 0

		for line in io.lines(manifest_location) do
			local exec_file_name = ''

			for m in string.gmatch(line, "/[^/]+[.]exe$") do
				exec_file_name = m
			end

			if exec_file_name ~= '' then
				i = i + 1
				lines[i] = line
				executables[i] = exec_file_name
			end
		end

		local option = 1

		vim.ui.select(
			executables,
			{
				prompt = 'Select executable: ',

			},
			function (choice, idx)
				option = idx
			end
		)
		
		return lines[option];
    end,
    cwd = '${workspaceFolder}',
	-- cwd = io.popen"cd":read'*l',
    stopAtEntry = true,
  },
}
