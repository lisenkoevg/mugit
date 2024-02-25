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
  "$PROJECTS_DIR/learn_languages"
)
count=${#repos[@]}

function mainWrapper() {
  clear
  printf "%60sTotal repos: %s\n\n" " " $count
  main | pr --columns=2 -w 140 -s" | " -o 2 -t -
  rc=${PIPESTATUS[0]}
  echo "Changed: $rc"
  return $rc
}

function main() {
  changed=0
  for i in `seq 0 $((count - 1))`; do
    processRepo $i || (( changed++ ))
  done
  return $changed
}

function processRepo() {
  repo="${repos[$1]}"
  pushd "$repo" > /dev/null
  name=${repo/$PROJECTS_DIR\//}
  remote=$(git remote -v)
  [ "${#remote}" == "0" ] && remote="==" || remote="R "
  printf "%2s) ==== %-35s %s======================== \n\n" "$1" "$name" "$remote"
  status=$(git status -s)
  printf "%s\n" "$status"
  popd > /dev/null
  [ "${#status}" == "0" ] || return 1
}

timeout=3600
mainWrapper && timeout=2

while true
do
  read -t $timeout -p "Press N to go to repo, 'r' for refresh or 'q/Enter' to exit (timeout=$timeout): "
  case $REPLY in
    'r')
      timeout=3600
      mainWrapper && timeout=2
      ;;
    'q' | '')
      exit
      ;;
    *)
      [ -n "${repos[$REPLY]}" ] && {
        cmd /c start /max /d "$(cygpath -w ${repos[$REPLY]})" bash -i
      }
      ;;
  esac
done
