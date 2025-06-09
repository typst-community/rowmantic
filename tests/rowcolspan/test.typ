/// [ppi: 72]
#import "/src/lib.typ": rowtable, expandcell

#set page(width: auto, height: auto, margin: 5mm)

#let cell = table.cell
#rowtable(
  separator: ",",
  columns: (3em, ) * 4,
  [1, 2, 3,     #cell(fill: yellow)[4]],
  [A, B, #cell(colspan: 2, stroke: 2pt)[Extra Wide]],
)

#rowtable(
  separator: ",",
  column-width: (3em, ) * 4 + (2em, ), rows: 3em,
  inset: 0.25em,
  [#cell(rowspan: 2, colspan: 2)[Square], 1, 2, #cell(rowspan: 3)[3], 4],
  [#expandcell[Expand], #cell(rowspan: 3)[D]],
  [e, f, g, h],
  [#expandcell[Expandcell], rest],
)
