root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
  @just --list --unsorted

# generate manual
doc:
  # typst compile docs/manual.typ docs/manual.pdf
  typst compile -f svg docs/figures/readmepicture1.typ docs/figures/readmepicture1.svg
  typst compile -f svg docs/figures/readmepicture1.typ docs/figures/readmepicture1-dark.svg --input dark=true
  typst compile -f svg docs/figures/readmepicture2.typ docs/figures/readmepicture2.svg
  typst compile -f svg docs/figures/readmepicture2.typ docs/figures/readmepicture2-dark.svg --input dark=true


test-readme:
  # test compile readme examples
  typst compile tests/readme.typ


# run test suite
test *args:
  tt run {{ args }}

# update test cases
update *args:
  tt update {{ args }}

# package the library into the specified destination folder
package target:
  ./scripts/package "{{target}}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@preview" prefix (for pre-release testing)
install-preview: (package "@preview")

[private]
remove target:
  ./scripts/uninstall "{{target}}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall-preview: (remove "@preview")

# run ci suite
ci: test doc



examples:
	typst compile *-example.typ

