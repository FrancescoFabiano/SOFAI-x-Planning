#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 graph_gen_class.py n_solutions sol1.out sol2.out .. solN.out".
#

import os
import re
from pathlib import Path
import sys
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

n_inst = 150

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
        fp.writelines(lines[0:n_inst])
        fp.writelines(lines[792:(792+n_inst)])
        fp.writelines(lines[1140:])
        fp.close()

if __name__ == '__main__':

    narg = int(sys.argv[1])
    print("Arg is " +  str(narg))

    filenames = []
    rootFilenames = []
    modfilenames = []
    count = 2
    while count < narg+2:
        temp = sys.argv[count]
        print("Temp is " +  str(temp))
        filenames.append(temp)
        rootFilenames.append(os.path.splitext(temp)[0])
        sol_reader(filenames[count-2],rootFilenames[count-2])
        modfilenames.append(rootFilenames[count-2]+'.csv')
        path, rootFilenames[count-2] = os.path.split(rootFilenames[count-2])
        count += 1



    os.makedirs(path+"/tmp", exist_ok=True)
    merged_name = path + "/tmp/merged.csv"
    sorted_name = path + "/tmp/sorted_merged.csv"

    plotting_val = "Time"

    with open(merged_name, 'w') as f:

        with open(modfilenames[0]) as file1, open(modfilenames[1]) as file2, open(modfilenames[2]) as file3,  open(modfilenames[3]) as file4:
            if plotting_val == "Time":
                print("Problem-JAC,Jaccard,Correctness-JAC,Sys-JAC,",end="",file=f)
                print("Problem-PF,SOFAIxPlansformers,Correctness-PF,Sys-PF,",end="",file=f)
                print("Problem-MIX,SOFAIxMix,Correctness-MIX,Sys-MIX,",end="",file=f)
                print("Problem-FD,Fast Downward,Correctness-FD,Sys-FD",end="\n",file=f)
            else:
                print("Problem-JAC,Time-JAC,Jaccard,Sys-JAC,",end="",file=f)
                print("Problem-PF,Time-PF,SOFAIxPlansformers,Sys-PF,",end="",file=f)
                print("Problem-MIX,Time-MIX,SOFAIxMix,Sys-MIX,",end="",file=f)
                print("Problem-FD,Time-FD,Fast Downward,Sys-FD",end="\n",file=f)
            for line1, line2, line3, line4 in zip(file1, file2, file3, file4):
                line1 = line1.strip()
                line2 = line2.strip()
                line3 = line3.strip()
                line4 = line4.strip()
                #if (not("-1" in line1 or "-1" in line2)):
                print(line1+","+line2+","+line3+","+line4,file=f)



    plt.rcParams["figure.figsize"] = [14.00, 8.00]
    plt.rcParams["figure.autolayout"] = True
    # Make a list of columns

    mydata = ["Fast Downward",'SOFAIxPlansformers','SOFAIxMix', 'Jaccard']
    mydata = ['SOFAIxMix',"Fast Downward"]

    #mydata = [plotting_val+'-JAC',plotting_val+'-FD']#,plotting_val+'-FD']
    #mydata = [plotting_val+'-JAC',plotting_val+'-FD']

    columns = mydata



    styles = ['o', 'x', 'h' , '^', 'D']
    sort_order = mydata
    sort_order.insert(0,"Problem-JAC")
    #sort_order = [plotting_val+'-PF', plotting_val+'-JAC', plotting_val+'-FD']
    #sort_order = [plotting_val+'-FD', plotting_val+'-SOFAI']

    # Read a CSV file
    df = pd.read_csv(merged_name, usecols=columns)
    # sorting according to multiple columns

    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df.to_csv(sorted_name)
    columns.remove("Problem-JAC")

    df = pd.read_csv(sorted_name, usecols=columns)

    if plotting_val == "Time":
        df[columns] = df[columns] / 1000

    # Plot the lines
    df.plot(y=columns, style=styles, figsize=(12,4))
    #plt.title(plotting_val + " comparsion between Fast and Slow Arch. and FD", weight='bold')
    # label the x and y axes
    plt.xlabel('Instances', weight='bold', size='large')
    if plotting_val == "Time":
        plt.ylabel(plotting_val + (" (s)"), weight='bold', size='large')
    else:
        plt.ylabel(plotting_val, weight='bold', size='large')
    #plt.legend(['Jac','Plf','SOFAIxMix','FD'])

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


    #Adding special fileds to CSV
    nInstances = (n_inst*2)+400-6
    nInstances+=1
    with open(merged_name, 'a') as f:
        countCases = 0
        while countCases < narg:
            increaser = countCases*4
            print("\"=SUBTOTAL(3,"+chr(ord('A') + increaser)+"2:"+chr(ord('A') + increaser)+str(nInstances) +")\",",end="",file=f)
            print("\"=SUBTOTAL(1,"+chr(ord('B') + increaser)+"2:"+chr(ord('B') + increaser)+str(nInstances) +")\",",end="",file=f)
            print("\"=SUBTOTAL(1,"+chr(ord('C') + increaser)+"2:"+chr(ord('C') + increaser)+str(nInstances) +")\",",end="",file=f)
            print("\"=COUNTIF("+chr(ord('D') + increaser)+"2:"+chr(ord('D') + increaser)+str(nInstances) +",1)\"",end="",file=f)
            if countCases < narg:
                print(",",end="",file=f)
            else:
                print("\n",end="",file=f)

            countCases+=1
