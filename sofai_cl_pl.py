#!/usr/bin/env python

# Example of execution: python sofai_cl_pl.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 1 7 2 201
# Example of profiling: python -m cProfile -o profiling.prof sofai_cl_pl.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 1 0

global timerTotal
import time
timerTotal = time.time()

import os
import json
import subprocess
import re
import csv
from pathlib import Path
import sys
import pprint
from time import gmtime, strftime
import random
import traceback
import logging


from Planners.CaseBasedS1 import caseBased_s1_solver
from Planners.CaseBasedS1 import caseBased_s1_distance
from Planners.PlansformerS1 import plansformer_s1
from Planners.New_PlansformerS1 import mode0 as newPlansformer_s1
from Planners.New_PlansformerS1 import mode1 as continual_training
from Planners.New_PlansformerS1 import mode2 as scracth_training

from Planners.PDDL_parser import classical_parser
from Planners.PDDL_parser import SubgoalCompleteness


''' Constants -- Variables Enumeration '''
### Type of Systems
systemALL = -1              # Constant that represents both System-1 and System-2
systemONE = 1               # Constant that represents only System-1
systemTWO = 2               # Constant that represents only System-2

### Type of Planners
plannerALL = -1             # Constant that represents all the possible Planners (both in System-1 and System-2)

## Type of System-1 Planners
onlySystem2 = 0             # Constant that represents NO System-1 Planner (evaluation porpuses)
plannerS1_Dist1 = 1         # Constant that represents the case-based planner with Levenshtein Distance
plannerS1_Dist2 = 2         # Constant that represents the case-based planner with Jaccard Distance
plannerS1_Random = 3        # Constant that represents the case-based planner with random selection (evaluation porpuses)
plannerS1_Combined = 4      # Constant that represents the case-based planner that selects the best solution among Levenshtein and Jaccard (based on the reward) 
plannerS1_Plansformer = 5   # Constant that represents the Plansformer (v1.0) solver
plannerS1_JacPlans = 6      # Constant that represents the combination of the Jaccard and the Plansformer (v1.0) solvers
plannerS1_NewPlans = 7      # Constant that represents the Plansformer (v2.0) solver

# Variation of Plansformer v2.0
newPlans_mode = -1          # Constant to indicate any configuration of Plansformer (v2.0)
newPlans_pretrained = 1     # Constant to indicate that Plansformer (v2.0) will be pretrained and withOUT continual learning
newPlans_continual = 2      # Constant to indicate that Plansformer (v2.0) will be pretrained and WITH continual learning
newPlans_scratch = 3        # Constant to indicate that Plansformer (v2.0) will have NO initial experience and WITH continual learning

# Parameters for Plansformer v2.0 continual learning
instances_count = 0         
final_training_time = 0.0
continual_train_size = 201
#firstTraining = True

## Type of System-2 Planners

onlySystem1 = 0            # Constant that represents NO System-2 Planner (evaluation porpuses)
plannerS2_FD = 1            # Constant to indicate the System-2 solver "FAST DOWNWARD"
plannerS2_LPG = 2           # Constant to indicate the System-2 solver "LPG" 
plannerS2_LPG_partial = 3   # Constant to indicate the System-2 solver "LPG" with the replanning capabilities (from S1)
plannerS2_FD_LPG = 4        # Constant to indicate the System-2 solver uses either "LPG" with the replanning capabilities (from S1) or if S1 solution is not good enough we employ FD


### Thresholds
threshold1 = 20     #This threshold represents the minimun number of plan (existence) that needs to be generated from System-2 (in the same domain) before accepting System-1 solution
threshold2 = 0.8    #The value which current_reward/average_revard must surpass to eploy System-1 -- FOR NOW NOT USED
threshold3 = 0.9    #This value represents the risk-adversion of the system -- The higher it is the more incline to use System-2 the system is
threshold4 = 20     #This is the threshold that is used to set 'M' = 1 when System-1 hasn't enough experience,
epsilonS1 = 0.1

maxExperience = 1000

### Path and Environmental Variables
output_folder = "Output/"
output_folderPl1 = output_folder + "Pl1/"
scripts_folder = "Scripts/"
dbFolder = "Memory/"
#db_file = "memory.db"
jsonFilename = "cases_classical.json"
jsonAllSolFilename = "allS1_solutions.json"
continual_train_file = "continual_exp.csv"
experience_file = dbFolder+jsonFilename


### Parsing related Variables
domainFile = ""
problemFile = ""

domainFileNoPath = ""
domainPath = ""
problemFileNoPath = ""
problemPath = ""

context = ""
solutionS1 = []
confidenceS1 = 0
difficulty = 0

domain_name = ""
problem_name = ""
init_States = ""
goal_States = ""
number_of_actions = 0
number_of_predicates = 0

global timerParsing
global timerSOFAI

'''Function that sets up the environment by creating some necessary folders'''
def createFolders():
    Path(output_folder).mkdir(parents=True,exist_ok=True)
    Path(output_folderPl1).mkdir(parents=True,exist_ok=True)
    ### Creating the memory file if it doesn't exist
    
    Path(dbFolder).mkdir(parents=True,exist_ok=True)
    if not os.path.isfile(experience_file):
        f = open(experience_file, "w")
        f.write("{\n\"size_limit\": 1000,\n\"cases\":{\n}\n}")
        f.close


