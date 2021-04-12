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
fct_to_apply=$1
shift
case $fct_to_apply in
    edit)
        fct_edit $@
        ;;
    show)
        fct_show $@
        ;;
    delete)
        fct_delete $@
        ;;

esac
