#!/bin/bash

input=$1
cp $input ${input}.1
cp $input ${input}.2

for z in 1 2; do
  mask=''
  for i in $(seq 1 12); do
    ones=$(sed -r 's?(.)(.)?\1 \2 ?g' $input.${z} | awk "{print \$$i}" | grep '^1$' |wc -l)
    zeros=$(sed -r 's?(.)(.)?\1 \2 ?g' $input.${z} | awk "{print \$$i}" | grep '^0$' |wc -l)
    if [[ $z -eq 1 ]]; then
      [[ $zeros -le $ones ]] && c="1"
      [[ $zeros -gt $ones ]] && c="0"
    else
      [[ $zeros -le $ones ]] && c="0"
      [[ $zeros -gt $ones ]] && c="1"
    fi
    mask="${mask}${c}"
    grep "^${mask}" $input.${z} > $input.${z}.1
    cp $input.${z}.1 $input.${z}
    wc -l $input.${z} | grep -q '^1 ' && break
  done
done

a1=$(cat input.1)
a2=$(cat input.2)
rm -f input.1 input.2 input.1.1 input.2.1

echo "$((2#$a1))*$((2#$a2))" | bc
