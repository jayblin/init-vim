local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local function ls_copy(args)
	return args[1]
end

local ts_snippets = {
    s("cfunc", {
        t({"/**", ""}),
        t(" * "), i(2),
        t({"", ""}),
        t({" */", ""}),
        t("const "), i(1), t(" = () => {"), i(0), t("};")
    }),
    s("vclog", {
        t("console.log(\""), f(ls_copy, 1), t("\", "), i(0), t(");")
    }),
    s("clog", {
        t("console.log("), i(0), t(");")
    })
}

ls.snippets = {
	cpp = {
		s("__grd", {
			t("#ifndef "), f(ls_copy, 1),
			t({"", "#define "}), i(1),
			t({"", ""}),
			t({"", ""}), i(0),
			t({"", ""}),
			t({"", "#endif // "}), f(ls_copy, 1),
		}),
	},
    typescriptreact = ts_snippets,
    typescript = ts_snippets,
    php = {
        s("pufunc", {
            t({"/**", ""}),
            t(" * "), i(2),
            t({"", ""}),
            t({" */", ""}),
            t("public function "), i(1), t({"()", ""}),
            t({"{", ""}),
         	t({"", ""}), i(0),
            t({"}", ""})
        }),
        s("prfunc", {
            t({"/**", ""}),
            t(" * "), i(2),
            t({"", ""}),
            t({" */", ""}),
            t("private function "), i(1), t({"()", ""}),
            t({"{", ""}),
         	t({"", ""}), i(0),
            t({"}", ""})
        }),
    },
}

