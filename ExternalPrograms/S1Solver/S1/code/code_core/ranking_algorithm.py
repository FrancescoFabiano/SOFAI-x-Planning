import os
from typing import Text

planfiles_path =  "../../cases/" 


def RankPlan(planfile):

    rank = GetAttributes(planfile)
    return rank

def GetAttributes(planfile):
    length = 0
    with open( os.path.join(planfiles_path + planfile) ) as currentfile:
        text = currentfile.read()
        if "Plan Length:" not in text:
            length = len(text.split("\n"))
        else:
            temp = [i for i in text.split("\n") if i]
            temp = temp[-1].split(":")
            length = int(temp[-1])

    return length
