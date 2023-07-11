#
# This Python File generates the graphs with the solutions from the raw output files
#
# Run it with "python3 merging_res.py".
#

import os
import re
from pathlib import Path
import sys
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def printNotSolFormat(writer,problem_name):
    writer.write(f"\nProblem </pro>{problem_name}</> could not be solved by System </sys>2</> using planner </pla>1</>.")

def printSolFormat(writer,problem_name,time,correctness,system_used):
    writer.write(f"\nThe solution of </pro>{problem_name}</> is </sol>[]</> with correctness </cor>{correctness}</> and has been found in </tim>{time/1000.0}s</> by System </sys>{system_used}</> using mode </mod> </>.")

if __name__ == '__main__':

    filenames = ["Classical/sol_fd.csv","Classical/sol_mix.csv"]
    outputFile = "Classical/sol_mixMerged2.sol"
    timeout = 60000
    partial_sol_discount = 5000

    df_SYS2 = pd.read_csv(filenames[0],header=None)
    df_MIX = pd.read_csv(filenames[1],header=None)

    rowcount_SYS2 = 0
    with open(outputFile,"w") as solWriter:
        for elem1 in df_SYS2[0]:

            found = False
            rowcount_MIX = 0
            for elem2 in df_MIX[0]:
                if (str(elem1) == str(elem2)):
                    found = True
                elif not found:
                    rowcount_MIX += 1

            if found:
                if (float(df_MIX.iloc[rowcount_MIX][2]) == 1.0):
                    printSolFormat(solWriter,df_MIX.iloc[rowcount_MIX][0],df_MIX.iloc[rowcount_MIX][1],df_MIX.iloc[rowcount_MIX][2],df_MIX.iloc[rowcount_MIX][3])
                elif float(df_MIX.iloc[rowcount_MIX][2]) == 0:
                    printNotSolFormat(solWriter,df_MIX.iloc[rowcount_MIX][0])
                elif (float(df_SYS2.iloc[rowcount_SYS2][2]) == 0):
                    #If also Sys2 was not able to find the solution, use the one provided by Sys1 as safety-net?
                    # Comment te if else if we donìt wat and keep only the ELSE branch
                    #if float(df_MIX.iloc[rowcount_MIX][2]) > 0:
                    #    printSolFormat(solWriter,df_MIX.iloc[rowcount_MIX][0],(timeout-partial_sol_discount),df_MIX.iloc[rowcount_MIX][2],df_MIX.iloc[rowcount_MIX][3])
                    #else:
                    printNotSolFormat(solWriter,df_SYS2.iloc[rowcount_SYS2][0])
                elif (float(df_SYS2.iloc[rowcount_SYS2][2]) == 1):
                    combined_time = float(df_SYS2.iloc[rowcount_SYS2][1]) + float(df_MIX.iloc[rowcount_MIX][1])
                    if (combined_time <= timeout):
                        printSolFormat(solWriter,df_SYS2.iloc[rowcount_SYS2][0],combined_time,df_SYS2.iloc[rowcount_SYS2][2],df_SYS2.iloc[rowcount_SYS2][3])
                    else:
                        print(f"I'm in here with a combined time of {combined_time} ({df_SYS2.iloc[rowcount_SYS2][1]} + {df_MIX.iloc[rowcount_MIX][1]})")
                        printNotSolFormat(solWriter,df_SYS2.iloc[rowcount_SYS2][0])

            else:
                if float(df_SYS2.iloc[rowcount_SYS2][2]) == 0:
                    printNotSolFormat(solWriter,df_SYS2.iloc[rowcount_SYS2][0])
                else:
                    printSolFormat(solWriter,df_SYS2.iloc[rowcount_SYS2][0],df_SYS2.iloc[rowcount_SYS2][1],df_SYS2.iloc[rowcount_SYS2][2],df_SYS2.iloc[rowcount_SYS2][3])
            rowcount_SYS2 +=1


