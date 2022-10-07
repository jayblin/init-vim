local home_path = os.getenv('HOME')

if home_path == nil then home_path = "" end

local is_linux = string.find(home_path, '/home')

local _shell = vim.o.shell

if is_linux == nil then
	_shell = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
end

require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  -- size = 60,
  -- open_mapping = [[<c-\>]],
  open_mapping = [[<leader>t]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = _shell,
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
	border = 'curved',
	width = vim.o.columns,
	height = vim.o.lines,
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

