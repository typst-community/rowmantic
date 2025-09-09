// Copyright 2025 Ulrik Sverdrup "bluss" and rowmantic contributors.
// Distributed under the terms of the EUPL v1.2 or any later version.

#import "../src/lib.typ" as self: rowtable, rowgrid, expandcell, row
#import "@preview/tidy:0.4.3"

#let subtitletext = [A Typst package for row-wise table editing]
#let pkgdata = toml("../typst.toml")
#let template = body => {
  set document(date: none,
    title: [rowmantic #pkgdata.package.version - Manual - #subtitletext])
  set page(numbering: "1")
  set text(font: "Atkinson Hyperlegible Next")
  show raw: set text(slashed-zero: true)  // affects only fira code
  show raw: set text(font: "Fira Code", ligatures: false, features: (calt: 0), weight: "medium")
  show raw.where(block: true): set block(stroke: 0.5pt + gray, outset: (x: 0.6em, y: 0.5em))
  show raw.where(block: true): set block(width: 95%)
  set heading(numbering: "1.1")
  show heading: set block(below: 1.0em)
  show outline: set text(number-width: "tabular")
  show outline.entry.where(level: 1): set block(above: 0.9em)
  body
}

#show: template

#let show-example(code, scope: auto, columns: 1, small: false, breakable: false) = {
  show: block.with(breakable: breakable)
  let scope = if scope == auto { (
    rowtable: rowtable,
    rowgrid: rowgrid,
    expandcell: expandcell,
    row: row,
  ) } else { scope }
  let evaluated = eval(code.text, mode: "markup", scope: scope)
  set text(size: 0.9em) if small
  show raw: set text(size: 0.9em)
  grid(
    columns: columns,
    stroke: none,
    inset: (x: 0.0em, y: 0.5em),
    {
      block(sticky: true)[_Document Result_]
      evaluated
    },
    {
      block(sticky: true)[_Input_]
      code
    },
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
    [version        & #raw(data.version)],
    [import as      & #raw(lang: "typst", ("#import \"@preview", "/", data.name, ":", data.version, "\"").join())],
    [typst universe & #link("https://typst.app/universe/package/" + data.name)],
    [repository     & #link(data.repository)],
  )
}

= Introduction
Rowmantic introduces the `rowtable` function as a row-oriented "frontend" to the usual `table` function in typst.

The `rowtable` function takes a markup block `[...]` per row, and the markup is split internally#footnote[But shallowly - not looking into styled or nested content] on a delimiter which is `&` by default. In all other aspects it works like the usual `table` function, with `stroke`, `fill`, `hline` and so on.

#{
  show raw: set block(stroke: none, width: auto)
  rowgrid(
    separator: "&",
    stroke: none,
    inset: (x: 2em, y: 5pt),
    [Input: &
      ```typc
      rowtable(
        [A & B],
        [C & D & E])
      ```
      &
      #grid.cell(rowspan: 2, rowtable([A & B], [C & D & E]))
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

For improved table ergonomics, the longest row determines the number of columns, and all rows are effectively completed so that they are of full length. This creates a better editing experience, as rows and columns can be filled out gradually.

There is a corresponding `rowgrid` function with identical interface, but for the usual `grid`.

#context {
  outline(depth: 2, target: selector(heading).after(here()))
}

#pagebreak(weak: true)

= Examples

== Introductory Examples

#show raw.where(block: true): it => {
  show "\"/src/lib.typ\"": ("\"@preview/",
    pkgdata.package.name, ":", pkgdata.package.version, "\"").join()
  it
}

#show-example(scope: (:), ```typst
#import "/src/lib.typ": rowtable, expandcell
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

#show-example(scope: (:), ```typst
#import "/src/lib.typ": rowtable
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

#pagebreak(weak: true)
== Escaping and Various Examples

#show-example(small: true, ````typst
#rowtable(
  align: horizon,
  column-width: 1fr,
  row-filler: [N/A],
  stroke: (x, y) => if x == 3 { none } else { 0.5pt },
  [_Emphasis &_   & *Strong &*  & Literal \&  & Escape the separator with `\&`],
  $ integral_(-oo)^oo f(x) thin d x   & integral_0^oo f(t) thin e^(-s t) thin d t
    & X \& Y & "Display equations" \ "as a row" $,
  [
    #{
      set figure.caption(position: top)
      [#figure(rect[A], caption: "Top")<fig1>]
    }
    &
    See @fig1 \& @fig2
    &
    #figure(rect[B], caption: "Bot")<fig2>
    &
    ```typc set``` rules need to be enclosed so that they don't try
    to style the separator itself.
  ],
  [
    + A
    + B
    &
    / A: a
    / B: b
    & #rowtable([A & B])
    & Lists and other larger elements can be embedded as usual.
  ],
  [ #table.cell(fill: yellow)[A]  & #table.cell(fill: orange)[B]  &
    #table.cell(fill: red)[C]     & Colorfully filled cells ],
)

````)

== Other Separators

#block(sticky: true)[
  *Example:* A double semicolon.
  The cell separator is specified as a string with the `separator` argument.
  It can be more than a single character, like in this example:
]
#show-example(```typst
#rowtable(
  separator: ";;",
  stroke: 0.5pt,
  [First    ;; Second; Third ],
  [Fourth   ;; This is a literal \;\; and ; and , and & ],
)
```)

#block(sticky: true)[
*Example:*
Using a space as a separator has special behaviour -- because of how spaces are treated in Typst markup: multiple spaces, tabs, or a (single) newline are all collapsed into just whitespace. Using a space as separator splits on any such whitespace:
]

#show-example(```typst
#rowtable(
  separator: " ",
  stroke: 0.5pt,
  [First  Second Third~(3rd)],
  [Fourth Fifth  Sixth~(6th)],
)
```)

The recommended way to insert a literal space in this case is to use ```typst ~```.



== Using Other Table Functions

#block(sticky: true)[
  Use the `table` argument to let rowtable pass its result to a different table function rather than the standard one, for example `pillar.table` (shown below) or `zero.ztable`.
  ]

#show-example(```typst
#import "@preview/pillar:0.3.3"
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
== Table Cells, `rowspan` and `colspan`

