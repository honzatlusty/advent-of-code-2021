#!/bin/bash

input=$1
j=''
i=''
k=0

while read i; do
  [[ -n $j ]] && [[ $i -gt $j ]] && k=$(($k+1))
  j=$i
done < $input
echo $k
