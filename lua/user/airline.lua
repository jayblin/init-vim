local g = vim.g
local api = vim.api

g.airline_powerline_fonts = 1
g.airline_theme = "zenburn"
g.airline_section_x = ""
g.airline_section_y = ""
g.airline_section_z = "%p%% (%L)"
g["airline#extensions#tabline#enabled"] = 1
g["airline#extensions#tabline#show_splits"] = 0
g["airline#extensions#tabline#switch_buffers_and_tabs"] = 0
g["airline#extensions#tabline#exclude_preview"] = 1
g["airline#extensions#tabline#tab_nr_type"] = 1 -- tab number
g["airline#extensions#tabline#tabnr_formatter"] = 'tabnr'
g["airline#extensions#tabline#show_tab_type"] = 0
g["airline#extensions#tabline#buffer_min_count"] = 0
g["airline#extensions#tabline#tab_min_count"] = 0
g["airline#extensions#tabline#show_close_button"] = 0
g["airline#extensions#scrollbar#enabled"] = 1
g["airline#extensions#tabline#show_buffers"] = 0

local function get_file_name(file)
	return file:match("^.+/(.+)$")
end


-- doesnt work as intendet. makes every tab same title
function my_tab_title_formatter(n)
	local wins = api.nvim_tabpage_list_wins(n)
	local title = ""

	if #wins > 1 then
		for _,w in ipairs(wins) do
			local buf = api.nvim_win_get_buf(w)
			title = title .. '|' .. get_file_name(api.nvim_buf_get_name(buf))
		end
	else
		local buf = api.nvim_win_get_buf(wins[1])
		title = get_file_name(api.nvim_buf_get_name(buf))
	end

	return title or "[No Name]"
end

-- TODO: redo
-- vim.cmd "source ~/.config/nvim/lua/user/airline.vim"

