/// Eval example from the readme
///
/// - importedit (bool): Change @preview/rowmantic to local import
/// - number (int): Which example to evaluate. Use `none` for all.
#let eval-examples(filename, importedit: false, number: 1) = {
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
  for (index, example) in examples.enumerate(start: 1) {
    if index != number and number != none { continue }
    set page(width: auto, height: auto, margin: 5mm) if number == none
    // eval markdown input to typst raw block
    let rwb = eval(example.join("\n"), mode: "markup")
    let text = if importedit {
      rwb.text.replace(regex("@preview/rowmantic:[^\\\"]+"), "/src/lib.typ")
    } else { rwb.text }
    // eval raw code to typst
    eval(text, mode: "markup")
  }
}
