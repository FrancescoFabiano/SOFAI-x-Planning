#!/usr/bin/env python
# Four spaces as indentation [no tabs]
import os
import json
import subprocess
import re
import csv
from pathlib import Path
import sys
import pprint
import time
import random


from Planners.EPDDL.parser import EPDDL_Parser
from Planners.CaseBasedS1 import caseBased_s1_solver
from Planners.CaseBasedS1 import getStates
from Planners.CaseBasedS1 import caseBased_s1_distance
from Planners.PlansformerS1 import plansformer_s1


# Constants
systemALL = -1;
systemONE = 1
systemTWO = 2

plannerALL = -1;

plannerS1_Dist1 = 1
plannerS1_Dist2 = 2
plannerS1_Random = 3
plannerS1_Combined = 4
plannerS1_Plansformer = 5

plannerS2_1 = 1
plannerS2_2 = 2

maxGroundDepth = 2
output_folder = "Output/"
output_folderPl1 = output_folder + "Pl1/"
output_folderEFP = output_folder + "EFP/"
output_folderPDKB = output_folder + "PDKB/"
scripts_folder = "Scripts/"
dbFolder = "Memory/"
#db_file = "memory.db"
jsonFilename = "cases.json"


# Thresholds
threshold1 = 20 #This threshold represents the minimun number of plan (existence) that needs to be generated from S2 (in the same domain) before accepting S1 solution
threshold2 = 0.8 #The value which current_reward/average_revard must surpass to eploy S1 -- FOR NOW NOT EMPLOYED
threshold3 = 0.9 #This value represents the risk-adversion of the system -- The higher it is the more incline to use S2 the system is
threshold4 = 20 #This is the threshold that is used to set 'M' = 1 when S1 hasn't enough experience,
epsilonS1 = 0.1

maxExperience = 1000

# Global variables seen by all the functions
domainFile = ""
problemFile = ""
context = ""
instanceNameEFP = ""
solutionS1 = []
confidenceS1 = 0
totalTIME = time.time()
difficulty = 0



# Global Objects
parser = EPDDL_Parser()

def createFolders():
    Path(dbFolder).mkdir(parents=True,exist_ok=True)
    Path(output_folder).mkdir(parents=True,exist_ok=True)
    Path(output_folderPl1).mkdir(parents=True,exist_ok=True)
    Path(output_folderEFP).mkdir(parents=True,exist_ok=True)
    Path(output_folderPDKB).mkdir(parents=True,exist_ok=True)

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
                        sol = sol.replace(' ','')
                        sol = sol.replace(';','')
                        sol = sol.replace('\n','')

                        acts = sol.split(',')

                        for act in acts:
                            res.append(act)

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
            elif "completed the search" in line:
                if ':' in line:
                    discard, ret = line.partition(":")[::2]
                    ret = ret.replace(' ','')
                    ret = ret.replace('\n','')

                    myfile.close()
                    return ret

    #raise Exception('Missing plan in '+ filename)
    return "TO"

def executeS1():

    #New S1###################
    similarity_threshold = 0.2 # If < than this is not returned
    json_path = dbFolder+jsonFilename
    try:
        with open(json_path) as f:
            experience = json.load(f)

        cases = experience["cases"]

        if (plannerS1 == plannerS1_Dist1 or plannerS1 == plannerS1_Dist2):
            init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

            #returned_list has records of this form <path_to_sol, similarity_score, problem_name>
            sol = ""
            confidence = 0
            returned_list = caseBased_s1_distance.doCaseMatch(cases, plannerS1, parser.domain_name, init, goal, similarity_threshold)
            if returned_list:
                first_act = True
                for act in returned_list[0][1]:
                    if first_act:
                        sol = act
                        first_act = False
                    else:
                        sol = sol + ", " + act
                confidence = returned_list[0][0]



        elif(plannerS1 == plannerS1_Combined):
            init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

            #returned_list has records of this form <path_to_sol, similarity_score, problem_name>
            sol = ""
            confidence = 0
            returned_list0 = caseBased_s1_distance.doCaseMatch(cases, 0, parser.domain_name, init, goal, similarity_threshold)
            returned_list1 = caseBased_s1_distance.doCaseMatch(cases, 1, parser.domain_name, init, goal, similarity_threshold)

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
            tens_confidence, plan = plansformer_s1.solve(domainFile,problemFile)
            str_confidence= re.sub(r'tensor\((.+)\)', r'\1', str(tens_confidence))
            confidence = float(str_confidence)
            sol = ""
            first_act = True
            for act in plan:
                if first_act:
                    sol = act
                    first_act = False
                else:
                    sol = sol + ", " + act
        else:
            raise Exception("The requested System 1 has not been implemented yet.")
    #    solString = s1_planner.s1Solver(parser.domain_name,parser.problem_name,json_path)
    #    solString = solString.replace(";", ",")
        resFile = instanceNameEFP.replace(".tmp", "S1.tmp")
        out = open(output_folderPl1 + resFile, "w")
        out.write("Solution = " + sol)
        out.close()
        return confidence, resFile;
    except IOError:
        return 0, "";

