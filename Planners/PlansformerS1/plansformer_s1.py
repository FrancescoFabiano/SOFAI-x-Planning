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

def getVarFromFile(filename,varname):
    with open(filename) as myfile:
        for line in myfile:
            if ":"+varname in line:
                line = re.sub(r';.*$', '', line)
                discard, var = line.partition(":"+varname)[::2]
                var = var.replace(")", "")
                myfile.close()
                return var.strip()
        raise Exception('Missing variable named '+ varname)
    raise Exception('Missing file named '+ filename)

def getRawVarFromFile(filename,varname):
    with open(filename) as myfile:
        for line in myfile:
            if ":"+varname in line:
                line = re.sub(r';.*$', '', line)
                discard, var = line.partition(":"+varname)[::2]
                myfile.close()
                return var
        raise Exception('Missing variable named '+ varname)
    raise Exception('Missing file named '+ filename)

def find_action_name(filename,act_name):
    with open(filename) as myfile:
        for line in myfile:
            if (":action " + act_name) in line:
                return True
        return False
        raise Exception('Missing variable named '+ varname)
    raise Exception('Missing file named '+ filename)

def cleanString(mystring):
    mystring = re.sub("\)\s*\(", ", ", mystring)

    mystring = mystring.strip()
    mystring = mystring[1:]
    mystring = mystring[:-2]
    return mystring

def getVarFromLine(line,varname):
#    print("Cond is </"+varname+">")
    if "</"+varname+">" in line:
        line = re.sub(r'.*</'+varname+'>([^<]+)</>.*',r'\1', line)
        return line.strip()
    return ''

def convert_input_to_string(domain_name,instance_name):

    init = getRawVarFromFile(instance_name,"init")
    init = cleanString(init)
    goal = getRawVarFromFile(instance_name,"goal")
    goal = cleanString(goal)

    #This works only for coin_in_the_box
    if find_action_name(domain_name,"close"):
        act_string = "<ACTION> move_to_box <ACT_TYPE> ontic <PRE> [?ag](in_room_empty ?ag), in_room_empty ?ag <EFFECT> in_room_box ?ag, -in_room_empty ?ag <ACTION> move_to_empty <ACT_TYPE> ontic <PRE> [?ag](in_room_box ?ag), in_room_box ?ag <EFFECT> in_room_empty ?ag, -in_room_box ?ag <ACTION> open <ACT_TYPE> ontic <PRE> [?ag](has_key ?ag), has_key ?ag, in_room_box ?ag <EFFECT> opened <ACTION> close <ACT_TYPE> ontic <PRE> [?ag](has_key ?ag), has_key ?ag, in_room_box ?ag <EFFECT> -opened <ACTION> signal <ACT_TYPE> ontic <PRE> [?ag1](looking ?ag1), [?ag2](not (looking ?ag2)) <EFFECT> looking ?ag2 <ACTION> peek <ACT_TYPE> sensing <PRE> [?ag](opened), [?ag](looking ?ag), looking ?ag, opened, in_room_box ?ag <EFFECT> tail <ACTION> distract <ACT_TYPE> ontic <PRE> [?ag1](looking ?ag1), [?ag2](looking ?ag2) <EFFECT> not (looking ?ag2) <ACTION> announce_room_box <ACT_TYPE> announcement <PRE> [?ag](tail), tail, in_room_box ?ag <EFFECT> tail <ACTION> announce_room_empty <ACT_TYPE> announcement <PRE> [?ag](tail), tail, in_room_empty ?ag <EFFECT> tail"
    else:
        act_string = "<ACTION> move_to_box <ACT_TYPE> ontic <PRE> [?ag](in_room_empty ?ag), in_room_empty ?ag <EFFECT> in_room_box ?ag, -in_room_empty ?ag <ACTION> move_to_empty <ACT_TYPE> ontic <PRE> [?ag](in_room_box ?ag), in_room_box ?ag <EFFECT> in_room_empty ?ag, -in_room_box ?ag <ACTION> open <ACT_TYPE> ontic <PRE> [?ag](has_key ?ag), has_key ?ag, in_room_box ?ag <EFFECT> opened <ACTION> signal <ACT_TYPE> ontic <PRE> [?ag1](looking ?ag1), [?ag2](not (looking ?ag2)) <EFFECT> looking ?ag2 <ACTION> peek <ACT_TYPE> sensing <PRE> [?ag](opened), [?ag](looking ?ag), looking ?ag, opened, in_room_box ?ag <EFFECT> tail <ACTION> distract <ACT_TYPE> ontic <PRE> [?ag1](looking ?ag1), [?ag2](looking ?ag2) <EFFECT> not (looking ?ag2) <ACTION> announce_room_box <ACT_TYPE> announcement <PRE> [?ag](tail), tail, in_room_box ?ag <EFFECT> tail <ACTION> announce_room_empty <ACT_TYPE> announcement <PRE> [?ag](tail), tail, in_room_empty ?ag <EFFECT> tail"

    problem = "<GOAL>" + goal
    problem += "<INIT>" + init
    problem += act_string

    return problem

def solve(domain, problem):
    #path to plansformer model files
    model_path = "Planners/PlansformerS1/model_files"

    #using plansformer's tokenizer and model weights
    tokenizer = RobertaTokenizer.from_pretrained(model_path, local_files_only = True)
    model = T5ForConditionalGeneration.from_pretrained(model_path, local_files_only = True)
    model = model.to(device)
    #input problem/task
    problem = convert_input_to_string(domain,problem)

    #tokenizing the input and passing it to the model
    input_ids = tokenizer.encode(problem, return_tensors='pt').to(device, dtype = torch.long)
    generated_ids = model.generate(
        input_ids, num_beams = 2, max_length=input_ids.shape[-1] + 2,
        repetition_penalty = 2.5, length_penalty = 1.0,
        early_stopping=False, do_sample = True, return_dict_in_generate=True, output_scores=True)

    #obtaining the predicted plan from Plansformer for given input
    predicted_plan = [tokenizer.decode(g, skip_special_tokens=True) for g in generated_ids.sequences]

    gen_sequences = generated_ids.sequences[:1,1:]

    probs = torch.stack(generated_ids.scores, dim=1).softmax(-1)

    gen_probs = torch.gather(probs, 2, gen_sequences[:, :, None]).squeeze(-1)

    #gen_probs

    return torch.mean(gen_probs), predicted_plan
