#!/bin/env bash

declare -i commits=2

while [[ $# > 0 ]]
do
    case $1 in
	commits=*)
	    commits=${1/commits=/}
	    echo "override commits = $commits"
	    ;;
    esac
    shift
done

timestamp=$(date +%Y%m%d%H%M%S)
branch=$(git symbolic-ref --short -q HEAD)
patchfile=${branch}_${timestamp}.patch


git log -n $commits | grep '^commit ' |
    {
	commit=();
	while read line;
	do
	    if [[ $line =~ ^commit\ ([0-9a-f]+) ]]
	    then
		commit_id=${BASH_REMATCH[1]}
		commit+=($commit_id)
	    fi
	done

	last_commit=$(( commits - 1 ))
	echo $last_commit
	if [[ ${#commit[@]} == $commits ]]
	then
	    # warning commit are reversed so [1] before [0]
	    command=(git format-patch -k --stdout ${commit[$last_commit]}..${commit[0]})
	    echo -e "run\n${command[@]}\nto create $patchfile" >&2
	    ${command[@]} >$patchfile
	else
	    echo "[ERROR] wrong number of commits ${#commit[@]} != $commits" >&2
	fi
    }
