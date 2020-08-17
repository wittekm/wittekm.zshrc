#!/bin/bash
export BEFORE=`date '+%Y-%m-%d'`
export AFTER=`date -v -2m '+%Y-%m-%d'`  # -2m means 2 months
# Argument is who authored it.
# Returns who reviewed their code reviews.
git log --after={$AFTER} --before={$BEFORE} $@ | grep "Reviewed By" | awk -F: '{print $2}' | awk -F, '{ for(i = 1; i <= NF; i++) { print $i; } }' | sort | uniq -c | sort -rn

