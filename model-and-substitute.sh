#!/bin/sh

# a model.
: << EOL #
  while line; 
    if one of :
       a
       b
       c
    do add to foo
    else echo
    fi
  done

EOL 

# a macro.
: <<EOM #while #
 while :; do
   old=$IFS
   IFS=
   read # || break
   IFS=$old
   s=`wc -c << EOL
 $line
 EOL
 `
EOM

# a macro over multiple lines.
: <<EOM #{
    if one of :
      #3()
    do #(add) ## what is?
  }
  case "$line" in
  #(1) | #(2) | #(3) )
    #(add) ## what is?
   ;; esac
EOM

# what is?
: <<EOM #add to #
  #="$# $line"
EOM
