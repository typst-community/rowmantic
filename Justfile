root := justfile_directory()

export TYPST_ROOT := root
export TYPST_FONT_PATHS := root + "/docs/fonts"

[private]
default:
  @just --list --unsorted

# generate manual
doc:
    typst compile docs/rowmantic-manual.typ --ignore-system-fonts

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

# run tt in docker
ttd *args: (package ".typdockerpkg/preview") && (remove ".typdockerpkg/preview")
    docker run -e TYPST_PACKAGE_PATH=/data/.typdockerpkg/ --rm -it -v $PWD:/data ghcr.io/tingerrr/tytanic:v0.2.2 --root data --font-path docs/fonts {{args}}

