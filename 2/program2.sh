#!/bin/bash

x=0
y=0
aim=0
input=$1

while read i j; do
  [[ $i == down ]] && aim=$((aim+$j))
  [[ $i == up ]] && aim=$((aim-$j))
  [[ $i == forward ]] && x=$((x+$j)) && y=$(($aim*$j+$y))
done < $input

echo $(($x*$y))
