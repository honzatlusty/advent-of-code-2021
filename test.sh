for i in $(ls | grep -v test.sh); do
  cd $i
  [[ $(bash program.sh input) -eq $(cat result) ]] || echo "${i}/program.sh failed"
  [[ $(bash program2.sh input) -eq $(cat result2) ]] || echo "${i}/program2.sh failed"
  cd ..
done
