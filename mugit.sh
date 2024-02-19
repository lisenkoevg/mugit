#!/bin/bash

PROJECTS_DIR='d:/YandexDisk/Projects'

repos=(
  'c:\bin'
  'c:\cygwin64\home\Evgen'
  'c:\Users\Evgen\Documents\Vim'
  'd:\Work\C\kernigan\excercises'
  "$PROJECTS_DIR/dotu.ru"
  "$PROJECTS_DIR/libex"
  "$PROJECTS_DIR/pdf_bookmarks"
  "$PROJECTS_DIR/text_analys"
  "$PROJECTS_DIR/mugit"
)
count=${#repos[@]}

function main() {
  for i in `seq 0 $((count - 1))`; do
    processRepo "${repos[i]}"
  done
}

function processRepo() {
  pushd "$1" > /dev/null
  name=${1/$PROJECTS_DIR\//}
  printf "==== %-35s ============================\n\n" "$name"
  # git remote -v | grep push
  git status -s
  popd > /dev/null
  echo -e \\n
}

printf "%60sTotal repos: %s\n\n" " " $count
main | pr --columns=2 -w 140 -s" | " -o 2 -t -
# read -p "Press Enter to exit..." 
