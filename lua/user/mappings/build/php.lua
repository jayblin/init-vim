PhpCommandFactory = {}

local project_test_cmd = ""

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function generate_test_cmd(file_name, filter)
    -- if file_exists() do
    -- endif
    -- project_test_cmd = "php8.2 ./vendor/bin/simple-phpunit"
    if not filter and not file_name then
        return "make unit-tests"
    end

    local _file_name = file_name:match("tests/.+")

    if not _file_name then
        -- todo show users the error
        return ""
    end

    if not filter then
        return "UNIT_TEST_PATH='" .. _file_name .. "' make unit-tests"
    end

    return "UNIT_TEST_PATH='" .. _file_name .. " --filter=" .. filter .."' make unit-tests"
    -- project_test_cmd = "make unit-tests"
    -- return project_test_cmd
end

local function is_target_name_valid(target_name)
    return nil ~= target_name and string.len(target_name) > 0
end

function PhpCommandFactory:use_users_target_of_choice()
end

function PhpCommandFactory:use_last_target()
end

function PhpCommandFactory:make_build()
    return nil
end

function PhpCommandFactory:make_run()
    return nil
end

function PhpCommandFactory:make_run_tests()
    return generate_test_cmd()
end

function PhpCommandFactory:make_run_test_file(bufnr)
    local file_name = vim.api.nvim_buf_get_name(bufnr)
    -- self._last_test_cmd = generate_test_cmd() .. file_name
    self._last_test_cmd = generate_test_cmd(file_name)
    return self._last_test_cmd
end

function PhpCommandFactory:make_run_last_test()
    return self._last_test_cmd
end

local function get_test_filter(bufnr, window)
    if not bufnr then
        return nil
    end

    local node = vim.treesitter.get_node({
        bufnr = bufnr,
        pos = vim.api.nvim_win_get_cursor(window)
    })
    local result = nil

    for i = 40,1,-1 do
        if node and "method_declaration" == node:type() then
            local q = vim.treesitter.query.parse(
                "php",
                [[ (method_declaration 
                    name: (name) @func_name
                ) ]]
            )
            local f_name = nil
            for id, n, metadata in q:iter_captures(node) do
                local start_row, start_col, end_row, end_col = n:range()
                local text = vim.api.nvim_buf_get_text(
                    bufnr,
                    start_row,
                    start_col,
                    end_row,
                    end_col,
                    {}
                )
                if text[1] then
                    local capture_name = q.captures[id]
                    if "func_name" == capture_name then
                        f_name = text[1]
                    end
                end
            end

            return f_name
        end
        node = node:parent()
    end

    return result
end

function PhpCommandFactory:make_run_test_case(bufnr, window)
    local filter = get_test_filter(bufnr, window)
    local file_name = vim.api.nvim_buf_get_name(bufnr)
    -- self._last_test_cmd = generate_test_cmd() .. " --filter=" .. filter .. " " .. file_name
    self._last_test_cmd = generate_test_cmd(file_name, filter)
    return self._last_test_cmd
end

return PhpCommandFactory
