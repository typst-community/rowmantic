#import "/src/lib.typ": row-split

#let sequence = [].func()
// #assert.eq(_row-split([A,B, C], sep: ","), (sequence(([A], )), sequence(([B], )), sequence(([C], ))))
#assert.eq(row-split([A,B, C], sep: ","),  ([A], [B], [C]))
#assert.eq(row-split([ Abcd ], sep: ","), ([Abcd], ))

#assert.eq(row-split([*A* & *B*], sep: "&"), ([*A*], [*B*]))
#assert.eq(row-split([Term  & Explanation    & Assumptions ]),
  (([Term]), [Explanation], [Assumptions]))

