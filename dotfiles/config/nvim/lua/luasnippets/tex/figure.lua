return {
    s({ trig = "fig", dscr = "A figure environment" },
        fmta(
            [[
                \begin{figure}[!htb]
                \centering
                \includegraphics[width=\columnwidth]{images/<>}
                \caption{<>}
                \label{fig:<>}
                \end{figure}
            ]],
            { i(1), i(2), rep(1) }
        )
    ),
}
