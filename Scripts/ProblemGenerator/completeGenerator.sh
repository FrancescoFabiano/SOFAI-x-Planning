#!/bin/bash
# Script to generate $1 problem files for the domains. These instances should require at least $2 seconds to be solved by the fastet planner we have and within $3 tries
# Usage from the "Scripts/ProblemGenerator" folder execute "./completeGenerator.sh 20 0.5 1000" 20 instances for all domains.
# Each instance will be below 512 token and should require more than 0.5 seconds to be solved by LPG. Finally, all domains will try to generate a maximum of 1000 instances

max_tokens=512
outFolder="Output/"
dmnFolder="domain/"
instFolderEasy="instancesEasy/"
instFolderHard="instancesHard/"
instFolderBigEasy="instancesBigEasy/"
instFolderBigHard="instancesBigHard/"
minimumTime=$2
declare -i maxAttemptsPerDomain=$3

#Blocksworld specific
declare -i maxBlockNum=16
declare -i minBlockNum=10
blocksNum=$minBlockNum
bwFolder="blocksworld/"

#Driverlog specific
dlFolder="driverlog/"

#Ferry specific
ferryFolder="ferry/"

#Gripper specific
grFolder="grippers/"

#Hanoi specific
hanoiFolder="hanoi/"

#Hanoi specific
miconicFolder="miconic/"

## declare an array variable
#declare -a dmnArr=("$bwFolder" "$dlFolder" "$ferryFolder" "$grFolder" "$hanoiFolder" "$miconicFolder")
declare -a dmnArr=("$hanoiFolder" "$miconicFolder" "$grFolder" "$ferryFolder" "$dlFolder" "$bwFolder" )

## now loop through the above array
for domain in "${dmnArr[@]}"
do

  echo -e "\nWorking on $domain..."

  if [ "$domain" != "$hanoiFolder" ]; then 
    cd $domain
    make > /dev/null
    cd ..
  fi


  tempDmnFolder=$outFolder$domain$dmnFolder
  tempInstancesDirEasy=$outFolder$domain$instFolderEasy
  tempInstancesDirHard=$outFolder$domain$instFolderHard
  tempInstancesDirBigEasy=$outFolder$domain$instFolderBigEasy
  tempInstancesDirBigHard=$outFolder$domain$instFolderBigHard


  mkdir -p $tempDmnFolder
  mkdir -p $tempInstancesDirEasy
  mkdir -p $tempInstancesDirHard
  mkdir -p $tempInstancesDirBigEasy
  mkdir -p $tempInstancesDirBigHard


  declare -i attemptPerDomain=0
  declare -i counter=0

  while (( $counter < $1 && $attemptPerDomain < $maxAttemptsPerDomain )); do



    if [ "$domain" = "$bwFolder" ]; then 
      #blocksNum only for blocksworld
      result=$(./"$domain"/generator_single.sh "$blocksNum")
      
      blocksNum=$(( blocksNum+1 ))
      if (( $blocksNum > $maxBlockNum )); then
        blocksNum=$minBlockNum
      fi
    else
      result=$(./"$domain"/generator_single.sh)
    fi


    seprated_res=($result)

    domain_file="${seprated_res[0]}"
    problem_file="${seprated_res[1]}"


    if [ -z "$(ls -A $tempDmnFolder)" ]; then
      cp $domain_file $tempDmnFolder/domain.pddl
    fi
    
    prompt=$(python plansformer_prompt_generator.py "$domain_file" "$problem_file")
    token_count=$(python count_512subset.py "$prompt")

    #token_count=100
    
    filename=$(basename -- "$problem_file")
    #Checking for token limitations
    if (( $token_count <= $max_tokens )); then

      #Checking for solving time limitations
      timeout "$minimumTime"s ./../../Planners/LPG-td-1.4/lpg-td -o $domain_file -f $problem_file -speed -out plan.tmp > /dev/null
      if [ $? -eq 124 ]; then #If we take more than the minimum time to solve with LPG fast we add it
        cp $problem_file $tempInstancesDirHard/$filename
        counter=$((counter + 1))
        echo "Added problem" $filename
      else
        cp $problem_file $tempInstancesDirEasy/$filename
        echo "Discarded problem" $filename  "solved too fast by LPG"
      fi
    else
      echo "Discarded problem" $filename  "because has too many tokens"
      timeout "$minimumTime"s ./../../Planners/LPG-td-1.4/lpg-td -o $domain_file -f $problem_file -speed > /dev/null
      if [ $? -eq 124 ]; then #If we take more than the minimum time to solve with LPG fast we add it
        cp $problem_file $tempInstancesDirBigHard/$filename
      else
        cp $problem_file $tempInstancesDirBigEasy/$filename
      fi      
    fi 



    attemptPerDomain=$((attemptPerDomain + 1))
  done

  rm -rf $domain"problem_files_temp/"


done

