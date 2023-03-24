#!/usr/bin/env bash
#USAGE EXAMPLE (from the project root folder): "./Scripts/newPlans_create_file_list.sh blocksworld hanoi"
#	where:
#			"blocksworld" and "hanoi" are the names of the folders containing the domains and the instances to be added in the solving list file


mkdir -p Input/FilesList

declare -i c=0
for file in $(find "Input/FilesList"/ -type f); do
    c=$(( c+1 ))
done

FILELISTNAME="Input/FilesList/NewPlansformerInputFile_$c.txt"

touch $FILELISTNAME

for arg in "${@}"; do
   INPATH="$arg"

    echo -e "\nRetrieving instances and domain names in Input/"$INPATH"\n"

    for context in $(find "Input/contexts"/ -type f); do
        for threshold in $(find "Input/thresholds"/ -type f); do
            for domain in $(find "Input/"$INPATH"/domain"/ -type f); do
                for instance in $(find "Input/"$INPATH"/instances"/ -type f); do
                    echo $domain $instance $context $threshold >> $FILELISTNAME;
                done
            done
        done
    done
done

python3 Scripts/shuffle_lines.py $FILELISTNAME