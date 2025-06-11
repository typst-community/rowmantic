/// [ppi: 72]
#import "/src/lib.typ": rowtable
#set page(width: auto, height: auto, margin: 5mm)

// colored cells in equations and markup
#let tc = table.cell
#rowtable(
  fill: yellow,
  $a & b & c$,
  $tc(fill: #red, a)  & tc(fill: #green, b) & tc(fill: #blue, c)$,
  [#tc(fill: red)[a]  & #tc(fill: green)[b] & #tc(fill: blue)[c]],
)
