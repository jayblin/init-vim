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
    }),
	s("**", {
		t("/**"),
		t({"", " * "}), i(0),
		t({"", " */"}),
	}),
}

local cpp_snippets = {
	s("__grd", {
		t("#ifndef "), f(ls_copy, 1),
		t({"", "#define "}), i(1),
		t({"", ""}),
		t({"", ""}), i(0),
		t({"", ""}),
		t({"", "#endif // "}), f(ls_copy, 1),
	}),
	s("if", {
		t("if ("), i(1), t(")"),
		t({"", "{"}),
		t({"", "\t"}), i(0),
		t({"", "}"}),
	}),
	s("while", {
		t("while ("), i(1), t(")"),
		t({"", "{"}),
		t({"", "\t"}), i(0),
		t({"", "}"}),
	}),
	s("fn", {
		i(1), t(" "), i(2), t("("), i(3), t(")"),
		t({"", "{"}),
		i(0),
		t({"", "}"}),
	}),
	s("afn", {
		t("auto "), i(1), t("("), i(2), t(")"), t(" -> "), i(3),
		t({"", "{"}),
		i(0),
		t({"", "}"}),
	}),
	s("inc", {
		t("#include "), i(1)
	}),
}

ls.add_snippets("cpp", cpp_snippets)
ls.add_snippets("typescript", ts_snippets)
ls.add_snippets("typescriptreact", ts_snippets)
