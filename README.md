# `rowmantic`: Tables row by row
A Typst package for editing tables row-by-row.

The idea is a row-oriented way to input tables, with just a little less syntactical overhead than the usual `table` function in Typst.

The function does a shallow split of the input row by a configurable separator, which is `&` by default.

For example, given typst `[A & B & C]`, the effective table row is `..([A], [B], [C])`.

For improved table ergonomics, the table sizes the number of columns by the longest row. All rows are effectively completed so that they are of full length. This creates a better the editing experience, as rows can be filled out gradually.

## Getting Started

```typ
#import "@preview/rowmantic:0.1.0": rowtable

#rowtable(
  stroke: 0.5pt,
  [Input tables & row     & by      & row       ],
  [Otherwise    & same as & regular & `#table`  ],
)
```


<img src="https://gitlab.com/blussbus/typst-recipes/-/raw/main/rowtable/docs/readmepicture.png"
 alt="rowtable example, glossing table" width="600px">

```typ
#import "@preview/rowmantic:0.1.0": rowtable, expandcell

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
```

This example [taken from Wikipedia](https://en.wikipedia.org/wiki/Interlinear_gloss)

<!--
### Installation

TBD
-->

## Usage

A more in-depth description of usage. Any template arguments? A complicated example that showcases most if not all of the functions the package provides? This is also an excellent place to signpost the manual.

```typ
#import "@preview/rowmantic:0.1.0": rowtable, expandcell
```

*To be added*

