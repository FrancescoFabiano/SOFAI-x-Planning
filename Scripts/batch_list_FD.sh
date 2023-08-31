#!/usr/bin/env bash
#USAGE EXAMPLE (from the project root folder): "./Scripts/batch_list_FD.sh Input/FilesList/NewPlansformerInputFile_0.txt"
#	where:
#			"Input/FilesList/NewPlansformerInputFile_0.txt" is the name of the file containing all the problems (shuffled) to be solved


instancesfile="$1" # Name of the file containing all the problems
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
  echo -n -e "\n</ist>$instance_count</>" >> tmp/SOL/"sol.out" | python3 sofai_cl_pl.py $line 1 0 >> tmp/SOL/"sol.out";
  instance_count=$(( instance_count+1 ))
done < $instancesfile

declare -i c=0
for file in $(find "Output/SOL"/ -type f); do
  c=$(( c+1 ))
done

mkdir -p Output/SOL/
mv tmp/SOL/sol.out tmp/SOL/FD.sol
echo "Solution of FD batch test" | mutt -s "FD solution" -a tmp/SOL/FD.sol -- fabianofrancesco.cs@gmail.com
mv tmp/SOL/FD.sol Output/SOL/FD_"$c".sol