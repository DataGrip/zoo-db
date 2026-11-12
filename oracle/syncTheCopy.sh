#!/bin/bash

# Updates the deployment copy of the Oracle scripts:
# makes ./scripts/content an exact copy of ../DB/Oracle (the SQL scripts only).
#
# Files that are absent in ../DB/Oracle are removed from the copy.
# The wrappers ./scripts/run-*.sql are not touched.
#
# Usage:  ./syncTheCopy.sh        to update the copy
#         ./syncTheCopy.sh -n     to only show what would be changed (dry run)
#
# The script can be run from any directory.

set -e

this_dir=$(cd "$(dirname "$0")" && pwd)
source_dir="$this_dir/../DB/Oracle"
target_dir="$this_dir/scripts/content"

if [ ! -d "$source_dir" ]; then
    echo "The source directory $source_dir doesn't exist" >&2
    exit 1
fi

mkdir -p "$target_dir"

# Copy the *.sql files from all subdirectories and nothing else;
# the options after "$@" are the filter: directories, then SQL files, then the rest.
rsync --recursive --times --delete --delete-excluded --prune-empty-dirs --itemize-changes "$@" \
      --include='*/' --include='*.sql' --exclude='*' \
      "$source_dir/" "$target_dir/"

echo "Done."
