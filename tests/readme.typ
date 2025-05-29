#show raw.where(lang: "typ"): it => {
  eval(it.text, mode: "markup")
}
#eval(read(sys.inputs.inputfile), mode: "markup")

