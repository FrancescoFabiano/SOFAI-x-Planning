#!/usr/bin/env python
# Four spaces as indentation [no tabs]
import re

import itertools

class Action:

    #-----------------------------------------------
    # Initialize
    #-----------------------------------------------

    def __init__(self,  name, act_type, parameters, positive_preconditions, negative_preconditions, add_effects, del_effects, observers, p_observers, derive_cond = [], explicit_eff = [], extensions = None):
        def frozenset_of_tuples(data):
            return frozenset([tuple(t) for t in data])
        self.name = name
        self.act_type = act_type
        self.parameters = parameters
        self.positive_preconditions = positive_preconditions
        self.negative_preconditions = negative_preconditions
        self.add_effects = add_effects
        self.del_effects = del_effects
        self.observers = observers
        self.p_observers = p_observers
        self.derive_cond = derive_cond
        self.explicit_eff = explicit_eff

    #-----------------------------------------------
    # to String
    #-----------------------------------------------

    def __str__(self):
        return 'action: ' + self.name + \
        '\n  action type: ' + self.act_type + \
        '\n  parameters: ' + str(self.parameters) + \
        '\n  positive_preconditions: ' + str([list(i) for i in self.positive_preconditions]) + \
        '\n  negative_preconditions: ' + str([list(i) for i in self.negative_preconditions]) + \
        '\n  add_effects: ' + str([list(i[0]) + list(i[1]) for i in self.add_effects]) + \
        '\n  del_effects: ' + str([list(i[0]) + list(i[1]) for i in self.del_effects]) + \
        '\n  full observers: ' + str([list(i[0]) + list(i[1]) for i in self.observers]) + \
        '\n  partial observers: ' + str([list(i[0]) + list(i[1]) for i in self.p_observers]) + '\n'


    #-----------------------------------------------
    # Equality
    #-----------------------------------------------

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    #-----------------------------------------------
    # Groundify
    #-----------------------------------------------

    def groundify(self, objects, types, requirements, fluents):
        duplicates = True
        if ':no-duplicates' in requirements:
            duplicates = False
        if not self.parameters:
            yield self
            return
        type_map = []
        variables = []
        for var, type in self.parameters:
            type_stack = [type]
            items = []
            while type_stack:
                t = type_stack.pop()
                if t in objects:
                    items += objects[t]
                elif t in types:
                    type_stack += types[t]
                else:
                    raise Exception('Unrecognized type ' + t)
            type_map.append(items)
            variables.append(var)

        for assignment in itertools.product(*type_map):
            if (not duplicates and len(assignment) == len(set(assignment))) or duplicates:
                positive_preconditions = self.replace(self.positive_preconditions, variables, assignment, fluents, 1)
                negative_preconditions = self.replace(self.negative_preconditions, variables, assignment, fluents, 1)
                add_effects = self.pair_replace(self.add_effects, variables, assignment, fluents, 1)
                del_effects = self.pair_replace(self.del_effects, variables, assignment, fluents, 1)
                observers = self.pair_replace(self.observers, variables, assignment, fluents, 0)
                p_observers = self.pair_replace(self.p_observers, variables, assignment, fluents, 0)
                yield Action(self.name, self.act_type, assignment, positive_preconditions, negative_preconditions, add_effects, del_effects, observers, p_observers)

    #-----------------------------------------------
    # Replace
    #-----------------------------------------------

    def replace(self, group, variables, assignment,fluents, to_print):
        g = []
    #    print("Group: " + str(group))
        for pred in group:
            pred = list(pred)

            fluent = ''
            l=0
            j=''
            k=''

            #for i in pred:
            #    if 'C(' in i:
            #        j = re.sub(r'C\((.+)\,', r'C([\1],',i)
            #        pred[pred.index(i)] = j

            for i in pred:
                iv = 0
                l = l+1
                if 'B(' in i:
                    j = re.sub(r'B\((.+)\,', r'\1',i)
                    for t in variables:
                        if t == j:
                            pred[pred.index(i)] = 'B('+assignment[iv]+','
                    if type(pred[l]) is list:
                        tmp_list = self.replace([pred[l]],variables, assignment,fluents, to_print)
                        pred[l] = tmp_list[0]
                elif 'C(' in i:
                    k = re.sub(r'C\((.+)\,', r'\1',i)
                    for j in re.findall(r'[^,]+\,', k):
                        j = j.replace(',', '')
                        for t in variables:
                            if t == j:
                                tmp_str = pred[pred.index(i)]
                                tmp_str = tmp_str.replace(t,assignment[iv])
                                pred[pred.index(i)] = tmp_str
                    if type(pred[l]) is list:
                        tmp_list = self.replace([pred[l]],variables, assignment,fluents, to_print)
                        pred[l] = tmp_list[0]
                iv += 1

            for i in pred:
                iv = 0
                if 'C(' in i:
                    k = re.sub(r'C\((.+)\,', r'\1',i)
                    for j in re.findall(r'[^,]+\,', k):
                        j = j.replace(',', '')
                        for t in variables:
                            if t == j:
                                pred[pred.index(i)] = 'C(['+assignment[iv]+'],'
                iv += 1


            iv = 0
            for v in variables:
                while v in pred:
                    pred[pred.index(v)] = assignment[iv]
                iv += 1
            if to_print == 1:
                fluent = Action.unify_fluent_EFP(pred)
                if 'B(' not in fluent and 'C(' not in fluent and '-' not in fluent:
                    fluents.add(fluent)
            g.append(pred)
        return g

    def pair_replace(self, group, variables, assignment,fluents, to_print):
        g = []
        for elem in group:
            body = self.replace([elem[0]], variables, assignment, fluents, to_print)
            positive_head = self.replace(elem[1], variables, assignment, fluents, to_print)
            negative_head = self.replace(elem[2], variables, assignment, fluents, to_print)
            diff = self.replace(elem[3], variables, assignment, fluents, to_print)
            g.append((body[0],positive_head,negative_head,diff))
        return g

    @staticmethod
    def unify_fluent_EFP(given_list):
        fluent = ''
        l = 0
        parCount = 0
        while l < len(given_list):
            i = given_list[l]
            if 'C(' in i:
                i = i.replace('C(','C([')
                i = i[:-1]
                i = i + '],'

            if 'B(' in i or  'C(' in i:
                parCount +=1
                l += 1
                fluent += i

                if type(given_list[l]) is list:
                    fluent += Action.unify_fluent_EFP(given_list[l])
                    l += len(given_list[l])
                #fluent += (str(i))

            else:
                fluent += (str(i))
                if l != len(given_list) -1:
                    fluent += '_'
                l +=1

        while parCount != 0:
            fluent +=')'
            parCount -=1
        return fluent

    @staticmethod
    def unify_fluent_PDKB(given_list, no_change, from_bf):
        fluent = ''
        l = 0
        parCount = 0
        while l < len(given_list):
            i = given_list[l]
            if '-' in i and no_change == False:
                i = i.replace('-','!')

            if 'C(' in i:
                from_bf = True
                i = i.replace('C(','[')
                i = i[:-1]
                l += 1
                fluent += i + ']'

                if type(given_list[l]) is list:
                    fluent += Action.unify_fluent_PDKB(given_list[l], no_change,from_bf)
                    l += len(given_list[l])

            elif 'B(' in i:
                from_bf = True
                i = i.replace('B(','[')
                i = i[:-1]
                l += 1
                fluent += i + ']'

                if type(given_list[l]) is list:
                    fluent += Action.unify_fluent_PDKB(given_list[l], no_change,from_bf)
                    l += len(given_list[l])
                #fluent += (str(i))

            else:
                if from_bf:
                    fluent += '('
                    parCount += 1
                    from_bf= False
                fluent += (str(i))
                if l != len(given_list) -1:
                    fluent += ' '
                l +=1

        while parCount != 0:
            fluent +=')'
            parCount -=1

        return fluent

#-----------------------------------------------
# Main
#-----------------------------------------------
if __name__ == '__main__':
    a = Action('move', [['?ag', 'agent'], ['?from', 'pos'], ['?to', 'pos']],
        [['at', '?ag', '?from'], ['adjacent', '?from', '?to']],
        [['at', '?ag', '?to']],
        [['at', '?ag', '?to']],
        [['at', '?ag', '?from']]
    )
    print(a)

    objects = {
        'agent': ['ana','bob'],
        'pos': ['p1','p2']
    }
    types = {'object': ['agent', 'pos']}
    for act in a.groundify(objects, types):
        print(act)
