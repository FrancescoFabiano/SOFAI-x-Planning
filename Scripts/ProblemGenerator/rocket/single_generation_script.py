import random
import sys
import os
import copy


def generate_instance(rockets, cargos, locations, init_state, goal_state):
    problem_name = f'rocket_{rockets}_{cargos}_{locations}'
    print(problem_name)
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
            print(f'Something was ill defined. That something is {obj}.')
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
        
    init_state = generate_partial_state(rockets, cargos, locations)
    goal_state = generate_partial_state(rockets, cargos, locations)
       
    generate_instance(rockets, cargos, locations, init_state, goal_state)