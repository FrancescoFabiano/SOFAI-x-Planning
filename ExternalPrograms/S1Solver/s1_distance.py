## Install libraries as needed
# There are many libraries for similarity (Levenstein) like editdistance and enchant
## For editdistance, pip install editdistance
## For enchant, pip install pyenchant

import json
import editdistance
import ast
from operator import itemgetter

problem_metadata = ['init','goal']

def initializeCaseLib(mode, cases):
    '''
    This function helps to initialize the Problem = (Init, Goal) from the case library
    There are two modes possible for problem instantiation, namely,
    Mode 0 - considers Problem as a string seperated by | and adopts Levenshtein distance as metric
    for finding similarity between user mentioned problem and problems existing in the case library.
    Mode 1 - considers Problem as a set and adopts Jaccard Similarity as a metric for finding similarity
    between user mentioned problem and problems existing in the case library.
    '''
    # mode 0 if for string based levenshtein distance calculation method
    if mode == 0:
        problem = []
        for i in range(1,len(cases)+1):
            item = cases[str(i)]
            string = ""
            for x in problem_metadata:
                temp_List = item[x]

                if type(temp_List) == list:
                    for j in temp_List:
                        string = string + j + '|'
                else:
                    string = string + temp_List + '|'
            problem.append(string)
    # mode 1 if for set based jaccard similarity calculation method
    elif mode == 1:
        problem = []
        for i in range(1,len(cases)+1):
            item = cases[str(i)]
            string = []
            for x in problem_metadata:
                temp_List = item[x]
                if type(temp_List) == list:
                    for j in temp_List:
                        string.append(j)
                else:
                    string.append(temp_List)
            problem.append(string)
    return problem

def createInput(mode, usr_problem_init, usr_problem_goal):
    usr_metadata = usr_problem_init + usr_problem_goal

    if mode == 0:
        problem = ""
        for x in usr_metadata:
            if type(x) == list:
                for j in x:
                    problem = problem + j + '|'
            else:
                problem = problem + x + '|'

    # mode 1 if for set based jaccard similarity calculation method
    elif mode == 1:
        problem = []
        for x in usr_metadata:
            if type(x) == list:
                for j in x:
                    problem.append(j)
            else:
                problem.append(x)
    return problem

#normalized levenshtein similarity (not distance)
def levenshtein(str1,str2):
    return 1-(editdistance.eval(str1, str2)/max(len(str1), len(str2)))

def jaccard(list1, list2):
    intersection = len(list(set(list1).intersection(list2)))
    union = (len(list1) + len(list2)) - intersection
    return float(intersection) / union

def createUserQueryCaseRepn(inp_dict):
    '''
    Function definition for creating the desired representation from the user input.
    '''
    res = ast.literal_eval(inp_dict)
    domain = res["domain"]
    init = res["init"]
    goal = res["goal"]
    return domain, "|".join(init) + "|" + "|".join(goal)

def doCaseMatch(cases, mode, domain, usr_problem_init, usr_problem_goal, similarity_threshold = 0.7):
    '''
    Matching user metioned problem with the problem representation based on the mode and planning
    domain mentioned by the user.
    '''
    problem = initializeCaseLib(mode, cases)
    usr_problem = createInput(mode, usr_problem_init, usr_problem_goal)

    if mode == 0:
        ranked_cases = list()
        for key in cases.keys():
            if(cases[key]['domain_name'] == domain):
                sim_score = levenshtein(usr_problem, problem[int(key)-1])
                if sim_score >= similarity_threshold:
                    ranked_cases.append((sim_score, cases[key]['plan'], cases[key]['init'], cases[key]['goal']))
        return sorted(ranked_cases, key=itemgetter(0), reverse=True)
    elif mode == 1:
        ranked_cases = list()
        for key in cases.keys():
            if(cases[key]['domain_name'] == domain):
                sim_score = jaccard(usr_problem, problem[int(key)-1])
                if sim_score >= similarity_threshold:
                    ranked_cases.append((sim_score, cases[key]['plan'], cases[key]['init'], cases[key]['goal']))
        return sorted(ranked_cases,key=itemgetter(0), reverse=True)
