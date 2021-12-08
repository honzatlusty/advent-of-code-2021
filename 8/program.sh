#!/bin/bash

input=$1
hits=0

while read line; do
  for segment in $line; do
    i=$(echo $segment | wc -c)
    i=$(($i-1))
    if [[ $i -eq 2 ]] || [[ $i -eq 4 ]] || [[ $i -eq 3 ]] || [[ $i -eq 7 ]]; then
      hits=$(($hits+1))
    fi
  done
done < <(sed 's?^.*| ??' $input)
echo $hits
