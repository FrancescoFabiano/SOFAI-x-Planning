#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 graph_gen.py Time 3 Input/FD.out Input/SOFAI-PF-FD.out Input/SOFAI-PF-LPGxFD.out".
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
                    print(f"{problem},{str(time)},{str(cor)},{str(opt)},{str(sys)},{str(pla)}",file=f)
                        #sys.exit()
            myfile.close()


    mydata = ['Name',f'Time-{suffix}',f'Corr-{suffix}',f'Opt-{suffix}',f'Sys-{suffix}',f'Planner-{suffix}']
    columns = mydata
    sort_order = mydata
    # Read a CSV file
    df = pd.read_csv(modfilename, usecols=columns)
    # sorting according to multiple columns
    df.sort_values(sort_order, ascending=True,inplace=True,na_position='first')
    df[f'Sys-{suffix}'] = df[f'Sys-{suffix}'].astype('Int64')
    df[f'Planner-{suffix}'] = df[f'Planner-{suffix}'].astype('Int64')
    df.to_csv(modfilename, index=False)

def loopPrintLaTeX(line,narg,tableFile):
    for i in range(narg):
        print(line,file=tableFile,end="")

def loopPrintLaTeXArray(line_before,endline,endSequence,array,tableFile):
    for elem in array[:-1]:
        print(line_before + str(elem),file=tableFile,end=endline)
    print(line_before + str(array[-1]),file=tableFile,end=endSequence)
    

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

    merged_path="Output/Merged/"
    Path(merged_path).mkdir(parents=True,exist_ok=True)
    
    merged_name = merged_path+"merged.csv"
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
    plt.savefig("Output/"+plotting_val+"-Plot.png")



    nRows = len(df)+1
    countCases = 0
    col_numbers = 5
    merged_name_formula = merged_path+"merged_formulae.csv"
    
    for suffix in suffixes:
        merged_df[f'Sys-{suffix}'] = merged_df[f'Sys-{suffix}'].astype('Int64')
        merged_df[f'Planner-{suffix}'] = merged_df[f'Planner-{suffix}'].astype('Int64')  
            
    merged_df.to_csv(merged_name_formula, encoding='utf-8', index=False)
    chrOrd = ord('A')
    extraChar = ''
    formula_row = "\"=SUBTOTAL(3,"+chr(chrOrd)+"2:"+chr(chrOrd)+str(nRows) +")\","
    chrOrd+=1
    internal_counter = 0
    extraCounter=0
    while countCases < narg:
        if internal_counter < 3:
            formula_row += "\"=SUBTOTAL(1,"+extraChar+chr(chrOrd)+"2:"+extraChar+chr(chrOrd)+str(nRows) +")\","
            internal_counter+=1
            if chrOrd<90:
                chrOrd+=1
            else:
                chrOrd = ord('A')
                extraChar = chr(ord('A')+extraCounter)
                extraCounter+=1
        
        elif internal_counter == 3:
            formula_row += "\"=COUNTIF("+extraChar+chr(chrOrd)+"2:"+extraChar+chr(chrOrd)+str(nRows) +",1)\""
            internal_counter+=1
            if chrOrd<90:
                chrOrd+=1
            else:
                chrOrd = ord('A')
                extraChar = chr(ord('A')+extraCounter)
                extraCounter+=1
                
        elif internal_counter == 4:
            formula_row += "," #For Empty column -- Type of system 2 does not have an aggregate
            internal_counter=0
            if chrOrd<90:
                chrOrd+=1
            else:
                chrOrd = ord('A')
                extraChar = chr(ord('A')+extraCounter)
                extraCounter+=1
        
            if countCases < narg:
                formula_row += ","
            else:
                formula_row += "\n"
            
            countCases+=1

    f = open(merged_name_formula, "a")
    f.write(formula_row)
    f.close()

    #Create LaTeX Table
    table_path="Output/Table/"
    Path(table_path).mkdir(parents=True,exist_ok=True)

    with open(table_path+"table.tex", "w") as tableFile:
        #Preamble
        print('\\documentclass[12pt,a4paper]{standalone}\n\\usepackage{hhline}\n\\usepackage{tabularx}\n\\begin{document}',file=tableFile)
        
        #Tabular declaration
        print('\t\\begin{tabular}{||l',file=tableFile,end="")
        loopPrintLaTeX('|c',narg,tableFile)
        print('||}',file=tableFile)

        #Approaches row
        print('\t\t\\hhline{~|t:',file=tableFile,end="")
        loopPrintLaTeX('=',narg,tableFile)
        print(':t|}',file=tableFile)
        print("\t\t\\multicolumn{1}{c||}{} & \multicolumn{1}{c|}", file=tableFile,end="")
        loopPrintLaTeXArray("{\\texttt{","}} & ","}}\\\\\n",suffixes,tableFile)
        print('\t\t\\hhline{|t:=:b:',file=tableFile,end="")
        loopPrintLaTeX('=',narg,tableFile)
        print(':t}',file=tableFile)

        #Number of plans Section

        solved_plans_stats = []
        correct_plans_stats = []
        partial_plans_stats = []
        partial_plansArr = []
        max_solved_plans = -1
        index_max = []
        count_plans = 0
        nInstances = nRows-1
        dictValues = {}
        for suff in suffixes:
            
            dictValues.clear()
            dictValues = merged_df[f'Corr-{suff}'].value_counts().to_dict()

            if 0.0 in dictValues.keys():
                failed_plans = dictValues[0.0]
            else:
                failed_plans = 0

            if 1.0 in dictValues.keys():
                correct_plans = dictValues[1.0]
            else:
                correct_plans = 0


            solved_plans = nInstances - failed_plans
            partial_plans = solved_plans - correct_plans

            if solved_plans > max_solved_plans:
                max_solved_plans = solved_plans
                index_max.clear()
                index_max.append(count_plans)
            elif solved_plans == max_solved_plans:
                index_max.append(count_plans)

            solved_plans_stats.append(f"{solved_plans} ({(solved_plans / nInstances)*100.0:.2f}\%)")
            correct_plans_stats.append(f"{correct_plans} ({(correct_plans / nInstances)*100.0:.2f}\%)")
            partial_plans_stats.append(f"{partial_plans} ({(partial_plans / nInstances)*100.0:.2f}\%)")
            partial_plansArr.append(partial_plans)

            count_plans += 1

        for c in index_max:
            solved_plans_stats[c] = "\\textbf{"+solved_plans_stats[c]+"}"

        print("\t\t%Number of Plans", file=tableFile)
        print("\t\tPlans & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",solved_plans_stats,tableFile)


        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad Complete & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",correct_plans_stats,tableFile)

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad Partial & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",partial_plans_stats,tableFile)


        print('\t\t\\hhline{|:',file=tableFile,end="")
        loopPrintLaTeX('=',narg+1,tableFile)
        print(':|}',file=tableFile)

        #S1 Plans
        sys1PlansArr = []
        sys1PlanClean = []
        sys2PlansArr = []

        for suff in suffixes:
            dictValues = merged_df[f'Sys-{suff}'].value_counts().to_dict()

           
            if -1 in dictValues.keys():
                failedPlans = dictValues[-1]
            else:
                failedPlans = 0

            if 1 in dictValues.keys():
                sys1Plans = dictValues[1]
            else:
                sys1Plans = 0

            if 2 in dictValues.keys():
                sys2Plans = dictValues[2]
            else:
                sys1Plans = 0

            sys1PlansArr.append(f"{sys1Plans} ({(sys1Plans / nInstances)*100.0:.2f}\%)")
            sys1PlanClean.append(sys1Plans)
            sys2PlansArr.append(f"{sys2Plans} ({(sys2Plans / nInstances)*100.0:.2f}\%)")

        print("\t\t\\texttt{S1} Plans & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",sys1PlansArr,tableFile)

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)



        sys1_completePlans = []
        c = 0
        while c in range(len(partial_plansArr)):
            sys1_completePlans.append(int(sys1PlanClean[c])-int(partial_plansArr[c]))
            c+=1

        print("\t\t\\quad Complete & ", file=tableFile,end="")
        
        sys1_complete_stats = []
        for elem in sys1_completePlans:
            sys1_complete_stats.append(f"{elem} ({(elem / nInstances)*100.0:.2f}\%)")
        loopPrintLaTeXArray(""," & ","\\\\\n",sys1_complete_stats,tableFile)

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad Partial & ", file=tableFile,end="")
        sys1_partial_stats = []
        for elem in partial_plansArr:
            sys1_partial_stats.append(f"{elem} ({(elem / nInstances)*100.0:.2f}\%)")
        loopPrintLaTeXArray(""," & ","\\\\\n",sys1_partial_stats,tableFile)


        print('\t\t\\hhline{|:',file=tableFile,end="")
        loopPrintLaTeX('=',narg+1,tableFile)
        print(':|}',file=tableFile)


        print("\t\t\\texttt{S2} Plans & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",sys2PlansArr,tableFile)



        FD_uses = []
        LPG_uses = []
        FDLPG_uses = []
        dictValues.clear()
        for suff in suffixes:
    
            df_Sys2_cleaned = merged_df
            df_Sys2_cleaned = df_Sys2_cleaned[ (df_Sys2_cleaned[f'Sys-{suff}'] == 2) ]
            dictValues = df_Sys2_cleaned[f'Planner-{suff}'].value_counts().to_dict()
        
            if 1 in dictValues.keys():
                fdPlans = dictValues[1]
            else:
                fdPlans = 0

            if 2 in dictValues.keys():
                lpgPlans = dictValues[2]
            else:
                lpgPlans = 0

            if 3 in dictValues.keys():
                pfLpgPlans = dictValues[3]
            else:
                pfLpgPlans = 0

            FD_uses.append(f"{fdPlans} ({(fdPlans / nInstances)*100.0:.2f}\%)")
            LPG_uses.append(f"{lpgPlans} ({(lpgPlans / nInstances)*100.0:.2f}\%)")
            FDLPG_uses.append(f"{pfLpgPlans} ({(pfLpgPlans / nInstances)*100.0:.2f}\%)")

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad FD & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",FD_uses,tableFile)

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad LPG & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",LPG_uses,tableFile)

        print('\t\t\\hhline{||',file=tableFile,end="")
        loopPrintLaTeX('-',narg+1,tableFile)
        print('||}',file=tableFile)

        print("\t\t\\quad PF + LPG & ", file=tableFile,end="")
        loopPrintLaTeXArray(""," & ","\\\\\n",FDLPG_uses,tableFile)

        print('\t\t\\hhline{|:',file=tableFile,end="")
        loopPrintLaTeX('=',narg+1,tableFile)
        print(':|}',file=tableFile)



        print("\t\tTime (avg) & ", file=tableFile,end="")
        timeArr = []
        minTime = sys.maxsize
        index_min = []
        count_time = 0
        for suff in suffixes:
            timeAvg = merged_df[f'Time-{suff}'].mean()/1000


            if timeAvg < minTime:
                minTime = timeAvg
                index_min.clear()
                index_min.append(count_time)
            elif minTime == max_solved_plans:
                index_max.append(count_time)
            count_time +=1

            timeArr.append(f"{timeAvg:.3f}s")

        for c in index_min:
            timeArr[c] = "\\textbf{"+timeArr[c]+"}"
        loopPrintLaTeXArray(""," & ","\\\\\n",timeArr,tableFile)

        print('\t\t\\hhline{|:',file=tableFile,end="")
        loopPrintLaTeX('=',narg+1,tableFile)
        print(':|}',file=tableFile)


        print("\t\tOptimality (avg) & ", file=tableFile,end="")
       
        df_cleaned = merged_df
        for suff in suffixes:
            df_cleaned = df_cleaned[ (df_cleaned[f'Opt-{suff}'] >= 0) ]
        
        optArr = []
        minOpt = sys.maxsize
        index_min = []
        count_opt = 0
        for suff in suffixes:
            optAvg = df_cleaned[f'Opt-{suff}'].mean()


            if optAvg < minOpt:
                minOpt = optAvg
                index_min.clear()
                index_min.append(count_opt)
            elif minOpt == max_solved_plans:
                index_max.append(count_opt)
            count_opt +=1

            optArr.append(f"+{optAvg:.2f}\%")

        for c in index_min:
            optArr[c] = "\\textbf{"+optArr[c]+"}"
        loopPrintLaTeXArray(""," & ","\\\\\n",optArr,tableFile)

        print('\t\t\\hhline{|b:',file=tableFile,end="")
        loopPrintLaTeX('=',narg+1,tableFile)
        print(':b|}',file=tableFile)


        print('\t\\end{tabular}\n\\end{document}',file=tableFile)


    with open(table_path+"table.tex", 'r') as file:
        data = file.read()
        data = data.replace("_", "\\_")

    with open(table_path+"table.tex", 'w') as file:
        file.write(data)