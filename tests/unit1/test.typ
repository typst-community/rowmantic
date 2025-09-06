#import "/src/lib.typ": row-split, rowtable, expandcell, row, rowgrid

#assert.eq(row-split([A,B, C], sep: ","),  ([A], [B], [C]))
#assert.eq(row-split([ Abcd ], sep: ","), ([Abcd], ))

#assert.eq(row-split([*A* & *B*], sep: "&"), ([*A*], [*B*]))
#assert.eq(row-split([Term  & Explanation    & Assumptions ]),
  (([Term]), [Explanation], [Assumptions]))

// escape the delimiter
#assert.eq(row-split([A,B\,C], sep: ","),  ([A], [B#sym.comma;C]))
#assert.eq(row-split([A&B\&C], sep: "&"),  ([A], [B#sym.amp;C]))

// space as delimiter
#assert.eq(row-split([A B], sep: " "),  ([A], [B]))
#assert.eq(row-split([A *B*], sep: " "),  ([A], [*B*]))
#assert.eq(row-split([A B  C	D E
F G~H], sep: " "),  ([A], [B], [C], [D], [E], [F], [G~H]))
// double space as delimiter
#assert.eq(row-split([A B  C	D E *F*], sep: "  "),  ([A B], [C], [D E], [*F*]))

// table
#assert.eq(rowtable(), table(columns: 1))
#assert.eq(rowtable([A & B], [C]), table(columns: 2, [A], [B], [C], []))

// with passthrough we can test a whole bunch of stuff
#assert.eq(rowtable(table: arguments, custom: 1, [A & B], [A & B & C]),
  arguments(columns: 3, custom: 1, [A], [B], none, [A], [B], [C]))
#assert.eq(rowtable(table: arguments, [], [A & B]),
  arguments(columns: 2, none, none, [A], [B]))
#assert.eq(rowtable(table: arguments, columns: (left, left, left), [A], [B]),
  arguments(columns: (left, left, left), [A], none, none, [B], none, none))

#assert.eq(rowtable(table: arguments), arguments(columns: 1))

#assert.eq(rowtable(table: arguments, separator: ",", table.header([A, B, C], repeat: false)),
  arguments(columns: 3, table.header([A], [B], [C], repeat: false)))

// expandcell
#assert.eq(rowtable(table: arguments, expandcell[X], [A & B & C]),
  arguments(columns: 3, table.cell(colspan: 3)[X], [A], [B], [C], ))
#assert.eq(rowtable(table: arguments, [S& #expandcell[T]], [A& B& C]),
  arguments(columns: 3, [S], table.cell(colspan: 2)[T], [A], [B], [C], ))
#assert.eq(rowtable(table: arguments, columns: 4, [#expandcell[S]& #expandcell[T]]),
  arguments(columns: 4, table.cell(colspan: 3)[S], table.cell(colspan: 1)[T]))

#assert.eq(rowtable(table: arguments, [A&B], table.header(expandcell[A])),
  arguments(columns: 2, [A], [B], table.header(table.cell(colspan: 2)[A])))
#assert.eq(rowtable(table: arguments, [A&B], table.footer(expandcell[A])),
  arguments(columns: 2, [A], [B], table.footer(table.cell(colspan: 2)[A])))

// rowspan
#let cell = table.cell
#assert.eq(rowtable(table: arguments,
  [#cell(rowspan: 2, colspan: 2)[A] & B],
  [C & D],
  [e & f & g & h]),
  arguments(columns: 4,
    cell(rowspan: 2, colspan: 2, [A]), [B], none,
    [C], [D],
    [e], [f], [g], [h]))

// row()
#assert.eq(rowtable(row([A & B], map: strong)), table(columns: 2, [*A*], [*B*]))
// map colspan
#assert.eq(rowtable(row([A & #cell(colspan: 2)[B]], map: strong)),
  table(columns: 3, [*A*], table.cell(colspan: 2)[*B*]))
// combine cell properties
#assert.eq(rowtable(row([A & #cell(colspan: 2)[B]], map: elt => table.cell(fill: yellow, elt))),
  table(columns: 3, table.cell(fill: yellow)[A], table.cell(colspan: 2, fill: yellow)[B]))
#assert.eq(rowtable(row([A & #cell(colspan: 2)[B]], cell: (stroke: none))),
  table(columns: 3, table.cell(stroke: none)[A], table.cell(colspan: 2, stroke: none)[B]))


// rowgrid
#assert.eq(rowgrid(table: arguments, separator: ",", grid.header([A, B, C], repeat: false)),
  arguments(columns: 3, grid.header([A], [B], [C], repeat: false)))
#assert.eq(rowgrid(row([A & #grid.cell(colspan: 2)[B]], map: elt => grid.cell(fill: yellow, elt))),
  grid(columns: 3, grid.cell(fill: yellow)[A], grid.cell(colspan: 2, fill: yellow)[B]))
// rowgrid expandcell
#assert.eq(rowgrid([A & B], expandcell[E], grid.header(expandcell[F])),
  grid(columns: 2, [A], [B], grid.cell(colspan: 2)[E], grid.header(grid.cell(colspan: 2)[F])))


// Past bugs section
// Treat [ ] (space) as a row
#assert.eq(rowtable([A&B], [ ], table: arguments), arguments(columns: 2, [A], [B], [], none))
#assert.eq(rowtable([A&B], [ ], [], table: arguments), arguments(columns: 2, [A], [B], [], none, none, none))
#assert.eq(row-split([ ]), ([], ))
#assert.eq(row-split([ ], strip-space: false), ([ ], ))
