local function os_capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))

	f:close()

	if raw then return s end

	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')

	return s
end

 local fs = {
	grep_lines = {},
	file_names = {},
	file_line_data = {},
	dest_window = nil,
	results_window = nil,
	results_buf = nil,
	input_window = nil,
	input_buf = nil,
}

function fs:open_for_edit()
	local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
	local row = cursor[1]
	local datum = self.file_line_data[row]
	local file_names_idx = datum[1]
	local file_row = datum[2]
	local filename = self.file_names[file_names_idx]

	vim.api.nvim_set_current_win(self.dest_window)
	-- edit file
	vim.api.nvim_command("e " .. filename)
	-- go to line number
	vim.api.nvim_command(tostring(file_row))
end

function fs:populate_tables(pattern)
	local cmd = "git grep -rEn --heading --break \"" .. pattern .. "\""
	local s = os_capture(cmd, 1)
	local i = 0
	local j = 0

	for line in string.gmatch(s, "[^\n]+") do
		local is_filename = true
		local number = 1

		table.insert(self.grep_lines, line)

		for n in string.gmatch(line, "%d+") do
			is_filename = false
			number = tonumber(n)
		end

		if is_filename then
			i = i + 1
			self.file_names[i] = line
		end

		j = j + 1
		self.file_line_data[j] = {i, number}
	end
end

function fs:populate_results_buf()
	vim.api.nvim_buf_set_lines(
		self.results_buf,
		0,
		-1,
		true,
		self.grep_lines
	)
end

function fs:close_all()
	vim.api.nvim_win_close(self.results_window, true)
	vim.api.nvim_win_close(self.input_window, true)
end

function fs:create_results_buf()
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
	-- We do not need swapfile for this buffer.
	vim.api.nvim_buf_set_option(buf, 'swapfile', false)
	vim.api.nvim_buf_set_option(buf, 'filetype', 'file-search-output')

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		"<Cmd>lua _G.file_search:open_for_edit()<CR>",
		{ noremap=true, silent=true }
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<C-b>",
		"<Cmd>lua _G.file_search:close_all()<CR>",
		{ noremap=true, silent=true }
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<C-f>",
		"<Cmd>lua _G.file_search:open_input_window(false)<CR>",
		{ noremap=true, silent=true }
	)

	self.results_buf = buf
end

function fs:open_results_window(populate_results)
	if self.results_buf == nil then
		self:create_results_buf()
	end

	if
		self.results_window == nil or
		not vim.api.nvim_win_is_valid(self.results_window)
	then
		local uis = vim.api.nvim_list_uis()
		local main_ui = uis[1]

		local opts = {
			relative="editor",
			width=40,
			height=main_ui.height - 8,
			col=main_ui.width - 40,
			row=8,
			style= "minimal",
			border="single",
		}

		self.results_window = vim.api.nvim_open_win(self.results_buf, true, opts)
		vim.api.nvim_command("stopinsert")
	else
		vim.api.nvim_set_current_win(self.results_window)
		vim.api.nvim_command("stopinsert")
	end

	if populate_results == true then
		self:populate_results_buf()
	end
end

function fs:get_input()
	return vim.api.nvim_get_current_line()
end

function fs:create_input_buf()
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
	-- We do not need swapfile for this buffer.
	vim.api.nvim_buf_set_option(buf, 'swapfile', false)
	vim.api.nvim_buf_set_option(buf, 'filetype', 'file-search-input')

	vim.api.nvim_buf_set_keymap(
		buf,
		"i",
		"<CR>",
		"<Cmd>lua _G.file_search:search(_G.file_search:get_input())<CR>",
		{ noremap=true, silent=true }
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		"<Cmd>lua _G.file_search:open_results_window(false)<CR>",
		{ noremap=true, silent=true }
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<C-b>",
		"<Cmd>lua _G.file_search:close_all()<CR>",
		{ noremap=true, silent=true }
	)

	self.input_buf = buf
end

function fs:open_input_window()
	if (self.input_buf == nil) then
		self:create_input_buf()
	end

	if
		self.input_window == nil or
		not vim.api.nvim_win_is_valid(self.input_window)
	then
		-- open window
		local uis = vim.api.nvim_list_uis()
		local main_ui = uis[1]

		local opts = {
			relative="editor",
			width=40,
			height=1,
			col=main_ui.width - 40,
			row=1,
			style= "minimal",
			border="single",
		}

		self.input_window = vim.api.nvim_open_win(self.input_buf, true, opts)

		vim.api.nvim_command("startinsert")
	else
		-- focus window
		vim.api.nvim_set_current_win(self.input_window)
		vim.api.nvim_command("startinsert")
	end
end

function fs:search(pattern)
	self.grep_lines = {}
	self.file_names = {}
	self.file_line_data = {}

	self:populate_tables(pattern)
	self:open_results_window(true)

	vim.api.nvim_command("/"..pattern)
end

function fs:toggle()
	self.dest_window = vim.api.nvim_get_current_win()

	if
		self.results_window ~= nil and
		self.results_buf ~= nil and
		vim.api.nvim_win_is_valid(self.results_window)
	then
		self:open_results_window(false)
	else
		self:open_input_window()

		if vim.api.nvim_buf_line_count(self.results_buf) > 1 then
			self:open_results_window(false)
		end
	end
end

_G.file_search = fs

vim.api.nvim_set_keymap(
	"n",
	"<C-f>",
	"<cmd>lua _G.file_search:toggle()<CR>",
	{ noremap=true, silent=true }
)
