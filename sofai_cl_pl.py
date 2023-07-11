#!/usr/bin/env python
# Four spaces as indentation [no tabs]

# Example of exwcution: python architecture_classical.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 7 1 10

import os
import json
import subprocess
import re
import csv
from pathlib import Path
import sys
import pprint
import time
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


# Constants -- Variables Enumeration
systemALL = -1
systemONE = 1
systemTWO = 2

plannerALL = -1

onlySystem2 = 0
plannerS1_Dist1 = 1
plannerS1_Dist2 = 2
plannerS1_Random = 3
plannerS1_Combined = 4
plannerS1_Plansformer = 5
plannerS1_JacPlans = 6
plannerS1_NewPlans = 7


newPlans_pretrained = 1
newPlans_continual = 2
newPlans_scratch = 3
newPlans_mode = -1
instances_count = 0
#firstTraining = True
final_training_time = 0.0


plannerS2_1 = 1
plannerS2_2 = 2

output_folder = "Output/"
output_folderPl1 = output_folder + "Pl1/"
scripts_folder = "Scripts/"
dbFolder = "Memory/"
#db_file = "memory.db"
jsonFilename = "cases_classical.json"
jsonAllSolFilename = "allS1_solutions.json"
continual_train_file = "continual_exp.csv"

# Thresholds
threshold1 = 20     #This threshold represents the minimun number of plan (existence) that needs to be generated from System-2 (in the same domain) before accepting System-1 solution
threshold2 = 0.8    #The value which current_reward/average_revard must surpass to eploy System-1 -- FOR NOW NOT USED
threshold3 = 0.9    #This value represents the risk-adversion of the system -- The higher it is the more incline to use System-2 the system is
threshold4 = 20     #This is the threshold that is used to set 'M' = 1 when System-1 hasn't enough experience,
epsilonS1 = 0.1

maxExperience = 1000

# Global variables seen by all the functions
domainFile = ""
problemFile = ""

domainFileNoPath = ""
domainPath = ""
problemFileNoPath = ""
problemPath = ""

context = ""
solutionS1 = []
confidenceS1 = 0
totalTIME = time.time()
difficulty = 0

# Parsing Variables
domain_name = ""
problem_name = ""
init_States = ""
goal_States = ""
number_of_actions = 0
number_of_predicates = 0

def createFolders():
    Path(dbFolder).mkdir(parents=True,exist_ok=True)
    Path(output_folder).mkdir(parents=True,exist_ok=True)
    Path(output_folderPl1).mkdir(parents=True,exist_ok=True)

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

#Every Solver stores the solution on a tmp file
def readSolutionFromFile(filename):
    try:
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

        #raise Exception('Missing solution in '+ filename)
        return "noSolution"
    except IOError:
        return "noSolution"

def readTimeFromFile(filename):
    with open(filename) as myfile:
        for line in myfile:
            if "TIMED-OUT" in line:
                return "TO"
            elif "completed the search" or "Search time" in line:
                if ':' in line:
                    discard, ret = line.partition(":")[::2]
                    ret = ret.replace(' ','')
                    ret = ret.replace('\n','')
                    ret = ret.replace('s','')


                    myfile.close()
                    return ret

    #raise Exception('Missing plan in '+ filename)
    return "TO"

def tensor_clean(to_clean):
    ret = re.sub(r'tensor\(([\d \.]+),(.+)\)', r'\1', str(to_clean))
    ret = re.sub(r'tensor\((.+)\)', r'\1', str(ret))
    return ret

def executeS1():

    #New System-1###################
    similarity_threshold = 0.2 # If < than this is not returned
    json_path = dbFolder+jsonFilename
    try:
        with open(json_path) as f:
            experience = json.load(f)

        cases = experience["cases"]

        if (plannerS1 == plannerS1_Dist1 or plannerS1 == plannerS1_Dist2):
            #init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

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

        elif (plannerS1 == plannerS1_Combined):
            #init_States,goal = getStates.States(problemFile) #reading initial and goal states from problem file

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

        elif (plannerS1 == plannerS1_NewPlans):
            
            global instances_count

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
                    global final_training_time
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

            tens_confidence, plan = plansformer_s1.solve(domainFile,problemFile)
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
    #    solString = s1_planner.s1Solver(domain_name,problem_name,json_path)
    #    solString = solString.replace(";", ",")
        resFile = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+"S1.tmp"
        out = open(output_folderPl1 + resFile, "w")
        out.write("Solution = " + sol)
        out.close()
        return confidence, resFile
    except Exception:
        return 0, ""

