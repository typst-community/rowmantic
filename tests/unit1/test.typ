#import "/src/lib.typ": row-split, rowtable, expandcell

#assert.eq(row-split([A,B, C], sep: ","),  ([A], [B], [C]))
#assert.eq(row-split([ Abcd ], sep: ","), ([Abcd], ))

#assert.eq(row-split([*A* & *B*], sep: "&"), ([*A*], [*B*]))
#assert.eq(row-split([Term  & Explanation    & Assumptions ]),
  (([Term]), [Explanation], [Assumptions]))

// escape the delimiter
#assert.eq(row-split([A,B\,C], sep: ","),  ([A], [B#sym.comma;C]))
#assert.eq(row-split([A&B\&C], sep: "&"),  ([A], [B#sym.amp;C]))

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
