#!/usr/bin/env bash
#USAGE EXAMPLE (from the project root folder): "./Scripts/batch_list_SOFAI-PF-LPG.sh Input/FilesList/NewPlansformerInputFile_0.txt 1"
#	where:
#			"Input/FilesList/NewPlansformerInputFile_0.txt" is the name of the file containing all the problems (shuffled) to be solved

instancesfile="$1" # Name of the file containing all the problems
approachName="SOFAI-PF-LPG"
system2="2"
system1="7"
PF_type="1"
training_size=""

./Scripts/batch_list_SOFAI.sh $instancesfile $approachName $system2 $system1 $PF_type $training_size