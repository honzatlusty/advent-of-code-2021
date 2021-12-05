#!/bin/bash

input=$1
c=''
for i in $(seq 1 12); do
   a=$(sed -r 's?(.)(.)?\1 \2 ?g' input | sed 's?+$??' | awk "{print \$$i}" | tr '\n' '+' | sed 's?+$??' | sed 's?^\+??')
   b=$(echo "$a" | bc)
   [[ $b -gt 500 ]] && c="${c}1"
   [[ $b -lt 500 ]] && c="${c}0"
done
d=$(echo $c | tr '01' '10')
echo "$((2#$c))*$((2#$d))" | bc
