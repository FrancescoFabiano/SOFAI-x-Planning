#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 graph_gen.py n_solutions sol1.out sol2.out .. solN.out".
#

import os
import re
from pathlib import Path
import sys
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


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
        #print("Problem,Time,Correctnessectness,System",file=f)
        with open(newfilename) as myfile:
            for line in myfile:
                problem = getVarFromLine(line,"pro")
                if (problem != ''):
                    if "could not be solved" in line:
                        time = 90
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
        with open(modfilenames[0]) as file1, open(modfilenames[1]) as file2, open(modfilenames[2]) as file3,  open(modfilenames[3]) as file4, open(modfilenames[4]) as file5:

            if plotting_val == "Time":
                print("Problem-JACCARD,SOFAIxJACCARD,Correctness-JACCARD,Sys-JACCARD,",end="",file=f)
                print("Problem-SOFAI_LEV,SOFAI_LEV,Correctness-SOFAI_LEV,Sys-SOFAI_LEV,",end="",file=f)
                print("Problem-SOFAI_MIX,SOFAI_MIX,Correctness-SOFAI_MIX,Sys-SOFAI_MIX,",end="",file=f)
                print("Problem-SOFAI_RNG,SOFAI_RNG,Correctness-SOFAI_RNG,Sys-SOFAI_RNG,",end="",file=f)
                print("Problem-EFP 2.0,EFP 2.0,Correctness-EFP 2.0,Sys-EFP 2.0",end="\n",file=f)
            else:
                print("Problem-JACCARD,Time-JACCARD,JACCARD,Sys-JACCARD,",end="",file=f)
                print("Problem-SOFAI_LEV,Time-SOFAI_LEV,SOFAI_LEV,Sys-SOFAI_LEV,",end="",file=f)
                print("Problem-SOFAI_MIX,Time-SOFAI_MIX,SOFAI_MIX,Sys-SOFAI_MIX,",end="",file=f)
                print("Problem-SOFAI_RNG,Time-SOFAI_RNG,SOFAI_RNG,Sys-SOFAI_RNG,",end="",file=f)
                print("Problem-EFP 2.0,Time-EFP 2.0,EFP 2.0,Sys-EFP 2.0",end="\n",file=f)

            for line1, line2, line3, line4,line5 in zip(file1, file2, file3, file4, file5):
                line1 = line1.strip()
                line2 = line2.strip()
                line3 = line3.strip()
                line4 = line4.strip()
                line5 = line5.strip()
                #if (not("-1" in line1 or "-1" in line2)):
                print(line1+","+line2+","+line3+","+line4+","+line5,file=f)



    plt.rcParams["figure.figsize"] = [14.00, 8.00]
    plt.rcParams["figure.autolayout"] = True
    # Make a list of columns
    #mydata = [plotting_val+'-JACCARD',plotting_val+'-SOFAI_LEV',plotting_val+'-SOFAI_MIX', plotting_val+'-SOFAI_RNG', plotting_val+'-EFP 2.0']
    #mydata = [plotting_val+'-JACCARD',plotting_val+'-EFP 2.0']#,plotting_val+'-EFP 2.0']
    mydata = ['SOFAIxJACCARD','EFP 2.0']

    columns = mydata



    styles = ['o', 'x', 'h' , '^', 'D']
    sort_order = ['EFP 2.0','SOFAIxJACCARD']
    #sort_order = [plotting_val+'-SOFAI_LEV', plotting_val+'-JACCARD', plotting_val+'-EFP 2.0']
    #sort_order = [plotting_val+'-EFP 2.0', plotting_val+'-SOFAI']

    # Read a CSV file
    df = pd.read_csv(merged_name, usecols=columns)
    # sorting according to multiple columns

    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df.to_csv(sorted_name)
    df = pd.read_csv(sorted_name, usecols=columns)

    if plotting_val == "Time":
        df[columns] = df[columns] / 1000

    # Plot the lines
    df.plot(y=columns, style=styles, figsize=(12,4))
    #plt.title(plotting_val + " comparsion between Fast and Slow Arch. and EFP 2.0", weight='bold')
    # label the x and y axes
    plt.xlabel('Instances', weight='bold', size='large')
    plt.xticks([0, 30, 60, 90, 120, 150, 180, 210, 240])
    plt.yticks([0, 10, 20, 30, 40, 50, 60, 70, 80, 90])

    if plotting_val == "Time":
        plt.ylabel(plotting_val + (" (s)"), weight='bold', size='large')
    else:
        plt.ylabel(plotting_val, weight='bold', size='large')

    #plt.xlim(1, 240)
    #plt.ylim(1, 900000)

    #plt.yscale('log')
    plt.legend(prop={'size': 18})
    plt.savefig(plotting_val+".png")


    #Adding special fileds to CSV
    with open(merged_name, 'a') as f:
        countCases = 0
        while countCases < narg:
            increaser = countCases*4
            print("\"=SUBTOTAL(3,"+chr(ord('A') + increaser)+"2:"+chr(ord('A') + increaser)+"241)\",",end="",file=f)
            print("\"=SUBTOTAL(1,"+chr(ord('B') + increaser)+"2:"+chr(ord('B') + increaser)+"241)\",",end="",file=f)
            print("\"=SUBTOTAL(1,"+chr(ord('C') + increaser)+"2:"+chr(ord('C') + increaser)+"241)\",",end="",file=f)
            print("\"=COUNTIF("+chr(ord('D') + increaser)+"2:"+chr(ord('D') + increaser)+"241,1)\"",end="",file=f)
            if countCases < narg:
                print(",",end="",file=f)
            else:
                print("\n",end="",file=f)

            countCases+=1
