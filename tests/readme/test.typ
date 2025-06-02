/// [ppi: 72]
///

#set page(width: auto, height: auto, margin: 5mm)
#let eval-examples(filename) = {
  // Extract each ```typ ``` block from the readme
  // Sed can do this: sed -n '/^```/,/^```/ p' < README.md
  // but this is portable (typst)
  let lines = read(filename).split("\n")
  let (examples, _rest) = lines.fold( ((), ()), ((examples, state), line) => {
    if state == () {
      if line == "```typ" {
        // start
        state = (line, )
      } else {
        // skip
      }
    } else {
      if line != "```" {
        // eat line
        state.push(line)
      } else {
        examples.push(state + (line, ))
        state = ()
      }
    }
    (examples, state)
  })
  assert(_rest == ())

  for (index, example) in examples.enumerate(start: 1) {
    text(size: 0.5em)[*Example* #index]
    line(length: 10cm, stroke: 0.5pt)
    // eval markdown input to typst raw block
    let rwb = eval(example.join("\n"), mode: "markup")
    // eval raw code to typst
    if rwb.lang in ("typ", "typst") {
      eval(rwb.text, mode: "markup")
    } else {
      rwb
    }
    line(length: 10cm, stroke: 0.5pt)
  }

}

#eval-examples("/README.md")

