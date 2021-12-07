#!/usr/bin/env python
# Four spaces as indentation [no tabs]
import subprocess
import re
import csv
from pathlib import Path


from ExternalPrograms.EPDDL.parser import EPDDL_Parser
# Constants
maxGroundDepth = 3
output_folder = "Output/"
output_folderPl1 = output_folder + "Pl1/"
output_folderEFP = output_folder + "EFP/"
output_folderPDKB = output_folder + "PDKB/"
scripts_folder = "Scripts/"
db_folder = "DB/"
db_file = "memory.db"


# Global variables seen by all the functions
domain_file = ""
problem_file = ""
context = ""
instanceNameEFP = ""


# Global Objects
parser = EPDDL_Parser()

def createFolders():
    Path(db_folder).mkdir(parents=True,exist_ok=True)
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

#Every Solver stores the solution on a tmp file
def readSolutionFromFile(filename):
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

    raise Exception('Missing solution in '+ filename)

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

    raise Exception('Missing plan in '+ filename)


def executeS1():

    db_file_name = db_folder + db_file

    solString =""
    with open(db_file_name, "r") as db:
        db_reader = csv.reader(db, delimiter=',')
        for row in db_reader:
            if row[0] == parser.domain_name and row[-2] == parser.problem_name:
                solString = row[-1]
    
    db.close()

    resFile = instanceNameEFP.replace(".tmp", "S1.tmp")
    out = open(output_folderPl1 + resFile, "w")
    out.write("Solution = " + solString)
    out.close()
    return 0.4, resFile;


def solveWithS1():
    confidence, resFile = executeS1()
    solutionS1 = readSolutionFromFile(output_folderPl1 + resFile)
    return solutionS1, confidence

def validateSolution(solution):
    stringSolution = ""
    for elem in solution:
        stringSolution += " "
        stringSolution += elem
    #print("Execution Line is:  sh ./ExternalPrograms/EFP/scripts/validate_solution.sh " + instanceNameEFP + " " + stringSolution)
    result = subprocess.run(['sh','./'+ scripts_folder + 'validate_solution.sh', output_folderEFP + instanceNameEFP, stringSolution], stdout=subprocess.PIPE)
    res = result.stdout.decode('utf-8')
    if ("Goal found" in res):
        #print("Found result is " + stringSolution)
        return 1.0
    else:
        #print("Goal not found")
        return 0.0

def generateEFPInstance():
    global instanceNameEFP
    global parser

    parser.parse_domain(domain_file)
    parser.parse_problem(problem_file)
    instanceNameEFP = parser.print_EFP(output_folderEFP)

def estimateDifficulty(instanceDepth):
    #For now difficulty evaluation that does not consider goal or initial state (Maybe include planning grpah lenght?)
    #parser.ag_number
    #parser.act_number
    #parser.fl_number
    return (pow(parser.ag_number, instanceDepth)*pow(2, parser.fl_number))

def estimateTimeCons(planner,difficulty):
    db_file_name = db_folder + db_file
    range = 100
    totalTimeConsumption = 0
    match_count = 0
    #Controlla IL CSV e leggi valori
    try:
        with open(db_file_name) as db:
            db_reader = csv.reader(db, delimiter=',')
            for row in db_reader:
                if(row[0] == parser.domain_name):
                    if(int(row[1]) == planner):
                        rowDiff = float(row[2])
                        if ((rowDiff < (difficulty + range)) and (rowDiff > (difficulty - range))):
                            match_count += 1
                            totalTimeConsumption += float(row[3])
    except IOError:
        match_count = 0

    db.close()

    if match_count > 0:
        return (totalTimeConsumption/match_count)


    else:
        noMatchConsumption = 5
        return noMatchConsumption

def checkDCK():
    return (parser.dynamicCK.lower() == "true")

