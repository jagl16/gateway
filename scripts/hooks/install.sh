#!/bin/sh

echo "Installing Git hooks..."

GIT_DIR=$(git rev-parse --git-dir)

ln -s -f "$PWD"/scripts/hooks/commit-msg.sh "$GIT_DIR"/hooks/commit-msg

echo "Git hooks are installed!"
