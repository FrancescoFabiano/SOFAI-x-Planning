def read_domain(path):
    file1 = open(path, 'r')
    lines = file1.readlines()
    dict_act = dict()
    for i in range(len(lines)):
        if lines[i].startswith('  (:action'):
            act = lines[i].split(' ')[3].replace("\n", "")
            dict_act[act] = [0,[]]
        elif lines[i].startswith("	     :parameters"):
            params = len(lines[i].split("(")[1].split(" "))
            dict_act[act][0] = params
        elif lines[i].startswith('	     :effect'):
            for j in range(i+1, len(lines)):
                if lines[j].startswith('	     ('):
                    dict_act[act][1].append(" ".join(lines[j].split(' ')[6:]).replace("(","").replace(")","").replace("\n", ""))
                elif lines[j].startswith('		   ('):
                    dict_act[act][1].append(" ".join(lines[j].split(' ')[3:]).replace("(","").replace(")","").replace("\n", ""))
                elif lines[j].startswith('  (:action'):
                    break
        else:
            pass

    new_dict = dict()
    for i in dict_act.keys():
        if dict_act[i][0] not in new_dict.keys():
            new_dict[dict_act[i][0]] = dict()
            new_dict[dict_act[i][0]][i] = dict_act[i][1]
        else:
            new_dict[dict_act[i][0]][i] = dict_act[i][1]
        #print(i, dict_act[i])

    list_unq = list()
    for i in new_dict:
        for j in new_dict[i]:
            for k in new_dict[i][j]:
                if k not in list_unq:
                    list_unq.append(k)
                else:
                    pass

    list_unq = [i.split(" ?")[0] for i in list_unq]

    final_dict = dict()
    for i in list_unq:
        final_dict[i] = dict()
        for j in new_dict:
            for k in new_dict[j]:
                if i in [m.split(" ?")[0] for m in new_dict[j][k]]:
                    if j not in final_dict[i].keys():
                        final_dict[i][j] = list()
                        final_dict[i][j].append(k)
                    else:
                        final_dict[i][j].append(k)

    return final_dict


#takes input plan text "action1, action2" -- string not list
def read_plan(plan_text):
    plan = plan_text.split(", ")
    plans = list()
    for j in range(len(plan)):
        if plan[j].count("not")==0:
            temp = plan[j].split(" ")
            plans.append([len(temp)-1] + temp)
        else:
            temp = plan[j].split(" ")
            plans.append([len(temp)-2] + [" ".join(temp[:2])] + temp[2:])

    new_plan = list()
    for i in plans:
        if "not" in " ".join([str(j) for j in i]):
            new_plan.append((str(i[0])," ".join(i[1:3])," ".join(i[1:])))
        else:
            new_plan.append((str(i[0])," ".join(i[1:2])," ".join(i[1:])))

    return new_plan


def read_goal(path): #path is problem_file
    file1 = open(path, 'r')
    lines = file1.readlines()
    goal = list()
    for i in range(len(lines)):
        if lines[i].startswith('(:goal'):
            for j in range(i+1, len(lines)):
                if lines[j].startswith('(') and lines[j].count("and")==0:
                    temp = lines[j].replace("(","").replace(")","").replace("\n", "")
                    if temp.count("not")==0:
                        temp = temp.split(" ")
                        goal.append([len(temp)-1] + temp)
                    else:
                        temp = temp.split(" ")
                        goal.append([len(temp)-2] + [" ".join(temp[:2])] + temp[2:])
                elif lines[j].startswith(' '):
                    break
        else:
            pass

    new_goal = list()
    for i in goal:
        if "not" in " ".join([str(j) for j in i]):
            new_goal.append((str(i[0])," ".join(i[1:3])," ".join(i[1:])))
        else:
            new_goal.append((str(i[0])," ".join(i[1:2])," ".join(i[1:])))

    return new_goal

#returns a value b/w 0 and 1 for subgoal completion, where 1 is all sub-goals being satisfied.
def subgoal_completeness(goal, plan, domain): #goal, plan generate, domainFile
    count = 0
    for i in goal:
        temp = domain[i[1]][int(i[0])]
        for j in temp:
            search = i[2].replace(i[1],j)
            for k in plan:
                #print(search,k[2])
                if search==k[2]:
                    count += 1
                    break
                else:
                    pass

    return count/len(goal)


def get_correctness(domain_path,plan_text,instance_path):
    read_domain(domain_path)
    read_plan(plan_text)
    read_goal(instance_path)
    return subgoal_completeness(goal, plan, domain)
