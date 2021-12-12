#!/bin/bash

_input=$1
input=$(mktemp)
sed -r 's?(.)(.)?\1 \2 ?g' $_input > $input
x_min=1
y_min=1
x_max=10
y_max=10

printf '' > /tmp/flashed

function get_neighbours () {
  local x=$(echo $1 | sed 's?x.*$??')
  local y=$(echo $1 | sed 's?^.*x??')
  
  [[ $(($x-1)) -ge $x_min ]] && echo "$(($x-1))x${y}"
  [[ $(($x+1)) -le $x_max ]] && echo "$(($x+1))x${y}"
  [[ $(($y+1)) -le $y_max ]] && echo "${x}x$(($y+1))"
  [[ $(($y-1)) -ge $y_min ]] && echo "${x}x$(($y-1))"
  
  [[ $(($x-1)) -ge $x_min ]] && [[ $(($y+1)) -le $y_max ]] && echo "$(($x-1))x$(($y+1))"
  [[ $(($x-1)) -ge $x_min ]] && [[ $(($y-1)) -ge $y_min ]] && echo "$(($x-1))x$(($y-1))"
  [[ $(($x+1)) -le $x_max ]] && [[ $(($y+1)) -le $y_max ]] && echo "$(($x+1))x$(($y+1))"
  [[ $(($x+1)) -le $x_max ]] && [[ $(($y-1)) -ge $y_min ]] && echo "$(($x+1))x$(($y-1))"

}

function flash () {
  echo $1 >> /tmp/flashed
  local -n nnums=$2
  local neighbours=$(get_neighbours $1)
  for neighbour in $neighbours; do
    x=$(echo $neighbour | sed 's?x.*$??')
    y=$(echo $neighbour | sed 's?^.*x??')
    nnums[${x}x${y}]=$((${nnums[${x}x${y}]}+1))
  done
  for neighbour in $neighbours; do
    x=$(echo $neighbour | sed 's?x.*$??')
    y=$(echo $neighbour | sed 's?^.*x??')
    if [[ ${nnums[${x}x${y}]} -gt 9 ]] && ! grep -q "^${x}x${y}$" /tmp/flashed; then
      flash ${x}x${y} nums
    fi
  done
}


declare -A nums
x=1
y=1

while read line; do
  for i in $line; do
    nums[${x}x${y}]=$i
    x=$(($x+1))
  done
  x=1
  y=$((y+1))
done < $input


for o in $(seq 1 1000); do
  for a in $(seq $y_min $y_max); do
    for b in $(seq $x_min $x_max); do
      nums[${b}x${a}]=$((${nums[${b}x${a}]}+1))
    done
  done

  for a in $(seq $y_min $y_max); do
    for b in $(seq $x_min $x_max); do
      if [[ ${nums[${b}x${a}]} -gt 9 ]] && ! grep -q "^${b}x${a}$" /tmp/flashed; then
        flash "${b}x${a}" nums
      fi
    done
  done

  for i in $(cat /tmp/flashed); do
    nums[$i]=0
  done
  wc -l /tmp/flashed | grep -q '100' && { echo ${o}; break; }
  printf '' > /tmp/flashed
done

rm -f $input /tmp/flashed
