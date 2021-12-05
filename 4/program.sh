#!/bin/bash

input=$1
bingo=0
last_num=''
winning_file=''

rm -rf sums x*
mkdir sums

egrep '^ *[0-9]{1,2} +[0-9]{1,2} +[0-9]{1,2} +[0-9]{1,2} +[0-9]{1,2} *$' $input | sed 's?^ *??' | sed 's? *$??' | split -l 5
for i in x*; do
  tr '\n' ' ' < $i | sed 's? $??' > ${i}.1
  mv ${i}.1 ${i}
  sed -r -i 's? +? ?g' $i
  echo $(tr ' ' '+' < $i) | bc > sums/${i}
done

nums=$(head -n1 $input | tr ',' ' ')
for i in $nums; do
  for j in x*; do
    sed -r "s?(^| )${i}($| )?\1x\2?g" $j -i
    egrep -q "x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x" $j && { winning_file=$j; last_num=$i; break 2; }
    cat $j | sed -r 's?([^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+) +?\1\n?g' | grep -q 'x.*x.*x.*x.*x' && { winning_file=$j; last_num=$i; break 2; }
  done
done

new_sum=$(echo $(sed 's?x??g' $winning_file  | sed -r 's?( *$|^ *)??g' |sed -r 's? +?+?g') | bc)


echo "${new_sum} * ${last_num}" | bc
rm -rf sums x*
