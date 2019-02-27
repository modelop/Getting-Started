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

  for INFILE in $IN/*; do
    FILENAME=`basename $INFILE`
    echo " - Translating $FILENAME"
    env `cat $CONF` envsubst < $INFILE > $OUT/$FILENAME
  done
elif [ "$1" = "discover" ]; then
  if [ $# != 2 ]; then
    echo "Usage: conf.sh discover [in directory]"
    exit 1
  fi
  IN=$2
  cat $IN/* | awk '{ gsub(/\${/,"\n${"); print }' | sed -n 's/${\(.*\)}/\1=/p' | uniq
else
  echo "Usage:"
  echo "  conf.sh translate"
  echo "  conf.sh discover"
fi
