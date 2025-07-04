/// [ppi: 72]
#import "/src/lib.typ": rowtable, row, expandcell
#import table: cell

#set page(width: auto, height: auto, margin: 5mm)

/// Table cell filled with color between `from` and `to`
#let colorcells(index, elt, from: yellow, to: red, step: 20%) = {
  let fr = index * step
  let fill = color.mix((to, fr), (from, 100% - fr)).lighten(50%)
  cell(fill: fill, elt)
}
/// Table cell with strong stroke if not empty, and red background if empty
#let markempty(elt) = {
  if elt != [] {
    cell(stroke: 2pt, elt)
  } else {
    cell(fill: red.lighten(80%), elt)
  }
}
#rowtable(
  separator: ",",
  align: center, inset: 0.7em,
  table.header(row([0,     1,    2,     3,     4,       5   ], map: strong)),
  row($alpha, beta, gamma, delta, epsilon, zeta$, imap: (idx, elt) => $elt^idx$),
  row([a,     b,    c,     d,     e,    #cell(stroke: 2pt)[f]], imap: colorcells),
  row([A,     B,     ,     C,      ,           ], map: markempty),
  row([A,     B,      ]), // no arguments
  row([A,     B,    C,     D], cell: (inset: 0pt)), // inset
  row([A,     B,      ], map: repr), // repr
  table.footer(row([$*$, #expandcell(stroke: (x: 0pt))[this is a table footer], $*$],
    cell: (fill: green.lighten(85%)))),
)
