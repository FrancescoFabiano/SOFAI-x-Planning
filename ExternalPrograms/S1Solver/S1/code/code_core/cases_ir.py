#importing necessary libraries
import requests
import os
import shutil
import json
import subprocess
import ast
from os import listdir
import sys
sys.path.append('../code_core')

from ranking_algorithm import *


def LoadCases(User_Input):

    input_dict = User_Input
    res = ast.literal_eval(input_dict)

    Domain = res["domain"]
    init = res["init"]
    goal = res["goal"]

    f = open( '../../cases/cases.json' )
    data = json.load(f)
    index = max( [int(k) for k in data['cases'].keys()] )

    res_plans = []
    ranks = []

    if Domain == str(0):

        for i in range(1, index+1):

            temp_init = data["cases"][str(i)]["initial"]
            temp_goal = data["cases"][str(i)]["goal"]

            check_init = any(item in init for item in temp_init)
            check_goal = any(item in goal for item in temp_goal)

            if check_init == True or check_goal == True:
                res_plans.append(data["cases"][str(i)]["Index"])
                ranks.append( RankPlan(data["cases"][str(i)]["Index"]) )

    else:

        for i in range(1, index+1):

            if data["cases"][str(i)]["Planning_Domain"] == Domain:

                temp_init = data["cases"][str(i)]["initial"]
                temp_goal = data["cases"][str(i)]["goal"]

                check_init = any(item in init for item in temp_init)
                check_goal = any(item in goal for item in temp_goal)

                if check_init == True or check_goal == True:
                    res_plans.append(data["cases"][str(i)]["Index"])
                    ranks.append( RankPlan(data["cases"][str(i)]["Index"]) )

    print("Following are the matching plan files ranked based on the number of steps to reach the goal:\n")
    for i in sorted(zip(ranks,res_plans)):
        print(i)


def UpdateCases(problem_path,domain_path,domain):

    planfiles_path =  "../../cases/"
    f = open( '../../cases/cases.json' )
    data = json.load(f)

    if 'cases' not in data.keys():
        data['cases'] = {}
        index = 0
    else:
        index = max( [int(k) for k in data['cases'].keys()] )


    def getData(text):
            lis = []
            start = 0
            end = 0
            flag = 0
            flag2 = 1
            for i in range(len( text )):

                    if text[i] == ")" and flag == 0:
                            flag = 1
                            end = i
                            lis.append(text[start:end+1])
                            flag2 = 1
                    
                    if text[i] == " " and flag == 1:
                            flag = 0
                    
                    if text[i] == '(' and flag2 == 1:
                            start = i
                            flag2 = 0

            return lis

    def initial_states(text):
            temp = text[text.index('(:init') +7 : text.index('(:goal')]     # to get states between specific characters into list of strings
            return getData(temp)                                            # to strip spaces from list 
            
    def goal_states(text):
            temp = text[text.index('(:goal') +6 : -1].replace('(and','')                 # to get states between specific characters into list of strings
            return getData(temp)                                    # to strip spaces from list

    def isPresentinCases( FilePath):

            if index == 0:
                    return False

            with open(FilePath) as tempfile:
                    check_text = tempfile.read()
                    temp_goal = goal_states(check_text)
                    temp_init = initial_states(check_text)
            
            for i in range( 1, index + 1 ):
                    if data['cases'][str(i)]['goal'] == temp_goal and data['cases'][str(i)]['initial'] == temp_init:
                            return True
                    
            
            return False

    def RunBashCmd(problem_name):
            arg1 = 'scripts/EPDDL_scripts/single_exec.sh'
            arg2 = 'exp/EPDDL/coininthebox/coininthebox.epddl'
            arg3 = 'exp/EPDDL/coininthebox/' + str(problem_name)
            subprocess.run(['bash',arg1, arg2, arg3], shell=True, cwd = '../../../EFP-EpistemicSolver' ,capture_output=True, text=True).stdout
            return False


    if domain == 'blockworld':

        mem_path = os.path.join( planfiles_path, domain +'-plans')
        
        if os.path.exists(mem_path) == False:
            os.mkdir(mem_path)

        if isPresentinCases(problem_path) == False and index < data["size_limit"]:
                
            index += 1
            
            file_data = {'domain': open( os.path.join(domain_path), 'r').read(),
                    'problem': open( os.path.join(problem_path), 'r').read()}

            resp = requests.post('http://solver.planning.domains/solve',verify=False, json=file_data).json()


            with open(mem_path + '/plan_'+ os.path.basename(problem_path).replace('.pddl','') +'.txt', 'w') as f:
                f.write('\n'.join([act['name'] for act in resp['result']['plan']]))

            with open( os.path.join(problem_path) ) as currentfile:
                text = currentfile.read()
                init = initial_states(text)
                goal = goal_states(text)

                data['cases'][str(index)] = {}
                
                data['cases'][str(index)]["Planning_Domain"] = domain
                data['cases'][str(index)]['initial'] = init
                data['cases'][str(index)]['goal'] = goal
                data['cases'][str(index)]["Index"] = domain+"-plans/" + "plan_" + os.path.basename(problem_path).replace('.pddl','') + '.txt' 
        
        elif isPresentinCases(problem_path) == True:
            print("Plan file already exists in the memory")

        elif index >= data["size_limit"]:
            print("Maximum Size Limit reached. Cannot add more plan files to Cases.json")

        json_object = json.dumps(data,indent=4)

        # writing dictionary data into json file
        with open("../../cases/cases.json","w") as out:
            out.write(json_object)

    elif domain == "coininthebox":

        mem_path = os.path.join( planfiles_path, domain +'-plans')
        
        if os.path.exists(mem_path) == False:
            os.mkdir(mem_path)

        if isPresentinCases(problem_path) == False and index < data["size_limit"]:
                
            index += 1

            src = problem_path
            dst = '../../../EFP-EpistemicSolver/exp/EPDDL/coininthebox/' + os.path.basename(problem_path)
            shutil.copy(src,dst)

            RunBashCmd(os.path.basename(problem_path))

            src = "../../../EFP-EpistemicSolver/out/EFP_comparison/findingplan/coininthebox_" + os.path.basename(problem_path).replace('.epddl','') + '.tmp'
            dst = "../../cases/coininthebox-plans/plan_" + os.path.basename(problem_path).replace('.epddl','') + ".txt"
            shutil.copy(src,dst)

            with open( os.path.join(problem_path) ) as currentfile:
                text = currentfile.read()
                init = initial_states(text)
                goal = goal_states(text)

                data['cases'][str(index)] = {}
                
                data['cases'][str(index)]["Planning_Domain"] = domain
                data['cases'][str(index)]['initial'] = init
                data['cases'][str(index)]['goal'] = goal
                data['cases'][str(index)]["Index"] = domain+"-plans/" + "plan_" + os.path.basename(problem_path).replace('.epddl','') + '.txt' 

        elif isPresentinCases(problem_path) == True:
            print("Plan file already exists in the memory")

        elif index >= data["size_limit"]:
            print("Maximum Size Limit reached. Cannot add more plan files to Cases.json")

        json_object = json.dumps(data,indent=4)

        # writing dictionary data into json file
        with open("../../cases/cases.json","w") as out:
            out.write(json_object)