'''Function that parses some basic values from utilities files (i.e., threshold and contex)'''
def getVarFromFile(filename,varname):
    with open(filename) as myfile:
        for line in myfile:
            if ":"+varname in line:
                line = re.sub(r';.*$', '', line)
                discard, var = line.partition(":"+varname)[::2]
                var = var.replace(")", "")
                myfile.close()
                return var.strip()
        raise Exception('Missing variable named '+ varname)
    raise Exception('Missing file named '+ filename)

'''Function that parses some basic values from utilities files and does not discard comments (i.e., threshold and contex)'''
def getVarFromFile_comment(filename,varname):
    with open(filename) as myfile:
        for line in myfile:
            if ":"+varname in line:
                discard, var = line.partition(":"+varname)[::2]
                var = var.replace(")", "")
                myfile.close()
                return var.strip()
        raise Exception('Missing variable named '+ varname)
    raise Exception('Missing file named '+ filename)

'''Function that parses the Threshold file'''
def readThreshold(thresholdFile):
    global threshold1
    global threshold2
    global threshold3
    global threshold4
    global epsilonS1

    threshold1 = float(getVarFromFile(thresholdFile,"threshold1"))
    threshold2 = float(getVarFromFile(thresholdFile,"threshold2"))
    threshold3 = float(getVarFromFile(thresholdFile,"threshold3"))
    threshold4 = float(getVarFromFile(thresholdFile,"threshold4"))
    epsilonS1  = float(getVarFromFile(thresholdFile,"epsilonS1"))

'''Function that parses the tmp file that stores the solution from any solving process
We assume that every solver (System-1 or System-2) generates this temporary file with the solution
'''
def readSolutionFromFile(filename, solver):
    try:
        if solver == 0: # System-1 plansformer and FD
            with open(filename) as myfile:
                for line in myfile:
                    if "Solution" in line:
                        if '=' in line:
                            discard, sol = line.partition("=")[::2]
                            res=[]
                            #sol = sol.replace(' ','')
                            sol = sol.replace(';','')
                            sol = sol.replace('\n','')

                            acts = sol.split(',')

                            for act in acts:
                                if act and not act.isspace():
                                    res.append(act.strip())

                            myfile.close()
                            return res
        elif solver == 1: # LPG
            with open(filename) as myfile:
                res=[]
                for line in myfile:
                    if "no solution" in line:
                        return "noSolution"
                    else:
                        cleanedLine = re.sub(r'(.*);.*',r'\1',line)
                        cleanedLine = cleanedLine.strip()
                        #print(f"Cleaned line --- {cleanedLine}")
                        if '(' in cleanedLine:
                            res.append(re.sub(r'.*\((.+)\).*',r'\1',cleanedLine).lower())
                return res

        #raise Exception('Missing solution in '+ filename)
        else:
            return "noSolution"
    except IOError:
        return "noSolution"

'''Function that parses the tmp file that stores the time from any solving process
We assume that every solver (System-1 or System-2) generates this temporary file with the solving time
'''
def readTimeFromFile(filename):
    with open(filename) as myfile:
        for line in myfile:
            if "TIMED-OUT" in line:
                return "TO"
            elif "completed the search" in line or "Search time" in line:
                if ':' in line:
                    discard, ret = line.partition(":")[::2]
                    ret = ret.replace(' ','')
                    ret = ret.replace('\n','')
                    ret = ret.replace('s','')
                    ret = ret.strip()
                    
                    return ret

    #raise Exception('Missing plan in '+ filename)
    return "TO"

'''Function that parses sthe optimal plan length in file'''
def readOptLenghtFromFile(filename):
    try:
        return getVarFromFile_comment(filename,"optlen")
    except:
        return -1

'''Function that cleans the solution generated by Plansformer to retrieve the actual info (i.e., the solution and the confidence)'''
def tensor_clean(to_clean):
    ret = re.sub(r'tensor\(([\d \.]+),(.+)\)', r'\1', str(to_clean))
    ret = re.sub(r'tensor\((.+)\)', r'\1', str(ret))
    return ret

