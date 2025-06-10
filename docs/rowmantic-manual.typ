// Copyright 2025 Ulrik Sverdrup "bluss" and rowmantic contributors.
// Distributed under the terms of the EUPL v1.2 or any later version.

#import "../src/lib.typ" as self: rowtable, expandcell
#import "@preview/tidy:0.4.3"

#let subtitletext = [A Typst package for row-wise table editing]
#let pkgdata = toml("../typst.toml")
#let template = body => {
  set document(date: none,
    title: [rowmantic #pkgdata.package.version - Manual - #subtitletext])
  set page(numbering: "1")
  set text(font: "Atkinson Hyperlegible Next")
  set text(slashed-zero: true)  // affects only fira code
  show raw: set text(font: "Fira Code", ligatures: false, features: (calt: 0), weight: "medium")
  show raw.where(block: true): set block(stroke: 0.5pt + gray, outset: (x: 0.6em, y: 0.5em))
  show raw.where(block: true): set block(width: 95%)
  set heading(numbering: "1.1")
  show heading: set block(below: 1.0em)
  show outline.entry.where(level: 1): set block(above: 0.9em)
  body
}

#show: template

#let show-example(code, functions: none, columns: 1, small: false, breakable: false) = {
  show: block.with(breakable: breakable)
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
#let title = body => block(text(size: 3em, strong(body)), below: 0.7em)
#let subtitle = body => text(size: 1.5em, body)

#title[rowmantic]
#subtitle[#subtitletext]

#{
  let data = pkgdata.package
  show table.cell.where(x: 0): strong
  show link: underline
  show link: set text(fill: blue.darken(60%))
  rowtable(
    stroke: 0pt,
    inset: (left: 0em, right: 1em),
    [version        & #data.version],
    [import as      & #raw(("#import \"@preview", "/", data.name, ":", data.version, "\"").join())],
    [typst universe & #link("https://typst.app/universe/package/" + data.name)],
    [repository     & #link(data.repository)],
  )
}

= Introduction
The idea is a row-oriented way to input tables, with just a little less syntactical overhead than the usual `table` function in Typst.

The `rowtable` function takes a markup block `[...]` per row, and the markup is split internally#footnote[But shallowly - not looking into styled or nested content] on a delimiter which is `&` by default. In all other aspects it works like the usual `table` function, with `stroke`, `fill`, `hline` and so on.

#{
  show raw: set block(stroke: none, width: auto)
  rowtable(
    separator: "&",
    stroke: none,
    inset: (x: 2em),
    [Input: &
      ```typc
      rowtable(
        [A & B],
        [C & D & E])
      ```
      &
      #rowtable([A & B], [C & D & E])
    ],
    [Equivalent \ table: &
      ```typc
      table(columns: 3,
        [A], [B], [],
        [C], [D], [E])
      ```
    ],
  )
}

For improved table ergonomics, the table sizes the number of columns by the longest row. All rows are effectively completed so that they are of full length. This creates a better the editing experience, as rows can be filled out gradually.

#outline()

#pagebreak(weak: true)

= Examples

== Introductory Examples

#show-example(```typst
#{
  show regex("\d"): super.with(size: 0.8em, typographic: false)
  show table.cell: it => { set text(size: 0.9em) if it.y >= 1; it }
  show table.cell.where(y: 0): emph
  rowtable(
    separator: ",",   // configurable separator
    stroke: none,     // pass through table arguments, hlines, cells et.c.
    inset: (x: 0em),
    column-gutter: 0.9em,
    // rows are filled to be equal length after collecting cells
    [goá,   iáu-boē,    koat-tēng,    tang-sî,    boeh,   tńg-khì   ],
    [goa1,  iau1-boe3,  koat2-teng3,  tang7-si5,  boeh2,  tng1-khi3 ],
    [goa2,  iau2-boe7,  koat4-teng7,  tang1-si5,  boeh4,  tng2-khi3 ],
    [I,     not-yet,    decide,       when,       want,   return.   ],
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

== Difficult Examples

#show-example(small: true, ```typst
#rowtable(
  align: horizon,
  stroke: 0.1pt,
  row-filler: [N/A],
  [Literal \& & *Strong* & *X*--_Y_ ],
  [Equation \ $pi = 3.1415...$ & $ integral_Omega d omega $  & $X \& Y$],
  $ pi^1 & pi^2 & pi^3 $,
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
    table.cell(stroke: 1pt + red, rowspan: 2)[`table.cell(` \ `rowspan: 2)`]
  },
  [#table.cell(fill: yellow.lighten(90%), colspan: 2)[Cell with colspan=2] ],
  [#expandcell(fill: yellow.lighten(90%))[Expandcell] & #expandcell[#none]],
  table.footer([]),
)
```)

== Double semicolon separator

#show-example(```typst
#rowtable(
  separator: ";;",
  stroke: 0.5pt,
  [First           ;; This is a literal \;\; and ; and , and & ],
  [Second; Third   ;; Equation $pi = 3.1415...$],
)
```)


== Using other Table Functions

Use the `table` argument to let rowtable pass its result to a different table function rather than the standard one, for example `pillar.table` (shown below) or `zero.ztable`.

#show-example(```typst
#import "@preview/pillar:0.3.2"
#set text(font: "Libertinus Serif")
#show table.cell.where(y: 0): strong
#rowtable(
  separator: ",",
  table: pillar.table,
  cols: "rCCCCC",
  format: (auto, ) * 4 + ((uncertainty-mode: "compact"), auto),
  column-gutter: (0.5em, 0pt),
  stroke: (x, y) => if y == 0 { (bottom: 0.75pt) },
  table.header(
  [Isotope,       Z,  N,  Half-life,  Mass (Da),        Abundance (%) ]),
  [#super[107]Ag, 47, 60, Stable,     106.9050915(26),  51.839(8) ],
  [#super[109]Ag, 47, 62, Stable,     108.9047558(14),  48.161(8) ],
)
```)

#pagebreak(weak: true)

== Equations

Equations as rows are are split on `&` by default, but it is configurable. Note that `&` can be escaped in equations, but other separator symbols are not as easy to escape #footnote[The escape for `&` is just `\&`, for other separators like for example the comma a `box` or `","` is used to escape them.].

#show-example(```typst
#rowtable(
  align: center + horizon,
  stroke: (x, y) => (bottom: int(y == 0) * 1pt),
  separator: ",",     // regular sep
  separator-eq: $&$,  // equation sep
  [A, B, C, D, E],
  $1  & x   & x^2 & sum_i^n & #[inline equation row]$,
  $ 1 & x   & x^2 & sum_i^n & #[block equation row] $,
  [$1$, $x$, $x^2$, $ sum_i^n $, markup with embedded \ equations row],
)
```)

=== Long Division

This example shows one way to set up long division. In this case it's polynomial division,
computing the result $x^3 + x + 1 = (x^2 - x + 2)(x + 1) - 1$. For this
example, the colorful annotations add the most of the complexity. `rowtable` contributes to the example by splitting equations on the separator and filling rows to be equal length.

#show-example(breakable: true, ```typst
#import "@preview/mannot:0.3.0": annot, markhl

/// Set up strokes and gutter for long division table
#let longdiv(..args, table: std.table) = {
  let cols = args.at("columns")
  let st = std.stroke(args.at("stroke", default: black))
  let stroke = (x, y) => (
     // Add left stroke to the last column
    left: if x == cols - 1 and y == 1 { st },
    bottom: if (
      // Add top and bottom stroke to denominator cell
      y == 1 and x == cols - 1
      // Add bottom stroke every two rows (calc.even check),
      // but for one less column each time
      or y >= 1 and x < cols - 1 and calc.even(y) and x + 1 >= y / 2
    ) {
      st
    }
  )
  table(..args,
    column-gutter: (0pt,) * (cols - 2) + (1.5em, ),
    stroke: stroke,
    std.table.hline(y: 1, stroke: st))
}

// Set up marking functions
#let markhl = markhl.with(outset: (top: 0.15em, rest: 0.30em), radius: 1pt)
#let um = math.class("unary", math.minus) // unary minus
#let mkq = markhl.with(color: luma(70%))
#let mkn = markhl.with()
#let mkdenom = markhl.with(color: blue, tag: <denom>)
#let mkrem = markhl.with(color: red, tag: <rem>)

#let leftset(x) = box(place(dx: -0.3em, right + bottom, $#x$))
#let rm = math.class("unary", leftset($(-)$)) // row minus

#show: block.with(breakable: false)
#rowtable(
  align: right,
  table: longdiv.with(stroke: 1.5pt),
  inset: 0.55em,
  $mkq(x^2, tag: #<ans>)& mkq(um x) & mkq(2)    &$,
  $mkn(x^3) &           & mkn(x)    & mkn(1, tag: #<num>) & mkdenom(x + 1)$,
  $rm x^3   & x^2$,

  $         &-x^2       &  x$,
  $         & rm -x^2   & -x$,

  $         &           &   2x  & 1$,
  $         &           &rm 2x  & 2$,

  $         &           &       & mkrem(um 1)$,
)
#annot(<ans>, pos: left + horizon, dx: -2em, dy: -0em, annot-text-props: (fill: black, size: 0.75em))[Quotient]
#annot(<denom>, pos: right + bottom, dy: +2em)[Denominator]
#annot(<num>, pos: right + top, dy: -1.5em, dx: 1em)[Numerator]
#annot(<rem>, pos: right + horizon, dy: 0em, dx: 2em)[Remainder]
```)

#pagebreak(weak: true)

=== Equations with alignment

Use a different separator than `&` to use equations with alignment.

#show-example(```typst
#set math.mat(delim: "[")
#rowtable(
  separator: ";",
  stroke: (x, y) => (bottom: int(y == 0) * 1pt),
  [Matrix Form; Equation System Form],
  $
    mat(y_1; y_2) = mat(a_11, a_12; a_21, a_22) mat(x_1; x_2)
    ;
    "(1st)" y_1 &= a_11 x_1 &+ a_12 x_2 \
    "(2nd)" y_2 &= a_21 x_1 &+ a_22 x_2 \
  $
)
```)


== Table Cells, `rowspan` and `colspan`

- `colspan`: a cell spans multiple columns
- `rowspan`: a cell spans multiple rows

Table cells can be customized with the usual properties (`stroke`, `fill`, et.c.) but also with colspan and rowspan. It's important to include the cells inline inside the rows, i.e like this:

#show-example(```typst
#let cell = table.cell
#rowtable(
  separator: ",",
  column-width: 3em,
  rows: 3em,
  [1, 2, 3,     #cell(fill: yellow)[4]],
  [A, B, #cell(colspan: 2, stroke: 2pt)[Extra Wide]],
)
```)

where ```typst [...]``` is the markup for the whole row. Then automatic row length computations will continue to work correctly.

The column span is straightforward, because it's contained in the row, so support for this
was available from `rowmantic`'s first version.

However, there is also support for `rowspan` since version 0.2.0:

#show-example(```typst
#show table.cell: it => if it.colspan + it.rowspan > 2 { strong(it) } else { it }
#let cell = table.cell
#rowtable(
  separator: ",",
  column-width: 3em, rows: 3em,
  inset: 0.25em,
  [#cell(rowspan: 2, colspan: 2)[R: 2, C: 2], 1, 2, #cell(rowspan: 3)[R: 3], 4],
  [#expandcell[Expandcell], #cell(rowspan: 3)[R: 3]],
  [e, f, g, h],
  [#expandcell[Expandcell], ijk],
)
```)

= Known Limitations

#set list(marker: "‣")

- Multi-row `table.header/footer` are not supported yet.
- `rowspan` is not supported in cells in rows inside `table.header/footer`.
- `expandcell` can collide with `rowspan`ned cells (if they are not placed along the left or right side of the table); use `colspan` as a workaround when necessary.
- Table cells can be passed outside the rows, and this removes the usefulness of automatic column lengths. Avoid doing this.
- `rowtable` does not properly support being used as a "front end" for `grid`.

#pagebreak(weak: true)

#show heading.where(level: 3): set heading(numbering: none, outlined: false)
#show heading.where(level: 4): set heading(numbering: none, outlined: false)

#{
  let expose = ("rowtable", "row-split", "expandcell")
  let mod = tidy.parse-module(read("/src/rowtable.typ"), name: "Function Reference", old-syntax: true)
  mod.functions = mod.functions.filter(elt => elt.name in expose)
  mod.variables = mod.variables.filter(elt => elt.name in expose)
  tidy.show-module(mod, first-heading-level: 1, show-outline: false)
}

// Postscript
#block(above: 2em, {
  [API Documentation generated using `tidy`.]
})
