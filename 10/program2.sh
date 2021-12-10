#!/bin/bash

_input=$1
input=$(mktemp)
stack=$(mktemp)
sed -r 's?(.)(.)?\1 \2 ?g' $1 > $input
pairs="() [] {} <>"
score=0
current_open=''

function main () {
  while read line; do
    score=0
    echo '' > $stack
    current_open=''
    for i in $line; do
      if echo "$i" | grep -q '[\(\[\{\<]'; then
        echo "$i" >> $stack
        current_open=$i
      elif echo "$i" | egrep -q  '\}|\)|\]|>'; then
        echo "$pairs" | grep -q -F "${current_open}${i}" || { rm -f $stack; break; }
        sed -i '$ d'  $stack
        current_open=$(tail -n1 $stack)
      fi
    done
    if [[ -f $stack ]]; then
      k=$(tac $stack | tr -d '\n' | tr '([{<' ')]}>' | sed -r 's?(.)(.)?\1 \2 ?g')
      for l in $k; do
        m=$(echo "$l" | tr ')]}>' '1234')
        score=$(($score*5+$m))
      done
      echo $score
    fi
  done < $input
}

scores=$(main | sort -n)
p=$(echo "$scores" | wc -l)
echo "$scores" | head -n $(($p/2+1)) | tail -n1
rm -f $input $stack
