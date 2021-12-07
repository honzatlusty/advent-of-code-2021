#!/bin/bash

input=$1
min_cost=9999999

positions=$(tr ',' ' ' < $input)
max_position=$(echo $positions | tr ' ' '\n' | sort -n | tail -n1)

for i in $(seq 0 $max_position); do
  cost=$(tr ',' '\n' < $input  | while read a; do echo  "$(($a-$i))" | tr -d '-'; done | tr '\n' '+' | sed 's?+$??')
  _cost=$(echo "$cost" | bc)
  [[ $_cost -lt $min_cost ]] && min_cost=$_cost
done

echo $min_cost