'''Function that executes the selected System-1 and evaluates its results (in term of confidence)'''
def executeS1():
    similarity_threshold = 0.2 # Value used to prune the comparisons in the case-based solvers. Only past problems with similarity >= than this are considered when looking for possible solutions
    try:
        
        ### Loading the experience accumulated
        with open(experience_file) as f:
            experience = json.load(f) # Loading the experience

        cases = experience["cases"]

        ### Secific System-1 handling
        global instances_count
        global final_training_time

        ## Levenshtein and Jaccard case-based (disjunctive)
        if (plannerS1 == plannerS1_Dist1 or plannerS1 == plannerS1_Dist2):
            #returned_list has records of this form <path_to_sol, similarity_score, problem_name>
            sol = ""
            confidence = 0
            returned_list = caseBased_s1_distance.doCaseMatch(cases, (plannerS1-1), domain_name, init_States, goal_States, similarity_threshold)
            if returned_list:
                first_act = True
                for act in returned_list[0][1]:
                    if first_act:
                        sol = act
                        first_act = False
                    else:
                        sol = sol + ", " + act
                confidence = returned_list[0][0]

        ## Levenshtein and Jaccard case-based (togheter)
        elif (plannerS1 == plannerS1_Combined):
            #returned_list has records of this form <path_to_sol, similarity_score, problem_name>
            sol = ""
            confidence = 0
            returned_list0 = caseBased_s1_distance.doCaseMatch(cases, 0, domain_name, init_States, goal_States, similarity_threshold)
            returned_list1 = caseBased_s1_distance.doCaseMatch(cases, 1, domain_name, init_States, goal_States, similarity_threshold)

            if returned_list0 and returned_list1:
                if (returned_list0[0][0] < returned_list1[0][0]):
                    returned_list = returned_list1
                else:
                    returned_list = returned_list0

                first_act = True
                for act in returned_list[0][1]:
                    if first_act:
                        sol = act
                        first_act = False
                    else:
                        sol = sol + ", " + act
                confidence = returned_list[0][0]

        ## Random case-based
        elif (plannerS1 == plannerS1_Random):
            sol = ""
            confidence, plan = caseBased_s1_solver.randomSolve(cases)
            first_act = True
            for act in plan:
                if first_act:
                    sol = act
                    first_act = False
                else:
                    sol = sol + ", " + act

        ## Plansformer v1.0
        elif (plannerS1 == plannerS1_Plansformer):
            try:
                tens_confidence, plan = plansformer_s1.solve(domainFile,problemFile)
            except Exception as e:
                 logging.error(traceback.format_exc())
                 raise Exception("Plansformer encountered some errors.")

            #To make it work with different output -- likely depending on the libs versions
            confidence = float(tensor_clean(tens_confidence))
            sol = ""
            first_act = True
            for act in plan:
                if first_act:
                    sol = act
                    first_act = False
                else:
                    sol = sol + ", " + act

        ## Plansformer v2.0
        elif (plannerS1 == plannerS1_NewPlans):
            
            

            if (newPlans_mode != newPlans_pretrained):
                if not os.path.exists(dbFolder + continual_train_file):
                    with open(dbFolder + continual_train_file, 'w+') as f:
                        f.write(",DomainProblem,Plan,ProblemPath\n")
                    instances_count = 0
                elif instances_count == 0:
                    instances_count = sum(1 for line in open(dbFolder + continual_train_file)) -1 #-1 for title

            #Training
            training = False
            if (newPlans_mode != newPlans_pretrained):
                if (instances_count >= continual_train_size): #We reached the appropriate number of new instances to train
                    training = True
                #    print(f"\n\nDEBUG:I'm in here with instance count = {instances_count} and training_size = {continual_train_size}")
                #elif newPlans_mode == newPlans_scratch and firstTraining:
                #    training = True
                #    firstTraining = False
                
                if training:
                    start_training_time = time.time()
                    if (newPlans_mode == newPlans_continual): #continual learning on pretrained model
                        continual_training.existing_plansformer_continual(dbFolder + continual_train_file,continual_train_size)
                    elif (newPlans_mode == newPlans_scratch): #continual learning on pretrained model
                        scracth_training.scratch_plansformer_continual(dbFolder + continual_train_file,continual_train_size)
                    os.rename(dbFolder + continual_train_file, dbFolder + strftime("%Y-%m-%d_%H-%M-%S", gmtime()) + "_done_" + continual_train_file)
                    final_training_time = time.time() - start_training_time


            #Solving
            try:
                tens_confidence, plan = newPlansformer_s1.solve(domainFile,problemFile,(newPlans_mode-1))
            except Exception as e:
                 logging.error(traceback.format_exc())
                 raise Exception("NewPlansformer encountered some errors.")

            #print(f"tens confidence is {str(str_confidence)}")


            confidence = float(tensor_clean(tens_confidence))
            sol = ""
            first_act = True
            for act in plan:
                if first_act:
                    sol = act
                    first_act = False
                else:
                    sol = sol + ", " + act

        ## Plansformer v2.0 and Jaccard case-based (toghether)
        elif(plannerS1 == plannerS1_JacPlans):
            #init_States,goal = getStates.States(problemFile) #reading initial and goal states from problem file


            #returned_list has records of this form <path_to_sol, similarity_score, problem_name>
            sol = ""
            confidenceCB = 0
            confidence = 0
            returned_list = caseBased_s1_distance.doCaseMatch(cases, 1, domain_name, init_States, goal_States, similarity_threshold)

            if returned_list:
                first_act = True
                solCB = ""
            for act in returned_list[0][1]:
                if first_act:
                    solCB = act
                    first_act = False
                else:
                    solCB = solCB + ", " + act
            confidenceCB = returned_list[0][0]


            if (newPlans_mode != newPlans_pretrained):
                if not os.path.exists(dbFolder + continual_train_file):
                    with open(dbFolder + continual_train_file, 'w+') as f:
                        f.write(",DomainProblem,Plan,ProblemPath\n")
                    instances_count = 0
                elif instances_count == 0:
                    instances_count = sum(1 for line in open(dbFolder + continual_train_file)) -1 #-1 for title

            #Training
            training = False
            if (newPlans_mode != newPlans_pretrained):
                if (instances_count >= continual_train_size): #We reached the appropriate number of new instances to train
                    training = True
                #    print(f"\n\nDEBUG:I'm in here with instance count = {instances_count} and training_size = {continual_train_size}")
                #elif newPlans_mode == newPlans_scratch and firstTraining:
                #    training = True
                #    firstTraining = False
                
                if training:
                    start_training_time = time.time()
                    if (newPlans_mode == newPlans_continual): #continual learning on pretrained model
                        continual_training.existing_plansformer_continual(dbFolder + continual_train_file,continual_train_size)
                    elif (newPlans_mode == newPlans_scratch): #continual learning on pretrained model
                        scracth_training.scratch_plansformer_continual(dbFolder + continual_train_file,continual_train_size)
                    os.rename(dbFolder + continual_train_file, dbFolder + strftime("%Y-%m-%d_%H-%M-%S", gmtime()) + "_done_" + continual_train_file)
                    final_training_time = time.time() - start_training_time


            #Solving
            try:
                tens_confidence, plan = newPlansformer_s1.solve(domainFile,problemFile,(newPlans_mode-1))
            except Exception as e:
                 logging.error(traceback.format_exc())
                 raise Exception("NewPlansformer encountered some errors.")

            #print(f"tens confidence is {str(str_confidence)}")


            confidencePL = float(tensor_clean(tens_confidence))
            solPL = ""
            first_act = True
            for act in plan:
                if first_act:
                    solPL = act
                    first_act = False
                else:
                    solPL = solPL + ", " + act

            if(confidenceCB > confidencePL):
                confidence = confidenceCB
                sol = solCB
            else:
                confidence = confidencePL
                sol = solPL

        else:
            raise Exception("The requested System 1 has not been implemented yet.")
    #    solString = s1_planner.s1Solver(domain_name,problem_name,experience_file)
    #    solString = solString.replace(";", ",")
        resFile = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+"S1.tmp"
        out = open(output_folderPl1 + resFile, "w")
        out.write("Solution = " + sol)
        out.close()
        return confidence, resFile
    except Exception:
        return 0, ""