- `colspan`: a cell spans multiple columns
- `rowspan`: a cell spans multiple rows

Table cells can be customized with the usual properties (`stroke`, `fill`, et.c.) but also with colspan and rowspan. It's important to include the cells inline inside the rows, i.e like this:

#show-example(```typst
#let cell = table.cell
#rowtable(
  separator: ",",
  column-width: 3em, rows: 3em,
  [1, 2, 3, #cell(fill: yellow)[4]],
  [A, B, #cell(colspan: 2, stroke: 2pt)[Extra Wide]],
)
```)

where ```typst [...]``` is the markup for the whole row. Then automatic row length computations will continue to work correctly.

The column span is straightforward, because it's contained in the row, but there is also support for
`rowspan`, seen below. The rows that follow take the `rowspan`-reserved space into account
when computing their effective length.

#show-example(breakable: true, ```typst
#show table.cell: it => if it.colspan + it.rowspan > 2 { strong(it) } else { it }
#let cell = table.cell
#rowtable(
  separator: ",",
  column-width: 2.5em, rows: 2.5em,
  inset: 0.25em,
  [#cell(rowspan: 2, colspan: 2)[Rs2, Cs2], 1, 2, #cell(rowspan: 3)[Rs3], 4],
  [#expandcell[expandc.], #cell(rowspan: 3)[Rs3]],
  [e, f, g, h],
  [#expandcell[expandcell], ijk],
)
```)

#pagebreak(weak: true)
== The `row` Function

The `row` function can be used to transform or style a whole row at a time. For example, ```typst row([a & b & c], map: strong)``` styles the row using *`strong`*. The row function is entirely optional. It has three optional arguments:

- `map` - apply a function to each element
- `imap` - apply a funtion to each element, and also receive its index
- `cell` - set a dictionary of cell properties, e.g. `fill` and `stroke` on the whole row.

It is recommended to use the style ```typst row([...], map: ..)``` with the row markup as the first argument so that rows align well to each other.

// See the example below with examples of `map`, `imap` and `cell`, including an example of returning `table.cell` from the mapping functions (new cell fields are merged with existing cell fields).
//
*Example:* Use `map` or `imap` to transform or style the cells of a row.
#v(0.5em, weak: true)

#show-example(scope: (:), small: true)[```typst
#import "/src/lib.typ": rowtable, row
/// Draw cell with a color between `from` and `to`
#let colorcells(index, elt, from: yellow, to: red, step: 20%) = {
  let fr = index * step
  let fill = color.mix((to, fr), (from, 100% - fr)).lighten(50%)
  table.cell(fill: fill, elt)
}
#rowtable(
  separator: ",", align: center, inset: 0.7em,
  row([0,     1,    2,     3,     4,       5   ], map: strong),
  row($alpha, beta, gamma, delta, epsilon, zeta$, imap: (idx, elt) => $elt^idx$),
  row([a,     b,    c,     d,     e,       f   ], imap: colorcells),
)
```]

*Example:* Use `map` to highlight empty entries, and `cell` to set background color.
#v(0.5em, weak: true)

#show-example(small: true)[```typst
/// Draw cell with thick stroke if not empty, and red background if empty
#let markempty(elt) = {
  if elt != [] and elt != none {
    table.cell(stroke: 2pt, elt)
  } else {
    table.cell(fill: red.lighten(80%), elt)
  }
}
#rowtable(
  separator: "&", align: center, inset: 0.7em,
  row([ A &   & C &   & E & F ], map: markempty),
  row([ G & H &   & J & K &   ], map: markempty),
  row([ ~ & ], cell: (fill: gray)),
)
```]

#pagebreak(weak: true)
== Equations

Equations can be treated as rows by themselves, and they split on `&` by default (but it is configurable).
Note that `&` can be escaped in equations, but other separator symbols are not as easy to escape #footnote[The escape for `&` is just `\&`, for other separators like for example the comma a `box` or `","` is used to escape them.].

#show-example(```typst
#rowtable(
  align: center + horizon,
  stroke: (x, y) => (bottom: int(y == 0) * 1pt),
  separator: ",",     // regular sep
  separator-eq: $&$,  // equation sep
  [A, B, C, D, E],
  $1    & x   & x^2   & sum_i^n & #[inline equation row]$,
  $ 1   & x   & x^2   & sum_i^n & #[block equation row] $,
  [$1$, $x$,  $x^2$,  $ sum_i^n $, markup with embedded \ equations row],
)
```)

=== Long Division

This example shows one way to set up long division. In this case it's polynomial division,
computing the result $x^3 + x + 1 = (x^2 - x + 2)(x + 1) - 1$. For this
example, the colorful annotations add the most of the complexity. `rowtable` contributes to the example by splitting equations on the separator and filling rows to be equal length.

#show-example(breakable: true, ```typst
#import "@preview/mannot:0.3.0": annot, mark

