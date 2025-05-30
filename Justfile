root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
  @just --list --unsorted

# generate manual (TODO)
doc:

# generate pictures for readme
readme:
    #!/bin/bash
    # generate readme pictures
    for file in readmepicture1 readmepicture2; do
        typst compile -f svg docs/figures/$file.typ out.svg
        scour --no-line-breaks --shorten-ids -i out.svg docs/figures/$file.svg
        typst compile -f svg docs/figures/$file.typ out.svg --input dark=true
        scour --no-line-breaks --shorten-ids -i out.svg docs/figures/$file-dark.svg
        rm -v out.svg
    done


# test compile readme
test-readme:
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

