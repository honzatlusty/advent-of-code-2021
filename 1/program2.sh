#!/bin/bash

input=$1
a=''
b=''
c=''
sum=''
last_sum=''

while read a; do
  if [[ -n $a ]] && [[ -n $b ]] && [[ -n $c ]]; then
    last_sum=$sum
    sum=$(($a+$b+$c))
    [[ -n $last_sum ]] && [[ $sum -gt $last_sum ]] && k=$(($k+1))
  fi
  c=$b
  b=$a
done < $input
echo $k
