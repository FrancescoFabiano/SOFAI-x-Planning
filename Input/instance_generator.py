import os
import json
import subprocess
import re
import csv
from pathlib import Path
import sys
import pprint
import time
import random

def generate_random_initial_state(tot_agents):

    sample_arr = [True,False]
    bool_arr = np.random.choice(sample_arr, size=tot_agents)
    initial_state = ""

    ####FACTS
    #initial position of each agent
    tmp_agents = 0
    while print_agents < tot_agents:
        if ()
        initial_state =
        print(" " + str(list_agents[print_agents]),end = '', file=gen_f)
        print_agents += 1
    #which agent has the key

    #The coin state

    #The box state

    #The looking agents (at least one)

    ####COMMON KNOWLEDGE ABOUT THE FACTS
    ##Positive Knowledge

    ##Negative Knowledge

if __name__ == '__main__':

    tot_inst = 10000
    l_inst = str(len(str(tot_inst)))
    tot_iter = 10
    l_iter = str(len(str(tot_iter)))

    list_agents = list(string.ascii_lowercase)

    n_inst = 0
    dir_path = "coininthebox-gen/instances/"
#    for path in os.listdir(dir_path):
#        # check if current path is a file
#        if os.path.isfile(os.path.join(dir_path, path)):
#            n_inst += 1


    depth = 2
    dynck = "false"

    while n_inst*tot_iter < tot_inst:

        n_inst += 1
        n_iter = 0

        tot_agents = random.randint(2, 10)
        initial_state = generate_random_initial_state(tot_agents)

        while n_iter < tot_iter:
            n_iter +=1
            string_n_inst = "{:0"+l_inst+"d}".format(n_inst)
            string_n_iter = "{:0"+l_iter+"d}".format(n_iter)
            gen_filename = dir_path + "pb" + string_n_inst + "_" + string_n_iter + ".epddl"
            with open(gen_filename, 'w') as gen_f:
                print("(define (problem pb" + string_n_inst + "_" + string_n_iter + ")", file=gen_f)

                print("  (:domain coininthebox)", file=gen_f)

                print("  (:agents",end = '', file=gen_f)
                print_agents = 0
                while print_agents < tot_agents:
                    print(" " + str(list_agents[print_agents]),end = '', file=gen_f)
                    print_agents += 1
                print(")", file=gen_f)

                print("  (:depth " + str(depth) + ")", file=gen_f)

                print("  (:dynck " + str(dynck) + ")", file=gen_f)

                print("  (:init " + str(initial_state) + ")", file=gen_f)

                print("  (:goal ", str(generate_random_goal_state(tot_agents)) + ")", file=gen_f)
