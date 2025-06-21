CppCommandFactory = {
    _cur_target_name = nil,
    _last_test_cmd = nil,
}

local function is_target_name_valid(target_name)
    return nil ~= target_name and string.len(target_name) > 0
end

-- @return string or nil
function CppCommandFactory:_get_user_chosen_target()
	local f = io.open("./cmake_targets", "r")
	local target_name = ""

	if f ~= nil then
		f:close()

		local lines = {}

		for line in io.lines("./cmake_targets") do
			lines[#lines + 1] = line
		end

		vim.ui.select(
			lines,
			{
				prompt = "Select target: "
			},
			function (choice)
				target_name = choice
			end
		)
	else
		vim.ui.input(
			{prompt = "Enter target name: "},
			function (input) target_name = input  end
		)
	end

    return target_name
end

function CppCommandFactory:use_users_target_of_choice()
    self._cur_target_name = self:_get_user_chosen_target()
end

function CppCommandFactory:use_last_target()
    if not is_target_name_valid(self._cur_target_name) then
        self:use_users_target_of_choice()
    end
end

function CppCommandFactory:make_build()
    if is_target_name_valid(self._cur_target_name) then
        return "cmake --build build --target=" .. self._cur_target_name
    end

    return nil
end

function CppCommandFactory:make_run()
	if is_target_name_valid(self._cur_target_name) then
        return './build/' .. self._cur_target_name
	end

    return nil
end

function CppCommandFactory:make_run_tests()
    if string.sub(self._cur_target_name, -6) ~= "_tests" then
        print(self._cur_target_name .. " - этот таргет не тестовый")
        return nil
    end

	if is_target_name_valid(self._cur_target_name) then
        self._last_test_cmd = "./build/" .. self._cur_target_name
        return self._last_test_cmd
	end

    return nil
end

function CppCommandFactory:make_run_test_file(bufnr, window)
    print("Не поддерживается")

    return nil
end

function CppCommandFactory:make_run_last_test(bufnr, window)
    return self._last_test_cmd
end

local function get_gtest_filter(bufnr, window)
    if not bufnr then
        return nil
    end

    local node = vim.treesitter.get_node({
        bufnr = bufnr,
        pos = vim.api.nvim_win_get_cursor(window)
    })

    for i = 40,1,-1 do
        if node then
            local prev_sibling = node:prev_sibling()

            if prev_sibling and "function_declarator" == prev_sibling:type() then
                local q = vim.treesitter.query.parse(
                    "cpp",
                    [[ (function_declarator 
                        declarator: (identifier) @func_name
                        parameters: (parameter_list
                            (parameter_declaration
                                type: (type_identifier) @param_name
                            ) 
                        )
                    ) ]]
                )
                local f_name = nil
                local test_fixture = nil
                local test_name = nil
                for id, n, metadata in q:iter_captures(prev_sibling) do
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
                        elseif "param_name" == capture_name then
                            if test_fixture then
                                test_name = text[1]
                            else
                                test_fixture = text[1]
                            end
                        end
                    end
                end

                if "TEST_F" == f_name then
                    return {test_fixture, test_name}
                end
                if "GTEST_TEST" == f_name then
                    return {test_fixture, test_name}
                end
            end
            node = node:parent()
        end
    end

    return nil
end

function CppCommandFactory:make_run_test_case(bufnr, window)
    if string.sub(self._cur_target_name, -6) ~= "_tests" then
        print(self._cur_target_name .. " - этот таргет не тестовый")
        return nil
    end

    local filter = get_gtest_filter(bufnr, window)

	if is_target_name_valid(self._cur_target_name) and filter then
        self._last_test_cmd = "./build/" .. self._cur_target_name .. " --gtest_filter=" .. filter[1] .. "." .. filter[2]
        return self._last_test_cmd
	end

    return nil
end

function CppCommandFactory:make_run_test_group(bufnr, window)
    if string.sub(self._cur_target_name, -6) ~= "_tests" then
        print(self._cur_target_name .. " - этот таргет не тестовый")
        return nil
    end

    local filter = get_gtest_filter(bufnr, window)

	if is_target_name_valid(self._cur_target_name) and filter then
        self._last_test_cmd = "./build/" .. self._cur_target_name .. " --gtest_filter=\"" .. filter[1] .. ".*\""
        return self._last_test_cmd
	end

    return nil
end

return CppCommandFactory
