#importing required packages
import sys
sys.path.append('../code_core/')

import cases_ir


switch = input("Enter 1 to LoadCases / Enter 2 to UpdateCases: ")

if switch == 1:

    # Sample input 
    # {"domain": 'blockworld', "init": ['(on-table a)','(clear b)'] ,"goal": ['(on a b)','(on b c)']}

    user_Input = input("Enter Input")

    cases_ir.LoadCases(user_Input)
else:

    # Sample input 
    # problem_path = ../../supported_planning_problems/blockworld/problem/pb-1.pddl
    # domain_path = ../../supported_planning_problems/blockworld/domain/blocksworld.pddl
    # domain = blockworld

    problem_path = input("Enter the problem file path: ")
    domain_path = input("Enter the domain file path: ")
    domain = input("Enter the Domain name: ")

    cases_ir.UpdateCases(problem_path,domain_path,domain)