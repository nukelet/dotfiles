return {
    s({ trig = "eq", dscr = "A LaTeX equation environment" },
        fmta(
            [[
                \begin{equation}
                    <>
                \end{equation}
            ]],
            { i(1) }
        )
    ),

    s({ trig = "env", dscr = "A LaTeX environment" },
        fmta(
            [[
                \begin{<>}
                    <>
                \end{<>}
            ]],
            { i(1), i(2), rep(1) }
        )
    ),
}
