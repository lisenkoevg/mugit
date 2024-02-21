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
  changed=0
  for i in `seq 0 $((count - 1))`; do
    processRepo "${repos[i]}" || (( changed++ ))
  done
  return $changed
}

function processRepo() {
  pushd "$1" > /dev/null
  name=${1/$PROJECTS_DIR\//}
  remote=$(git remote -v)
  [ "${#remote}" == "0" ] && remote="==" || remote="R "
  printf "==== %-35s %s========================= \n\n" "$name" "$remote"
  status=$(git status -s)
  printf "%s\n" "$status"
  popd > /dev/null
  printf "\n"
  [  ${#status} != 0 ] && return 1
}
printf "%60sTotal repos: %s\n\n" " " $count
main | pr --columns=2 -w 140 -s" | " -o 2 -t -
[ "${PIPESTATUS[0]}" != "0" ] && read -p "Press Enter to exit..." || sleep 1
