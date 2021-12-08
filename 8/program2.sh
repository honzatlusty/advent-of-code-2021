#!/bin/bash

function dif () {
  echo "$1" | tr -d "$2"
}

function srt () {
  echo "$1" | sed -r 's?(.)?\1\n?g' | grep -v '^$' | sort | tr '\n' ' '
}

function decode_number () {

  input="$1"
  digits="$2"
  number=''
  declare -A numbers

  for i in $(seq 0 9); do
    numbers[$i]=''
  done

  numbers[1]=$(echo  "$input" | egrep -o '(^| )[a-z]{2}( |$)' | tr -d ' ')
  numbers[4]=$(echo  "$input" | egrep -o '(^| )[a-z]{4}( |$)' | tr -d ' ')
  numbers[7]=$(echo  "$input" | egrep -o '(^| )[a-z]{3}( |$)' | tr -d ' ')
  numbers[8]=$(echo  "$input" | egrep -o '(^| )[a-z]{7}( |$)' | tr -d ' ')

  fives=$( echo "$input" | tr ' ' '\n' | egrep "^[a-z]{5}$" | tr '\n' ' ')
  sixes=$( echo "$input" | tr ' ' '\n' | egrep "^[a-z]{6}$" | tr '\n' ' ')

  for five in $fives; do
    x==$(echo $fives | sed "s?${five}??" | awk '{print $1}')
    y==$(echo $fives | sed "s?${five}??" | awk '{print $2}')
    [[ $(dif $x $five | wc -c) -eq $(dif $y $five | wc -c) ]] && numbers[3]=$five && break
  done

  for six in $sixes; do 
    dif $six ${numbers[4]} | wc -c | grep -q 3 && numbers[9]=$six
  done

  for five in $(echo $fives | tr ' ' '\n' | grep -v ${numbers[3]} | tr '\n' ' '); do
    dif $five ${numbers[9]} | wc -c | grep -q '^1$' && numbers[5]=$five
    dif $five ${numbers[9]} | wc -c | grep -q '^2$' && numbers[2]=$five
  done

  for six in $(echo $sixes | tr ' ' '\n' | grep -v ${numbers[9]}) ; do
    dif $six ${numbers[1]}  | wc -c | grep -q '^6$' && numbers[6]=$six
    dif $six ${numbers[1]}  | wc -c | grep -q '^5$' && numbers[0]=$six
  done

  for digit in $digits; do
    for i in $(seq 0 9); do
      if [[ $( srt ${numbers[$i]}) == $( srt $digit ) ]]; then
        number=${number}${i}
      fi
    done
  done
  echo $number
}


input=$1
sum=0

while read line; do
 f=$(echo $line | sed 's? |.*??')
 g=$(echo $line | sed 's?.*| ??')
 l=$(decode_number "$f" "$g")
 sum="$sum+$l"
done < $input

echo $sum | bc
