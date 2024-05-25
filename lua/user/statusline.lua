local lsp_status = require "lsp-status"

local function sl_get_file_name(path)
	local expr = '[^\\/]+[.].+$'
    local start, finish = path:find(expr)
    return path:sub(start,#path)
end

function sl_get_lsp_message()
	local result = ""
	-- local message = lsp_status.messages()
	-- local bnum = vim.api.nvim_get_current_buf()
	-- local bname = vim.api.nvim_buf_get_name(bnum)
	-- -- Не совсем правильно т.к. у файлов могут быть одинаковые названия.
	-- -- local filename1 = sl_get_file_name(bname)
	
	-- for i, msg in ipairs(message) do
	-- 	if i ~= 1 then
	-- 		result = result .. ';'
	-- 	end

	-- 	if msg.name == 'clangd' and msg.uri then
	-- 		-- local filename2 = sl_get_file_name(msg.uri)
	-- 		-- if filename1 == filename2 then
	-- 			result = result .. ' clangd'
	-- 			if msg.content ~= 'idle' then
	-- 				result = result .. '...'
	-- 			end
	-- 			-- Решил пока не показывать текст, т.к. мерцает при
	-- 			-- редактировании файла.
	-- 			-- if msg.content then result = result .. ' ' .. msg.content  end
	-- 		-- end
	-- 	else
	-- 		if msg.title then result =  result .. ' ' .. msg.title end
	-- 		if msg.message then result = result .. ' ' .. msg.message end
	-- 		if msg.percentage then
	-- 			result = result .. string.format(' (%.0f%%)', msg.percentage)
	-- 		end
	-- 	end
	-- end

	return result
end

local function status_line()
  local mode = '%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}'
  local file_name = '%-.46f'
  local buf_nr = '[%n]'
  local modified = ' %-m'
  local right_align = '%='
  local line_no = '%10([%l/%L%)]'
  local pct_thru_file = '%5p%%'
  local lsp = '%{v:lua.sl_get_lsp_message()}'

  return string.format(
    '%s%s%s%s%s%s%s%s',
    mode,
    file_name,
    buf_nr,
    modified,
	lsp,
    right_align,
    line_no,
    pct_thru_file
  )
end

vim.opt.statusline = status_line()
