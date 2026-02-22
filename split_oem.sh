#!/bin/bash

OEM_COMMIT=$1

if [ -z "$OEM_COMMIT" ]; then
    echo "Usage: ./split_oem.sh <commit_hash>"
    exit 1
fi

# Get list of changed top-level directories
DIRS=$(git diff --name-only ${OEM_COMMIT}^ ${OEM_COMMIT} | cut -d/ -f1-2 | sort -u)

for DIR in $DIRS; do
    echo "Processing $DIR"

    # Restore only that directory from OEM commit
    git checkout $OEM_COMMIT -- $DIR

    # Add files
    git add $DIR

    # Commit
    git commit -m "oem: import changes for $DIR"

done

echo "Done splitting OEM commit."