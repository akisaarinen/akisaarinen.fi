#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <command>"
  exit 1
fi
bundle exec compass $1 www/
