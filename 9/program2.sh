#!/bin/bash

rm -rf ./visited ./basins
mkdir  ./visited ./basins

_input=$1
input=$(mktemp)
sed -r 's?(.)(.)?\1 \2 ?g' $_input > $input

y_min=1
x_min=1
x_max=100
y_max=100


function get_point_value () {
  x=$(echo $1 | sed -r 's?^([0-9]+)x[0-9]+$?\1?')
  y=$(echo $1 | sed -r 's?^[0-9]+x([0-9]+)$?\1?')
  awk "NR==${y}{print \$${x}}" $input
}

function get_neighbours () {
  x=$(echo $1 | sed -r 's?^([0-9]+)x[0-9]+$?\1?')
  y=$(echo $1 | sed -r 's?^[0-9]+x([0-9]+)$?\1?')

  [[ $(($x-1)) -ge $x_min ]] && echo "$(($x-1))x${y}"
  [[ $(($x+1)) -le $x_max ]] && echo "$(($x+1))x${y}"
  [[ $(($y+1)) -le $y_max ]] && echo "${x}x$(($y+1))"
  [[ $(($y-1)) -ge $y_min ]] && echo "${x}x$(($y-1))"
}

function visit_point () {
  [[ -f ./visited/${1} ]]           && return 0
  [[ $(get_point_value $1) -eq 9 ]] && return 0
  local neighbour=''
  local neighbours=$(get_neighbours $1)
  touch ./visited/${1}
  echo $1 >> ./basins/$2
  for neighbour in $neighbours; do
    visit_point $neighbour $2
  done

}

function list_points () {
  for i in $(seq $y_min $y_max); do
    for j in $(seq $x_min $x_max); do
      echo "${j}x${i}"
    done
  done
}

m=1
for k in $(list_points); do
  visit_point $k $m
  m=$(($m+1))
done

for i in basins/*; do wc -l $i; done | sort -n -k1 | tail -n3 | cut -f 1 -d ' ' | tr '\n' '*' | sed 's?\*$?\n?' | bc
rm -f $input
rm -rf ./visited ./basins
