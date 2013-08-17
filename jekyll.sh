#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <command> [parameters]"
  exit 1
fi
bundle exec jekyll $1 -s www -d www/_site --config www/_config.yml $2
