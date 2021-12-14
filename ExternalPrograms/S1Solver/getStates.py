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

def States(problem_path):

        with open(problem_path) as currentfile:
            text = currentfile.read()
            init = initial_states(text)
            goal = goal_states(text)

        return init,goal