'''Utility function that calls subroutines to sovle the problme with System-1'''
def solveWithS1():
    confidence, resFile = executeS1()
    solutionS1 = readSolutionFromFile(output_folderPl1 + resFile,0)
    return solutionS1, confidence

'''Procedure that, given a solution, returns the value of that solution correctness (for now is the ratio between solved goals and total goals)'''
def validateSolution(solution):

    #print("solution is: "+ solution)
    if solution == "noSolution":
        return 0

    stringSolution = ""
    count = 1

    for elem in solution:
        stringSolution += elem
        if count < len(solution):
            stringSolution += ", "
            count +=1

    
    print(f"String solution: {stringSolution}")

    #print("Execution Line is:  sh ./Planners/EFP/scripts/validate_solution.sh " + instanceNameEFP + " " + stringSolution)
    #Classical
    #print(f"Domain file is {domainFile}")
    return SubgoalCompleteness.get_correctness(domainFile,stringSolution,problemFile)

'''Procedure that calculates the difficulty of a problem by looking at its pddl encoding'''
def estimateDifficulty():
    #For now difficulty evaluation that does not consider goal or initial state (Maybe include planning graph lenght?)

    #domain_name, problem_name, init_States, goal_States, number_of_actions, number_of_predicates = classical_parser.get_details(domainFile,problemFile)
    intersection = [value for value in goal_States if value in init_States]
    diff_fluents = len(goal_States) - len(intersection)

    #print("Difficulty is: " + str(diff_fluents*number_of_actions*pow(2, number_of_predicates)))
    #sys.exit(0)

    return (diff_fluents*number_of_actions*pow(2, number_of_predicates))

'''Procedure that retrieves from the experience the average solving times for a given problem difficulty'''
def estimateTimeCons(planner,difficulty):
    dbFilename = dbFolder + jsonFilename
    range = 100
    timerComputationConsumption = 0
    matchCount = 0
    #Controlla IL CSV e leggi valori
    try:
        with open(dbFilename) as db:
            db_reader = csv.reader(db, delimiter=',')
            for row in db_reader:
                if(row[0] == domain_name):
                    if(int(row[1]) == planner):
                        rowDiff = float(row[2])
                        if ((rowDiff < (difficulty + range)) and (rowDiff > (difficulty - range))):
                            matchCount += 1
                            timerComputationConsumption += float(row[3])

    except IOError:
        matchCount = 0


    if matchCount > 0:
        return (timerComputationConsumption/matchCount)


    else:
        noMatchConsumption = 5
        return noMatchConsumption

