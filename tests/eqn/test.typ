#import "/src/lib.typ": row-split, rowtable, expandcell

// Tests for equations in tables

#assert.eq(rowtable(table: arguments, $x & x^2$),
  arguments(columns: 2, $x$, $x^2$))

#assert.eq(rowtable(table: arguments, $x, x^2$, separator-eq: $,$),
  arguments(columns: 2, $x$, $x^2$))

#assert.eq(rowtable(table: arguments, $x \& x^2$),
  arguments(columns: 1, $x \& x^2$))

// equation in header footer
#assert.eq(rowtable(table: arguments, table.header($x & x^2$), table.footer($y & y^2$)),
  arguments(columns: 2, table.header($x$, $x^2$), table.footer($y$, $y^2$)))

// turn off equation split with separator none
#assert.eq(rowtable(table: arguments, [A & B], $x & x^2$, $x$, $y$, separator-eq: none),
  arguments(columns: 2, [A], [B], $x & x^2$, $x$, $y$))
