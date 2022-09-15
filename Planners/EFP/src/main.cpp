/*
 * \brief The main file.
 *
 * \copyright GNU Public License.
 *
 * \author Francesco Fabiano.
 * \date Aprile 1, 2019
 */

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <memory>
#include <vector>


#include "../include/search/planner.ipp"

#include "../include/utilities/asp_maker.h"

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

#define VERSION "2.0"

reader generator()
{
	return reader();
}

using namespace boost;

shared_ptr<reader> domain_reader = make_shared<reader>(generator());

bool debug = false;
bool results_file = false;
bool is_global_obsv = true;
bool check_visited = false;
bool has_attitudes = false;
bis_type bisimulation = BIS_NONE;
heuristics used_heur = NO_H;
state_type state_struc = POSSIBILITIES; //default
domain_restriction ini_restriction = S5; //default
domain_restriction goal_restriction = NONE; //default
action_check act_check = EXE_POINTED__COND_WORLD; //default

bool execute_given_actions = false;
bool kopt = false;
std::vector<std::string> given_actions;

bool generate_asp = false;

int max_depth = 1;
int step = 1;

void print_usage(char* prog_name)
{
	std::cout << "USAGE:" << std::endl;
	std::cout << prog_name << " input_domain [options]" << std::endl << std::endl;
	std::cout << "OPTIONS:" << std::endl;

	std::cout << "-debug" << std::endl;
	std::cout << "	Makes the solving process verbose." << std::endl;

	std::cout << "-st @state_type" << std::endl;
	std::cout << "	Select the @state_type for the planner." << std::endl;
	std::cout << "	Possible @state_type:" << std::endl;
	std::cout << "		KRIPKE: The States are represented with Kripke structures and the transition function follows the paper definition. (Default)" << std::endl;
	std::cout << "		KRIPKE_OPT: The States are represented with Kripke structures and the transition function is optimized." << std::endl;
	std::cout << "		POSS: The States are represented with Possibilities (NWF-SET)." << std::endl;
	std::cout << "		OBDD: The States are represented with OBDDs." << std::endl;

	std::cout << "-ir @restriction" << std::endl;
	std::cout << "	Set the @restriction that the Initial state must encode." << std::endl;
	std::cout << "	Possible @restriction:" << std::endl;
	std::cout << "		S5: The Initial state must encode an S5 model. (Default)" << std::endl;
	std::cout << "		K45: The Initial state must encode a K45 model." << std::endl;
	std::cout << "		NONE: The Initial state does not have restrictions." << std::endl;

	std::cout << "-gr @restriction" << std::endl;
	std::cout << "	Set the @restriction for the Goal description." << std::endl;
	std::cout << "	Possible @restriction:" << std::endl;
	std::cout << "		NONE: The Goal does not have restrictions. (Default)" << std::endl;
	std::cout << "		NONEG: The Goal does not accept negative belief formula (-B(i,phi))." << std::endl;

	std::cout << "-bis @bisimulation_type" << std::endl;
	std::cout << "	Set the @bisimulation_type used for the kstate reduction." << std::endl;
	std::cout << "	Possible @bisimulation_type:" << std::endl;
	std::cout << "		NONE: No Bisimulation is used for the reduction. (Default)" << std::endl;
	std::cout << "		PT: The Paige-Tarjan Algorithm." << std::endl;
	std::cout << "		FB: The Fast-Bisimulation Algorithm introduced by Dovier et al, 2001." << std::endl;

	std::cout << "-act_obsv @action_observability" << std::endl;
	std::cout << "	Set the type of @action_observability for the action execution." << std::endl;
	std::cout << "	Possible @action_observability:" << std::endl;
	std::cout << "		GLOBAL: The observability frame is globally defined for each state (Default)." << std::endl;
	std::cout << "		RELATIVE: The observability frame is defined for each world of the state." << std::endl;

	std::cout << "-act_check @action_check" << std::endl;
	std::cout << "	Set the type of @action_check for the action execution." << std::endl;
	std::cout << "	Possible @action_check:" << std::endl;
	std::cout << "		PW: The executability is checked only on the state but the conditional effects are checked in every worlds (Default)." << std::endl;
	std::cout << "		PP: Both the executability and the conditional effects are checked only on the state." << std::endl;
	std::cout << "		WW: Both the executability and the conditional effects are checked in every world." << std::endl;

	/*std::cout << "-ini_build @building_tech" << std::endl;
	std::cout << "	Set the @building_tech that describes how the initial state will be build." << std::endl;*/

	std::cout << "-check_visited" << std::endl;
	std::cout << "	The planner will check for visited states (by default it does not)." << std::endl;

	std::cout << "-attitudes" << std::endl;
	std::cout << "	The planner will use the updated semantics with attitudes (by default it does not)." << std::endl;

	std::cout << "-h @heuristic" << std::endl;
	std::cout << "	Set the @heuristic to use to perform the search." << std::endl;
	std::cout << "	Possible @heuristic:" << std::endl;
	std::cout << "		L_PG: A planning graph is used to calculate the distance of each state from the goal." << std::endl;
	std::cout << "		NO_H_DFS: DFS standard" << std::endl;
	std::cout << "		DFS_ITER: DFS Iterative and used -mm max_depth and -ss step" << std::endl;
	std::cout << "		S_PG: A planning graph is used to calculate the sum of each sub-goal distance starting from the state." << std::endl;
	std::cout << "		C_PG: A single planning graph is used to calculate the sum of each 'grounded' belief formula." << std::endl;
	std::cout << "		SUBGOALS: We select the state with the highest number of satisfied subgoals." << std::endl;



	std::cout << "-e action1 action2 action3 ..." << std::endl;
	std::cout << "	Perform a sequence of actions and print out" << std::endl;
	std::cout << "	results step by step. The planner does not" << std::endl;
	std::cout << "	search for a plan." << std::endl << std::endl;
	std::cout << "	If the @debug option is on the states are printed as pdf in out/states/@domain_name/." << std::endl << std::endl;


	std::cout << "-results_file" << std::endl;
	std::cout << "	Print the plan time in a file to make the tests confrontations easier." << std::endl << std::endl;


	std::cout << "-generate_asp" << std::endl;
	std::cout << "	Generate a version of the input file for the ASP solver (the c++ planner does not search for a plan)." << std::endl << std::endl;


	std::cout << "EXAMPLES:" << std::endl;
	std::cout << prog_name << " exp/ex.txt -st POSS" << std::endl;
	std::cout << "	Find a plan for exp/ex.txt." << std::endl;
	std::cout << "	The solver will use Possibilities as e-state representation." << std::endl;
	std::cout << prog_name << " exp/ex.txt -st KRIPKE_OPT -h SUBGOALS" << std::endl;
	std::cout << "	Find a plan for exp/ex.txt with the heuristic \"SUBGOALS\"." << std::endl;
	std::cout << "	The solver will use Kripke Structures with the optimized transition function." << std::endl;
	std::cout << prog_name << " exp/ex.txt -e open_a peek_a" << std::endl;
	std::cout << "	Execute the plan [open_a; peek_a]." << std::endl;
	std::cout << "	As no e-state representation is selected the solver will use Kripke Structures." << std::endl << std::endl;

	exit(1);
}

