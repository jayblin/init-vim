local Terminal  = require("toggleterm.terminal").Terminal
local CppCommandFactory = require("user.mappings.build.cpp")

local opts = { noremap=true, silent=true }
local filetypes_that_need_rebuild = {}
local last_win = nil
local last_buf = nil

local terminal = Terminal:new({
	hidden = true,
	direction = "vertical",
	start_in_insert = false,
	on_open = function (term)
		term:set_mode("n")
		term:resize(vim.o.columns * 0.5)
	end,
})

local function get_command_factory()
    local t = vim.bo.filetype

    if "cpp" == t then
        return CppCommandFactory
    end

    return nil
end

-- @return string or nil
-- local function rebuild_if_needed(cmd_factory, should_present_choice)
local function rebuild_if_needed(cmd_factory)
    local t = vim.bo.filetype

    if nil == filetypes_that_need_rebuild[t]
        or true == filetypes_that_need_rebuild[t] then

        filetypes_that_need_rebuild[t] = false

        return cmd_factory:make_build()
    end

    return nil
end

local function setup()
    last_win = vim.api.nvim_get_current_win()
    last_buf = vim.api.nvim_get_current_buf()
end

local function cleanup()
    -- vim.cmd [[ wincmd r ]]
    if nil ~= last_win then
        vim.api.nvim_set_current_win(last_win)
    end
    if nil ~= last_buf then
        vim.api.nvim_set_current_buf(last_buf)
    end
end

-- @param cmd string or nil
local function exec_in_terminal(cmd)
    if cmd then
        if not terminal:is_open() then
            terminal:open()
        end
        terminal:send(cmd)
    end
end

function _G.build_last_target__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(b:make_build())
    end

    cleanup()
    filetypes_that_need_rebuild[vim.bo.filetype] = false
end

function _G.build_with_choice__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_users_target_of_choice()
        exec_in_terminal(b:make_build())
    end

    cleanup()
    filetypes_that_need_rebuild[vim.bo.filetype] = false
end

function _G.run_last_target__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run())
    end

    cleanup()
end

function _G.run_with_choice__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_users_target_of_choice()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run())
    end

    cleanup()
end

function _G.run_tests__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run_tests())
    end

    cleanup()
end

function _G.run_test_file__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run_test_file())
    end

    cleanup()
end

function _G.run_test_last__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run_last_test())
    end

    cleanup()
end

function _G.run_test_case__user_mappings()
    setup()

    local b = get_command_factory()

    if b then
        b:use_last_target()
        exec_in_terminal(rebuild_if_needed(b))
        exec_in_terminal(b:make_run_test_case(last_buf, last_win))
    end

    cleanup()
end

function _G.toggle_terminal__user_mappings()
    setup()

    if terminal:is_open() then
        terminal:close()
    else
        terminal:open()
    end

    cleanup()
end

-- todo implement???
local t_buf = nil
local t_win = nil
local t_chn = nil
function _G._dodo()
    if nil == t_buf then
        t_buf = vim.api.nvim_create_buf(false, false)
    end
    if not t_buf then
        return
    end

    if not t_win then
        t_win = vim.api.nvim_open_win(
            t_buf,
            false,
            {
                relative = "editor",
                bufpos = {0,0},
                width = vim.o.columns * 0.5,
                height = vim.o.lines,
                style = "minimal",
                border = "rounded",
                title = "hayyaa",
            }
        )
    end

    if not t_chn then
        t_chn = vim.api.nvim_open_term(
            t_buf,
            {}
        )
        -- vim.api.nvim_chan_send()
    end
end

vim.api.nvim_set_keymap(
    "n",
    "<leader>ua",
    "<Cmd>lua _G.run_tests__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>uf",
    "<Cmd>lua _G.run_test_file__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>ui",
    "<Cmd>lua _G.run_test_case__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>ul",
    "<Cmd>lua _G.run_test_last__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>cl",
    "<Cmd>lua _G.build_last_target__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>cc",
    "<Cmd>lua _G.build_with_choice__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>rl",
    "<Cmd>lua _G.run_last_target__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>rc",
    "<Cmd>lua _G.run_with_choice__user_mappings()<CR>",
    opts
)
vim.api.nvim_set_keymap(
    "n",
    "<F12>",
    "<Cmd>lua _G.toggle_terminal__user_mappings()<CR>",
    opts
)
-- vim.api.nvim_set_keymap(
--     "n",
--     "<F2>",
--     "<Cmd>lua _G._dodo()<CR>",
--     opts
-- )

vim.api.nvim_create_autocmd(
    {"BufWritePost"},
    {
        callback = function ()
            filetypes_that_need_rebuild[vim.bo.filetype] = true
        end
    }
)
