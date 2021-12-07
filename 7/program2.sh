#!/bin/bash

input=$1
min_cost=9999999

positions=$(tr ',' ' ' < $input)
max_position=$(echo $positions | tr ' ' '\n' | sort -n | tail -n1)
for i in $(seq 0 $max_position); do
  cost=0
  for p in $positions; do
    delta=$(echo $(($i-$p)) | tr -d '-')
      [[ $delta -ne 0 ]] && cost="$cost+$(echo $(seq -s '+' 1 $delta) | bc)"
  done
  _cost=$(echo "$cost" | bc)
  [[ $_cost -lt $min_cost ]] && min_cost=$_cost
done

echo $min_cost