void manage_arguments(int argc, char** argv)
{
	int i = 2;
	while (i < argc) {
		//No case sensitivity
		if (strcmp(argv[i], "-debug") == 0) {
			std::cout << "Debug is on." << std::endl;
			debug = true;
		} else if (strcmp(argv[i], "-results_file") == 0) {
			results_file = true;
		} else if (strcmp(argv[i], "-generate_asp") == 0) {
			generate_asp = true;
		}//No case sensitivity
		else if (strcmp(argv[i], "-ir") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-ir needs specification (S5, K45, NONE)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "S5") == 0) {
				std::cout << "Initial state must be an S5. (Default)" << std::endl;
				ini_restriction = S5; //default
			} else if (strcmp(argv[i], "K45") == 0) {
				std::cout << "Initial state must be a K45." << std::endl;
				ini_restriction = K45;
			} else if (strcmp(argv[i], "NONE") == 0) {
				std::cout << "Initial state does not have restrictions." << std::endl;
				ini_restriction = NONE;
			} else {
				std::cerr << "Wrong specification for '-ir'; use 'S5' or 'K45' or 'NONE'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-gr") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-gr needs specification (NONE, NONEG)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "NONE") == 0) {
				std::cout << "The Goal does not have restrictions. (Default)" << std::endl;
				goal_restriction = NONE; //default
			} else if (strcmp(argv[i], "NONEG") == 0) {
				std::cout << "The Goal does not accept negative belief formula (-B(i,phi))." << std::endl;
				goal_restriction = NONEG;
			} else {
				std::cerr << "Wrong specification for '-gr'; use 'S5' or 'K45' or 'NONE'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-check_visited") == 0) {

			std::cout << "The planner will check for visited states" << std::endl;
			check_visited = true;

		}else if (strcmp(argv[i], "-attitudes") == 0) {

			std::cout << "The planner will use the updated semantics with attitudes" << std::endl;
			has_attitudes = true;

		}
		else if (strcmp(argv[i], "-st") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-st needs specification (POSS, KRIPKE, KRIPKE_OPT, OBDD)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "POSS") == 0) {
				std::cout << "The States are represented with Possibilities (NWF-SET).  (Default)" << std::endl;
				state_struc = POSSIBILITIES;
			} 
			else if (strcmp(argv[i], "KRIPKE") == 0) {
				std::cout << "The States are represented with Kripke structures." << std::endl;
				state_struc = KRIPKE; //default
				kopt = false;
				std::cerr << "Kripke Structures implementation is a little bit behind. We will back online in a bit :)" << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "KRIPKE_OPT") == 0) {
				std::cout
					<< "KRIPKE_OPT: The States are represented with Kripke structures and the transition function is optimized"
					<< std::endl;
				state_struc = KRIPKE;
				kopt = true;
				std::cerr << "Kripke Structures implementation is a little bit behind. We will back online in a bit :)" << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "OBDD") == 0) {
				std::cout << "The States are represented with OBDDs." << std::endl;
				state_struc = OBDD;
			} else {
				std::cerr << "Wrong specification for '-st'; use 'KRIPKE' or 'POSS' or 'OBDD'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-ss") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-s needs an integer value." << std::endl;
				exit(1);
			} else {
				max_depth = atoi(argv[i]);

			}
		} else if (strcmp(argv[i], "-mm") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-m needs an integer value" << std::endl;
				exit(1);
			} else {
				step = atoi(argv[i]);

			}
		} else if (strcmp(argv[i], "-act_obsv") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-act_obsv needs specification (GLOBAL, RELATIVE)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "GLOBAL") == 0) {
				std::cout << "The observability frame is globally defined for each state. (Default)" << std::endl;
				is_global_obsv = true; //default
			} else if (strcmp(argv[i], "RELATIVE") == 0) {
				std::cout << "The observability frame is defined for each world of the state." << std::endl;
				is_global_obsv = false;
			} else {
				std::cerr << "Wrong specification for '-act_obsv'; use 'GLOBAL' or 'RELATIVE'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-act_check") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-act_check needs specification (PP, PW, WW)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "PP") == 0) {
				std::cout << "Both the executability and the conditonal effects are checked only on the state."
					<< std::endl;
				act_check = EXE_POINTED__COND_POINTED; //default
			} else if (strcmp(argv[i], "PW") == 0) {
				std::cout
					<< "The executability is checked only on the state but the conditonal effects are checked in every worlds. (Default)"
					<< std::endl;
				act_check = EXE_POINTED__COND_WORLD;
			} else if (strcmp(argv[i], "WW") == 0) {
				std::cout << "Both the executability and the conditonal effects are checked in every world."
					<< std::endl;
				act_check = EXE_WORLD__COND_WORLD;
			} else {
				std::cerr << "Wrong specification for '-act_obsv'; use 'PP' or 'PW' or 'WW'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-h") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-h needs specification (NONE, L_PG, S_PG, C_PG, SUBGOALS)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "NONE") == 0) {
				std::cout << "Breadth first search. (Default)" << std::endl;
				used_heur = NO_H; //default
			} else if (strcmp(argv[i], "L_PG") == 0) {
				std::cout << "A planning graph is used to calculate the distance of each state from the goal."
					<< std::endl;
				used_heur = L_PG;
			} else if (strcmp(argv[i], "S_PG") == 0) {
				std::cout
					<< "A planning graph is used to calculate the sum of each sub-goal distance starting from the state."
					<< std::endl;
				used_heur = S_PG;
			} else if (strcmp(argv[i], "C_PG") == 0) {
				std::cout << "A single planning graph is used to calculate the sum of each 'grounded' belief formula."
					<< std::endl;
				used_heur = C_PG;
			} else if (strcmp(argv[i], "E_PG") == 0) {
				std::cout << "A single planning graph is used to calculate the sum of each 'grounded' belief formula."
					<< std::endl;
				used_heur = E_PG;
			} else if (strcmp(argv[i], "SUBGOALS") == 0) {
				std::cout << "We select the state with the highest number of satisfied subgoals." << std::endl;
				used_heur = SUBGOALS;
			} else if (strcmp(argv[i], "NO_H_DFS") == 0) {
				std::cout << "Search with DFS." << std::endl;
				used_heur = NO_H_DFS;
			} else if (strcmp(argv[i], "DFS_ITER") == 0) {
				std::cout << "Search with DFS Iterative." << std::endl;
				used_heur = DFS_ITER;
			} else {
				std::cerr
					<< "Wrong specification for '-h'; use 'NONE' or 'L_PG' or 'S_PG' or 'C_PG' or 'SUBGOALS' or 'DFS_ITER' or 'NO_H_DFS'."
					<< std::endl;
				exit(1);

			}
		} else if (strcmp(argv[i], "-bis") == 0) {
			i++;
			if (i >= argc) {
				std::cerr << "-bis needs specification (NONE,PT,FB)." << std::endl;
				exit(1);
			} else if (strcmp(argv[i], "NONE") == 0) {
				std::cout << "No Bisimulation is used for the reduction. (Default)" << std::endl;
				bisimulation = BIS_NONE; //default
			} else if (strcmp(argv[i], "PT") == 0) {
				std::cout << "The Paige-Tarjan Algorithm is used for kstate reduction." << std::endl;
				bisimulation = PaigeTarjan;
			} else if (strcmp(argv[i], "FB") == 0) {
				std::cout << "The Fast-Bisimulation Algorithm introduced by Dovier et al, 2001 is used for kstate reduction." << std::endl;
				bisimulation = FastBisimulation;
			} else {
				std::cerr << "Wrong specification for '-gr'; use 'S5' or 'K45' or 'NONE'." << std::endl;
				exit(1);
			}
		} else if (strcmp(argv[i], "-e") == 0) {
			execute_given_actions = true;

			if (i == argc - 1)
				print_usage(argv[0]);
			i++;

			while (i < argc && argv[i][0] != '-') {
				given_actions.push_back(std::string(argv[i++]));
			}

		} else {
			print_usage(argv[0]);
		}

		i++;
	}

}

