#!/bin/bash
# Script to generate $1 problem files for the domain for the BW (for each number fo blocks). These instances should require at least $2 seconds to be solved by the fastet planner we have and within $3 tries. $4 Activate (if == 1) optimality calculation
# Usage from the "Scripts/ProblemGenerator" folder execute "./completeGenerator_bw.sh 150 0.01 1000 1"
# Each instance will be below 512 token and should require more than 0.5 seconds to be solved by LPG. Finally, all domains will try to generate a maximum of 1000 instances and for each one the optiaml plan is calculated

max_tokens=512
outFolder="Output/"
dmnFolder="domain/"
instFolder="instances/"
instFolderPlans="plans/"
minimumTime=$2
declare -i maxAttemptsPerDomain=$3
optimality=$4
optimality_time=600

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
#declare -a dmnArr=("$bwFolder")
#declare -a dmnArr=("$hanoiFolder" "$miconicFolder" "$grFolder" "$ferryFolder" "$bwFolder" "$dlFolder")
declare -a dmnArr=("$bwFolder")

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
  tempInstancesDir=$outFolder$domain$instFolder
  tempInstancesDirPlan=$outFolder$domain$instFolderPlans


  mkdir -p $tempDmnFolder
  mkdir -p $tempInstancesDir
  mkdir -p $tempInstancesDirPlan




  while (( $blocksNum <= $maxBlockNum )); do
  declare -i attemptPerDomain=0
  declare -i counter=0
    while (( $counter < $1 && $attemptPerDomain < $maxAttemptsPerDomain )); do

      result=$(./"$domain"/generator_single.sh "$blocksNum")
        
      seprated_res=($result)

      domain_file="${seprated_res[0]}"
      problem_file="${seprated_res[1]}"


      if [ -z "$(ls -A $tempDmnFolder)" ]; then
        cp $domain_file $tempDmnFolder/domain.pddl
      fi

      #Optimality checker
      if (( $optimality == 1)); then
        timeout "$optimality_time"s python3 ../../Planners/FastDownward/fast-downward.py --plan-file planopt.tmp $domain_file $problem_file  --search "astar(blind())" > /dev/null
        if [ $? -eq 124 ]; then #If we take more than the minimum time to solve with LPG fast we add it
          optimal_lenght=-1
        else
          optimal_lenght=`wc --lines < planopt.tmp`
          optimal_lenght=$((optimal_lenght - 1))
          optPath=""
          filename=$(basename -- "$problem_file")
          cp planopt.tmp $tempInstancesDirPlan$filename
        fi
      fi
      echo -e "; Optimality lenght is (:optlen $optimal_lenght)\n" | cat - $problem_file > optFileName.tmp && mv optFileName.tmp $problem_file

      #Checking for token limitations
      prompt=$(python plansformer_prompt_generator.py "$domain_file" "$problem_file")
      token_count=$(python count_512subset.py "$prompt")
      #token_count=100
      
      filename=$(basename -- "$problem_file")
      #Checking for token limitations
      if (( $token_count <= $max_tokens )); then
          if (( $optimal_lenght > 0)); then
            cp $problem_file $tempInstancesDir$optPath$filename
            counter=$((counter + 1))
            echo "Added problem" $filename
          else
            rm -f $tempInstancesDirPlan$filename
          fi
      else
        rm -f $tempInstancesDirPlan$filename
      fi 

      attemptPerDomain=$((attemptPerDomain + 1))
      sleep 1s
    done
    
    blocksNum=$(( blocksNum+1 ))
  
  done
  rm -rf $domain"problem_files_temp/"


done

