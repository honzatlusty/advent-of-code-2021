#!/bin/bash

input=$(mktemp)
stack=$(mktemp)
_input=$1
sed -r 's?(.)(.)?\1 \2 ?g' $_input > $input
pairs="() [] {} <>"
current_open=''
corrupted=''

while read line; do
  echo '' > /tmp/stack
  current_open=''
  for i in $line; do
    if echo "$i" | grep -q '[\(\[\{\<]'; then
      echo "$i" >> /tmp/stack
      current_open=$i
    elif echo "$i" | egrep -q  '\}|\)|\]|>'; then
      echo "$pairs" | grep -q -F "${current_open}${i}" || { corrupted="${corrupted} ${i}"; break; }
      sed -i '$ d'  /tmp/stack
      current_open=$(tail -n1 /tmp/stack)
    fi
  done
done < $input

echo "$corrupted" | sed -r 's?\)?3?g' | sed -r 's?\]?57?g' | sed -r 's?\}?1197?g' | sed -r 's?>?25137?g' | sed -r 's?([0-9]+) +([0-9]+)?\1+\2+?g' | tr -d ' ' | bc
rm -f $stack $input
