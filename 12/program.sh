input=$1

function get_neighbours () {
  egrep "(^|-)$1($|-)" $input | sed -r "s?(^|-)$1($|-)??g" | grep -v start
}

function visit () {
  local point=$1
  local visited="$2-$1-"
  local neighbours=$(get_neighbours $point)
  for neighbour in $neighbours; do
    if [[ $neighbour != 'end' ]]; then
	    ! echo "$visited" | grep -q -- "-$point--$neighbour-" &&\
	    (echo $neighbour | grep -q '[A-Z]' || ! echo $visited | grep -q  -- -${neighbour}- ) &&\
	    visit $neighbour "${visited}"
    else
      echo "${visited}"
    fi
  done

}


visit 'start' '' | wc -l