'''Procedure that tris to solve the problem with System 2 within the time limit'''
def solveWithS2(timeLimit, planner, solutionS1, correctnessS1, timerComputation, continue_solve=False, temp_solve=False):

    #print("Problem </pro>" + problem_name + "</> solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
    #sys.exit(0)

    head_tail = os.path.split(domainFile)
    domainFileNoPath = head_tail[1]
    domainPath = head_tail[0] + "/"

    head_tail = os.path.split(problemFile)
    problemFileNoPath = head_tail[1]
    problemPath = head_tail[0] + "/"

    ## Used to discard the S1 solutions that are too incorect to be used for replanning porpuses
    lpg_partial_corr_threshold = 0.3


    if planner == plannerS2_LPG_partial or planner == plannerS2_FD_LPG:
        if correctnessS1 >= lpg_partial_corr_threshold:
            planner = plannerS2_LPG_partial
        elif planner == plannerS2_LPG_partial:
            planner = plannerS2_LPG
        elif planner == plannerS2_FD_LPG:
            planner = plannerS2_FD
        else:
            planner = -1


    ### Fast Downward solving
    if planner == plannerS2_FD:

        #print(f"system 2 with FD and s1 correctness {correctnessS1}")
        result = subprocess.run(['bash','./'+ scripts_folder + 'FASTDOWNWARD_solve.sh', domainFileNoPath, domainPath, problemFileNoPath, problemPath, " " + str(int(timeLimit))+"s"])
        resFilename = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+".out"
        solutionS2 = readSolutionFromFile("tmp/FastDownward/" + resFilename,0)
        time = readTimeFromFile("tmp/FastDownward/" + resFilename)
        
    ### LPG solving
    elif planner == plannerS2_LPG:
        
        #print("system 2 with LPG")
        result = subprocess.run(['bash','./'+ scripts_folder + 'LPG_solve.sh', domainFileNoPath, domainPath, problemFileNoPath, problemPath, " " + str(int(timeLimit))+"s"])
        resFilename = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+".SOL"
        solutionS2 = readSolutionFromFile("tmp/LPG/" + resFilename,1)
        time = readTimeFromFile("tmp/LPG/" + resFilename)


    ### LPG partial + LPG solving or LPG partial + FastDownward solving
    elif planner == plannerS2_LPG_partial:
        
        #print("system 2 with LPG partial")

        s1SolFile = 's1Sol.tmp'
        with open(s1SolFile, 'w') as sol_f:
            for act in solutionS1:
                sol_f.write(f"({str(act)})\n")
        result = subprocess.run(['bash','./'+ scripts_folder + 'LPG_partial_solve.sh', domainFileNoPath, domainPath, problemFileNoPath, problemPath, s1SolFile, " " + str(int(timeLimit))+"s"])
        resFilename = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+".SOL"
        solutionS2 = readSolutionFromFile("tmp/LPG/" + resFilename,1)
        time = readTimeFromFile("tmp/LPG/" + resFilename)
        #print(f"\n\nSolution is {solutionS2} and time is {time}, file is tmp/LPG/{resFilename}\n\n")
        os.remove(s1SolFile)


    else:
        raise Exception('Planner '+ str(planner) +' is not a known S2-planner')

    

    if(time == "TO" or solutionS2 == "noSolution"):
        #return False, timeLimit, None
        #print("Problem </pro>" + problem_name + "</> could not be solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
        return False
    else:
        memorizeSolution(systemTWO, planner, 1.0, float(time), 1.0, solutionS2, timerComputation, continue_solve, temp_solve)
        #return True, float(time), solutionS2

'''Function that stores (both for evaluation and in the experience) the solution when found, and also terminates the code execution'''
def memorizeSolution(system, planner, confidence, elapsedTime, correctness, solution, timerComputation, continue_solve=False, temp_solve=False):

    memory_file = open(experience_file)
    totalTIME = time.time()-timerComputation


    data = json.load(memory_file)

    if ('cases' not in data.keys()) or (len(data['cases']) == 0):
        index = 0
    else:
        index = max( [int(k) for k in data['cases'].keys()] )

    index += 1

    #jsonformat established here

    data['cases'][str(index)] = {}
    data['cases'][str(index)]['domain_name'] = domain_name
    data['cases'][str(index)]['problem_name'] = problem_name
    data['cases'][str(index)]['difficulty'] = difficulty
    data['cases'][str(index)]['system'] = system
    data['cases'][str(index)]['planner'] = planner
    data['cases'][str(index)]['confidence'] = confidence
    data['cases'][str(index)]['correctness'] = correctness
    data['cases'][str(index)]['solving_time'] = elapsedTime
    data['cases'][str(index)]['training_time'] = final_training_time
    data['cases'][str(index)]['total_time'] = totalTIME

    #init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

    data['cases'][str(index)]['init'] = init_States
    data['cases'][str(index)]['goal'] = goal_States
    data['cases'][str(index)]['plan'] = solution

    if not temp_solve:
        json_object = json.dumps(data,indent=4)
        # writing dictionary data into json file
        with open(experience_file,"w") as out:
            out.write(json_object)
    
    if continue_solve:
        return

    if system != systemONE: #We only take sys2 solution
        if plannerS1 == plannerS1_NewPlans:
            if newPlans_mode != newPlans_pretrained:
                global instances_count
                
                with open(dbFolder + continual_train_file, 'a') as cont_file:

                    solutionCleaned = ""
                    for act in solution[:-1]:
                        solutionCleaned += act + ", "
                    solutionCleaned += solution[-1]

                    cont_file.write(f'{instances_count},"{classical_parser.get_plansformer_description(domainFile,problemFile)}","{solutionCleaned}","{problemFile}"\n')
                    instances_count += 1
                    

    sollenght = len(solution)
    if sollenght < 1:
        sollenght = -1
    print("The solution of </dmn>" + domain_name + "</> </pro>" + problem_name + "</> is </sol>"
          + str(solution) + "</> of lenght </sollenght>" + str(sollenght) + "</> and optimal lenght of </optlen>"
          + str(readOptLenghtFromFile(problemFile)) + "</> with correctness </cor>"
          + str(correctness) + "</> and has been found in </tim>" + str(elapsedTime) + "s</> and total time </tti>"
          + str(totalTIME) +"s</> by System </sys>" + str(system) + "</>" + " and continual training time of </trt>"
          + str(final_training_time) + "s</>", end = '')
    if (system != systemONE):
        print(" using planner </pla>" + str(planner) +"</>", end = '')
    else:
        print(" using mode </mod>" + str(plannerS1) +"</>", end = '')
        if plannerS1 == plannerS1_NewPlans:
            print(" and submodality </sub>" + str(newPlans_mode) +"</> with training size of </tra>" + str(continual_train_size) +"</>", end = '')

    endComputation(problem_name,domain_name,timerComputation,True)


