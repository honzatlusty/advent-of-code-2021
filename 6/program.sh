#!/bin/bash

input=$1
day=0
interval=80
[[ -n $2 ]] && interval=$2
interval=$(($interval-1))

declare -A counts
declare -A _counts

for i in $(seq 0 8); do
  _counts[$i]=0
  counts[$i]=0
done

for i in $(tr ',' ' ' < $1); do
  counts[$i]=$((${counts[$i]}+1))  
done

while [[ $day -le $interval ]]; do
  for i in $(seq 0 8); do
    if [[ $i -ge 1 ]] && [[ $i -le 8 ]]; then
      j=$(($i-1))
      _counts[$j]=$((${_counts[$j]}+${counts[$i]}))
    elif [[ $i -eq 0 ]]; then
      _counts[8]=$((${_counts[8]}+${counts[$i]}))
      _counts[6]=$((${_counts[6]}+${counts[$i]}))
    fi
  done
  day=$(($day+1))
  for i in $(seq 0 8); do
    counts[$i]=${_counts[$i]}
    _counts[$i]=0
  done
done
echo ${counts[@]} | tr ' ' '+' | bc
