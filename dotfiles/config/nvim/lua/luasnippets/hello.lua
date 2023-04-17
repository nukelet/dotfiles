return {
    require("luasnip").snippet(
        {
            trig = "hi",
            dscr = "Expand 'hi' into 'Hello, world!'",
            regTrig = false,
            priority = 100,
            snippetType = "autosnippet",
        },
        {
            t("Hello, world!"),

        },
        {

        }
    ),
}
