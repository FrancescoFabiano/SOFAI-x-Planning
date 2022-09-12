import re

def getData(text):
        res = re.sub(r'\)\s+\(', ')(', text, flags=re.MULTILINE)
        res = res.strip()
        res = re.split('\)\(', res)
        res[0] = res[0][1:]
        res[len(res)-1] = res[len(res)-1][:-2]

        return res

def initial_states(text):
        temp = text[text.index('(:init') +7 : -1]
        temp = temp.split('(:')     # to get states between specific characters into list of strings
        return getData(temp[0])                                            # to strip spaces from list

def goal_states(text):
        temp = text[text.index('(:goal') +6 : -1].replace('(and','')                 # to get states between specific characters into list of strings
        temp = temp.split('(:')     # to get states between specific characters into list of strings
        return getData(temp[0])                                    # to strip spaces from list

def States(problem_path):

        with open(problem_path) as currentfile:
            text = currentfile.read()
            text = re.sub(r';.*$', '', text, flags=re.MULTILINE).lower()
            init = initial_states(text)
            goal = goal_states(text)

        return init,goal