/// Set up strokes and gutter for long division table
#let longdiv(..args, grid: std.grid) = {
  let cols = args.at("columns")
  let st = std.stroke(args.at("stroke", default: black))
  let stroke = (x, y) => (
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
  grid(..args,
    column-gutter: (0pt,) * (cols - 2) + (1.5em, ),
    stroke: stroke,
    std.grid.hline(y: 1, stroke: st))
}

// Set up marking functions and grid cell backgrounds
#let mark = mark.with(outset: (top: 0em, rest: 0.50em))
#let mkq(..args) = grid.cell(fill: luma(70%), mark(..args))
#let mkn(..args) = grid.cell(fill: orange.lighten(50%), mark(..args))
#let mkdenom(it) = grid.cell(fill: blue.lighten(70%), mark(tag: <denom>, it))
#let mkrem(it)   = grid.cell(fill: red.lighten(50%), mark(tag: <rem>, it))

#let um = math.class("unary", math.minus) // unary minus
#let leftset(x) = box(place(dx: -0.3em, right + bottom, $#x$))
#let rm = math.class("unary", leftset($(-)$)) // row minus

#show: block.with(breakable: false)
#rowgrid(
  align: right,
  table: longdiv.with(stroke: 1.5pt),
  inset: 0.55em,
  $mkq(x^2, tag: #<ans>)& mkq(um x) & mkq(2)    &$,
  $mkn(x^3) & mkn(.)    & mkn(x)    & mkn(1, tag: #<num>) & mkdenom(x + 1)$,
  $rm x^3   & x^2$,

  $         &-x^2       &  x$,
  $         & rm -x^2   & -x$,

  $         &           &   2x  & 1$,
  $         &           &rm 2x  & 2$,

  $         &           &       & mkrem(um 1)$,
)
#annot(<ans>, pos: left + horizon, dx: -2em, dy: -0em, annot-text-props: (fill: black, size: 0.75em))[Quotient]
#annot(<denom>, pos: right + bottom, dy: 1.5em, dx: -1.0em)[Denominator]
#annot(<num>, pos: right + top, dy: -2.0em, dx: 1.5em)[Numerator]
#annot(<rem>, pos: right + horizon, dy: 0em, dx: 2em)[Remainder]
```)

#pagebreak(weak: true)

=== Equations with Alignment

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


=== Sizing Delimiters in Annotated Matrix

This example draws a matrix using `rowgrid` and inserts iteratively sized
delimiters in `rowspan` cells. Grid lines are drawn to show how the table is constructed.


#show-example(breakable: true, ```typst
/// Measure a grid's size
/// Successively remove display of each row
///  (first full table, then remove 0, then remove 0 and 1, and so on).
/// Returns an array of measurements which is a size profile of the grid's rows
/// (or columns if `attr: "x"`)
#let measure-grid(t, min: 0, max: 50, attr: "y") = {
  let wh = (x: "width", y: "height").at(attr)
  let result = ()
  for i in range(max) {
    let sz = measure({
      show grid.cell: it => {
        if it.at(attr) < i { none } else { it }
      }
      t
    })
    result.push(sz)
    if i > min and (sz.at(wh) == 0pt or result.at(-2, default: none) == sz) {
      break
    }
  }
  result
}

