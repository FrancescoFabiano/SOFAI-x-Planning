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

def getVarFromLine(line,varname):
#    print("Cond is </"+varname+">")
    if "</"+varname+">" in line:
        line = re.sub(r'.*</'+varname+'>([^<]+)</>.*',r'\1', line)
        return line.strip()
    return ''


if __name__ == '__main__':

    filename = sys.argv[1]

    modfilename = os.path.splitext(filename)[0]+'.csv'  # /home/user/somefile.jpg
    newfilename = os.path.splitext(filename)[0]+'.txt'  # /home/user/somefile.jpg

    #print("ModName is " + modfilename + " and number is " +  str(instance_number))
    printed=set()
    okLine = True
    with open(newfilename, 'w') as f:
        with open(filename) as myfile:
            for line in myfile:
                okLine = True
                found = 0
                problem = getVarFromLine(line,"pro")
                if (problem != ''):
                    if "could not be solved" in line:
                        with open(filename) as myfileCheck:
                            for lineCheck in myfileCheck:
                                problemCheck = getVarFromLine(lineCheck,"pro")
                                if problem == problemCheck:
                                    if "could not be solved" not in lineCheck:
                                        okLine = False
                                    else:
                                        found +=1
                if (okLine and problem not in printed):
                    printed.add(problem)
                    print(line,file=f)
                            #sys.exit()
            myfile.close()

    with open(modfilename, 'w') as f:
        print("Problem,Time,Correctness,System",file=f)
        with open(newfilename) as myfile:
            for line in myfile:
                problem = getVarFromLine(line,"pro")
                if (problem != ''):
                    if "could not be solved" in line:
                        print(problem + ", -1,-1,-1",file=f)
                    else:
                        print(problem + ", "+ getVarFromLine(line,"tim")[:-1]+ "," + getVarFromLine(line,"cor")+ "," +getVarFromLine(line,"sys"),file=f)
                        #sys.exit()
            myfile.close()





    #raise Exception('Missing file named '+ filename)
    #print(str(agents))
    #