'''Function that stores the solutions proposed by System 1, even if are not adopted, for evaluation porpuses'''
def saveAllS1Solution(newPlans_mode,confidenceS1,correctnessS1, timerS1, solutionS1):
    json_path = dbFolder+jsonAllSolFilename

    if not os.path.exists(json_path):
        with open(json_path, 'w') as jFile:
            jFile.write("{\n\"cases\":{\n}\n}")

    memory_file = open(json_path)

    data = json.load(memory_file)

    if ('cases' not in data.keys()) or (len(data['cases']) == 0):
        index = 0
    else:
        index = max( [int(k) for k in data['cases'].keys()] )

    index += 1

    #jsonformat established here

    data['cases'][str(index)] = {}
    data['cases'][str(index)]['domain_name'] = domain_name
    data['cases'][str(index)]['problem_name'] = problem_name
    data['cases'][str(index)]['difficulty'] = difficulty
    data['cases'][str(index)]['system'] = "System1"
    data['cases'][str(index)]['planner'] = "New Plansformer"
    data['cases'][str(index)]['mode'] = newPlans_mode
    data['cases'][str(index)]['confidence'] = confidenceS1
    data['cases'][str(index)]['correctness'] = correctnessS1
    data['cases'][str(index)]['solving_time'] = timerS1

    #init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

    data['cases'][str(index)]['init'] = init_States
    data['cases'][str(index)]['goal'] = goal_States
    data['cases'][str(index)]['plan'] = solutionS1

    json_object = json.dumps(data,indent=4)

    # writing dictionary data into json file
    with open(json_path,"w") as out:
        out.write(json_object)

'''Utility function that counts how many solutions have been solved by System 1 in the experience'''
def countSolvedInstances(system,planner):
    dbFilename = dbFolder + jsonFilename
    matchCount = 0
    totalCorrectness = 0

    # Opening JSON file
    try:
        f = open(dbFilename)
        # returns JSON object as a dictionary
        data = json.load(f)

        index = len(data['cases'])
        count = 0
        while (index > 0) and (count < maxExperience):
            if(data['cases'][str(index)]['domain_name'] == domain_name):
                #planner == systemALL means that we accept all the planners
                if(int(data['cases'][str(index)]['system']) == system or system == systemALL):
                    if(int(data['cases'][str(index)]['planner']) == planner or planner == plannerALL):
                        matchCount += 1
            index -= 1
            count += 1

        return matchCount
    except IOError:
        return 0

'''Utility function that return the correctness (average) of System 1 in the last 'sliding window' instances'''
def getAvgCorrS1(system,planner,slidingWindow):
    dbFilename = dbFolder + jsonFilename
    matchCount = 0
    totalCorrectness = 0

    # Opening JSON file
    f = open(dbFilename)
    # returns JSON object as a dictionary
    data = json.load(f)

    index = len(data['cases'])
    count = 0
    while (index > 0) and (count < maxExperience):
        if(data['cases'][str(index)]['domain_name'] == domain_name):
            #planner == systemALL means that we accept all the planners
            if(int(data['cases'][str(index)]['system']) == system or system == systemALL):
                if(int(data['cases'][str(index)]['planner']) == planner or planner == plannerALL):
                    if (matchCount < slidingWindow):
                        matchCount += 1
                        totalCorrectness += float(data['cases'][str(index)]['correctness'])
                    else:
                        index = 0
        index -= 1
        count += 1


    if matchCount > 0:
        return (totalCorrectness/matchCount)
    else:
        return 0

'''Function that tries to employ System 1 and, if fails, employs System 2'''
def tryS1(plannerS1, plannerS2, solutionS1, confidenceS1, timerS1, timerComputation, timeLimit):
    correctnessS1 = validateSolution(solutionS1)
    #print(f"Correctness of S1 is {str(correctnessS1)}")

    if (correctnessS1 >= correctnessCntx):
        memorizeSolution(systemONE, plannerS1, confidenceS1, timerS1, correctnessS1, solutionS1, timerComputation)
    else:
        solveWithS2(timeLimit - (time.time() - timerComputation), plannerS2, solutionS1, correctnessS1, timerComputation)
    
    return correctnessS1