def solveWithS1():
    confidence, resFile = executeS1()
    solutionS1 = readSolutionFromFile(output_folderPl1 + resFile)
    return solutionS1, confidence

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


    #print("Execution Line is:  sh ./Planners/EFP/scripts/validate_solution.sh " + instanceNameEFP + " " + stringSolution)
    #Classical
    #print(f"Domain file is {domainFile}")
    return SubgoalCompleteness.get_correctness(domainFile,stringSolution,problemFile)

def estimateDifficulty():
    #For now difficulty evaluation that does not consider goal or initial state (Maybe include planning grpah lenght?)

    #domain_name, problem_name, init_States, goal_States, number_of_actions, number_of_predicates = classical_parser.get_details(domainFile,problemFile)
    intersection = [value for value in goal_States if value in init_States]
    diff_fluents = len(goal_States) - len(intersection)

    #print("Difficulty is: " + str(diff_fluents*number_of_actions*pow(2, number_of_predicates)))
    #sys.exit(0)

    return (diff_fluents*number_of_actions*pow(2, number_of_predicates))

def estimateTimeCons(planner,difficulty):
    dbFilename = dbFolder + jsonFilename
    range = 100
    timeSTARTConsumption = 0
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
                            timeSTARTConsumption += float(row[3])

    except IOError:
        matchCount = 0


    if matchCount > 0:
        return (timeSTARTConsumption/matchCount)


    else:
        noMatchConsumption = 5
        return noMatchConsumption

def solveWithS2NoPlan(timeLimit, timeSTART):
    return solveWithS2(timeLimit, selectPlannerS2(), timeSTART)

def solveWithS2(timeLimit, planner, timeSTART):

    #print("Problem </pro>" + problem_name + "</> solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
    #sys.exit(0)


    if planner == plannerS2_1:

        head_tail = os.path.split(domainFile)
        domainFileNoPath = head_tail[1]
        domainPath = head_tail[0] + "/"

        head_tail = os.path.split(problemFile)
        problemFileNoPath = head_tail[1]
        problemPath = head_tail[0] + "/"

        result = subprocess.run(['bash','./'+ scripts_folder + 'FASTDOWNWARD_solve.sh', domainFileNoPath, domainPath, problemFileNoPath, problemPath, " " + str(int(timeLimit))+"s"])

        resFilename = os.path.splitext(domainFileNoPath)[0]+os.path.splitext(problemFileNoPath)[0]+".out"
        solutionS2 = readSolutionFromFile("tmp/FastDownward/" + resFilename)
        time = readTimeFromFile("tmp/FastDownward/" + resFilename)

    else:
        raise Exception('Planner '+ str(planner) +' is not a known S2-planner')

    if(time == "TO" or solutionS2 == "noSolution"):
        #return False, timeLimit, None
        #print("Problem </pro>" + problem_name + "</> could not be solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
        return False
    else:
        memorizeSolution(systemTWO, planner, 1.0, float(time), 1.0, solutionS2, timeSTART)
        #return True, float(time), solutionS2

def memorizeSolution(system, planner, confidence, elapsedTime, correctness, solution, timeSTART):

    json_path = dbFolder+jsonFilename

    if not os.path.exists(json_path):
        with open(json_path, 'w') as jFile:
            jFile.write("{\n\"size_limit\": 1000,\n\"cases\":{\n}\n}")

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
    data['cases'][str(index)]['system'] = system
    data['cases'][str(index)]['planner'] = planner
    data['cases'][str(index)]['confidence'] = confidence
    data['cases'][str(index)]['correctness'] = correctness
    data['cases'][str(index)]['solving_time'] = elapsedTime
    data['cases'][str(index)]['training_time'] = final_training_time
    data['cases'][str(index)]['total_time'] = time.time()-timeSTART

    #init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

    data['cases'][str(index)]['init'] = init_States
    data['cases'][str(index)]['goal'] = goal_States
    data['cases'][str(index)]['plan'] = solution

    json_object = json.dumps(data,indent=4)

    # writing dictionary data into json file
    with open(json_path,"w") as out:
        out.write(json_object)

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
                    


    print("The solution of </dmn>" + domain_name + "</> </pro>" + problem_name + "</> is </sol>" + str(solution) +
          "</> with correctness </cor>" + str(correctness) + "</> and has been found in </tim>" + str(elapsedTime) 
          + "s</> and total time </tti> + "str(totalTIME)" +s</> by System </sys>" + str(system) + "</>" + " and continual training time of </trt>" + str(final_training_time) + "</>", end = '')
    if (system != systemONE):
        print(" using planner </pla>" + str(planner) +"</>.")
    else:
        print(" using mode </mod>" + str(plannerS1) +"</>", end = '')
        if plannerS1 == plannerS1_NewPlans:
            print(" and submodality </sub>" + str(newPlans_mode) +"</> with training size of </tra>" + str(continual_train_size) +"</>.")
        else:
            print(".")

    sys.exit(0)

