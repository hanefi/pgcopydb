#! /bin/bash

set -e
set -o pipefail

# This script is used to update the help messages in the docs. It is not yet run
# automatically. To run it, execute: ./update-help-messages.sh

INCLUDE_DIR="docs/include"

# Given a single commands, print the help text, and wrap the output in rst style
# code block format
function print_help() {
    local cmd="$1"
    local help_text

    # shellcheck disable=SC2086
    help_text="$(pgcopydb $cmd --help 2>&1)"

    # Remove the first line of the help text, which is the version number
    help_text="$(echo "$help_text" | sed '/.*Running pgcopydb version.*/d')"

    # shellcheck disable=SC2001
    # Add spaces at the beginning of each line
    help_text="$(echo "$help_text" | sed 's/^/   /')"

    # Print the command name in a rst code block
    echo "::"
    echo
    echo "$help_text"
    echo
}

# Loop through each command and store help output in separate files
# `pgcopydb --help` output will be in `pgcopydb.rst`. All other commands will
# be in their own file, e.g. `pgcopydb clone --help` will be in `clone.rst`
function print_help_to_files() {
    declare -a cmds=( \
        "clone" "fork" "follow" "copy" "snapshot" "compare" "copy-db" "dump" "restore" "list" "stream" "ping" \
        "compare schema" "compare data" \
        "copy db" "copy roles" "copy extensions" "copy schema" "copy data" "copy table-data" "copy blobs" "copy sequences" "copy indexes" "copy constraints" \
        "dump schema" "dump pre-data" "dump post-data" "dump roles" \
        "list databases" "list extensions" "list collations" "list tables" "list table-parts" "list sequences" "list indexes" "list depends" "list schema" "list progress" \
        "restore schema" "restore pre-data" "restore post-data" "restore roles" "restore parse-list" \
        "stream setup" "stream cleanup" "stream prefetch" "stream catchup" "stream replay" "stream sentinel" "stream receive" "stream transform" "stream apply" \
        "stream sentinel create" "stream sentinel drop" "stream sentinel get" "stream sentinel set" \
        "stream sentinel set startpos" "stream sentinel set endpos" "stream sentinel set apply" "stream sentinel set prefetch" \
    )

    # Print the main pgcopydb help output to pgcopydb.rst
    print_help "" >"$INCLUDE_DIR/pgcopydb.rst"

    # Print the help output for each command to their separate file
    for cmd in "${cmds[@]}"; do
        print_help "$cmd" >"$INCLUDE_DIR/$cmd.rst"
    done
}

# Clear out the include directory before writing new files.
rm -rf "${INCLUDE_DIR:?}/*"
print_help_to_files
