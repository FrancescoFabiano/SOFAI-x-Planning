#!/usr/bin/env python
# Four spaces as indentation [no tabs]

import re
import itertools
import warnings
import copy
import os


from pathlib import Path

from .action import Action

DEBUG = False

class EPDDL_Parser:

    SUPPORTED_REQUIREMENTS = [':strips', ':negative-preconditions', ':typing', ':no-duplicates', ':mep']

    #-----------------------------------------------
    # Tokens
    #-----------------------------------------------

    def scan_tokens(self, filename):
        try:
            with open(filename,'r') as f:
                # Remove single line comments
                str = re.sub(r';.*$', '', f.read(), flags=re.MULTILINE).lower()
                str = re.sub(r'\[([^[]+)-agent(\s+|)\]', r'[\1]',str,flags=re.MULTILINE)

                nb_rep = 1

                while (nb_rep):
                        (str, nb_rep) = re.subn(r'\((\s|)+\(([^()]+)\)(\s|)+\)', r'\2',str,flags=re.MULTILINE)

                nb_rep = 1

                while (nb_rep):
                    (str, nb_rep) = re.subn(r'(\[[^[]+\])\(([^(]+)\)', r'\1\2',str,flags=re.MULTILINE)

            # Tokenize
            stack = []
            list = []
            isBF = 0
            insideBF = 0
            firstAg = 1
            countSqPa = 0
            multi_ag = 0
            Bf_string = ''
            for t in re.findall(r'[()\[\]]|[^\s()\[\]]+', str):
                if t == '(':
                    stack.append(list)
                    list = []
                elif t == ')':
                    if stack:
                        l = list
                        list = stack.pop()
                        list.append(l)
                    else:
                        raise Exception('Missing open parentheses')
                elif t == '[':
                    firstAg = 1
                    insideBF = 1
                    Bf_string = 'B('
                elif t == ']':
                    insideBF = 0
                    Bf_string += ','
                    if multi_ag == 1:
                        Bf_string = Bf_string.replace('B(', 'C(')
                    list.append(Bf_string)
                    multi_ag = 0
                elif insideBF == 1:
                    if firstAg == 0:
                        multi_ag = 1
                        Bf_string +=','
                    Bf_string +=t
                    firstAg = 0
                else:
                    list.append(t)
            if stack:
                raise Exception('Missing close parentheses')
            if len(list) != 1:
                raise Exception('Malformed expression')
            return list[0]

        except Exception as e: print(e)

    #-----------------------------------------------
    # Parse domain
    #-----------------------------------------------

    def parse_domain(self, domain_filename):
        tokens = self.scan_tokens(domain_filename)
        if type(tokens) is list and tokens.pop(0) == 'define':
            self.domain_name = 'unknown'
            self.requirements = []
            self.types = {}
            self.objects = {}
            self.actions = []
            self.predicates = {}
            while tokens:
                group = tokens.pop(0)
                t = group.pop(0)
                if t == 'domain':
                    self.domain_name = group[0]
                elif t == ':requirements':
                    for req in group:
                        if not req in self.SUPPORTED_REQUIREMENTS:
                            raise Exception('Requirement ' + req + ' not supported')
                    self.requirements = group
                elif t == ':constants':
                    self.parse_objects(group, t)
                elif t == ':predicates':
                    self.parse_predicates(group)
                elif t == ':types':
                    self.parse_types(group)
                elif t == ':action':
                    self.parse_action(group)
                else: self.parse_domain_extended(t, group)
        else:
            raise Exception('File ' + domain_filename + ' does not match domain pattern with \''+str(tokens)+'\'')

    def parse_domain_extended(self, t, group):
        print(str(t) + ' is not recognized in domain')

    #-----------------------------------------------
    # Parse hierarchy
    #-----------------------------------------------

    def parse_hierarchy(self, group, structure, name, redefine):
        list = []
        while group:
            if redefine and group[0] in structure:
                raise Exception('Redefined supertype of ' + group[0])
            elif group[0] == '-':
                if not list:
                    raise Exception('Unexpected hyphen in ' + name)
                group.pop(0)
                type = group.pop(0)
                if not type in structure:
                    structure[type] = []
                structure[type] += list
                list = []
            else:
                list.append(group.pop(0))
        if list:
            if not 'object' in structure:
                structure['object'] = []
            structure['object'] += list

    def parse_hierarchy_ag(self, group, structure, name, redefine):
        list = []
        while group:
            if redefine and group[0] in structure:
                raise Exception('Redefined supertype of ' + group[0])
            elif group[0] == '-':
                raise Exception('Unexpected hyphen in ' + name)
            else:
                list.append(group.pop(0))
        if list:
            if not 'agent' in structure:
                structure['agent'] = []
            structure['agent'] += list

    #-----------------------------------------------
    # Parse objects
    #-----------------------------------------------

    def parse_objects(self, group, name):
        self.parse_hierarchy(group, self.objects, name, False)

    def parse_agents(self, group, name):
        self.parse_hierarchy_ag(group, self.objects, name, False)

    # -----------------------------------------------
    # Parse types
    # -----------------------------------------------

    def parse_types(self, group):
        self.parse_hierarchy(group, self.types, 'types', True)

    #-----------------------------------------------
    # Parse predicates
    #-----------------------------------------------

    def parse_predicates(self, group):
        for pred in group:
            predicate_name = pred.pop(0)
            if predicate_name in self.predicates:
                raise Exception('Predicate ' + predicate_name + ' redefined')
            arguments = {}
            untyped_variables = []
            while pred:
                t = pred.pop(0)
                if t == '-':
                    if not untyped_variables:
                        raise Exception('Unexpected hyphen in predicates')
                    type = pred.pop(0)
                    while untyped_variables:
                        arguments[untyped_variables.pop(0)] = type
                else:
                    untyped_variables.append(t)
            while untyped_variables:
                arguments[untyped_variables.pop(0)] = 'object'
            self.predicates[predicate_name] = arguments



    #-----------------------------------------------
    # Parse action
    #-----------------------------------------------

    def parse_action(self, group):
        name = group.pop(0)
        if not type(name) is str:
            raise Exception('Action without name definition')
        for act in self.actions:
            if act.name == name:
                raise Exception('Action ' + name + ' redefined')
        parameters = []
        act_type = 'ontic'
        positive_preconditions = []
        negative_preconditions = []
        add_effects = []
        del_effects = []
        f_obs = []
        p_obs = []
        derive_cond = []
        explicit_eff = []
        extensions = None
        while group:
            t = group.pop(0)
            if t == ':parameters':
                if not type(group) is list:
                    raise Exception('Error with ' + name + ' parameters')
                parameters = []
                untyped_parameters = []
                p = group.pop(0)
                while p:
                    t = p.pop(0)
                    if t == '-':
                        if not untyped_parameters:
                            raise Exception('Unexpected hyphen in ' + name + ' parameters')
                        ptype = p.pop(0)
                        while untyped_parameters:
                            parameters.append([untyped_parameters.pop(0), ptype])
                    else:
                        untyped_parameters.append(t)
                while untyped_parameters:
                    parameters.append([untyped_parameters.pop(0), 'object'])
            elif t == ':act_type':
                act_type = self.assign_act_type(group.pop(0))
            elif t == ':precondition':
                self.split_predicates(group.pop(0), positive_preconditions, negative_preconditions, name, ' preconditions')
            elif t == ':effect':
                #self.split_effects(group.pop(0), add_effects, del_effects, name, ' effects')
                self.recoursive_reading(group.pop(0), [['']], [['']], [['']], 0, add_effects, del_effects, name, ' effects')

            #    print(str([list(i) for i in add_effects]))
            #    print(str([list(i) for i in del_effects]))
            elif t == ':observers':
                #self.read_observer(group.pop(0), f_obs, name, ' agents')
                self.recoursive_reading(group.pop(0), [['']], [['']], [['']], 0, f_obs, [], name, ' agents')

            elif t == ':p_observers':
                self.recoursive_reading(group.pop(0), [['']], [['']], [['']], 0, p_obs, [], name, ' agents')
            elif t == ":derive":
                derive_cond = group.pop(0)
            elif t == ":exp_effect":
                explicit_eff = group.pop(0)
            else: extensions = self.parse_action_extended(t, group)
        self.actions.append(Action(name, act_type, parameters, positive_preconditions, negative_preconditions, add_effects, del_effects, f_obs, p_obs, derive_cond, explicit_eff, extensions))

    def parse_action_extended(self, t, group):
        print(str(t) + ' is not recognized in action')

    #-----------------------------------------------
    # Parse problem
    #-----------------------------------------------

    def parse_problem(self, problem_filename):

        #Default depth value
        self.depth = 2

        def frozenset_of_tuples(data):
            return frozenset([tuple(t) for t in data])
        tokens = self.scan_tokens(problem_filename)
        if type(tokens) is list and tokens.pop(0) == 'define':
            self.problem_name = 'unknown'
            self.state = frozenset()
            self.positive_goals = frozenset()
            self.negative_goals = frozenset()
            self.dynamicCK = "false"
            while tokens:
                group = tokens.pop(0)
                t = group.pop(0)
                if t == 'problem':
                    self.problem_name = group[0]
                elif t == ':domain':
                    if self.domain_name != group[0]:
                        raise Exception('Different domain specified in problem file')
                elif t == ':requirements':
                    pass # Ignore requirements in problem, parse them in the domain
                elif t == ':objects':
                    self.parse_objects(group, t)
                elif t == ':agents':
                    self.parse_agents(group, t)
                elif t == ':depth':
                    self.depth = group[0]
                elif t == ':dynck':
                    self.dynamicCK = group[0]
                elif t == ':init':
                    init = []
                #    tmp_group = []
                #    tmp_group.insert(0, 'and')
                #    tmp_group.insert(1, group)
                    group.insert(0,'and')
                    self.split_predicates(group, init, [], '', 'init')
                    self.state = init
                elif t == ':goal':
                    positive_goals = []
                    negative_goals = []
                    group.insert(0,'and')
                    self.split_predicates(group, positive_goals, negative_goals, '', 'goals')
                    self.positive_goals = positive_goals
                    self.negative_goals = negative_goals
                else: self.parse_problem_extended(t, group)
        else:
            raise Exception('File ' + problem_filename + ' does not match problem pattern')

    def parse_problem_extended(self, t, group):
        print(str(t) + ' is not recognized in problem')

    #-----------------------------------------------
    # Split predicates
    #-----------------------------------------------

    def split_predicates(self, group, positive, negative, name, part):
        if not type(group) is list:
            raise Exception('Error with ' + name + part)
        if group[0] == 'and':
            group.pop(0)
        else:
            group = [group]
        for predicate in group:
            #print("Here with predicate[0] == " + str(predicate[0]))
            if 'B(' in predicate[0] or 'C(' in predicate[0]:
                if type(predicate[1]) is list:
                    if predicate[1][0] == 'not':
                        if len(predicate[1][1]) > 0:
                            i = 0
                            tmp_predicate=[]
                            tmp_predicate.insert(0,predicate[0])
                            while i < len(predicate[1][1]):
                                if (i == 0):
                                    tmp_predicate.insert(i+1,'-'+predicate[1][1][0])
                                else:
                                    tmp_predicate.insert(i+1,predicate[1][1][i])
                                i = i+1
                            predicate = tmp_predicate
                        else:
                            raise Exception('Expected predicate after a \'not\'')

            if predicate[0] == 'not':
                if len(predicate) != 2:
                    raise Exception('Unexpected not in ' + name + part)
                negative.append(predicate[-1])
                #print("Appended " + str(predicate[-1]))
            else:
                positive.append(predicate)

    def recoursive_reading(self, body, head_positive, head_negative, diff, subProcedure, positive, negative, name, part):
        if not type(body) is list:
            raise Exception('Error with ' + name + part)

        if body[0] == 'and':
            body.pop(0)
            and_count = 0
            total_body = []
            while and_count < len(body):
                total_body.append(self.recoursive_reading(body[and_count], head_positive, head_negative, diff, subProcedure, positive, negative, name, part))
                and_count = and_count + 1

            #print("Total body: " + str(total_body))
            ret = ([],[])
            for elem in total_body:
                if elem:
                #    print("Elem: " + str(elem))
                    if elem[1] == 0:
                        ret[0].append(elem[0])
                    else:
                        ret[1].append(elem[0])

            return ret


        elif body[0] == 'when':
            body.pop(0)
            condition = body[0]
            body.pop(0)
            #if type(condition) is list:
            if (condition[0] == 'when' or condition[0] == 'forall'):
                raise Exception('Error with ' + name + part + ' you cannot embed other keywords, other than \'and\', in the \'when\' condition')
            elif condition[0] == 'and':
                condition = self.recoursive_reading(condition, [['']], [['']], [['']], 1, positive, negative, name, part)
                pos_condition = condition[0]
                neg_condition = condition[1]

            elif condition[0] == 'not':
                condition.pop(0)
                neg_condition = condition
                pos_condition = [['']]

            else:
                pos_condition = [condition]
                neg_condition = [['']]

            rule = body[0]
            body.pop(0)
            if (rule[0] == 'when' or rule[0] == 'forall'):
                raise Exception('Error with ' + name + part + ' you cannot embed other keywords, other than \'and\', in the \'when\' body')

            self.recoursive_reading(rule,pos_condition,neg_condition, diff, subProcedure, positive, negative, name, part)
            return(rule,pos_condition,neg_condition)

        elif body[0] == 'forall':
            if part != ' agents':
                raise Exception('\'Forall\' keyword only implemented for agents')
            else:
                body.pop(0)
                head = body[0]
                body.pop(0)
                #if type(condition) is list:
                #make sense inside forall
                if head[0] == 'diff':
                    head.pop(0)
                    if len(head) != 2:
                        raise Exception('Bad \'diff\' construction')
                    else:
                        diff = [head[1]]
                        head = head[0]

                if (head[0] == 'when' or head[0] == 'forall' or head[0] == 'and' or head[0] == 'not'):
                    raise Exception('Error with ' + name + part + ' you cannot embed other keywords in the \'forall\' condition')
                else:
                    fa_start = "FASTART"
                    fa_stop = "FASTOP"
                    rule = body[0]
                    body.pop(0)
                    for v in head:
                        if '?' in v:
                            if v in rule:
                                rule[rule.index(v)] =  fa_start + rule[rule.index(v)] + fa_stop
                                self.recoursive_reading(rule,[['']], [['']],[['']], subProcedure, positive, negative, name, part)
                            elif rule[0] == 'when':
                                parsed_rule = self.recoursive_reading(rule,[['']], [['']],[['']], 1, positive, negative, name, part)

                                i = 0
                                while i < 3:
                                    if i > 0:
                                        j = 0
                                        while j < len(parsed_rule[i]):
                                            if v in parsed_rule[i][j]:
                                                parsed_rule[i][j][parsed_rule[i][j].index(v)] =  fa_start + parsed_rule[i][j][parsed_rule[i][j].index(v)] + fa_stop
                                            j = j+1
                                    else:
                                        if v in parsed_rule[i]:
                                            parsed_rule[i][parsed_rule[i].index(v)] =  fa_start + parsed_rule[i][parsed_rule[i].index(v)] + fa_stop
                                    i = i+1
                                self.recoursive_reading(parsed_rule[0],parsed_rule[1],parsed_rule[2], diff, subProcedure, positive, negative, name, part)
                            else:
                                raise Exception('To many nested command in the agents\' observability\n' + str(rule))


        elif body[0] == 'not':
            if len(body) != 2:
                raise Exception('Unexpected not in ' + name + part)
            if subProcedure == 0:
                negative.append((body[-1], head_positive, head_negative,diff))
            return (body[-1], 1)

        else:
            if subProcedure == 0:
                positive.append((body, head_positive, head_negative,diff))
            return (body, 0)

    def assign_act_type(self, name):
        name = name.lower()
        if name == 'ontic' or name == 'announcement' or name == 'sensing':
            return name.lower()
        else:
            raise Exception('Error with the action type definition. Please select one of the following: \'ontic\', \'sensing\', \'announcement\'')


    #-----------------------------------------------
    # Print EFP
    #-----------------------------------------------
    def print_EFP(self,output_folder):
        #########File NAME
        Path(output_folder).mkdir(parents=True,exist_ok=True)




        file_name = self.domain_name + '_' + self.problem_name
        out = open(output_folder +  file_name+".tmp", "w")
        out.write("%This file is automatically generated from an E-PDDL specification and follows the mAp syntax.\n\n")

        #Generate grounded actions and add grounded fluents
        fluents = set()
        ground_actions = []
        for action in self.actions:
            for act in action.groundify(self.objects, self.types, self.requirements, fluents):
                act_name = act.name
                for parameter in act.parameters:
                    act_name += '_'+parameter
                act.name = act_name
                ground_actions.append(act)
        #########FLuents
        self.generate_fluents_EFP(fluents)
        if '' in fluents:
            fluents.remove('')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%    FLUENTS    %%%%%%%%%%%%%%%%%%%%%%%%\n')
        out.write('%Fluents generated from EPDDL by grounding each predicate (and cheking in :init, :goal and actions for extra predicates)\n')
        out.write('%The fluents are lexicographically sorted and printed in sets of 10\n\n')
        out.write('fluent ')
        fl_count = 0
        for fluent in sorted(fluents):
            out.write(str(fluent))
            if (fl_count != len(fluents)-1):
                if((fl_count+1)%10 == 0):
                    out.write(';\nfluent ')
                else:
                    out.write(', ')
                fl_count +=1
        self.fl_number = (fl_count +1)
        out.write(';\n\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')

        #########Actions Names
        out.write('%%%%%%%%%%%%%%%%%%%%%    ACTIONS\' NAMES    %%%%%%%%%%%%%%%%%%%%%\n')
        out.write('%Actions\' names generated from EPDDL by adding to each action names its grounded predicates\n\n')
        out.write('action ')
        act_count = 0
        for action in ground_actions:
            out.write(action.name)
            if (act_count != len(ground_actions)-1):
                if((act_count+1)%10 == 0):
                    out.write(';\naction ')
                else:
                    out.write(', ')
                act_count +=1
        self.act_number = (act_count +1)
        out.write(';\n\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')


        out.write('%%%%%%%%%%%%%%%%%%%%%    AGENTS\' NAMES    %%%%%%%%%%%%%%%%%%%%%%\n')
        out.write('%Agents\' names generated from EPDDL by looking at the \'agent\' predicate\n\n')
        out.write('agent ')
        ag_count = 0
        for agent in self.objects['agent']:
            out.write(agent)
            if (ag_count != len(self.objects['agent'])-1):
                if((ag_count+1)%10 == 0):
                    out.write(';\nagent ')
                else:
                    out.write(', ')
                ag_count +=1
        self.ag_number = (ag_count + 1)
        out.write(';\n\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')


        #########Actions Specifications
        out.write('%%%%%%%%%%%%%%%%%    ACTIONS\' SPECIFICATIONS    %%%%%%%%%%%%%%%%\n')
        out.write('%Actions\' specifications generated from EPDDL by grounding each action\'s definition\n\n')
        for action in ground_actions:
            out.write('%%%Action ' + action.name + '\n\n')
            out.write('executable ' + action.name)
            self.print_precondition_EFP(action, out)
            self.print_effects_EFP(action, out)
            self.print_observers_EFP(action, 1, out)
            self.print_observers_EFP(action, 0, out)
            out.write('\n%%%\n\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')

        #########Actions Specifications
        out.write('%%%%%%%%%%%%%%%%%%    INITIAL FLUENTS TRUTH   %%%%%%%%%%%%%%%%%%\n')
        out.write('%Fluents are considered true when are inserted in :init; otherwise are considered false\n\n')
        out.write('%%%True fluents\n')
        out.write('initially ')
        ini_count = 0
        true_fluents = set()
        belief_ini= set()
        temp_ini = list(self.state)
        for index, ini_f in enumerate(temp_ini):
            ini_fs = self.unify_fluent_EFP(ini_f)
            if 'B(' in ini_fs or 'C(' in ini_fs:
                belief_ini.add(ini_fs)
            else:
                out.write(ini_fs)
                true_fluents.add(ini_fs)
                if ( (index+1 < len(temp_ini)) and ('B(' not in temp_ini[index+1][0]  and 'C(' not in temp_ini[index+1][0])):
                    out.write(', ')
        out.write(';\n')
        neg_fluents = fluents - true_fluents

        out.write('%%%False fluents\n')
        out.write('initially ')
        ini_count = 0
        for ini_f in neg_fluents:
            out.write('-'+ini_f)
            if (ini_count != len(neg_fluents)-1):
                out.write(', ')
                ini_count+=1
        out.write(';\n')
        out.write('\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')


        out.write('%%%%%%%%%%%%%%%%%%    INITIAL BELIEFS TRUTH   %%%%%%%%%%%%%%%%%%\n')
        out.write('%Extracted from the :init field\n\n')
        ini_count = 0
        for ini_bf in belief_ini:
            out.write('initially ')
            out.write(ini_bf)
            if (ini_count != len(belief_ini)-1):
                out.write(';\n')
                ini_count+=1
        if (len(belief_ini) > 0):
            out.write(';\n')
        out.write('\n')
        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n')

        out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%    GOALS   %%%%%%%%%%%%%%%%%%%%%%%%%%\n')
        out.write('%The goals of the plan. Each goal is presented separately to ease the reading\n\n')
        for goal_f in self.positive_goals:
            out.write('goal ')
            goal_fs = self.unify_fluent_EFP(goal_f)
            out.write(goal_fs + ';\n')

        for goal_f in self.negative_goals:
            out.write('goal (-')
            goal_fs = self.unify_fluent_EFP(goal_f)
            out.write(goal_fs + ');\n')

        out.write('\n')
    #    out.write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n')
        out.close()
        return file_name+".tmp"

    def unify_fluent_EFP(self,given_list):
        return Action.unify_fluent_EFP(given_list)

    def generate_fluents_EFP(self, fluents_set):

        for ini_f in self.state:
            fluent = self.unify_fluent_EFP(ini_f)
            if 'B(' not in fluent and 'C(' not in fluent and not '-' in fluent:
                fluents_set.add(fluent)

        for goal_f in self.positive_goals:
            fluent = self.unify_fluent_EFP(goal_f)
            if 'B(' not in fluent and 'C(' not in fluent and not '-' in fluent:
                fluents_set.add(fluent)

        for goal_f in self.negative_goals:
            fluent = self.unify_fluent_EFP(goal_f)
            if 'B(' not in fluent and 'C(' not in fluent and not '-' in fluent:
                fluents_set.add(fluent)

        #duplicates = True
        duplicates = False
        if ':no-duplicates' in self.requirements:
            duplicates = False
        for predicate in self.predicates.items():
            #print('original:' + str(predicate))
            type_map = []
            variables = []
            pred_ini=[]
            pred_ini.append(predicate[0])
            for var in self.predicates[predicate[0]]:
                type = self.predicates[predicate[0]][var]
                #print ('Type: ' + str(type) + ' var: ' + var + ' predicate: ' + predicate[0])
                pred_ini.append(var)
                type_stack = [type]
                items = []
                while type_stack:
                    t = type_stack.pop()
                    if t in self.objects:
                        items += self.objects[t]
                    elif t in self.types:
                        type_stack += self.types[t]
                    else:
                        raise Exception('Unrecognized type ' + t)
                type_map.append(items)
                variables.append(var)
            for assignment in itertools.product(*type_map):
                if (not duplicates and len(assignment) == len(set(assignment))) or duplicates:
                    #pred = predicate
                    pred = list(pred_ini)
                    iv = 0
                #    print(str(variables))
                #    print(str(assignment))
                    for v in variables:
                        while v in pred:
                            pred[pred.index(v)] = assignment[iv]
                        iv += 1
                    fluent = self.unify_fluent_EFP(pred)
                    if 'B(' not in fluent and 'C(' not in fluent and not '-' in fluent:
                        fluents_set.add(fluent)

    def print_precondition_EFP(self,action,out):
        if (len(action.positive_preconditions)+len(action.negative_preconditions) > 0):
            out.write(' if ' )
            #+ str([list(i) for i in action.positive_preconditions]) +  str([list(i) for i in action.negative_preconditions]))
            self.subprint_precondition_EFP(action, 1, out)
            self.subprint_precondition_EFP(action, 0, out)
        out.write(';\n')

    def reorder_bf_list(self, list):
        ret = []
        for elem in list:
            if 'B(' in elem[0]:
                ret.insert(0,elem)
            else:
                ret.append(elem)
        return ret

    def subprint_precondition_EFP(self,action,is_postive,out):
        positive_pre = True
        if (is_postive == 1):
            preconditions = action.positive_preconditions
        else:
            positive_pre = False
            preconditions = action.negative_preconditions
        count = 0
        preconditions = self.reorder_bf_list(preconditions)
        for i in preconditions:
            fluent = self.unify_fluent_EFP(i)
            if (positive_pre):
                out.write(fluent)
            else:
                out.write('-'+ fluent + '')
            if (count < len(preconditions)-1) or (positive_pre and len(action.negative_preconditions) > 0):
                out.write(', ')
                count +=1

    def print_effects_EFP(self,action,out):
        if (action.act_type == 'sensing'):
            act_type = ' determines '
        elif (action.act_type == 'announcement'):
            act_type = ' announces '
        else:
            act_type = ' causes '

        if (len(action.add_effects) > 0):
            for i in action.add_effects:
                out.write(action.name + act_type)
                fluent = self.unify_fluent_EFP(i[0])
                out.write(fluent)
                self.print_conditions_EFP(i[1],i[2],out)

                out.write(';\n')

        if (len(action.del_effects) > 0):
            for i in action.del_effects:
                out.write(action.name + act_type)
                fluent = self.unify_fluent_EFP(i[0])
                out.write('-'+ fluent + '')
                self.print_conditions_EFP(i[1],i[2],out)

                out.write(';\n')

    def print_observers_EFP(self,action,fully,out):
        if fully == 1:
            obs_type = ' observes '
            observers = action.observers
        else:
            obs_type = ' aware_of '
            observers = action.p_observers

        if (len(observers) > 0):
            for ags in observers:
                for ag in ags[0]:
                    if 'FASTART' in ag:
                        for agent in self.objects['agent']:
                            notPrint = 0
                            if ags[3][0][0] != '':
                                if agent == ags[3][0][0]:
                                    notPrint = 1
                            if notPrint == 0:
                                tmp_cond = [[]]
                                self.copy_cond_list(ags,tmp_cond)

                                out.write(agent + obs_type + action.name)
                                self.substitute_ag(tmp_cond[1],agent)
                                self.substitute_ag(tmp_cond[2],agent)

                                self.print_conditions_EFP(tmp_cond[1],tmp_cond[2],out)
                                out.write(';\n')
                    else:
                        out.write(str(ag) + obs_type + action.name)
                        self.print_conditions_EFP(ags[1],ags[2],out)
                        out.write(';\n')

    def copy_cond_list(self, agents, temp):
        i = 0
        while i < len(agents):
            sub_temp = []
            j = 0
            while j < len(agents[i]):
                if i > 0:
                    k = 0
                    sub_sub_temp = []
                    while k < len(agents[i][j]):
                        sub_sub_temp.insert(k,agents[i][j][k])
                        k = k+1
                else:
                    sub_sub_temp = agents[i][j]
                sub_temp.insert(j, sub_sub_temp)
                j = j+1
            temp.insert(i, sub_temp)
            i = i+1

    def substitute_ag(self, conds, agent):
        for cond in conds:
            for elem in cond:
                if 'FASTART' in elem:
                    conds[conds.index(cond)][cond.index(elem)] = re.sub(r'(FASTART\S+FASTOP)', agent ,elem)

    def print_conditions_EFP(self,pos_cond,neg_cond,out):
        yet_to_print = 1
        if self.subprint_cond_EFP(pos_cond,1,out, yet_to_print) == 1:
            yet_to_print = 0;
        self.subprint_cond_EFP(neg_cond,0,out, yet_to_print);

    def subprint_cond_EFP(self,conditions,isPos,out, yet_to_print):
        printed = 0
        for condition in conditions:
            if '' in condition:
                condition.remove('')

        for condition in conditions:
            if not condition:
                conditions.remove(condition)

        if conditions:
            count_cond = 0
            if (yet_to_print == 1):
                out.write( ' if ' )
                printed = 1
            else:
                out.write(', ')
            conditions = self.reorder_bf_list(conditions)
            for condition in conditions:
                cond = self.unify_fluent_EFP(condition)
                if not isPos:
                    out.write('-')
                out.write(cond)
                if count_cond < len(conditions)-1:
                    out.write(', ')
                    count_cond = count_cond +1

        return printed

    #-----------------------------------------------
    # Print PDKB
    #-----------------------------------------------
    def print_PDKB(self,output_folder):
        #########File NAME
        Path(output_folder).mkdir(exist_ok=True)
        return self.print_domain_pdkb(output_folder), self.print_problem_pdkb(output_folder)

    def print_domain_pdkb(self, output_folder):
        pdkb_domain_name = self.domain_name+".pdkbpddl"
        out = open(output_folder + pdkb_domain_name, "w")
        out.write(";This file is automatically generated from an E-PDDL specification and follows the PDKB-PDDL syntax.\n\n")

        out.write(';;;;;;;;;;;;;;;;;;;;    DOMAIN\'S FEATURES    ;;;;;;;;;;;;;;;;;;;\n\n')

        out.write('(define (domain ' + self.domain_name +')\n\n')

        count_types = 0
        out.write('\t(:agents')
        for elem in self.objects['agent']:
            out.write(' ' + elem)
        out.write(')\n\n')

        out.write('\t(:constants)\n\n')

        count_types = 0
        out.write('\t(:types')
        for elem in self.types:
            for el in self.types[elem]:
                out.write('\n\t  ' + el)
                if count_types == len(self.types[elem])-1:
                    out.write('\n\t')
                count_types = count_types+1

        out.write(')\n\n')

        out.write('\t(:predicates')
        for elem in self.predicates:
            out.write( ' (' + elem)
            for el in self.predicates[elem]:
                out.write(' ' + el + ' - ',)
                out.write(self.predicates[elem][el])
            out.write(')')
        out.write(')\n\n')

        out.write(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n')


        out.write(';;;;;;;;;;;;;;;;;    ACTIONS\' SPECIFICATIONS    ;;;;;;;;;;;;;;;;\n\n')

        for action in self.actions:
            out.write(';;;Action ' + action.name + '\n\n')
            out.write('\t(:action ' + action.name + '\n')
            self.print_parameters_PDKB(action, out)
            if not self.print_expl_derive_condition_PDKB(action,out):
                self.print_derive_condition_PDKB(action, out)
            self.print_precondition_PDKB(action, out)
            if not self.print_expl_effects_PDKB(action,out):
                self.print_effects_PDKB(action, out)

            #self.print_observers_EFP(action, 0, out)
            out.write('\t)\n;;;\n\n')
        out.write(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n')

        out.write(')')
        return pdkb_domain_name

    def print_problem_pdkb(self, output_folder):
        pdkb_problem_name = self.problem_name+".pdkbpddl"
        out = open(output_folder + pdkb_problem_name, "w")
        out.write(";This file is automatically generated from an E-PDDL specification and follows the PDKB-PDDL syntax.\n\n")
        out.write('{include:'+self.domain_name+'.pdkbpddl}\n\n')
        out.write('(define (problem '+self.problem_name+')\n')

        out.write('\n\t(:domain ' + self.domain_name + ')\n')
        out.write('\n\t(:depth '+str(self.depth)+')\n')

        if len(self.objects) > 1:
            out.write('\n\t(:objects\n')
            for obj in self.objects:
                if obj != 'agent':
                    out.write('\t\t')
                    for elem in self.objects[obj]:
                        out.write(str(elem)+ ' ')
                    out.write('- ' + str(obj) + '\n')
            out.write('\t)\n')

        out.write('\n\t(:projection )\n')
        out.write('\n\t(:task valid_generation)\n')

        #init print
        out.write('\n\t(:init-type complete)')
        out.write('\n\t(:init')
        t_depth = 1
        while (t_depth <= int(self.depth)):
            out.write("\n\n\t\t;Depth " + str(t_depth))
            for ini_f in self.state:
                ini_fs = self.unify_fluent_init_PDKB(ini_f,t_depth)
                if ini_fs != '':
                    out.write('\n\n' + ini_fs)
            t_depth+=1


        out.write('\n\t)')
        out.write('\n')

        #goal print
        out.write('\n\t(:goal ')
        for goal_f in self.positive_goals:
            goal_fs = self.unify_fluent_PDKB(goal_f)
            out.write('\n\t  ' + goal_fs)

        for goal_f in self.negative_goals:
            goal_fs = self.unify_fluent_PDKB(goal_f)
            out.write('\n\t  !' + goal_fs)
        out.write('\n\t)')
        out.write('\n)')
        return pdkb_problem_name

    def print_parameters_PDKB(self, action, out):
        out.write('\t\t:parameters\t\t\t (')
        count_param = 0
        for param in action.parameters:
            out.write(param[0] + ' - ' + param[1])
            count_param = count_param+1
            if (count_param < len(action.parameters)):
                out.write(' ')
        out.write(')\n')

    def print_expl_derive_condition_PDKB(self,action,out):
        if (len(action.derive_cond) > 0):
            out.write('\t\t:derive-condition\t (')
            out.write(self.unify_fluent_PDKB(action.derive_cond, True))
            out.write(')\n')
            return True

        return False

    def print_derive_condition_PDKB(self,action,out):
        out.write('\t\t:derive-condition\t (')
        observers = action.observers
        visited = False
        if (len(observers) > 0):
            for ags in observers:
                for ag in ags[0]:
                    if 'FASTART' in ag:
                        if visited == True:
                            raise Exception('PDKB coversion cannot handle mutiple Fully Observants Group, make use of the explicit fields.')

                        visited = True
                        if  (len(ags[3]) > 0) and DEBUG:
                            print("\n********CONVERSION WARNING********")
                            print("The \'diff\' operator cannot be directly translated to PDKB and therefore will be ignored.")
                            print("You should make use of the more explicit fields.")
                            print("**********************************\n")

                        if len(ags[1]) == 1 and self.unify_fluent_PDKB(ags[1][0]) != '':

                            if ags[1] == ags[2]:
                                out.write('always')

                            else:
                                der_cond = self.unify_fluent_PDKB(ags[1][0])

                                der_cond = re.sub(r'FASTART(\S)+FASTOP', r'$agent$',der_cond)
                                out.write(der_cond)
                        elif len(ags[2]) == 1:
                            der_cond = self.unify_fluent_PDKB(ags[2][0])
                            der_cond = re.sub(r'FASTART(\S)+FASTOP', r'$agent$',der_cond)
                            out.write('!' + der_cond)
#                            raise Exception('PDKB coversion cannot handle negative condition for Fully Observants Groups, make use of the explicit fields.')
                        elif len(ags[1]) > 1 or len(ags[2]) >1:
                            raise Exception('PDKB coversion cannot handle mutiple Fully Observants Groups, make use of the explicit fields.')
                        else:
                            raise Exception('PDKB coversion cannot handle strange specification for Fully Observants Groups, make use of the explicit fields.')


                        #self.print_conditions_PDKB(ags[1],ags[2],out)
                        out.write(')\n')

        if visited == False:
            out.write('never)\n')

    def print_precondition_PDKB(self,action,out):
        #if (len(action.positive_preconditions)+len(action.negative_preconditions) > 0):
            out.write('\t\t:precondition\t\t (and' )
            #+ str([list(i) for i in action.positive_preconditions]) +  str([list(i) for i in action.negative_preconditions]))
            self.subprint_precondition_PDKB(action, 1, out)
            self.subprint_precondition_PDKB(action, 0, out)
            out.write(')\n')

    def subprint_precondition_PDKB(self,action,is_postive,out):
        positive_pre = True
        if (is_postive == 1):
            preconditions = action.positive_preconditions
        else:
            positive_pre = False
            preconditions = action.negative_preconditions
        for i in preconditions:
            fluent = self.unify_fluent_PDKB(i)

            if not positive_pre:
                fluent = '!'+ fluent

            if not '[' in fluent:
                fluent  = '('+ fluent + ')'

            out.write(' '+ fluent)

    def print_expl_effects_PDKB(self,action,out):
        if (len(action.explicit_eff) > 0):
            out.write('\t\t:effect\t\t\t\t (')
            print ("Effects are: " + str(action.explicit_eff) + " normal are " + str(action.positive_preconditions))
            out.write(self.unify_fluent_PDKB(action.explicit_eff, True))
            out.write(')\n')
            return True

        return False

    def print_effects_PDKB(self,action,out):

    #    if (len(action.p_observers) > 0):
    #        print("\n********CONVERSION WARNING********")
    #        print("Partial observability cannot be directly translated to PDKB and therefore will be ignored.")
    #        print("You should make use of the more explicit fields.")
    #        print("**********************************\n")

        out.write('\t\t:effect\t\t\t\t (and' )
        is_ontic = True;
        if (action.act_type == 'sensing' or action.act_type == 'announcement'):
            is_ontic = False

        printed = False
        self.subprint_effects_PDKB(action, out, is_ontic, printed, True)
        self.subprint_effects_PDKB(action, out, is_ontic, printed, False)
        out.write(')\n')

    def subprint_effects_PDKB(self,action,out,is_ontic,printed, is_pos):
        ag_printed = False
        p_ag_printed = False

        count = 0
        if (is_pos):
            effects = action.add_effects
        else:
            effects = action.del_effects

        if (len(effects) > 0):
            for i in effects:
                if count == 3:
                    count = 0
                    out.write('\n\t\t\t\t\t\t\t ')
                fluent = self.unify_fluent_PDKB(i[0])
                if self.print_conditions_PDKB(i[1],i[2],out) == 1:
                    printed = True
                if (is_ontic):
                    count = count + 1
                    if (is_pos):
                        out.write(' ('+ fluent + ')')
                    else:
                        out.write(' (!'+ fluent + ')')


                if (len(action.observers) > 0):
                    for ags in action.observers:
                        for ag in ags[0]:
                            if not 'FASTART' in ag:
                                if self.print_conditions_PDKB(ags[1],ags[2],out) == 1:
                                    ag_printed = True
                                else:
                                    ag_printed = False
                                if count == 3:
                                    count = 0
                                    out.write('\n\t\t\t\t\t\t\t ')
                                    count = count + 1
                                out.write(' [' + ag + '](')
                                if (is_pos):
                                    out.write(fluent + ')')
                                else:
                                    out.write('!'+fluent + ')')

                                if (len(action.p_observers) > 0):
                                    for p_ags in action.p_observers:
                                        for p_ag in p_ags[0]:
                                            if not 'FASTART' in p_ag:
                                                if self.print_conditions_PDKB(p_ags[1],p_ags[2],out) == 1:
                                                    p_ag_printed = True
                                                else:
                                                    p_ag_printed = False
                                                if count == 3:
                                                    count = 0
                                                    out.write('\n\t\t\t\t\t\t\t ')
                                                count = count + 1
                                                out.write(' [' + p_ag + '][' + ag + '](or')
                                                out.write(' ('+fluent + ')')
                                                out.write(' (!'+fluent + '))')
                                            elif (DEBUG):
                                                print("\n********CONVERSION WARNING********")
                                                print("Partial observability has not fully integrated the FORALL operator.")
                                                print("You should make use of the more explicit fields if the results are not correct.")
                                                print("**********************************\n")
                                if p_ag_printed:
                                    out.write(')')
                                    p_ag_printed = False

                            elif (DEBUG):
                                print("\n********CONVERSION WARNING********")
                                print("Observability has not fully integrated the FORALL operator.")
                                print("Please, check the resulting conversion.\nYou should make use of the more explicit fields if the results are not correct.")
                                print("**********************************\n")
                    if ag_printed:
                        out.write(')')
                        ag_printed = False

                        #print ("Obs of " + action.name + ": " + str(ags))
                        #for ag in ags[0]:
                        #    if not 'FASTART' in ag:
                        #        if count == 3:
                        #            count = 0
                        #            out.write('\n\t\t\t\t\t\t\t ')
                        #        count = count + 1
                        #        out.write(' [' + ag + '](')
                        #        if (is_pos):
                        #            out.write(fluent + ')')
                        #        else:
                        #            out.write('!'+fluent + ')')



                elif not is_ontic:
                    raise Exception('Each action needs at least one fully observant agent.')
                if printed == True:
                    out.write(')')

    def print_conditions_PDKB(self,pos_cond,neg_cond,out):
        yet_to_print = 1
        if self.subprint_cond_PDKB(pos_cond,1,out, yet_to_print) == 1:
            yet_to_print = 0;
        if self.subprint_cond_PDKB(neg_cond,0,out, yet_to_print) == 1 or yet_to_print == 0:
            out.write(")")
            return 1
        return 0

    def subprint_cond_PDKB(self,conditions,isPos,out, yet_to_print):
        printed = 0
        for condition in conditions:
            if '' in condition:
                condition.remove('')

        for condition in conditions:
            if not condition:
                conditions.remove(condition)

        if conditions:
            count_cond = 0
            if (yet_to_print == 1):
                out.write( ' (when (and (' )
                printed = 1
            else:
                out.write(' (')
            for condition in conditions:
                cond = self.unify_fluent_PDKB(condition)
                if not isPos:
                    out.write('!')
                out.write(cond)
                if count_cond < len(conditions):
                    out.write(')')
                    count_cond = count_cond +1
        return printed

    def unify_fluent_init_PDKB(self,given_list, t_depth, no_change = False):
        ret = ''
        count = 1
        found = False
        to_reprint = False

        if t_depth == 1:
            to_reprint = True

        new_list = copy.deepcopy(given_list)
        for elem in given_list:
            if 'C(' in elem:
                if len(self.objects['agent']) == elem.count(','):
                    to_reprint = True
                    if not found:
                        found = True
                    else:
                        return ('\t\t('+ self.unify_fluent_PDKB(given_list)+') ')

                    del new_list[new_list.index(elem)]

                    while count <= t_depth:
                        ag_name = '?ag'+str(count)
                        new_list.insert(0,'B('+ag_name+',')
                        t_count = 0
                        ret += ('\t\t(forall ' + ag_name + ' - agent\n')
                        while t_count < count:
                            ret += '\t'
                            t_count += 1
                        count += 1

        if to_reprint:
            ret+='\t\t'
            if not found:
                ret+= '('
                count += 1

            ret += self.unify_fluent_PDKB(new_list)

            while count > 1:
                ret += ')'
                count -= 1
            #ret+='\n'

        return ret

    def unify_fluent_PDKB(self,given_list, no_change = False):
        return Action.unify_fluent_PDKB(given_list, no_change, False)


#-----------------------------------------------
# Main
#-----------------------------------------------
if __name__ == '__main__':
    import sys, pprint
    domain = sys.argv[1]
    problem = sys.argv[2]
    parser = EPDDL_Parser()
#    print('----------------------------')
#    pprint.pprint(parser.scan_tokens(domain))
#    print('----------------------------')
#    pprint.pprint(parser.scan_tokens(problem))
#    print('----------------------------')
    parser.parse_domain(domain)
    parser.parse_problem(problem)
    output_folder = "exp/tmp"
    parser.print_EFP(output_folder)
    print("\nThe given files have been correctly converted to mAp.")
    print("The resulting file, called \'" +parser.domain_name+"_"+parser.problem_name+".tmp\', is in the \'"+output_folder+"\' folder.\n")


    f = open("exp/tmp/lastcreated.tmp", "w")

    p, domain_name_from_file = os.path.split(domain)
    domain_name_from_file = domain_name_from_file.rsplit('.', 1)[0]

    p, problem_name_from_file = os.path.split(problem)
    problem_name_from_file = problem_name_from_file.rsplit('.', 1)[0]

    f.write(domain_name_from_file+"_"+problem_name_from_file+".tmp")
    f.close()


    #parser.print_PDKB()
    #print("\nThe given files have been correctly converted to PDKB-PDDL.")
    #print("The resulting files, called \'" +parser.domain_name+".pdkpddl\' and \'" +parser.problem_name+".pdkpddl\', are in the \'out\pdkb\' folder.\n")
#    print('State: ' + str(parser.state))
#    for act in parser.actions:
#        print(act)
#    for action in parser.actions:
#        for act in action.groundify(parser.objects, parser.types, parser.requirements, fluents):
#            print(act)
#    print('----------------------------')
#    print('Problem name: ' + parser.problem_name)
#    print('Objects: ' + str(parser.objects))
    #print('Predicates: ' + str(parser.predicates)
#    print('State: ' + str(parser.state))
#    print('Positive goals: ' + str(parser.positive_goals))
#    print('Negative goals: ' + str(parser.negative_goals))
