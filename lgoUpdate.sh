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
for i in `awk '{$1=$1;print}' b2.legofit | 
        grep -e ^twoN -e ^m -e ^T | 
        awk '{print $1"="$3}' `;
    do NEW[`echo $i | cut -f1 -d"="`]=`echo $i | cut -f2 -d"="`;
done

#echo ${!NEW[@]}
#echo ${NEW[@]}

cp a.lgo $OUTPUT
for param in "${!NEW[@]}";
    #do echo $param ${NEW[$param]}
    do sed -i 's/[^#]#.*//g' $OUTPUT #removes comments not in the header
    
    #change thre free time parameters
    sed -i "s/^time.free.*$param[^A-Za-z].*/time  free $param = ${NEW[$param]}/g" $OUTPUT
    
    #change the population size parameters
    sed -i "s/^twoN.*$param[^A-Za-z].*/twoN  free $param = ${NEW[$param]}/g" $OUTPUT

    #change the mixFrac parameters
    sed -i "s/^mixFrac.*[^A-Za-z]$param[^A-Za-z].*/mixFrac  free $param = ${NEW[$param]}/g" $OUTPUT
done