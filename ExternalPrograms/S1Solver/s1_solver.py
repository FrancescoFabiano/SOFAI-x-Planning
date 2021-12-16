#importing required packages
import json

#s1 solver searches through the existing plans in the memory and returns cases - plan and goal
def s1Solver(domain, problem,json_path):

    memory_file = open(json_path)

    data = json.load(memory_file)
    if ('cases' not in data.keys()) or (len(data['cases']) == 0):
        index = 0
    else:
        index = max( [int(k) for k in data['cases'].keys()] )


    maxLength = 0
    problem_plan = ""
    if index == 0:
        return 0
    else:
        for i in range(1,index+1):
            if data['cases'][str(i)]['problem_name'] == problem and data['cases'][str(i)]['domain_name'] == domain:
                temp = max(maxLength, len( data['cases'][str(i)]['plan'] ))
                if temp != maxLength:
                    maxLength = temp
                    problem_plan = ';'.join(data['cases'][str(i)]['plan'])

        return problem_plan
