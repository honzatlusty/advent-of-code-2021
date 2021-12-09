input=$1
sum=0

for i in $(seq 1 100); do
  for j in $(seq 1 100); do
    x=$(head -n $i $input | tail -n 1 | sed -r 's?(.)(.)?\1 \2 ?g' | awk "{print \$${j}}")
    upper=$(head -n $(($i-1)) $input | tail -n 1 | sed -r 's?(.)(.)?\1 \2 ?g' | awk "{print \$${j}}")
    lower=$(head -n $(($i+1)) $input | tail -n 1 | sed -r 's?(.)(.)?\1 \2 ?g' | awk "{print \$${j}}")
    [[ $i -eq 100 ]] && lower=11
    left=$(head -n $i $input | tail -n 1 | sed -r 's?(.)(.)?\1 \2 ?g' | awk "{print \$$(($j-1))}")
    [[ $( echo $left | wc -c) -gt 2 ]] && left=11
    right=$(head -n $i $input | tail -n 1 | sed -r 's?(.)(.)?\1 \2 ?g' | awk "{print \$$(($j+1))}")
    
    echo "${x}: upeer: ${upper}; lower: ${lower}; right: ${right}; left: ${left}"
    [[ -z $upper ]] && upper=11
    [[ -z $left ]] && left=11
    [[ -z $lower ]] && lower=11
    [[ -z $right ]] && right=11

    [[ $x -lt $upper ]] && [[ $x -lt $lower ]] && [[ $x -lt $right ]] && [[ $x -lt $left ]] && sum=$(($sum+$(($x+1))))  #echo $(($x+1))

  done
done

echo $sum
