require("bufferline").setup{
	options = {
		mode = "tabs", -- "buffers" | "tabs"
		-- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		numbers = "ordinal",
		-- close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
		close_command = "tabc! %d",       -- can be a string | function, see "Mouse actions"
		right_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		-- left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
		-- left_mouse_command = "%dgt",    -- can be a string | function, see "Mouse actions"
		middle_mouse_command = "tabc! %d",          -- can be a string | function, see "Mouse actions"
		indicator = {
			icon = '▎', -- this should be omitted if indicator style is not 'icon'
			-- style = 'icon' | 'underline' | 'none',
			style = 'icon',
		},
		buffer_close_icon = 'x',
		modified_icon = '●',
		close_icon = 'x',
		left_trunc_marker = '<',
		right_trunc_marker = '>',
		--- name_formatter can be used to change the buffer's label in the bufferline.
		--- Please note some names can/will break the
		--- bufferline so use this at your discretion knowing that it has
		--- some limitations that will *NOT* be fixed.
		name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
			-- remove extension from markdown files for example
			-- if buf.name:match('%.md') then
			-- 	return vim.fn.fnamemodify(buf.name, ':t:r')
			-- end
			return buf.name
		end,
		max_name_length = 22,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = false, -- whether or not tab names should be truncated
		tab_size = 22,
		-- diagnostics = false | "nvim_lsp" | "coc",
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
		-- diagnostics_indicator = function(count, level, diagnostics_dict, context)
		-- 	return "("..count..")"
		-- end,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		-- custom_filter = function(buf_number, buf_numbers)
		-- 	-- filter out filetypes you don't want to see
		-- 	if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
		-- 		return true
		-- 	end
		-- 	-- filter out by buffer name
		-- 	if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
		-- 		return true
		-- 	end
		-- 	-- filter out based on arbitrary rules
		-- 	-- e.g. filter out vim wiki buffer from tabline in your work repo
		-- 	if vim.fn.getcwd() == "<work-repo>"
		-- 		and vim.bo[buf_number].filetype ~= "wiki" then
		-- 		return true
		-- 	end
		-- 	-- filter out by it's index number in list (don't show first buffer)
		-- 	if buf_numbers[1] ~= buf_number then
		-- 		return true
		-- 	end
		-- end,
		offsets = {
			{
				filetype = "NvimTree",
				-- text = "File Explorer" | function ,
				text = "File Explorer",
				-- text_align = "left" | "center" | "right",
				text_align = "left",
				separator = true,
			}
		},
		color_icons = false, -- whether or not to add the filetype icon highlights
		show_buffer_icons = false, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_buffer_default_icon = false, -- whether or not an unrecognised filetype should show a default icon
		show_close_icon = true,
		show_tab_indicators = false,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		-- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
		separator_style = "thin",
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		-- hover = {
		-- 	enabled = true,
		-- 	delay = 200,
		-- 	reveal = {'close'},
		-- },
		-- sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
		-- 	-- add custom logic
		-- 	return buffer_a.modified > buffer_b.modified
		-- end,
		sort_by = 'tabs',
	},
}
