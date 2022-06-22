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
        #print("Problem,Time,Correctness,System",file=f)
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

    filename1 = sys.argv[1]
    filename2 = sys.argv[2]

    rootFilename1 = os.path.splitext(filename1)[0]
    rootFilename2 = os.path.splitext(filename2)[0]

    sol_reader(filename1,rootFilename1)
    sol_reader(filename2,rootFilename2)

    modfilename1 = rootFilename1+'.csv'
    modfilename2 = rootFilename2+'.csv'

    path, rootFilename1 = os.path.split(rootFilename1)
    path, rootFilename2 = os.path.split(rootFilename2)

    merged_name = path + "/merged_"+rootFilename1+"_"+rootFilename2+".csv"
    sorted_name = path + "/sorted_merged_"+rootFilename1+"_"+rootFilename2+".csv"

    with open(merged_name, 'w') as f:
        with open(modfilename1) as file1, open(modfilename2) as file2:
            print("Problem-SOFAI,Time-SOFAI,Corr-SOFAI,Sys-SOFAI,Problem-EFP,Time-EFP,Corr-EFP,Sys-EFP",file=f)
            for line1, line2 in zip(file1, file2):
                line1 = line1.strip()
                if (not("-1" in line1 or "-1" in line2)):
                    print(line1+","+line2,file=f)



    plt.rcParams["figure.figsize"] = [14.00, 8.00]
    plt.rcParams["figure.autolayout"] = True
    # Make a list of columns
    plotting_val = "Time"
    columns = [plotting_val+'-SOFAI', plotting_val+'-EFP']



    colors = ['#89FAB4', '#FAE4A0']
    styles = ['-o', 'x']
    sort_order = [plotting_val+'-SOFAI', plotting_val+'-EFP']
    #sort_order = [plotting_val+'-EFP', plotting_val+'-SOFAI']

    # Read a CSV file
    df = pd.read_csv(merged_name, usecols=columns)
    # sorting according to multiple columns

    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df.to_csv(sorted_name)

    df = pd.read_csv(sorted_name, usecols=columns)


    # Plot the lines
    df.plot(y=columns, style=styles, figsize=(16, 9))
    plt.title(plotting_val + " comparsion between SOFAI and EFP", weight='bold')
    # label the x and y axes
    plt.xlabel('Instances', weight='bold', size='large')
    plt.ylabel(plotting_val, weight='bold', size='large')

    #plt.xlim(1, 240)
    #plt.ylim(1, 900000)

    #plt.yscale('log')
    plt.savefig(plotting_val+".png")
