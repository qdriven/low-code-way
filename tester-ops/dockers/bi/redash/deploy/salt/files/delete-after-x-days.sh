#!/usr/bin/env bash
#
# This file is managed by Dogsbody Technology Ltd.
#   https://www.dogsbody.com/
#
# Description:  A script to remove files older than X days
#
# Usage:  $0 <how many days to keep files> <path to look under>
#
# Future Improvements:
#   - Leaves the root directory because the delete is updating the timestamp.

set -euo pipefail

function cleanup {
    local LC="$BASH_COMMAND" RC=$?
    [ "$RC" != 0 ] && echo "Command [$LC] exited with code [$RC]"
}
trap cleanup EXIT

DAYSTOKEEP=$1
RMPATH=$2

# Don't want to remove the base directory.
touch "$RMPATH"

# Using xargs because it passes the files as arguments to one single rm, alternatively "-exec rm {} \;" runs rm multiple times.
find "$RMPATH" -mtime +"$DAYSTOKEEP" -type f -delete

# Find empty old directories
find "$RMPATH" -mtime +"$DAYSTOKEEP" -type d -empty -delete

# Overwrite cleanup function because it is called by the script finishing.
function cleanup {
    exit 0
}
trap cleanup EXIT

# done