def solveWithS1():
    confidence, resFile = executeS1()
    solutionS1 = readSolutionFromFile(output_folderPl1 + resFile)
    return solutionS1, confidence

def validateSolution(solution):
    stringSolution = ""
    for elem in solution:
        stringSolution += " "
        stringSolution += elem
    #print("Execution Line is:  sh ./Planners/EFP/scripts/validate_solution.sh " + instanceNameEFP + " " + stringSolution)
    result = subprocess.run(['sh','./'+ scripts_folder + 'validate_solution.sh', output_folderEFP + instanceNameEFP, stringSolution], stdout=subprocess.PIPE)
    res = result.stdout.decode('utf-8')
    if ("Goal found" in res):
        #print("Found result is " + stringSolution)
        return 1.0
    elif ("The solution score is: <<" in res):
        res = re.findall(r'<<(.+)>>', res, re.MULTILINE)
        return float(res[-1])

    else:
        #print("Goal not found")
        return 0.0

def generateEFPInstance():
    global instanceNameEFP
    global parser

    parser.parse_domain(domainFile)
    parser.parse_problem(problemFile)
    instanceNameEFP = parser.print_EFP(output_folderEFP)

def estimateDifficulty(instanceDepth):
    #For now difficulty evaluation that does not consider goal or initial state (Maybe include planning grpah lenght?)
    #parser.ag_number
    #parser.act_number
    #parser.fl_number
    return (pow(parser.ag_number, instanceDepth)*pow(2, parser.fl_number))

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
                if(row[0] == parser.domain_name):
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

def checkDCK():
    return (parser.dynamicCK.lower() == "true")

def solveWithS2NoPlan(timeLimit):
    solveWithS2(timeLimit, selectPlannerS2())

def solveWithS2(timeLimit, planner):

    planner = plannerS2_2
    print("Problem </pro>" + parser.problem_name + "</> solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
    sys.exit(0)


    if planner == plannerS2_1:
        domainNamePDKB, problemNamePDKB = parser.print_PDKB(output_folderPDKB)
        result = subprocess.run(['sh','./'+ scripts_folder + 'PDKB_solve.sh', problemNamePDKB,  " " + output_folderPDKB, " " + str(int(timeLimit))+"s"])
        solutionS2 = readSolutionFromFile("tmp/PDKB/" + problemNamePDKB)
        time = readTimeFromFile("tmp/PDKB/" + problemNamePDKB)
    elif planner == plannerS2_2:
        result = subprocess.run(['sh','./'+ scripts_folder + 'EFP_solve.sh', instanceNameEFP, " " + output_folderEFP, " " + str(int(timeLimit))+"s"])
        solutionS2 = readSolutionFromFile("tmp/EFP/" + instanceNameEFP)
        time = readTimeFromFile("tmp/EFP/" + instanceNameEFP)
    else:
        raise Exception('Planner '+ str(planner) +' is not a known S2-planner')

    if(time == "TO" or solutionS2 == "noSolution"):
        #return False, timeLimit, None
        print("Problem </pro>" + parser.problem_name + "</> could not be solved by System </sys>" + str(systemTWO) + "</> using planner </pla>" + str(planner) +"</>.")
        return False
    else:
        memorizeSolution(systemTWO, planner, 1.0, float(time), 1.0, solutionS2)
        #return True, float(time), solutionS2

def memorizeSolution(system, planner, confidence, elapsedTime, correctness, solution):


    json_path = dbFolder+jsonFilename

    if not os.path.exists(json_path):
        open(json_path, 'w').close()

    memory_file = open(json_path)

    data = json.load(memory_file)

    if ('cases' not in data.keys()) or (len(data['cases']) == 0):
        index = 0
    else:
        index = max( [int(k) for k in data['cases'].keys()] )

    index += 1

    #jsonformat established here

    data['cases'][str(index)] = {}
    data['cases'][str(index)]['domain_name'] = parser.domain_name
    data['cases'][str(index)]['problem_name'] = parser.problem_name
    data['cases'][str(index)]['difficulty'] = difficulty
    data['cases'][str(index)]['system'] = system
    data['cases'][str(index)]['planner'] = planner
    data['cases'][str(index)]['confidence'] = confidence
    data['cases'][str(index)]['correctness'] = correctness
    data['cases'][str(index)]['solving_time'] = elapsedTime
    data['cases'][str(index)]['total_time'] = time.time()-timeSTART

    init,goal = getStates.States(problemFile) #reading initial and goal states from problem file

    data['cases'][str(index)]['init'] = init
    data['cases'][str(index)]['goal'] = goal
    data['cases'][str(index)]['plan'] = solution

    json_object = json.dumps(data,indent=4)

    # writing dictionary data into json file
    with open(json_path,"w") as out:
        out.write(json_object)


    print("The solution of </pro>" + parser.problem_name + "</> is </sol>" + str(solution) + "</> with correctness </cor>" + str(correctness) + "</> and has been found in </tim>" + str(elapsedTime) + "s</> by System </sys>" + str(system) + "</>", end = '')
    if (system != systemONE):
        print(" using planner </pla>" + str(planner) +"</>.")
    else:
        print(" using mode </mod>" + str(plannerS1) +"</>.")
    sys.exit(0)

def generateNamePDKB():
    domainNamePDKB = EPPDL.getDomainPDKB(domainFile)
    problemNamePDKB = EPPDL.getProblemPDKB(problemFile)

#----NEW

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
            if(data['cases'][str(index)]['domain_name'] == parser.domain_name):
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
        if(data['cases'][str(index)]['domain_name'] == parser.domain_name):
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

def tryS1(plannerS1, solutionS1, confidenceS1, timeS1):
    correctnessS1 = validateSolution(solutionS1)
    if (correctnessS1 >= correctnessCntx):
        memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1)
    else:
        solveWithS2NoPlan(timeLimitCntx)

