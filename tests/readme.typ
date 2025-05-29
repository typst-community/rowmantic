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

  // eval raw to typst
  show raw.where(lang: "typ"): it => {
    eval(it.text, mode: "markup")
  }

  // eval fenced markdown to raw block
  set heading(numbering: "1")
  for example in examples {
    [= Example]
    line(length: 100%)
    eval(example.join("\n"), mode: "markup")
    line(length: 100%)
  }
}

#eval-examples("/README.md")

