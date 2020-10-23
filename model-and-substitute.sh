#!/bin/sh
# 1. : <<EOL #       (a model)
# 2. : <<EOM # [ { ] command [ ... [a sharp] ... ]
#                            [ ... [a sharp] ... ]
#              [ } ] (a macro)
# 3. in one file.
# 4. specialize a colon. exchange it with macro.
#   #(name)    a command. name is optional.
#   #n(name)   some commands. name is optional.
#   #          a word.
# 5. an indent in the documents
#

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
: <<EOM #{
    if one of :
      #3()
    do #(add)
  }
  case "$line" in
  #(1) | #(2) | #(3) )
    #(add)
   ;; esac

: <<EOM #add to #
  #="$# $line"
EOM
