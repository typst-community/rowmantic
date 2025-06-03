/// [ppi: 72]
///

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

  // Each example on its own page
  for example in examples {
    set page(width: auto, height: auto, margin: 5mm)
    // eval markdown input to typst raw block
    let rwb = eval(example.join("\n"), mode: "markup")
    // eval raw code to typst
    eval(rwb.text, mode: "markup")
  }

}

#eval-examples("/README.md")

