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
            continue

    new_dict = dict()
    for i in dict_act.keys():
        if str(dict_act[i][0]) not in new_dict.keys():
            new_dict[str(dict_act[i][0])] = dict()
            new_dict[str(dict_act[i][0])][i] = dict_act[i][1]
        else:
            new_dict[str(dict_act[i][0])][i] = dict_act[i][1]

    print("Domain is: " + str(new_dict))
    return new_dict



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
    new_plan = [i for i in new_plan if len(i[1])>0 and len(i[2])>0]
    return new_plan

def read_init(path):
    file1 = open(path, 'r')
    lines = file1.readlines()
    init_cond = list()
    for i in range(len(lines)):
        if lines[i].startswith('(:init'):
            for j in range(i+1, len(lines)):
                if lines[j].startswith('(:goal'):
                    break
                if lines[j].startswith('(') and lines[j].count("and")==0:
                    temp = lines[j].replace("(","").replace(")","").replace("\n", "")
                    if temp.count("not")==0:
                        temp = temp.split(" ")
                        init_cond.append([len(temp)-1] + temp)
                    else:
                        temp = temp.split(" ")
                        init_cond.append([len(temp)-2] + [" ".join(temp[:2])] + temp[2:])
        else:
            continue

    new_init = list()
    for i in init_cond:
        if "not" in " ".join([str(j) for j in i]):
            new_init.append((str(i[0])," ".join(i[1:3])," ".join(i[1:])))
        else:
            new_init.append((str(i[0])," ".join(i[1:2])," ".join(i[1:])))

    return [i[2] for i in new_init]

def read_goal(path):
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
            continue

    new_goal = list()
    for i in goal:
        if "not" in " ".join([str(j) for j in i]):
            new_goal.append((str(i[0])," ".join(i[1:3])," ".join(i[1:])))
        else:
            new_goal.append((str(i[0])," ".join(i[1:2])," ".join(i[1:])))

    return new_goal

def check_not(final_state, temp):
    new_state = list()
    for i in final_state:
        if i.count("not")>0:
            if i.replace("not ","") in temp:
                continue
            else:
                new_state.append(i)
        else:
            if "not "+i in temp:
                continue
            else:
                new_state.append(i)
    return new_state

def subgoal_completeness(goal, plan, domain, init_cond):
    final_state = init_cond.copy()
    for i in plan:
        if i[0]=='2':
            temp = domain[i[0]][i[1]]
            x = i[2].split(" ")[1]
            y = i[2].split(" ")[2]
            temp = [j.replace("?x",x).replace("?y",y) for j in temp]
            if len(final_state)!=0:
                final_state = check_not(final_state, temp)
                #final_state = check(final_state, temp)
            for j in temp:
                final_state.append(j)
        else:
            print("Domain: " + str(domain))
            temp = domain[i[0]][i[1]]
            x = i[2].split(" ")[1]
            temp = [j.replace("?x",x) for j in temp]
            if len(final_state)!=0:
                final_state = check_not(final_state, temp)
                #final_state = check(final_state, temp)
            for j in temp:
                final_state.append(j)
    count = 0
    for i in goal:
        if i[2] in final_state:
            count += 1
        else:
            continue

    return count/len(goal)


def get_correctness(domain_path, plan_text, instance_path):
    #domain  = read_domain(domain_path)
    domain  = read_domain("Input/NewPlansformer/driverlog/domain/domain.pddl")
    print(f"Domain is: {domain_path} and read domain is: {str(domain)}")
    plan = read_plan(plan_text)
    goal = read_goal(instance_path)
    init_cond = read_init(instance_path)
    return subgoal_completeness(goal, plan, domain, init_cond)