/// Create an element using `func`; then measure it using `measure-func`
/// then create the final version of the element again using func, this
/// time with the size info from the first try.
#let measure-and-make(func, measure-func: measure-grid) = context {
  func(measure-func(func(none)))
}

#measure-and-make(sizeinfo => {
  set text(size: 1.5em)
  let nrows = 2
  // use row height information from size profile with one row removed.
  let row = if sizeinfo != none { sizeinfo.at(1).height / nrows } else { 1em }
  let delimheight = row * 0.90 * nrows
  let delim(p) = grid.cell(rowspan: nrows, $lr(#p, size: #delimheight)$, inset: 0em)
  let open = delim([\[])
  let close = delim([\]])
  rowgrid(
    stroke: 0.10pt + blue,
    align: horizon,
    inset: 0.4em,
    $     &      & (k)     & (l) &&& $,
    $ (a) & open & n       & sum_(i=1)^n x_i   & close & open & beta_0 & close $,
    $ (b) &        sum_(i=1)^n x_i & sum_(i=1)^n x_i^2 &        beta_1 $,
  )
})
```)


= Known Limitations

#set list(marker: "‣")

*Properties/Behaviours*

- A single _styled_ item is not treated as a row, like this: `[*One item*]`. Fix this by inserting a cell separator: `[*One item* & ]`.#footnote[Only content sequences and text are treated as rows and split on separators. `[*item*]` ends up being a `strong` element.]
- Table cells can be passed outside the rows, and this messes up the row length calculations. Avoid doing this.

*Unimplemented*

- Multi-row `table.header/footer` are not supported yet.
- `rowspan` is not supported in rows inside `table.header/footer`.
- `expandcell` can collide with `rowspan`ned cells (if they are not placed along the left or right side of the table); use `colspan` as a workaround when necessary.

#pagebreak(weak: true)

#show heading.where(level: 3): set heading(numbering: none, outlined: false)
#show heading.where(level: 4): set heading(numbering: none, outlined: false)

#{
  let expose = ("rowtable", "rowgrid", "row", "row-split", "expandcell")
  let mod = tidy.parse-module(read("/src/rowtable.typ"), name: "Function Reference", old-syntax: true)
  mod.functions = mod.functions.filter(elt => elt.name in expose)
  mod.variables = mod.variables.filter(elt => elt.name in expose)
  // put rowtable and rowgrid first since they are the main functions.
  let isrt = elt => elt.name == "rowtable"
  let sort-order = ("rowtable", "rowgrid")
  let if-none(x, default) = if x == none { default } else { x }
  mod.functions = mod.functions.sorted(key: func => if-none(sort-order.position(elt => func.name == elt), 3))
  tidy.show-module(mod, first-heading-level: 1, show-outline: false, sort-functions: false)
}

// Postscript
#block(above: 2em, {
  [API Documentation generated using `tidy`.]
})
