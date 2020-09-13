#!/bin/sh

message="$1"
commit_regex='^(revert: )?(feat|fix|docs|style|refactor|perf|test|workflow|build|ci|chore|wip)(\(.+\))?: .*'

if ! grep -iqE "$commit_regex" "$message"; then
    echo "Invalid commit message format." >&2
    exit 1
fi
