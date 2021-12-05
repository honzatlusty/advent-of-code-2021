#!/bin/bash

while read x1 y1 x2 y2; do
  if [[ $x1 -eq $x2 ]] || [[ $y1 -eq $y2 ]]; then
    eval echo {$x1..$x2}x{$y1..$y2} | tr ' ' '\n'
  elif [[ $(echo $(($x1-$x2)) | tr -d '-') -eq $(echo $(($y1-$y2)) | tr -d '-') ]]; then
    eval echo {$x1..$x2} | tr ' ' '\n' > /tmp/seq1
    eval echo {$y1..$y2} | tr ' ' '\n' > /tmp/seq2
    while read k l; do
      echo "${k}x${l}"
    done < <(paste -d" " /tmp/seq1 /tmp/seq2)
  fi

done < <(sed 's? -> ? ?' input | tr ',' ' ') | sort | uniq -d | wc -l
