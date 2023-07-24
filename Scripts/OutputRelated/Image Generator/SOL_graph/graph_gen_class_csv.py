#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 graph_gen_class.py 4 Classical/sol_jac.sol Classical/sol_pf.sol Classical/FinalPLans.sol Classical/sol_fd.sol".
#

import os
import re
from pathlib import Path
import sys
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

n_inst = 0

def getVarFromLine(line,varname):
#    print("Cond is </"+varname+">")
    if "</"+varname+">" in line:
        line = re.sub(r'.*</'+varname+'>([^<]+)</>.*',r'\1', line)
        return line.strip()
    return ''


def sol_reader(filename,rootFilename):
    modfilename = rootFilename+'.csv'  # /home/user/somefile.jpg
    newfilename = rootFilename+'.txt'  # /home/user/somefile.jpg

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
        print("Name,Time,Corr,Sys",file=f)
        with open(newfilename) as myfile:
            for line in myfile:
                problem = getVarFromLine(line,"pro")
                if (problem != ''):
                    if "could not be solved" in line:
                        time = 60
                        cor = "0"
                        sys = "-1"
                    else:
                        time = float(getVarFromLine(line,"tim")[:-1])
                        cor = getVarFromLine(line,"cor")
                        sys = getVarFromLine(line,"sys")
                    time = time * 1000.00
                    print(problem + ", "+ str(time)+ "," + str(cor)+ "," +str(sys),file=f)
                        #sys.exit()
            myfile.close()


    mydata = ['Name','Time','Corr','Sys']
    columns = mydata
    sort_order = mydata
    # Read a CSV file
    df = pd.read_csv(modfilename, usecols=columns)
    # sorting according to multiple columns
    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df.to_csv(modfilename, index=False)

    with open(modfilename, 'r+') as fp:
    # read an store all lines into list
        lines = fp.readlines()
        # move file pointer to the beginning of a file
        fp.seek(0)
        # truncate the file
        fp.truncate()

        # start writing lines except the first line
        # lines[1:] from line 2 to last line
        fp.writelines(lines[1:])
        fp.close()

    with open(modfilename, 'r+') as fp:
    # read an store all lines into list
        lines = fp.readlines()
        # move file pointer to the beginning of a file
        fp.seek(0)
        # truncate the file
        fp.truncate()

        # start writing lines except the first line
        # lines[1:] from line 2 to last line
        #fp.writelines(lines[0:n_inst])
        fp.writelines(lines[1:])
        #fp.writelines(lines[792:(792+n_inst)])
        #fp.writelines(lines[1140:])
        fp.close()

if __name__ == '__main__':


    plotting_val = "Time"

    if plotting_val == "Time":
        merged_name = "Sys1Sol/merged_time.csv"
    else:
        merged_name = "Sys1Sol/merged_corr.csv"

   


    plt.rcParams["figure.figsize"] = [14.00, 8.00]
    plt.rcParams["figure.autolayout"] = True
    # Make a list of columns

   # mydata = ["Fast Downward",'SOFAIxPlansformers','SOFAIxPlanning', 'Jaccard']

    mydata = ['SOFAI','FD']#,plotting_val+'-FD']
    #mydata = [plotting_val+'-JAC',plotting_val+'-FD']

    columns = mydata



    styles = ['o', 'x', 'h' , '^', 'D']

    df = pd.read_csv(merged_name, usecols=columns)

    if plotting_val == "Time":
        df[columns] = df[columns] / 1000

    # Plot the lines
    df.plot(y=columns, style=styles, figsize=(12,4),color=['limegreen','tab:blue'])
    #plt.title(plotting_val + " comparsion between Fast and Slow Arch. and FD", weight='bold')
    # label the x and y axes
    plt.xlabel('Instances', weight='bold', size='large')
    if plotting_val == "Time":
        plt.ylabel(plotting_val + (" (s)"), weight='bold', size='large')
    else:
        plt.ylabel(plotting_val, weight='bold', size='large')
    #plt.legend(['Jac','Plf','SOFAIxPlanning','FD'])

    n_inst = 150
    plt.axvspan(0, n_inst-1, color='red', alpha=0.2)
    plt.axvspan(n_inst, (n_inst*2)-1, color='green', alpha=0.2)
    plt.axvspan((n_inst*2), (n_inst*2)+99, color='yellow', alpha=0.2)
    plt.axvspan((n_inst*2)+100, (n_inst*2)+199, color='blue', alpha=0.2)
    plt.axvspan((n_inst*2)+200, (n_inst*2)+299, color='orange', alpha=0.2)

    plt.legend(prop={'size': 18})

    #plt.xlim(1, 240)
    #plt.ylim(1, 900000)

    #plt.yscale('log')
    plt.savefig(plotting_val+"Clas.png")
