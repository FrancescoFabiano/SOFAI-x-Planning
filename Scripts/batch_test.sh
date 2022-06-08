#!/usr/bin/env bash
#This script prints out the time for executing a plan, giventhe actions, on the same domain with the two version of PDKB
#USAGE EXAMPLE (from the project root folder): ". scripts/givenplan_comparison.sh exp/paper/CC/CC_2_2_3.txt right_a left_b a_check_3"
#	where:
#			"exp/paper/CC/CC_2_2_3.txt" is the path to the domain name
#			"right_a left_b a_check_3" are the names of three actions (the number of actions can be any n > 0)
INPATH="$1" # Name of the domain



mkdir -p tmp/SOL/
touch tmp/SOL/"sol.out"

echo -e "\nExecution of architecture in all the instances in Input/"$INPATH"/instances\n"

for context in $(find "Input/contexts"/ -type f); do
  for threshold in $(find "Input/thresholds"/ -type f); do
    for domain in $(find "Input/"$INPATH"/domain"/ -type f); do
      for instance in $(find "Input/"$INPATH"/instances"/ -type f); do

        echo -e "    Solving the instance \"$(basename ${instance%%.*})\" with context \"$(basename ${context%%.*})\" and thresholds \"$(basename ${threshold%%.*})\"";
        python3 architecture.py "$domain" "$instance" "$context" "$threshold" >> tmp/SOL/"sol.out";
        echo -e "" >> tmp/SOL/"sol.out";

      done
    done
      declare -i c=0
      for file in $(find "Output/SOL"/ -type f); do
        c=$(( c+1 ))
      done

      mkdir -p Output/SOL/
      mv tmp/SOL/"sol.out" Output/SOL/sol_"$(basename ${domain%%.*})"_"$(basename ${context%%.*})"_"$(basename ${threshold%%.*})"_"$c".out
  done
done
