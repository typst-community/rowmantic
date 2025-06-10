#import "/tests/evalex.typ": eval-examples

#set page(width: auto, height: auto, margin: (x: 0.2cm, y: 0.5cm))
#set text(font: "Atkinson Hyperlegible Next")
#let clr = if "dark" in sys.inputs { white } else { black }
#set page(fill: white) if clr == black
#set page(fill: none) if clr != black
#set text(fill: clr)
#set table.hline(stroke: clr)

#eval-examples("/README.md", importedit: true, number: 2)