def solveWithS2(timeLimitCntx,planner):
    if planner == 1:
        domainNamePDKB, problemNamePDKB = parser.print_PDKB(output_folderPDKB)
        result = subprocess.run(['sh','./'+ scripts_folder + 'PDKB_solve.sh', problemNamePDKB,  " " + output_folderPDKB, " " + str(int(timeLimitCntx))+"s"])
        solutionS2 = readSolutionFromFile("tmp/PDKB/" + problemNamePDKB)
        time = readTimeFromFile("tmp/PDKB/" + problemNamePDKB)
    elif planner == 2:
        result = subprocess.run(['sh','./'+ scripts_folder + 'EFP_solve.sh', instanceNameEFP, " " + output_folderEFP, " " + str(int(timeLimitCntx))+"s"])
        solutionS2 = readSolutionFromFile("tmp/EFP/" + instanceNameEFP)
        time = readTimeFromFile("tmp/EFP/" + instanceNameEFP)
    else:
        raise Exception('Planner '+ str(planner) +' is not a known S2-solver')

    if(time == "TO"):
        return False, timeLimitCntx, None
    else:
        return True, float(time), solutionS2



def memorizeSolution(planner, difficulty, elapsedTime, solutionS2):
    db_file_name = db_folder + db_file
    writeMemory = open(db_file_name, "a+")
    writeMemory.write(parser.domain_name + ",")
    writeMemory.write(str(planner) + ",")
    writeMemory.write(str(difficulty) + ",")
    writeMemory.write(str(elapsedTime)+ ",")
    writeMemory.write(parser.problem_name)

    first = True
    for act in solutionS2:
        if first:
            writeMemory.write("," + act)
            first = False
        else:
            writeMemory.write(";" + str(act))

    writeMemory.write("\n")
    writeMemory.close()





def generateNamePDKB():
    domainNamePDKB = EPPDL.getDomainPDKB(domain_file)
    problemNamePDKB = EPPDL.getProblemPDKB(problem_file)


#-----------------------------------------------
# Main
#-----------------------------------------------
if __name__ == '__main__':
    import sys, pprint

    createFolders()

    domain_file = sys.argv[1]
    problem_file = sys.argv[2]
    context = sys.argv[3]
    #Always used to verify the solution
    generateEFPInstance()

    correctnessCntx = float(getVarFromFile(context,"correctness"))
    timeLimitCntx = float(getVarFromFile(context,"timelimit"))

    ######### S1 metacognitive part
    # Try to solve the problem with the metacognitive part
    # if the returned value is within range of the given one, validate solution.
    # if not go to s2 solving

    #@TODO: Confidence magari è ridondante w.r.t. correctness

    solutionS1, confidenceS1 = solveWithS1();
    if (confidenceS1 >= correctnessCntx): #@TODO: Errore cambia variabile
        print("The solution is: " + str(solutionS1) + " found by System 1.")
        sys.exit(0)

    ######### S2 metacognitive part
    # Employ the S2 metacognitive structure
    correctnessS1 = validateSolution(solutionS1)
    if(correctnessS1 >= correctnessCntx):
        print("The solution is: " + str(solutionS1) + " found by System 1.")
        sys.exit(0)

    planner = 1 #By default we use Planner1 -- we use label to indicate the planners
    instanceDepth = int(getVarFromFile(problem_file,"depth"))

    if (instanceDepth > maxGroundDepth or checkDCK()): #Check if depth > 3 or if DCK is not required
        planner = 2

    difficulty = estimateDifficulty(instanceDepth)
    EstimatedTimeCons2 = estimateTimeCons(planner, difficulty)
    #print("Estimated Resource consumption is: " + str(EstimatedTimeCons2))

    # #Is the found solution within the given times limits? We assume time is an Hard constraint
    estimatedError = 0
    allowedFluttation = 10
    if (timeLimitCntx + (estimatedError + allowedFluttation) > EstimatedTimeCons2):
    # # Here check if the tradeoff between consumption and accuracy in S2-solver beats the S1-solver
    # if (isS2Worth(confidenceS1,EstimatedTimeCons2)):
        isSolved, elapsedTime, solutionS2 = solveWithS2(timeLimitCntx,planner)
        if (isSolved):
            memorizeSolution(planner, difficulty, elapsedTime, solutionS2)
            print("The solution is: " + str(solutionS2) + " and has been found in " + str(elapsedTime) + "s") #Aggiungi da che planner ha trovato la sol
        else:
            print("It was not possibile find any solution in the given time (" + str(elapsedTime) + "s)") #Metti anche la soluzione di Sys1
    else:
        print("The only found solution (System 1) is: " + str(solutionS1))
