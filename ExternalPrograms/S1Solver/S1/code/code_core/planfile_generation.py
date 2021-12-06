import requests
import os
import shutil
import json
import subprocess
from os import listdir

path = "../../supported_planning_problems/"               #Problem Path for Domain and problems
planfiles_path =  "../../cases/" 

f = open(planfiles_path + 'cases.json')
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

def RunBashCmd(problem_number):
        arg1 = 'scripts/EPDDL_scripts/single_exec.sh'
        arg2 = 'exp/EPDDL/coininthebox/coininthebox.epddl'
        arg3 = 'exp/EPDDL/coininthebox/pb' + str(problem_number) + '.epddl'
        subprocess.run(['bash',arg1, arg2, arg3], shell=True, cwd = '../../../EFP-EpistemicSolver' ,capture_output=True, text=True).stdout
        return False



for x in listdir(path):

    sub_dir = os.path.join(path,x)

    if x == 'blockworld' and os.path.isdir( sub_dir ):      #plan generation for Blockworld

        # creating directory for to save plan files
        mem_path = os.path.join( planfiles_path, x +'-plans')
        
        if os.path.exists(mem_path) == False:
            os.mkdir(mem_path)

        for filename in listdir( os.path.join(sub_dir,'problem') ):
            
            number = filename[ filename.index('-') + 1 : filename.index('.') ]

            if isPresentinCases( os.path.join(sub_dir,'problem',filename)) == False and index < data["size_limit"]:
                
                index += 1
                
                file_data = {'domain': open( os.path.join(sub_dir,'domain', 'blocksworld.pddl'), 'r').read(),
                        'problem': open( os.path.join(sub_dir,'problem', filename), 'r').read()}

                resp = requests.post('http://solver.planning.domains/solve',verify=False, json=file_data).json()


                with open(mem_path + '/plan_'+ number +'.txt', 'w') as f:
                    f.write('\n'.join([act['name'] for act in resp['result']['plan']]))

                with open( os.path.join(sub_dir,'problem',filename) ) as currentfile:
                    text = currentfile.read()
                    init = initial_states(text)
                    goal = goal_states(text)
                    data['cases'][str(index)] = {}

                    data['cases'][str(index)]["Planning_Domain"] = x
                    data['cases'][str(index)]['initial'] = init
                    data['cases'][str(index)]['goal'] = goal
                    data['cases'][str(index)]["Index"] = x+"-plans/" + "plan_" + number + '.txt' 
            
            elif index >= data["size_limit"]:
                print("Maximum Size Limit reached. Cannot add more plan files to Cases.json")
                
    elif os.path.isdir( sub_dir ):      #plan generation for "Coin in the Box"

        # creating directory for to save plan files
        mem_path = os.path.join( planfiles_path, x +'-plans')
        
        if os.path.exists(mem_path) == False:
            os.mkdir(mem_path)

        for filename in listdir( os.path.join(sub_dir,'problem') ) :

            number = filename[ filename.index('b') + 1 : filename.index('.') ]

            if isPresentinCases( os.path.join(sub_dir,'problem',filename)) == False and index < data["size_limit"]:
                                
                index += 1

                RunBashCmd(number)

                src = "../../../EFP-EpistemicSolver/out/EFP_comparison/findingplan/coininthebox_pb" + str(number) + '.tmp'
                dst = "../../cases/coininthebox-plans/plan_" + number + ".txt"

                shutil.copy(src,dst)

                with open( "../../supported_planning_problems/" + x + '/problem/' + filename ) as currentfile:
                    text = currentfile.read()
                    init = initial_states(text)
                    goal = goal_states(text)
                    data['cases'][str(index)] = {}

                    data['cases'][str(index)]["Planning_Domain"] = x
                    data['cases'][str(index)]['initial'] = init
                    data['cases'][str(index)]['goal'] = goal
                    data['cases'][str(index)]["Index"] = "coininthebox-plans/plan_" + number + ".txt"


#creating a json object to write to a json file
json_object = json.dumps(data,indent=4)

# writing dictionary data into json file
with open("../../cases/cases.json","w") as out:
    out.write(json_object)