'''Utility function that ends the computation'''
def endComputation(problem_name,domain_name,timerComputation,solved):
    if not solved:
        print("Problem </pro>" + problem_name + "</> of </dmn>" + domain_name + "</> could not be solved and timed-out in </tio>" + str((time.time() - timerComputation)) + "s</>", end = '')
    
    print(f" -- Total time is </tot>{(time.time() - timerTotal)}s</>, SOFAI time is </sot>{(time.time() - timerSOFAI)}s</>, Parsing was done in </par>" + str(timerParsing) + "s</>.")
    sys.exit(0)


#-----------------------------------------------
# MAIN
#-----------------------------------------------
if __name__ == '__main__':

    timerSOFAI = time.time()


    timerParsing = time.time()


    ''' ARGUMENT PARSING
    The architecture should be called following the following scheme:
        python3 sofai_cl_pl.py <domain_file> <instance_file> <context_file> <threshold_file> <type_of_S2> <type_of_S1> (<planformerV2.0_mode>) (<training_size>)
    where:
        * <type_of_S2> can be:
            - 0 to indicate that the architecture should just use System 1 (for comparison purposes)
            - 1 to indicate FastDownward
            - 2 to indicate LPG
            - 3 to indicate LPG with the possibility of replanning from S1 solutions when this is "acceptable"
            - 4 to indicate FastDownard + the LPG replanning capabilities when S1 solution is "acceptable"
        * <type_of_S1> can be:
            - 0 to indicate that the architecture should just use System 2 (for comparison purposes)
            - 1 to indicate the case-based solver with the concept of Levenshtein Distance
            - 2 to indicate the case-based solver with the concept of Jaccard Distance
            - 3 to indicate the case-based solver that selects randomly the solution (for comparison purposes)
            - 4 to indicate the case-based solver that selects the best solution among Levenshtein and Jaccard (based on the reward) 
            - 5 to indicate the Plansformer (v1.0) solver
            - 6 to indicate the combination of the Jaccard and the Plansformer (v1.0) solvers
            - 7 to indicate the Plansformer (v2.0) solver: in this case we can further select among <planformer_mode>
                + 1 to use pretrained Plansformer (v2.0) withOUT continual learning
                + 2 to use pretrained Plansformer (v2.0) WITH continual learning
                + 3 to use Plansformer (v2.0) WITH continual learning and without initial experience
                    . If 2 or 3 are selected it is necessary to provide also the <training_size>
    '''
    
    domainFile = sys.argv[1]                        #<domain_file>
    problemFile = sys.argv[2]                       #<instance_file>
    context = sys.argv[3]                           #<context_file>
    readThreshold(sys.argv[4])                      #<threshold_file>
    plannerS2 = int(sys.argv[5])                    #<type_of_S2>
    plannerS1 = int(sys.argv[6])                    #<type_of_S1>
    if (plannerS1 == plannerS1_NewPlans or plannerS1 == plannerS1_JacPlans):           
        newPlans_mode = int(sys.argv[7])            #<planformer_mode>
        if (newPlans_mode == newPlans_scratch or newPlans_mode == newPlans_continual):
            continual_train_size = int(sys.argv[8])     #<training_size>

    # print(f"\n\nI'm here with the following {str(sys.argv)}\n\n")

    timerParsing = time.time() - timerParsing

    '''PARSING (.pddl based)'''
    ### Domain and Instance parsing (problem)
    domain_name, problem_name, init_States, goal_States, number_of_actions, number_of_predicates = classical_parser.get_details(domainFile,problemFile)
    
    ### Enviromental variables parsing
    timeLimitCntx = float(getVarFromFile(context,"timelimit"))
    correctnessCntx = float(getVarFromFile(context,"correctness"))


    ''' TIMER DECLARATION & ENVIRONMENT PREPARATION '''
    createFolders()
    timerComputation = time.time()

    ### Difficulty estimation
    difficulty = estimateDifficulty()

   
   
   
    ''' EXPERIENCE MANAGEMENT
    - If we are using a pre-trained model we should account for that and set threshold1 to be = threshold1 - experience in the model
    - If we are using a pre-trained model we should account for that and set threshold4 accordingly

    @TODO: For simplicity we set thresholds 1 and 4 to be 0 when using pre-trained Plansformer for the moment
    '''
   
    if (plannerS1 == plannerS1_Plansformer or plannerS1 == plannerS1_NewPlans):
        threshold1 = 0
        threshold4 = 1

    #Test
    #timerS1 = time.time()
    #solutionS1, confidenceS1 = solveWithS1()
    #tryS1(plannerS1, solutionS1, confidenceS1, timerS1)
    #sys.exit(0)

    ''' PERFORMANCE BASELINE GENERATION
    This is just to allow to generate the only System-2 Baseline
    '''
    if (plannerS1 == onlySystem2):
        solveWithS2(timeLimitCntx,plannerS2,[],0.0,timerComputation)
        endComputation(problem_name,domain_name,timerComputation,False)
    
    elif(plannerS2 == onlySystem1):
        timerOnlyS1 = time.time()
        solutionS1, confidenceS1 = solveWithS1()
        timerOnlyS1 = time.time() - timerOnlyS1 - final_training_time
        correctnessS1 = validateSolution(solutionS1)

        if (correctnessS1 >= correctnessCntx):
            memorizeSolution(systemONE, plannerS1, confidenceS1, timerOnlyS1, correctnessS1, solutionS1, timerComputation)
        else:
            if plannerS1 != plannerS1_NewPlans:
            	solveWithS2(timeLimitCntx - (time.time() - timerComputation), plannerS2_FD, solutionS1, correctnessS1, timerComputation, True, False)
            memorizeSolution(systemONE, plannerS1, confidenceS1, timerOnlyS1, correctnessS1, solutionS1, timerComputation, False, True)

    ''' SYSTEM-1 METACOGNITIVE MODULE'''
   
    ### The ''automatic'' call to System-1
    timerS1 = time.time()
    solutionS1, confidenceS1 = solveWithS1()
    timerS1 = time.time() - timerS1 - final_training_time
    #print(f"Solution of S1 is {str(solutionS1)} with confidence {confidenceS1}")

    ### Time management
    ## Storing System-1 solutions (done for future evaluation pourpouses) takes time that has to be removed from the overall running time
    timeToRemove = time.time()
    if (plannerS1 == plannerS1_NewPlans):
        saveAllS1Solution(newPlans_mode,confidenceS1,validateSolution(solutionS1), timerS1, solutionS1)
    timeToRemove = time.time() - timeToRemove
    timerComputation += timeToRemove
    #print(f"Time to remove is {timeToRemove} and timerComputation is {timerComputation}")

    ### First Metacognition process
    ## We first check if System-2 has generated at least an experience of n > threshold1 entries to allow System-1 to continue
    M = 1
    testedS1 = False
    correctnessS1=0
    if (countSolvedInstances(systemALL,plannerALL) > threshold1):
        ## We then check if System-1 has generated at least m > threshold4 plans to evaluate its performance and check if it make sense to verify it
        if (countSolvedInstances(systemONE,plannerALL) > threshold4):
            M = 1-getAvgCorrS1(systemONE,plannerALL,threshold4)
        else:
            M = 0

        if (confidenceS1 * (1-M) > threshold3):
            correctnessS1 = tryS1(plannerS1, plannerS2, solutionS1, confidenceS1, timerS1, timerComputation, timeLimitCntx)
            testedS1 = True


    ## @TODO Maybe we just always verify the plan?


    ''' SYSTEM-2 METACOGNITIVE MODULE'''

    ### We select the System-2 (this is done by looking at the result of System-1 for now and not at the instance)
    # @TODO MAybe add a neural-net that select the best System-2 planner given a problem

    ## Once the planner is selected we calculate its usage "cost" by looking at previous example of similar difficulty
    # @TODO Maybe a neural module also for the above mentione task
    estimatedTimeS2 = estimateTimeCons(plannerS2, difficulty)
    estimatedCostS2 = sys.maxsize

    ## We check if the estimated time is enough to solve the problem
    remainingTime = timeLimitCntx - (time.time() - timerComputation)
    if(remainingTime - estimatedTimeS2 > 0):
        estimatedCostS2 = estimatedTimeS2 / remainingTime

    ## If we think that there is not enough time to employ System-2, we check System-1 solution even if it has low confidence value
    if (estimatedCostS2 > 1 and (not testedS1)):
        correctnessS1 = tryS1(plannerS1, plannerS2, solutionS1, confidenceS1, timerS1, timerComputation, timeLimitCntx)
        testedS1 = True

    ### Trying to employ System-2
    ## If System-1 had low confidence (or failed) we try to employ System-2
    # if System-1 failed we try using System-2 even if we think that we do not have ebough time
    else:
        ## This first block of code randomly (with probability of epsilon) employs System-1 to give it more chance 
        probabilityS1 = (1-threshold3)*epsilonS1
        if (probabilityS1 > random.random() and (not testedS1)):
            correctnessS1 = tryS1(plannerS1, plannerS2, solutionS1, confidenceS1, timerS1, timerComputation, timeLimitCntx)

        ## Instead, with 1-epsilon, we use the ''standard'' metacognitive path
        else:
            if (len(solutionS1) > 0):
                ## Instead, with 1-epsilon, we use the ''standard'' metacognitive path
                # @TODO Here we calcuate the correctness once again, check the part where we refrain to calculate it
                if(not testedS1):
                    correctnessS1 = validateSolution(solutionS1)

                ## Here we check if we can improve on the System-1 results
                if (correctnessS1 >= correctnessCntx):
                    if((1-(estimatedCostS2 * (1-threshold3))) > (correctnessS1*(1-M))):
                        if (not solveWithS2(remainingTime,plannerS2,solutionS1,correctnessS1,timerComputation)):
                            memorizeSolution(systemONE, plannerS1, confidenceS1, timerS1, correctnessS1, solutionS1, timerComputation)
                    else:
                        memorizeSolution(systemONE, plannerS1, confidenceS1, timerS1, correctnessS1, solutionS1, timerComputation)

    ### Finally we run System-2 only if the available time is within reasonable distance w.r.t. the time we think that the System-2 is goin to take 
    ## We arbitrary set the extra time to be 50%
    flexibility_perc = 50
    if (remainingTime >= (estimatedTimeS2 - (float(estimatedTimeS2)/100.0 * float(flexibility_perc)))):
        solveWithS2(remainingTime,plannerS2,solutionS1,correctnessS1,timerComputation)

    endComputation(problem_name,domain_name,timerComputation,False)
