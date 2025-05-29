#import "/src/lib.typ": rowtable

#set page(width: auto, height: auto, margin: (x: 0.2cm, y: 0.5cm))
#set text(font: "Atkinson Hyperlegible Next")

#let clr = if "dark" in sys.inputs { white } else { black }
#set page(fill: white) if clr == black
#set page(fill: none) if clr != black
#set text(fill: clr)

#rowtable(
  stroke: 0.5pt + clr,
  [Input tables & row     & by      & row       ],
  [Otherwise    & same as & regular & `#table`  ],
)
