#!/usr/bin/env bash
#USAGE EXAMPLE (from the project root folder): "./Scripts/batch_list_SOFAI-PF-LPG.sh Input/FilesList/NewPlansformerInputFile_0.txt 1"
#	where:
#			"Input/FilesList/NewPlansformerInputFile_0.txt" is the name of the file containing all the problems (shuffled) to be solved
#     "1" is the mode in which we are using plansformer (can be 1,2, or 3 for no_continual, continual, and scratch_continual)

instancesfile="$1" # Name of the file containing all the problems
MODE="$2"
FILEMem="Memory/fresh_classicalNP.json"

mkdir -p tmp/SOL/
touch tmp/SOL/"sol.out"
echo "" > tmp/SOL/"sol.out"

if test -f "$FILEMem"; then
  cp -f $FILEMem "Memory/cases_classical.json"
else
  touch "Memory/cases_classical.json"
  echo -e "{\n\"cases\":{\n}\n}" > "Memory/cases_classical.json"
fi

declare -i instance_count=0
while read -r line;
do
  echo -e "Solving the instance \"$line\"";
  echo -n -e "\n</ist>$instance_count</>" >> tmp/SOL/"sol.out" | python3 sofai_cl_pl.py $line 2 7 $MODE >> tmp/SOL/"sol.out";
  instance_count=$(( instance_count+1 ))
done < $instancesfile

declare -i c=0
for file in $(find "Output/SOL"/ -type f); do
  c=$(( c+1 ))
done

mkdir -p Output/SOL/
mv tmp/SOL/sol.out tmp/SOL/SOFAI-PF-LPG.sol
echo "Solution of SOFAI-PF-LPG batch test" | mutt -s "SOFAI-PF-LPG solution" -a tmp/SOL/SOFAI-PF-LPG.sol -- fabianofrancesco.cs@gmail.com
mv tmp/SOL/SOFAI-PF-LPG.sol Output/SOL/SOFAI-PF-LPG_"$c".sol
