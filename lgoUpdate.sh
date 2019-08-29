#!/bin/bash
#Take an lgo file and update it with new values from a legofit run.

while test $# -gt 0; do
    case "$1" in
        --lgo)
            shift
            if test $# -gt 0; then
                export LGO=$1
            else
                echo "lgo flag set, but no populion history (--lgo) file provided."
                exit 1
            fi
            shift
            ;;
        --update)
            shift
            if test $# -gt 0; then
                export UPDATE=$1
            else
                echo "No populion history (--lgo) file provided."
                exit 1
            fi
            shift
            ;;
        --output)
            shift
            if test $# -gt 0; then
                export OUTPUT=$1
            else
                echo "No populion history (--lgo) file provided."
                exit 1
            fi
            shift
            ;;
        *)
            echo "Invalid argument found: $1"
            exit 1
            break
            ;;
    esac
done

echo "File to update: $LGO"
echo "New values to use: $UPDATE"
echo "File to write: $OUTPUT"


declare -A NEW 
for i in `grep twoN b2.legofit | awk '{print $1"="$3}' `;
    #do echo $i;
    do export temp=`cut -f1 -d"=" $i`;
    echo $temp
    NEW["$temp"]=`cut -f2 -d"=" $i`;
done