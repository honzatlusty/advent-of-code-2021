#!/bin/bash

input=$1

while read x1 y1 x2 y2; do
  if [[ $x1 -eq $x2 ]] || [[ $y1 -eq $y2 ]]; then
    eval echo {$x1..$x2}x{$y1..$y2} | tr ' ' '\n'
  fi

done < <(sed 's? -> ? ?' $input | tr ',' ' ') | sort | uniq -d | wc -l