void launch_search(state_type state_struc, bool execute_given_action, bool results_file, heuristics used_heur, std::vector<std::string> given_actions, int max_depth, int step)
{
	switch ( state_struc ) {
		/*case KRIPKE:
		{
			planner< state<kstate> > m_planner;
			if (execute_given_action) {
				if (results_file) {
					m_planner.execute_given_actions_timed(given_actions);
				} else {
					m_planner.execute_given_actions(given_actions);
				}
				std::cout << "\n\n\n*****THE END*****\n";
			} else {
				if (m_planner.search(results_file, used_heur)) {
					std::cout << "\n\n\n*****THE END*****\n";
				} else {
					std::cout << "\n\n\n*****THE SAD END*****\n";
				}
			}	
			break;
		}*/
	case POSSIBILITIES:
	{
		planner< state<pstate> > m_planner;
		if (execute_given_action) {
			if (results_file) {
				m_planner.execute_given_actions_timed(given_actions);
			} else {
				m_planner.execute_given_actions(given_actions);
			}
			std::cout << "\n\n\n*****THE END*****\n";
		} else {
			if (m_planner.search(results_file, used_heur, max_depth, step)) {
				std::cout << "\n\n\n*****THE END*****\n";
			} else {
				std::cout << "\n\n\n*****THE SAD END*****\n";
			}
		}
		break;
	}
	case OBDD:
	default:
		std::cerr << "\nNot implemented yet\n";
		exit(1);
	}
}

