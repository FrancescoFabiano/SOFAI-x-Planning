#!/usr/bin/env bash
#USAGE EXAMPLE (from the project root folder): "./Scripts/newPlans_batch_test_list.sh Input/FilesList/NewPlansformerInputFile_0.txt 1"
#	where:
#			"Input/FilesList/NewPlansformerInputFile_0.txt" is the name of the file containing all the problems (shuffled) to be solved
#     "1" is the mode in which we are using plansformer (can be 1,2, or 3 for no_continual, continual, and scratch_continual)

FILELIST="$1" # Name of the file containing all the problems
MODE="$2"

mkdir -p tmp/SOL/
touch tmp/SOL/"sol.out"
echo "" > tmp/SOL/"sol.out"

declare -i instance_count=0
while read -r line;
do
  echo -e "Solving the instance \"$line\"";
  echo -n "</ist>$instance_count</>" >> tmp/SOL/"sol.out" | python3 architecture_classical.py $line 7 $MODE >> tmp/SOL/"sol.out";
  instance_count=$(( instance_count+1 ))
done < $FILELIST

declare -i c=0
for file in $(find "Output/SOL"/ -type f); do
  c=$(( c+1 ))
done

mkdir -p Output/SOL/
mv tmp/SOL/"sol.out" Output/SOL/sol_"$c".out