def selectPlannerS2():
    planner = plannerS2_1 #By default we use plannerS2_1 -- we use label to indicate the planners
    instanceDepth = int(getVarFromFile(problemFile,"depth"))

    if (instanceDepth > maxGroundDepth or checkDCK()): #Check if depth > 3 or if DCK is not required
        planner = plannerS2_2

    return planner
#-----------------------------------------------
# Main
#-----------------------------------------------
if __name__ == '__main__':

    forceP1 = False
    forceP2 = False
    forceDepth = False
    forcedDepth = 0

    for arg in sys.argv:
        if forceDepth and forcedDepth == 0:
            forcedDepth = int(arg)

        if (arg == "-d"):
            forceDepth = True

        if (arg == "P1"):
            forceP1 = True
        elif (arg == "P2"):
            forceP2 = True

    if (len(sys.argv) > 4 and not forceP1 and not forceP2):
        readThreshold(sys.argv[4])



    timeSTART = time.time()
    createFolders()

    domainFile = sys.argv[1]
    problemFile = sys.argv[2]
    context = sys.argv[3]
    #Always used to verify the solution anyway
    generateEFPInstance()

    #correctnessCntx = float(getVarFromFile(context,"correctness"))
    reduced_risk_adversion = 0.4
    correctnessCntx = threshold3 - reduced_risk_adversion
    timeLimitCntx = float(getVarFromFile(context,"timelimit"))
    instanceDepth = int(getVarFromFile(problemFile,"depth"))
    if forcedDepth > 0:
        instanceDepth = forcedDepth

    #print("Instance Depth is " + str(instanceDepth))

    if (forceP1):
        solveWithS2(timeLimitCntx - (time.time() - timeSTART),plannerS2_1)
        sys.exit()
    elif (forceP2):
        solveWithS2(timeLimitCntx - (time.time() - timeSTART),plannerS2_2)
        sys.exit()



    difficulty = estimateDifficulty(instanceDepth)



    ######### S1 metacognitive part
    # AUTOMATICALLY CALL S1
    plannerS1 = plannerS1_Plansformer
    timeS1 = time.time()
    solutionS1, confidenceS1 = solveWithS1()
    timeS1 = time.time() - timeS1
    M = 1



    # IF NUMBER OF CASES IN JSON FILE (that match the domain) IS > THRESHOLD1 THEN CONTINUE WITH TO S1
    if (countSolvedInstances(systemALL,plannerALL) > threshold1):
        if (countSolvedInstances(systemONE,plannerALL) > threshold4):
            M = 1-getAvgCorrS1(systemONE,plannerALL,threshold4)
        else:
            M = 0

        M = 0

        if (confidenceS1 * (1-M) > threshold3):
            tryS1(plannerS1, solutionS1, confidenceS1, timeS1)


    # ######### S2 metacognitive part
    # # Employ the S2 metacognitive structure



    plannerS2 = selectPlannerS2()
    estimatedTimeS2 = estimateTimeCons(plannerS2, difficulty)
    estimatedCostS2 = sys.maxsize

    remainingTime = timeLimitCntx - (time.time() - timeSTART)
    if(remainingTime - estimatedTimeS2 > 0):
        estimatedCostS2 = estimatedTimeS2 / remainingTime

    if (estimatedCostS2 > 1):
        tryS1(plannerS1, solutionS1, confidenceS1, timeS1)
    else:
        probabilityS1 = (1-threshold3)*epsilonS1
        #random() genrates a number between 0 and 1
        if (probabilityS1 > random.random()):
            tryS1(plannerS1, solutionS1, confidenceS1, timeS1)
        else:
            correctnessS1 = validateSolution(solutionS1)
            if (correctnessS1 >= correctnessCntx):
                if((1-(estimatedCostS2 * (1-threshold3))) > (correctnessS1*(1-M))):
                    if (not solveWithS2(remainingTime,plannerS2)):
                        memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1)
                else:
                    memorizeSolution(systemONE, plannerS1, confidenceS1, timeS1, correctnessS1, solutionS1)
            else:
                solveWithS2(remainingTime,plannerS2)

    print("Problem </pro>" + parser.problem_name + "</> could not be solved by System </sys>Metacognitive</>.")
