import Planners.PDDL_parser.domain_functions as df
import Planners.PDDL_parser.problem_functions as pf

#domain_file_path = "C:\\Users\\muppa\\Desktop\\domain train data\\blockworld\\domain.pddl"
#problem_file_path = "C:\\Users\\muppa\\Desktop\\domain train data\\blockworld\\problems\\problem_2_1.pddl"

# fucntion gives required details modeled in classical pddl files

def get_details(domain_file, problem_file):
    doamain_name = df.get_domain_name(domain_file).strip()
    problem_name = pf.get_problem_name(problem_file)[0].strip()
    init_States = pf.get_initialState(problem_file)
    goal_States = pf.get_goalState(problem_file)
    number_of_actions = len(df.get_actions(domain_file))
    number_of_predicates = len(df.get_predicates(domain_file))

    return doamain_name, problem_name, init_States, goal_States, number_of_actions, number_of_predicates

#print(get_details(domain_file_path, problem_file_path))