void generate_domain(char** argv)
{
	std::string domain_name = argv[1];
	if (freopen(argv[1], "r", stdin) == NULL) {

		std::cerr << argv[0] << ": File " << domain_name << " cannot be opened.\n";
		exit(1);
	}

	domain_name = domain_name.substr(domain_name.find_last_of("\\/") + 1);
	domain_name = domain_name.substr(0, domain_name.find_last_of("."));


	//timer.start(READ_TIMER);
	domain_reader->read();
	//	if (debug) {
	//		domain_reader->print();
	//	}
	//Domain building
	domain::get_instance().set_domain(domain_name, debug, state_struc, kopt, domain_reader, ini_restriction, goal_restriction, is_global_obsv, act_check, check_visited, bisimulation, has_attitudes);

	domain::get_instance().build();
}

void generate_asp_encoding()
{
	if (generate_asp) {

		asp_maker aspm;
		aspm.print_all();
		exit(0);
	}
}

int main(int argc, char** argv)
{
	//Get build date
	std::cout << "EFP version " << VERSION << " - Built date: " << BUILT_DATE << std::endl;
	//if arguments are too less
	if (argc < 2)
		print_usage(argv[0]);

	//manage and prepare arguments for the planner
	manage_arguments(argc, argv);
	//check eventualy problem on input file and generate domain
	generate_domain(argv);

	//check generation asp	
	generate_asp_encoding();


	//domain::get_instance().get_attitudes().print();

	//launch search planner
	launch_search(state_struc, execute_given_actions, results_file, used_heur, given_actions, max_depth, step);

	//timer.end(READ_TIMER);
	//planner.main();

	exit(0);
}

