import random
from shutil import move
import sys
import os
import re
import copy

verbose = False

def generate_instance(rockets, cargos, locations, init_state, goal_state):
    problem_name = f'rocket_{rockets}_{cargos}_{locations}'
    if verbose: print(problem_name)
    with open('problem_template.pddl', 'r') as f:
        lines = f.readlines()
        for l in range(len(lines)):
            if '(problem' in lines[l]:
                problem_line = l
            if '(:objects' in lines[l]:
                objects_line = l
            if '(:init' in lines[l]:
                initial_line = l
            if '(:goal' in lines[l]:
                goal_line = l

    lines[problem_line] = '(define (problem '+problem_name+')\n'

    rocket_list = [i for i in range(rockets)]
    cargo_list = [i for i in range(cargos)]
    location_list = [i for i in range(locations)]

    objects_list = []
    for elem in rocket_list:
        objects_list.append(f'r{elem}')
    for elem in cargo_list:
        objects_list.append(f'c{elem}')
    for elem in location_list:
        objects_list.append(f'l{elem}')

    newline_counter = rockets-1

    #Obj generator
    lines[objects_line] += '\t'
    count_obj = 0
    for obj in objects_list:
        lines[objects_line] += f'{obj}'
        if count_obj == newline_counter:
            count_obj = 0
            lines[objects_line] += '\n\t'
        else:
            count_obj +=1
            lines[objects_line] += ' '
    
    #Init generator
    lines[initial_line] += '\t'
    count_obj = 0

    for elem in rocket_list:
        lines[initial_line] += f'(at r{elem} l0)'
        if count_obj == newline_counter:
            count_obj = 0
            lines[initial_line] += '\n\t'
        else:
            count_obj +=1
            lines[initial_line] += ' '

    lines[initial_line] += '\n\t'
    for obj in objects_list:
        
        if 'r' in str(obj):
            value = f'(rocket {obj})'
        elif 'l' in str(obj):
            value = f'(location {obj})'
        elif 'c' in str(obj):
            value = f'(cargo {obj})'
        else:
            if verbose: print(f'Something was ill defined. That something is {obj}.')
            sys.exit(1)


        lines[initial_line] += f'{value}'
        if count_obj == newline_counter:
            count_obj = 0
            lines[initial_line] += '\n\t'
        else:
            count_obj +=1
            lines[initial_line] += ' '
   
    lines[initial_line] += '\n\t'
    count_obj = 0
    for elem in init_state:
        lines[initial_line] += f'{elem}'
        if count_obj == newline_counter:
            count_obj = 0
            lines[initial_line] += '\n\t'
        else:
            count_obj +=1
            lines[initial_line] += ' '


    #Goal generator
    lines[goal_line] += '\t'
    count_obj = 0
    for elem in goal_state:
        lines[goal_line] += f'{elem}'
        if count_obj == newline_counter:
            count_obj = 0
            lines[goal_line] += '\n\t'
        else:
            count_obj +=1
            lines[goal_line] += ' '

    if os.path.exists('problems/') == False:
        os.mkdir('problems/')

    with open('problems/'+problem_name+'.pddl', 'w') as write_file:
        lines = "".join(lines)
        write_file.write(lines)
    write_file.close()

    return 'problems/'+problem_name+'.pddl'

def plan_generation(rockets, cargos, locations, init_state, goal_state, filename):

    rocket_list = [i for i in range(rockets)]
    cargo_list = [i for i in range(cargos)]
    location_list = [i for i in range(locations)]

    init_locations_cargo = {l: [] for l in location_list}
    goal_locations_cargo = {l: [] for l in location_list}
    rocket_move_cargo = {r: [] for r in rocket_list}
    rocket_visited_location = {r: [] for r in rocket_list}

    for elem in init_state:
        l = get_val_from_clause(elem,'l')
        c = get_val_from_clause(elem,'c')
        init_locations_cargo[int(l)].append(int(c))
    
    for elem in goal_state:
        l = get_val_from_clause(elem,'l')
        c = get_val_from_clause(elem,'c')
        goal_locations_cargo[int(l)].append(int(c))

    cargo_list_to_move = [i for i in range(cargos)]

    #Remove trivial goals
    for l in location_list:
        for c in init_locations_cargo[int(l)]:
            if c in goal_locations_cargo[int(l)]:
                cargo_list_to_move.remove(int(c))
                #Each rocket has to move carge across each planet
                return False
                
    #All the rockets start at 0    
    for r in rocket_list:
        loc = 0
        move_count = 0
        no_move = False

        while move_count < locations and not no_move:
            no_move = True
            for c in cargo_list_to_move:
                if c in init_locations_cargo[int(loc)]:
                    goal_dest = -1
                    for l1 in location_list:
                        if c in goal_locations_cargo[int(l1)]:
                            goal_dest = l1

                        if goal_dest not in rocket_visited_location[r] and goal_dest >= 0:
                            cargo_list_to_move.remove(int(c))
                            rocket_move_cargo[r].append(int(c))
                            rocket_visited_location[r].append(int(l1))
                            loc = goal_dest            
                            no_move = False
                            move_count+=1
        
        
        init_locations_cargo[int(l)].sort()
        goal_locations_cargo[int(l)].sort()

    found_plan = not cargo_list_to_move

    if found_plan:
        if verbose: print(f'Init dictionary {init_locations_cargo}')
        if verbose: print(f'Goal dictionary {goal_locations_cargo}')
        if verbose: print(f'Rocket-Cargo {rocket_move_cargo}')
        if verbose: print(f'Rocket-Location {rocket_visited_location}')

        #Here print the plan on top of the file

    return found_plan

def get_val_from_clause(clause,val):
    id = re.sub(rf'\(at.*\s*{val}(\d+).*\s*\)', r'\1', clause)
    return id

def generate_partial_state(rockets, cargos, locations):


    rocket_list = [i for i in range(rockets)]
    cargo_list = [i for i in range(cargos)]
    location_list = [i for i in range(locations)]
    
    state = []
    cargo_tmp_list = copy.deepcopy(cargo_list)
    random.shuffle(cargo_tmp_list)

    for rocket in rocket_list:
        location_tmp_list = copy.deepcopy(location_list)

        random.shuffle(location_tmp_list)

        while location_tmp_list and cargo_list:
            l = location_tmp_list.pop()
            c = cargo_tmp_list.pop()

            state.append(f'(at c{c} l{l})')
    
    return state


if __name__ == "__main__":
    rockets = int(sys.argv[1])
    locations = int(sys.argv[2])
    cargos = rockets*locations


    #objects_list = []
    #for elem in rocket_list:
    #    objects_list.append(f'r{i}')
    #for elem in cargo_list:
    #    objects_list.append(f'c{i}')
    #for elem in location_list:
    #    objects_list.append(f'l{i}')

    found_plan = False

    attempt_count = 0
    max_attempt = 10000
    while not found_plan:
        attempt_count += 1
        if verbose: print(f'Attempt #{attempt_count} at generating a solvable instance with {rockets} rockets, {locations} locations, and {cargos} cargos.')      
        init_state = generate_partial_state(rockets, cargos, locations)
        goal_state = generate_partial_state(rockets, cargos, locations)
        
        filename = generate_instance(rockets, cargos, locations, init_state, goal_state)

        found_plan = plan_generation(rockets, cargos, locations, init_state, goal_state,filename)

        if attempt_count > max_attempt:
            if verbose: print(f'No instance with {rockets} rockets, {locations} locations, and {cargos} cargos found.')      
            sys.exit()