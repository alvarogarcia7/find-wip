#!/bin/bash

set -euf -o pipefail

function validate_args() {
  if [ $# -ne 1 ]; then
    echo "No arguments supplied"
    echo "Usage: $0 folder"
    exit 1
  fi
  echo "$1"
}

git_status=$(mktemp)

function find_all_git_repos() {
  temp=$(mktemp)

  find "$1" -iname ".git" -type d >> $temp

  while read -r line; do
    cd "$line/.."
    pwd >> $git_status
    set +e
    git status|grep "Your branch is ahead" >> $git_status
    set -e
    cd - >> $git_status
  done < $temp
  rm -f $temp
}

function inform_ahead_repos() {
  cat $git_status |grep "ahead" -B1
  rm -f $git_status
}

function main() {
  folder=$(validate_args $@)
  find_all_git_repos "$folder"
  inform_ahead_repos
}

main $@
