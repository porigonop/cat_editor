#!/bin/sh

fct_show () {
    file=$1
    line=$2
    cat -n $file | grep "^ *$line" -A 2 -B 2
}
fct_edit () {
    file=$1
    line=$2
    total_line_in_file=$(wc -l < ${file}) 2>/dev/null
    head -n $line $file > $file.swp 2>/dev/null
    cat >> $file.swp &&
    tail -n $(($total_line_in_file-$line)) $file >> $file.swp &&
    mv $file.swp $file
}

fct_delete () {
    file=$1 
    line=$2
    total_line_in_file=$(wc -l < ${file}) 2>/dev/null
    line_minus_one=$(($line - 1))
    head -n $line_minus_one $file > $file.swp 2>/dev/null
    tail -n $(($total_line_in_file-$line)) $file >> $file.swp;
    mv $file.swp $file
}

##########
## VARS ##
##########

current_file=""

##################
## Sub-routines ##
##################

sub_new() {
  echo 'New'
}

sub_open() {
  echo 'Open'
}

sub_close() {
  echo 'Close'
}

sub_git() {
  select item in Add Commit Pull Push
  do
    echo $REPLY
  done  
}

##########
## Main ##
##########

if [ "$1" = '--help' ]; then
  echo "Usage: $0 [file]"
  exit 0
elif [ -f "$1" ]; then
  cat -n "$1"
  current_file="$1"
  echo '===================================================='
  options=('New' 'Open' 'Quit' 'Git' 'Close' )
else
  options=('New' 'Open' 'Quit' 'Git')
fi

echo 'Welcome in cat editor \o/'
echo ''

PS3="Action: "

select item in ${options[*]}
do 
  case $item in
    Quit)
      exit 0
      ;;
    New)
      sub_new
      ;;
    Open)
      sub_open
      ;;
    Git)
      sub_git
      ;;
    Close)
      sub_close
      ;;
  esac
done

