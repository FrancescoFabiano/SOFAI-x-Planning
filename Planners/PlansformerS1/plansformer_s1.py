# -*- coding: utf-8 -*-

#!pip install sentencepiece
#!pip install transformers

# Setting up the device for GPU usage
import pwd
from torch import cuda
device = 'cuda' if cuda.is_available() else 'cpu'

#imports
import torch
import torch.nn.functional as F
import re

#imports
from transformers import RobertaTokenizer, T5ForConditionalGeneration

def find_parens(s):
    toret = {}
    pstack = []
    flag = 0
    for i, c in enumerate(s):

        if flag == 1 and len(pstack) == 0:
            return toret

        if c == '(':
            pstack.append(i)
            flag = 1
        elif c == ')':
            toret[pstack.pop()] = i

    return toret

def prompt_action(data):

    # print(data)
    string = '<ACTION> ' + data.split('\n')[0].split(' ')[1].lower() + ' '

    if ':precondition' in data:
        string += '<PRE> '
        pre_idx = data.find(':precondition')
        effect_idx = data.find(':effect')
        pre_data = data[pre_idx:effect_idx]
        pre_parens = find_parens(pre_data)
        # print(pre_data)
        for keys in sorted(pre_parens.keys()):
            temp_str = pre_data[keys:pre_parens[keys]+1]
            if '(and' not in temp_str:
                string += temp_str.strip('(').strip(')').replace('?', '') + ', '

        string = string[:-2] + ' '
        # print(string)

    if ':effect' in data:
        string += '<EFFECT> '
        effect_idx = data.find(':effect')
        effect_data = data[effect_idx:]
        effect_parens = find_parens(effect_data)

        check_st = 0
        check_end = 0
        flag = 0
        flag_forall = 0
        for keys in sorted(effect_parens.keys()):
            temp_str = effect_data[keys:effect_parens[keys]+1]

            if '(forall' in temp_str[:8] and '(and' not in temp_str[:5]:
                for ind in range(len(temp_str)):
                    if ind < len(temp_str) - 2:
                        if temp_str[ind] == ')' and temp_str[ind+2] == '(':
                            temp_str = temp_str[:ind] + ', '+ temp_str[ind+2:]

                string += '(' + temp_str.replace('?', '').replace('(','').replace(')','').replace('and', '').replace('\n', ',').strip() + ')' + ', '
                flag_forall = 1

            elif flag_forall == 0:
                if flag == 1:
                    if keys > check_st and keys < check_end:
                        continue

                if '(and' not in temp_str:
                    string += temp_str.replace('(', '').replace(')', '').replace('?', '') + ', '

                    if '(not' in temp_str:
                        flag = 1
                        check_st = keys
                        check_end = effect_parens[keys]

        string = string[:-2] + ' '

    return string


def prompt_problem( data ):

    if '(:init' in data:
        string = '<INIT>'

        parens = find_parens(data)
        check_st = 0
        check_end = 0
        flag = 0

        for keys in sorted(parens.keys()):
            temp_str = data[keys:parens[keys]+1]

            if flag == 1:
                if keys > check_st and keys < check_end:
                    continue

            if '(:init' not in temp_str:
                string += temp_str.replace('(', '').replace(')', '') + ', '

                if '(not' in temp_str:
                    flag = 1
                    check_st = keys
                    check_end = parens[keys]

        return string[:-2] + ''

    elif '(:goal' in data:
        string = '<GOAL>'

        parens = find_parens(data)
        check_st = 0
        check_end = 0
        flag = 0

        for keys in sorted(parens.keys()):
            temp_str = data[keys:parens[keys]+1]

            if flag == 1:
                if keys > check_st and keys < check_end:
                    continue

            if ('(:goal' and '(and') not in temp_str:
                string += temp_str.replace('(', '').replace(')', '') + ', '

                if '(not' in temp_str:
                    flag = 1
                    check_st = keys
                    check_end = parens[keys]

        return string[:-2] + ''


def get_prompt(domain_file, problem_file):
    with open(domain_file, 'r') as f:
        domain_data = f.read()

    domain_name = re.findall(r'(?<=domain )\w+', domain_data)
    domain_name = domain_name[0]

    flag = 1
    # domain_name += '_rao'

    # continue

    idx = [m.start() for m in re.finditer(pattern=':action', string=domain_data)]

    domain_string = ''

    for id in range(len(idx)):
        # print(domain_data[idx[id]-1: idx[id+1]-1])
        if id != len(idx) - 1:
            domain_string += prompt_action(domain_data[idx[id]-1: idx[id+1]-1]).strip() + ' '
        else:
            domain_string += prompt_action(domain_data[idx[id]-1:])

    with open(problem_file, 'r') as f:
        problem_data = f.read()


    init_ind = problem_data.find('(:init')
    goal_ind = problem_data.find('(:goal')

    problem_string = ''
    problem_string += prompt_problem( problem_data[goal_ind:] )
    problem_string += prompt_problem( problem_data[init_ind:goal_ind] )

    return problem_string + domain_string



def solve(domain, problem):
    #path to plansformer model files
    model_path = "Planners/PlansformerS1/model_files"

    #using plansformer's tokenizer and model weights
    tokenizer = RobertaTokenizer.from_pretrained(model_path, local_files_only = True)
    model = T5ForConditionalGeneration.from_pretrained(model_path, local_files_only = True)
    model = model.to(device)
    #input problem/task
    instance_prompt = get_prompt(domain,problem)

    #tokenizing the input and passing it to the model
    input_ids = tokenizer.encode(instance_prompt, return_tensors='pt').to(device, dtype = torch.long)
    generated_ids = model.generate(
        input_ids, num_beams = 2, max_length=input_ids.shape[-1] + 2,
        repetition_penalty = 2.5, length_penalty = 1.0,
        early_stopping=False, do_sample = True, return_dict_in_generate=True, output_scores=True)

    #obtaining the predicted plan from Plansformer for given input
    predicted_plan = [tokenizer.decode(g, skip_special_tokens=True) for g in generated_ids.sequences]
    gen_sequences = generated_ids.sequences[:1,1:]
    probs = torch.stack(generated_ids.scores, dim=1).softmax(-1)
    if probs.shape[0] > 1:
        probs = probs[:1]
    gen_probs = torch.gather(probs, 2, gen_sequences[:, :, None]).squeeze(-1)

    return torch.mean(gen_probs), predicted_plan
