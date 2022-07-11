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

    with open(merged_name, 'w') as f:
        with open(modfilenames[0]) as file1, open(modfilenames[1]) as file2, open(modfilenames[2]) as file3,  open(modfilenames[3]) as file4:
            print("Problem-SOFAI_JAC,Time-SOFAI_JAC,Corr-SOFAI_JAC,Sys-SOFAI_JAC,",end="",file=f)
            print("Problem-SOFAI_LEV,Time-SOFAI_LEV,Corr-SOFAI_LEV,Sys-SOFAI_LEV,",end="",file=f)
            print("Problem-SOFAI_RNG,Time-SOFAI_RNG,Corr-SOFAI_RNG,Sys-SOFAI_RNG,",end="",file=f)
            print("Problem-EFP,Time-EFP,Corr-EFP,Sys-EFP",end="\n",file=f)
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
    plotting_val = "Time"
    mydata = [plotting_val+'-SOFAI_JAC',plotting_val+'-SOFAI_LEV', plotting_val+'-SOFAI_RNG', plotting_val+'-EFP']
    mydata = [plotting_val+'-SOFAI_JAC',plotting_val+'-SOFAI_LEV',plotting_val+'-SOFAI_RNG']
    columns = mydata



    styles = ['o', 'x', '^', 'D']
    sort_order = mydata
    #sort_order = [plotting_val+'-SOFAI_LEV', plotting_val+'-SOFAI_JAC', plotting_val+'-EFP']
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
