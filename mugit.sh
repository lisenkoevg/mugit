#!/bin/bash

. ~/lib.sh

PROJECTS_DIR='d:/YandexDisk/Projects'

tmpScript=$(dirname "$0")/tmp.sh
trap "rm -f \"$tmpScript\"" EXIT

repos=(
  'c:\bin'
  'c:\cygwin64\home\Evgen'
  'c:\Users\Evgen\Documents\Vim'
)
count=${#repos[@]}
for p in $PROJECTS_DIR/*; do
  repos[$count]=$p
  ((count++))
done

function mainWrapper() {
  clear
  printf "%60sTotal repos: %s\n\n" " " $count
  main | pr --columns=3 -w 140 -s" | " -o 1 -t -
  rc=${PIPESTATUS[0]}
  echo -e "\nChanged: $rc"
  title "Changed: $rc"
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
  [ "${#remote}" == "0" ] && remote="===" || remote="(R)"
  printf "(%-2s ===%s %-20s \n" "$1" "$remote" "$name"
  status=$(git status -s)
  printf "%s\n\n" "$status"
  popd > /dev/null
  [ "${#status}" == "0" ] || return 1
}

timeout=3600
mainWrapper && timeout=3

while true
do
  read -t $timeout -p "Press N to go to repo, 'r' for refresh or 'q/Enter' to exit (timeout=$timeout): "
  case $REPLY in
    'r')
      timeout=3600
      mainWrapper && timeout=3
      ;;
    'e' | 'q' | '' | ' ')
      exit
      ;;
    *)
      [ -n "${repos[$REPLY]}" ] && $(echo "$REPLY" | grep -qP '^\d+$') && {
        timeout=3600
        echo "git diff; rm \"$tmpScript\"; $SHELL" > "$tmpScript"
        cygstart --maximize --directory "${repos[$REPLY]}" $SHELL -i "$tmpScript"
        echo -e -n '\e[1A\e[K' # move 1-line up and clean it
      }
      ;;
  esac
done
