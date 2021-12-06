#importing required packages
from os import listdir #to open all the text files in a particular folder

#s1 solver searches through the existing plans in the memory and returns cases - plan and goal
def s1Solver(goal, path):
    matching_plans = list()
    for filename in listdir(path):
        with open(path + filename) as currentFile:
            text = currentFile.read()
            for x in goal:
                if (x in text):
                    matching_plans.append(filename)
    return matching_plans



