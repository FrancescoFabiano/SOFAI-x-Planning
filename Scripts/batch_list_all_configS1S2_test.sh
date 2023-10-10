#!/usr/bin/env bash
# USAGE EXAMPLE (from the project root folder): "./Scripts/batch_list_all_configS1S2_test.sh Input/FilesList/NewPlansformerInputFile_0.txt"
# Where Input/FilesList/NewPlansformerInputFile_0.txt contains the list of the instances for the tes


instancesfile="$1"


#!/usr/bin/env bash


system1_configs=("0" "1" "2" "3" "4" "5" "6" "7 1")
system1_names=("" "LEV" "JAC" "RNG" "MIX" "PFOLD" "JACPF" "PF")

system2_configs=("1" "2" "3" "4")
system2_names=("FD" "LPG" "LPGxLPG" "FDxLPG")

used_S1configs=("2" "4" "6")
used_S2configs=("1" "2" "3" "4")

declare -i count=0
mkdir -p S1SOl_Memory
mkdir -p TotSOl_Memory

for sys1 in "${used_S1configs[@]}"; do
    for sys2 in "${used_S2configs[@]}"; do

        echo -e "\nCleaning repository for new execution"
        
        rm -rf Memory/*
        rm -rf tmp/

        declare -i sys1ConfigIndex=$(( sys1 ))
        declare -i sys2ConfigIndex=$(( sys2 - 1 ))

        if [[ "$sys1" == "0" ]]; then
            approachName="SOFAI-${system2_names[sys2ConfigIndex]}"
        else
            approachName="SOFAI-${system1_names[sys1ConfigIndex]}-${system2_names[sys2ConfigIndex]}"
        fi
        echo -e "Running the script for $approachName\n"
        ./Scripts/batch_list_SOFAI.sh $instancesfile $approachName $sys2 $sys1
        echo -e "\nEnd of the script the script for $approachName"
        
        if [ -e Memory/allS1_solutions.json ]
            then cp Memory/allS1_solutions.json S1SOl_Memory/allS1_solutions_$count.json
        fi
        
        if [ -e Memory/cases_classical.json ]
            then cp Memory/cases_classical.json TotSOl_Memory/cases_classical_$count.json
        fi
        
        count=$((count+1))
        
        sleep 10s
    done
done
