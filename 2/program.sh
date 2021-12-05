#!/bin/bash

x=0
y=0
input=$1

while read i j; do
  [[ $i == forward ]] && x=$((x+$j))
  [[ $i == down ]] && y=$((y+$j))
  [[ $i == up ]] && y=$((y-$j))
done < $input

echo $(($x*$y))
