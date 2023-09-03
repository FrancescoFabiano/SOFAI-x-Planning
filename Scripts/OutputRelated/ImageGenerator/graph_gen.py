#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 graph_gen.py Time 3 Input/FD.out Inputpyth/SOFAI-PF-FD.out Input/SOFAI-PF-LPGxFD.out".
#

import os
import re
from pathlib import Path
import sys
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import functools


def getVarFromLine(line,varname):

#    print("Cond is </"+varname+">")
    if "</"+varname+">" in line:
        line = re.sub(r'.*</'+varname+'>([^<]+)</>.*',r'\1', line)
        return line.strip()
    return ''

def calculate_optimality(planLen,optLen):
    
    #print(f"Plan len is {planLen} while optimal len is {optLen}",end="")

    planLen = int(planLen)
    optLen = int(optLen)

    if optLen == -1 or planLen == -1:
        #print(f" Optimality is {-1}")
        return -1

    diff = float(planLen-optLen)
    optimality = (diff / optLen)*100.0

    #print(f" Optimality is {optimality}")
    return optimality

def sol_reader(filename,rootFilename,suffix):
    modfilename = rootFilename+'.csv'  # /home/user/somefile.jpg
  
    found_names = {}

    with open(modfilename, 'w') as f:
        print(f"Name,Time-{suffix},Corr-{suffix},Opt-{suffix},Sys-{suffix},Planner-{suffix}",file=f)
        with open(filename) as myfile:
            for line in myfile:
                problem = getVarFromLine(line,"pro")
                
                if (problem != ''):

                    #problem = getVarFromLine(line,"dmn") +"_"+ problem

                    if re.match(r"problem\_\d+\_\d+\_\d+\_\d+", problem):
                        problem = "gripper" + problem     
                    elif re.match(r"problem\_\d+\_\d\d\d", problem):
                        problem = "hanoi" + problem            
                    elif re.match(r"problem\_\d+\_\d+", problem):
                        problem = "zBW" + problem 

                    if problem in found_names.keys():
                        found_names[problem] = found_names[problem]+1
                    else:
                        found_names[problem] = 0

                    problem = problem + f"__{found_names[problem]}"

                    time = float(getVarFromLine(line,"sot")[:-1])
                    if "could not be solved" in line:
                        cor = "0"
                        sys = "-1"
                        pla = "-1"
                        opt = "-1"
                    else:
                        cor = getVarFromLine(line,"cor")
                        sys = getVarFromLine(line,"sys")
                        pla = getVarFromLine(line,"pla")
                        planLen = getVarFromLine(line,"sollenght")
                        optLen = getVarFromLine(line,"optlen")
                        opt = calculate_optimality(planLen,optLen)
                    time = time * 1000.00
                    print(f"{problem}, {str(time)}, {str(cor)}, {str(opt)}, {str(sys)}, {str(pla)}",file=f)
                        #sys.exit()
            myfile.close()


    mydata = ['Name',f'Time-{suffix}',f'Corr-{suffix}',f'Opt-{suffix}',f'Sys-{suffix}',f'Planner-{suffix}']
    columns = mydata
    sort_order = mydata
    # Read a CSV file
    df = pd.read_csv(modfilename, usecols=columns)
    # sorting according to multiple columns
    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df.to_csv(modfilename, index=False)

