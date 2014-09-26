#!/bin/sh

# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

echo Diffing: $*
File1=$1
File2=$2
if [ $# -gt 2 ]; then
    File1=$2
    File2=$5
fi

tkdiff $File1 $File2 | cat
exit 0
