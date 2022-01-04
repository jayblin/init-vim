local o = vim.o

local function get_tab_number()
	return
end


function my_tab_line()
	local tabpages = vim.api.nvim_list_tabpages()
	local line = ""
	local current_tab_number = vim.api.nvim_get_current_tabpage()

	local n = #tabpages
	for i, page_number in ipairs(tabpages) do
		local windows = vim.api.nvim_tabpage_list_wins(page_number)

		if page_number == current_tab_number then
			line = line .. "%#SpecialKey# "
		else
			line = line .. "%#TabLine# "
		end

		line = line .. "%" .. i .. "T" .. i .. " "

		for j, window in ipairs(windows) do
			local buffer = vim.api.nvim_win_get_buf(window)
			local buffer_name = vim.api.nvim_buf_get_name(buffer) or ""

			buffer_name = buffer_name:match("[^/]*.$") or ""

			if j > 1 then
				line = line .. " | " .. buffer_name
			else
				line = line .. buffer_name
			end
		end

		-- line = line .. "%T"
		line = line .. "%T "
	end

	-- after the last tab fill with TabLineFill and reset tab page nr
	line = line .. '%#TabLineFill#'

	return line
end

-- o.tabline = '%!v:lua.my_tab_line()'