def saveAllS1Solution(newPlans_mode,confidenceS1,correctnessS1, timeS1, solutionS1):
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
    data['cases'][str(index)]['solving_time'] = timeS1

    #init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

    data['cases'][str(index)]['init'] = init_States
    data['cases'][str(index)]['goal'] = goal_States
    data['cases'][str(index)]['plan'] = solutionS1

    json_object = json.dumps(data,indent=4)

    # writing dictionary data into json file
    with open(json_path,"w") as out:
        out.write(json_object)

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

def tryS1(plannerS1, solutionS1, confidenceS1, timeS1, timeSTART, timeLimit):
    correctnessS1 = validateSolution(solutionS1)
    if (correctnessS1 >= correctnessCntx):
        memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1, timeSTART)
    else:
        solveWithS2NoPlan(timeLimit - (time.time() - timeSTART), timeSTART)
    
    return correctnessS1

def selectPlannerS2():
    planner = plannerS2_1 #By default we use plannerS2_1 -- we use label to indicate the planners

    return planner

def endComputation(problem_name,timeSTART):
    print("Problem </pro>" + problem_name + "</> could not be solved and timed-out in </tio>" + (time.time() - timeSTART) + "s</>.")
    sys.exit(0)

#-----------------------------------------------
# Main
#-----------------------------------------------
if __name__ == '__main__':

    ''' TIMER DECLARATION & ENVIRONMENT PREPARATION '''
    timeSTART = time.time()
    createFolders()

    ''' ARGUMENT PARSING
    The architecture should be called following the following scheme:
        python3 sofai_cl_pl.py <domain_file> <instance_file> <context_file> <threshold_file> <type_of_S1> (<planformer_mode>) (<training_size>)
    where <type_of_S1>:
        - 0 to indicate that the architecture should just use System 2 (for comparison purposes)
        - 1 to indicate the case-based solver with the concept of Levenshtein Distance
        - 2 to indicate the case-based solver with the concept of Jaccard Distance
        - 3 to indicate the case-based solver that selects randomly the solution (for comparison purposes)
        - 4 to indicate the case-based solver that selects a the best solution among Levenshtein and Jaccard (based on the reward) 
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
    plannerS1 = int(sys.argv[5])                    #<type_of_S1>
    if (plannerS1 == plannerS1_NewPlans):           
        newPlans_mode = int(sys.argv[6])            #<planformer_mode>
        continual_train_size = int(sys.argv[7])     #<training_size>

    # print(f"\n\nI'm here with the following {str(sys.argv)}\n\n")


    '''PARSING (.pddl based)'''
    ### Domain and Instance parsing (problem)
    domain_name, problem_name, init_States, goal_States, number_of_actions, number_of_predicates = classical_parser.get_details(domainFile,problemFile)
    difficulty = estimateDifficulty()

    ### Enviromental variables parsing
    timeLimitCntx = float(getVarFromFile(context,"timelimit"))
    correctnessCntx = float(getVarFromFile(context,"correctness"))
   
   
    ''' EXPERIENCE MANAGEMENT
    - If we are using a pre-trained model we should account for that and set threshold1 to be = threshold1 - experience in the model
    - If we are using a pre-trained model we should account for that and set threshold4 accordingly

    @TODO: For simplicity we set thresholds 1 and 4 to be 0 when using pre-trained Plansformer for the moment
    '''
   
    if (plannerS1 == plannerS1_Plansformer or plannerS1 == plannerS1_NewPlans):
        threshold1 = 0
        threshold4 = 0

    #Test
    #timeS1 = time.time()
    #solutionS1, confidenceS1 = solveWithS1()
    #tryS1(plannerS1, solutionS1, confidenceS1, timeS1)
    #sys.exit(0)

    ''' PERFORMANCE BASELINE GENERATION
    This is just to allow to generate the only System-2 Baseline
    '''
    if (plannerS1 == onlySystem2):
        plannerS2 = selectPlannerS2()
        solveWithS2(timeLimitCntx,plannerS2,timeSTART)
        endComputation(problem_name,timeSTART)


    ''' SYSTEM-1 METACOGNITIVE MODULE'''
   
    ### The ''automatic'' call to System-1
    timeS1 = time.time()
    solutionS1, confidenceS1 = solveWithS1()
    timeS1 = time.time() - timeS1 - final_training_time

    ### Time management
    ## Storing System-1 solutions (done for future evaluation pourpouses) takes time that has to be removed from the overall running time
    timeToRemove = time.time()
    if (plannerS1 == plannerS1_NewPlans):
        saveAllS1Solution(newPlans_mode,confidenceS1,validateSolution(solutionS1), timeS1, solutionS1)
    timeToRemove = time.time() - timeToRemove
    timeSTART += timeToRemove
    #print(f"Time to remove is {timeToRemove} and timestart is {timeSTART}")

    ### First Metacognition process
    ## We first check if System-2 has generated at least an experience of n > threshold1 entries to allow System-1 to continue
    M = 1
    testedS1 = False
    if (countSolvedInstances(systemALL,plannerALL) > threshold1):
        ## We then check if System-1 has generated at least m > threshold4 plans to evaluate its performance and check if it make sense to verify it
        if (countSolvedInstances(systemONE,plannerALL) > threshold4):
            M = 1-getAvgCorrS1(systemONE,plannerALL,threshold4)
        else:
            M = 0

        if (confidenceS1 * (1-M) > threshold3):
            correctnessS1 = tryS1(plannerS1, solutionS1, confidenceS1, timeS1, timeSTART, timeLimitCntx)
            testedS1 = True


    ## @TODO Maybe we just always verify the plan?


    ''' SYSTEM-2 METACOGNITIVE MODULE'''

    ### We select the System-2 (this is done by looking at the result of System-1 for now and not at the instance)
    # @TODO MAybe add a neural-net that select the best System-2 planner given a problem
    plannerS2 = selectPlannerS2()

    ## Once the planner is selected we calculate its usage "cost" by looking at previous example of similar difficulty
    # @TODO Maybe a neural module also for the above mentione task
    estimatedTimeS2 = estimateTimeCons(plannerS2, difficulty)
    estimatedCostS2 = sys.maxsize

    ## We check if the estimated time is enough to solve the problem
    remainingTime = timeLimitCntx - (time.time() - timeSTART)
    if(remainingTime - estimatedTimeS2 > 0):
        estimatedCostS2 = estimatedTimeS2 / remainingTime

    ## If we think that there is not enough time to employ System-2, we check System-1 solution even if it has low confidence value
    if (estimatedCostS2 > 1 and (not testedS1)):
        correctnessS1 = tryS1(plannerS1, solutionS1, confidenceS1, timeS1, timeSTART, timeLimitCntx)
        testedS1 = True

    ### Trying to employ System-2
    ## If System-1 had low confidence (or failed) we try to employ System-2
    # if System-1 failed we try using System-2 even if we think that we do not have ebough time
    else:
        ## This first block of code randomly (with probability of epsilon) employs System-1 to give it more chance 
        probabilityS1 = (1-threshold3)*epsilonS1
        if (probabilityS1 > random.random() and (not testedS1)):
            correctnessS1 = tryS1(plannerS1, solutionS1, confidenceS1, timeS1, timeSTART, timeLimitCntx)

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
                        if (not solveWithS2(remainingTime,plannerS2,timeSTART)):
                            memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1, timeSTART)
                    else:
                        memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1, timeSTART)

    ### Finally we run System-2 only if the available time is within reasonable distance w.r.t. the time we think that the System-2 is goin to take 
    ## We arbitrary set the extra time to be 50%
    flexibility_perc = 50
    if (remainingTime >= (estimatedTimeS2 - (float(estimatedTimeS2)/100.0 * float(flexibility_perc)))):
        solveWithS2(remainingTime,plannerS2,timeSTART)

    endComputation(problem_name,timeSTART)