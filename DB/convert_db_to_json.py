
import json

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

f = open('cases.json')
data = json.load(f)

problem_path = '../Input/coininthebox/'

if 'cases' not in data.keys():
    data['cases'] = {}
    index = 0
else:
    index = max( [int(k) for k in data['cases'].keys()] )

with open("memory.db") as file:
    for line in file:
        ele_list = line.split(",")

        index+=1

        data['cases'][str(index)] = {}
        data['cases'][str(index)]['domain_name'] = ele_list[0]
        data['cases'][str(index)]['problem_name'] = ele_list[-2]
        data['cases'][str(index)]['planner'] = ele_list[1]
        data['cases'][str(index)]['complexity'] = ele_list[2]
        data['cases'][str(index)]['time_taken'] = ele_list[3]

        with open(problem_path+ele_list[-2]+".epddl") as currentfile:
            text = currentfile.read()
            init = initial_states(text)
            goal = goal_states(text)

        data['cases'][str(index)]['init'] = init
        data['cases'][str(index)]['goal'] = goal
        data['cases'][str(index)]['plan'] = ele_list[-1][:-1].split(';')

json_object = json.dumps(data,indent=4)

# writing dictionary data into json file
with open("cases.json","w") as out:
    out.write(json_object)

        


