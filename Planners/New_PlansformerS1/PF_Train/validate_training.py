#!/usr/bin/env python

# Example of execution: python3 validate_training.py rocketTrainingSet.csv
# Where:
# - rocketTrainingSet.csv is the name of the file that contains the training data


import sys
import os
import re
import csv

#-----------------------------------------------
# MAIN
#-----------------------------------------------
if __name__ == '__main__':

    training_file = sys.argv[1]
    pathRocket="Output/"
    domain_file=f"{pathRocket}domain/domain.pddl"
    instacePath=f"{pathRocket}instances"

    fileNumber=-1
    # iterating over all files
    with open(training_file, mode ='r') as file:
        
        # reading the CSV file
        csvFile = csv.reader(file)
        rows = list(csvFile)
    
    valid_plans = 0
    checked_plans = 0

    for fileName in os.listdir(instacePath):
        if fileName.endswith('.pddl'):
            fileNumber=int(re.sub(rf'.*problem_rocket_\d+_\d+_(\d+).pddl', r'\1', fileName))
            if (fileNumber <= 1900):
                checked_plans += 1
                print(f"Here with file number {fileNumber}")
                plan=rows[fileNumber-1][1]
                
                solution=plan.split(',')

                with open("tmp_val_plan.tmp", mode ='w') as tmp_plan:
                    for elem in solution:
                        tmp_plan.write(f'({elem})\n')

                validation_res_file="res_tmp_plan.tmp"
                cmd = f'./../../VAL/bin/Validate {domain_file} {instacePath}/{fileName} tmp_val_plan.tmp > {validation_res_file}'
                os.system(cmd)

                with open(validation_res_file, mode ='r') as val_file:
                    if 'Plan valid' in val_file.read():
                        valid_plans += 1
    
    if valid_plans == checked_plans:
        print(f"Congrats, all the {checked_plans} plans are valid.\n(Checked: {checked_plans}, Valid: {valid_plans})")
    else:
        print(f"Ops! Some of the {checked_plans} plans are not valid.\n(Checked: {checked_plans}, Valid: {valid_plans})")


                

#fuelup r0 l0,load c0 r0 l0,fly r0 l0 l1,unload c0 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l0,unload c2 r0 l0,fuelup r1 l0,load c3 r1 l0,fly r1 l0 l1,unload c3 r1 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l0,unload c1 r1 l0
#fuelup r0 l0,load c0 r0 l0,fly r0 l0 l1,unload c0 r0 l1,fuelup r0 l1,load c2 r0 l1,fly r0 l1 l0,unload c2 r0 l0,fuelup r1 l0,load c3 r1 l0,fly r1 l0 l1,unload c3 r1 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l0,unload c1 r1 l0