if __name__ == '__main__':

    plotting_val = (sys.argv[1])
    print(f"Plotting value is \"{plotting_val}\"")

    narg = int(sys.argv[2])
    print("Arg is " +  str(narg))

    filenames = []
    rootFilenames = []
    modfilenames = []
    dataFrames=[]
    suffixes=[]
    padding_arg = 3
    count = padding_arg
    while count < narg+padding_arg:
        temp = sys.argv[count]
        print("Temp is " +  str(temp))
        filenames.append(temp)
        rootFilenames.append(os.path.splitext(temp)[0])
        suffixes.append(os.path.basename(rootFilenames[count-padding_arg]))

        sol_reader(filenames[count-padding_arg],rootFilenames[count-padding_arg],suffixes[count-padding_arg])

        modfilenames.append(rootFilenames[count-padding_arg]+'.csv')
        dataFrames.append(pd.read_csv(modfilenames[count-padding_arg]).reset_index(drop=True))
        path, rootFilenames[count-padding_arg] = os.path.split(rootFilenames[count-padding_arg])
        count += 1

    merged_df = functools.reduce(lambda left, right: pd.merge(left,right,on='Name'), dataFrames)


    merged_name = "Input/Merged/merged.csv"
    merged_df.to_csv(merged_name, encoding='utf-8', index=False)



    plt.rcParams["figure.figsize"] = [14.00, 8.00]
    plt.rcParams["figure.autolayout"] = True
    # Make a list of columns

   # mydata = ["Fast Downward",'SOFAIxPlansformers','SOFAIxPlanning', 'Jaccard']

    mydata=[]
    for elem in suffixes:
        mydata.append(plotting_val+'-'+elem)

    columns = mydata

    styles = ['o', 'x', 'h' , '^', 'D']

    df = pd.read_csv(merged_name, usecols=columns)

    if plotting_val == "Time":
        df[columns] = df[columns] / 1000

    # Plot the lines
    df.plot(y=columns, style=styles, figsize=(12,4),color=['black','limegreen','tab:blue','tab:orange','tab:red'])
    #plt.title(plotting_val + " comparsion between Fast and Slow Arch. and FD", weight='bold')
    # label the x and y axes
    plt.xlabel('Instances', weight='bold', size='large')
    if plotting_val == "Time":
        plt.ylabel(plotting_val + (" (s)"), weight='bold', size='large')
    else:
        plt.ylabel(plotting_val, weight='bold', size='large')
    #plt.legend(['Jac','Plf','SOFAIxPlanning','FD'])

    #n_inst = 100
    #plt.axvspan(0, 99, color='red', alpha=0.2)
    #plt.axvspan(100, 199, color='green', alpha=0.2)
    #plt.axvspan(200, 299, color='yellow', alpha=0.2)
    #plt.axvspan(300, 399, color='blue', alpha=0.2)
    #plt.axvspan(400, 499, color='orange', alpha=0.2)

    plt.legend(prop={'size': 18})
    plt.legend(labels=suffixes)
    #plt.xlim(1, 240)
    #plt.ylim(1, 900000)

    #plt.yscale('log')
    plt.savefig(plotting_val+"-Plot.png")



    nInstances = len(df)+1
    countCases = 0
    col_numbers = 5
    merged_name_formula = "Input/Merged/merged_formulae.csv"
    merged_df.to_csv(merged_name_formula, encoding='utf-8', index=False)

    formula_row = "\"=SUBTOTAL(3,"+chr(ord('A') + 0)+"2:"+chr(ord('A') + 0)+str(nInstances) +")\","
    while countCases < narg:
        increaser = countCases*col_numbers
        formula_row += "\"=SUBTOTAL(1,"+chr(ord('B') + increaser)+"2:"+chr(ord('B') + increaser)+str(nInstances) +")\","
        formula_row += "\"=SUBTOTAL(1,"+chr(ord('C') + increaser)+"2:"+chr(ord('C') + increaser)+str(nInstances) +")\","
        formula_row += "\"=SUBTOTAL(1,"+chr(ord('D') + increaser)+"2:"+chr(ord('D') + increaser)+str(nInstances) +")\","
        formula_row += "\"=COUNTIF("+chr(ord('E') + increaser)+"2:"+chr(ord('E') + increaser)+str(nInstances) +",1)\""
        formula_row += "," #For Empty column -- Type of system 2 does not have an aggregate
        if countCases < narg:
            formula_row += ","
        else:
            formula_row += "\n"
        countCases+=1

    f = open(merged_name_formula, "a")
    f.write(formula_row)
    f.close()