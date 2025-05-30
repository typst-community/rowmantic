// Copyright 2025 Ulrik Sverdrup "bluss" and rowmantic contributors.
// Distributed under the terms of the EUPL v1.2 or any later version.

#import "src/lib.typ": rowtable, expandcell

#let template = body => {
  set document(date: none)
  set page(numbering: "1")
  set text(font: "Atkinson Hyperlegible Next")
  show raw: set text(font: "Fira Code", ligatures: false, features: (calt: 0))
  show raw.where(block: true): set block(stroke: 0.5pt + gray, outset: (x: 0.6em, y: 0.5em))
  show raw.where(block: true): set block(width: 95%)
  body
}
#show: template

#let show-example(code, functions: none, columns: 1, small: false) = {
  show: block.with(breakable: false)
  let scope = (
    rowtable: rowtable,
    expandcell: expandcell,
  )
  let evaluated = eval(code.text, mode: "markup", scope: scope + functions)
  set text(size: 0.9em) if small
  show raw: set text(size: 0.9em)
  table(
    columns: columns,
    stroke: none,
    inset: (x: 0.5em, y: 0.5em),
    emph[Document Result],
    evaluated,
    emph[Input],
    code,
  )
}

= `rowmantic`: Tables row by row
A Typst package for editing tables row-by-row.

The idea is a row-oriented way to input tables, with just a little less syntactical overhead than the usual `table` function in Typst.

The `rowtable` function works like the usual `table` function but takes one markup block (`[...]`) per row, and the markup is split internally#footnote[But shallowly - not looking into styled or nested content] on a delimiter which is `&` by default.

#rowtable(
  separator: "&",
  stroke: none,
  [Input:                     & ```typst [A & B & C]```       ],
  [Table cells (effectively): & ```typst ..([A], [B], [C])``` ],
)

For improved table ergonomics, the table sizes the number of columns by the longest row. All rows are effectively completed so that they are of full length. This creates a better the editing experience, as rows can be filled out gradually.

== Examples

#show-example(```typst
#{
  set table.hline(stroke: 0.08em)
  show regex("\d"): super.with(size: 0.8em, typographic: false)
  show table.cell: it => { set text(size: 0.9em) if it.y >= 1; it }
  show table.cell.where(y: 0): emph
  rowtable(
    separator: ",",   // configurable separator
    stroke: 0pt,      // pass through table arguments, hlines, cells et.c.
    inset: (x: 0em),
    column-gutter: 0.9em,
    // rows are filled to be equal length after collecting cells
    [goá   , iáu-boē    , koat-tēng   , tang-sî   , boeh  , tńg-khì    ],
    [goa1  , iau1-boe3  , koat2-teng3 , tang7-si5 , boeh2 , tng1-khi3  ],
    [goa2  , iau2-boe7  , koat4-teng7 , tang1-si5 , boeh4 , tng2-khi3  ],
    [I     , not-yet    , decide      , when      , want  , return.    ],
    table.hline(),
    // cell that fills remainder of row
    expandcell["I have not yet decided when I shall return."],
  )
}
```)
Example from Wikipedia#footnote[https://en.wikipedia.org/wiki/Interlinear_gloss]

#show-example(```typst
#{
  set table(stroke: none, inset: 0.8em)
  set table.hline(stroke: 0.5pt)
  show table.cell.where(y: 0): strong
  show table.cell.where(x: 0): x => math.bold(math.upright(x))
  rowtable(
    table.hline(),
    table.header([Term  & Explanation         & Assumptions ]),
    table.hline(),
    [$X$      & Explanatory variables         & Non-random ],
    [$Y$      & $Y_1, ..., Y_n$ observations  & *Pairwise independent*],
    [$beta$   & Model parameters              ],
    table.hline(),
  )
}
```)

== Trying some more difficult examples

#show-example(small: true, ```typst
#rowtable(
  align: horizon,
  stroke: 0.1pt,
  row-filler: [N/A],
  [Literal \& & *Strong* & *X*--_Y_ ],
  [Equation \ $pi = 3.1415...$ & $ integral_Omega d omega $  & $X \& Y$],
  [
    - A
    - B
    &
    + A
    + B
    &
    / A: a
    / B: b
  ],
  [
    #{
      set figure.caption(position: top)
      [#figure(rect[A], caption: "Top")<fig1>]
    }
    &
    See @fig1 \& @fig2
    &
    #figure(rect[B], caption: "Bot")<fig2>
  ],
  {
    [Nested rowtable \ ]
    rowtable([A & B])
    [&]
    [Nested table \ ]
    table(columns: 2, [A], [B])
    [&]
    table.cell(stroke: 1pt + red)[`table.cell`]
  },
  [#table.cell(fill: yellow.lighten(90%), colspan: 2)[Cell with colspan=2] &#none],
  [#expandcell(fill: yellow.lighten(90%))[Expandcell] & #expandcell[the rest]],
  [&&],
  table.footer([]),
)
```)

== Double semicolon separator

#show-example(```typst
#rowtable(
  separator: ";;",
  align: horizon,
  stroke: (x, y) => (y: int(y <= 0) * 0.9pt + 0.1pt, x: 0.1pt),
  [First           ;; This is a literal \;\; and ; and , and & ],
  [Second; Third   ;; Equation $pi = 3.1415...$],
  table.hline(stroke: 1pt),
)
```)
