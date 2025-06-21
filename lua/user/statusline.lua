function G_user_statusline_lsp_status()
    
  -- local lsp_clients = vim.lsp.get_active_clients({bufnr=vim.api.nvim_get_current_buf()})
  local lsp_clients = vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()})

  if 1 ~= #lsp_clients then
      return ""
    end

  local result = ""

  for k,progress in pairs(lsp_clients[1].messages.progress) do
      -- result = result .. " " .. (progress.title or "???") .. ":"
    if not progress.done then
      result = result .. " " .. (progress.title or "???") .. ":"
                  .. " " .. (progress.percentage or "0") .. "%"
    else
      -- result = result .. " done"
    end
  end

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
  local lsp_status = '%{v:lua.G_user_statusline_lsp_status()}'

  return mode .. file_name .. buf_nr .. modified .. right_align .. lsp_status .. line_no .. pct_thru_file
end

vim.opt.statusline = status_line()

vim.api.nvim_create_autocmd(
    {"DiagnosticChanged"},
    {
        callback = function () vim.opt.statusline = status_line() end
    }
)
