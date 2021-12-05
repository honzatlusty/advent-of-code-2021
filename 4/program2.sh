#!/bin/bash

input=$1
bingo=0
last_num=''
winning_file=''

rm -rf sums won x*
mkdir sums won

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
    test -f $j || continue
    sed -r "s?(^| )${i}($| )?\1x\2?g" $j -i
    egrep -q "x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} [0-9x]{1,2} x" $j && { mv $j won/$j; last_num=$i; winning_file=$j; continue; }
    cat $j | sed -r 's?([^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+) +?\1\n?g' | grep -q 'x.*x.*x.*x.*x' && { mv $j won/$j; last_num=$i; winning_file=$j; }
  done
done

new_sum=$(echo $(sed 's?x??g' won/$winning_file  | sed -r 's?( *$|^ *)??g' |sed -r 's? +?+?g') | bc)


echo "${new_sum} * ${last_num}" | bc
rm -rf sums won x*
