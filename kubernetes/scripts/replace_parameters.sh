#!/bin/bash
# Do a bunch of input validation
if [ "$1" = "translate" ]; then
  if [ "$2" ] && [ "$3" ] && [ "$4" ]; then
    CONF=$2
    IN=$3
    OUT=$4
  else
    echo "Usage: conf.sh [config file] [in directory] [out directory]"
    exit 1
  fi

  if [ -f $CONF ]; then
    echo "(reading config file: $CONF)"
  else
    echo "ERROR: First argument must be a valid config file"
    exit 1
  fi

  if [ -d $IN ]; then
    echo "(reading template files in: $IN)"
  else
    echo "ERROR: Second argument must be a valid directory"
    exit 1
  fi

  if [ -d $OUT ]; then
    echo "(writing output files in: $OUT)"
  else
    echo "ERROR: Third argument must be a valid directory"
    exit 1
  fi

  if [ $IN == $OUT ]; then
    echo "ERROR: Input/Output directories must be distinct"
    exit 1
  fi

	# Recursively copy the contents of the IN directory to the OUT directory
	cp --recursive ${IN}/* $OUT

	# Define arrays containing the parameters and substitutions
	# The extra `sed` in here just deletes any lines that start with a # character, to allow for comments in default parameters files
	PARAMS=( $(cat $CONF | sed '/#.*/d' | cut -d '=' -f 1) )
	VALUES=( $(cat $CONF | sed '/#.*/d' | cut -d '=' -f 2-) )

	# Loop through the arrays, doing a recursive sed to find/replace every instance of the parameter in the project
	for val in ${!PARAMS[@]}; do
		find_string=${PARAMS[$val]}
		replace_string=${VALUES[$val]}
		# The strings in the egrep -v command are any files you know you want to skip 
    find ${OUT} -type f | xargs sed -i "s|${find_string}|${replace_string}|g"
	done

elif [ "$1" = "discover" ]; then
  if [ $# != 2 ]; then
    echo "Usage: conf.sh discover [in directory]"
    exit 1
  fi
	# Find and print out every ${PARAM}-notated parameter in the directory given - or any subdirectory thereof
	# The command line below prints params including the encompassing ${}
	# Using '|' as the command separator in sed in order to support URLs in parameter replacement
	find ${2} -type f | xargs grep -oh '${ENV_.*}' |	sed -n 's|\(${.*}\)|\1=|p' | sort | uniq
else
  echo "Usage:"
  echo "  conf.sh translate"
  echo "  conf.sh discover"
fi
