/**
 * \brief Implementation of the \ref planner.h.
 *
 * \copyright GNU Public License.
 *
 * \author Francesco Fabiano.
 * \date May 6, 2019
 */
#include <algorithm>
#include "planner.h"

template <class T>
void planner<T>::print_results(std::chrono::duration<double> elapsed_seconds, T goal, bool results_file, bool givenplan)
{
	std::cout << "\n\n\nWell Done, Goal found in " << elapsed_seconds.count() << " :)\n";
	goal.print();
	if (results_file) {
		std::ofstream result;
		std::string folder = "out/EFP_comparison/";
		if (givenplan) {
			folder = folder + "givenplan/";
		} else {
			folder = folder + "findingplan/";
		}
		//@MOD For the overall metacognitive architecture
		folder = "tmp/EFP/";
		system(("mkdir -p " + folder).c_str());
		result.open(folder + domain::get_instance().get_name() + ".tmp", std::ofstream::out | std::ofstream::app);
		//@MOD For the overall metacognitive architecture
		result << "EFP Version 2.0 (";
		switch ( domain::get_instance().get_stype() ) {
		case KRIPKE:
			if (domain::get_instance().get_k_optimized()) {
				result << "on KRIPKE with OPTIMIZED transition function";
			} else {
				result << "on KRIPKE with STANDARD transition function";
			}

			if (domain::get_instance().get_bisimulation() == PaigeTarjan) {
				result << " and Paige-Tarjan Bisimulation";
			} else if (domain::get_instance().get_bisimulation() == FastBisimulation) {
				result << " and Fast Bismulation";
			}

			break;
		case POSSIBILITIES:
			result << "on POSS with STANDARD transition function";
			break;
		default:
			result << "on UNKNOWN with UNKNOWN transition function";
			break;
		}
		result << ") ";
		if (domain::get_instance().check_visited()) {
			result << "with VISITED-STATE ";
		}
		result << "completed the search in: " << elapsed_seconds.count() << "\n";
		result.close();
	} else {
		std::cout << "\ncompleted the search in: " << elapsed_seconds.count() << "\n";
	}
}

template <class T>
bool planner<T>::search(bool results_file, heuristics used_heur, int max_depth, int step_)
{
	
	if (used_heur == NO_H) {
		return search_BFS(results_file);
	} else if (used_heur == NO_H_DFS) {
		return search_DFS(results_file);
	} else if (used_heur == DFS_ITER) {
		return search_IterativeDFS(results_file, max_depth, step_);
	} else {
		return search_heur(results_file, used_heur);
	}

	//non arrivo mai qui.
	return false;
}

template <class T>
bool planner<T>::search_BFS(bool results_file)
{
	T initial;
	bool check_visited = domain::get_instance().check_visited();
	bool bisimulation = false;
	if (domain::get_instance().get_bisimulation() != BIS_NONE) {
		bisimulation = true;
	}
	bisimulation = false;
	std::set<T> visited_states;

	auto start_timing = std::chrono::system_clock::now();
	initial.build_initial();
	if (bisimulation) {
		initial.calc_min_bisimilar();
	}

	auto end_timing = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end_timing - start_timing;

	std::cout << "\nInitial Built in " << elapsed_seconds.count() << " seconds\n";

	action_set actions = domain::get_instance().get_actions();
	action_set::const_iterator it_acset;
	T popped_state;
	T tmp_state;
	action tmp_action;

	start_timing = std::chrono::system_clock::now();
	if (initial.is_goal()) {
		end_timing = std::chrono::system_clock::now();
		elapsed_seconds = end_timing - start_timing;
		print_results(elapsed_seconds, initial, results_file, false);

		return true;
	}

	m_search_space.push(initial);
	if (check_visited) {
		visited_states.insert(initial);
	}
	
	while (!m_search_space.empty()) {
		popped_state = m_search_space.front();
		m_search_space.pop();
		//std::cerr << "\nDEBUG: Plan length is " << popped_state.get_plan_length();
		for (it_acset = actions.begin(); it_acset != actions.end(); it_acset++) {
			tmp_action = *it_acset;

			if (popped_state.is_executable(tmp_action)) {
				tmp_state = popped_state.compute_succ(tmp_action);
				//tmp_state.print();
				if (bisimulation) {
					tmp_state.calc_min_bisimilar();
				}

				if (tmp_state.is_goal()) {
					end_timing = std::chrono::system_clock::now();
					elapsed_seconds = end_timing - start_timing;
					print_results(elapsed_seconds, tmp_state, results_file, false);
					return true;
				}
				if (!check_visited || visited_states.insert(tmp_state).second) {
					m_search_space.push(tmp_state);
				}
			} /*else {
				if (tmp_state.get_plan_length() == count) {
					std::cerr << "\nDEBUG: Plan length is " << count;
					count++;
				}
			}*/

		}

	}
	std::cout << "\nNo plan found for this goal.\n";
	return false;
}

template <class T>
bool planner<T>::search_IterativeDFS(bool results_file, int maxDepth_, int step_)
{
	//stack di supporto per i risultati della ricerca.
	std::stack<T> supportSearch;
	T initial;

	bool bisimulation = false;
	if (domain::get_instance().get_bisimulation() != BIS_NONE) {
		bisimulation = true;
	}
	bisimulation = false;
	std::set<T> visited_states;

	auto start_timing = std::chrono::system_clock::now();
	initial.build_initial();
	if (bisimulation) {
		initial.calc_min_bisimilar();
	}

	int maxDepth = maxDepth_;
	int step = step_;

	auto end_timing = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end_timing - start_timing;

	std::cout << "\nInitial Built in " << elapsed_seconds.count() << " seconds\n";

	action_set actions = domain::get_instance().get_actions();
	action_set::const_iterator it_acset;
	T popped_state, popped_state2;
	T tmp_state;
	action tmp_action;

	start_timing = std::chrono::system_clock::now();
	if (initial.is_goal()) {
		end_timing = std::chrono::system_clock::now();
		elapsed_seconds = end_timing - start_timing;
		print_results(elapsed_seconds, initial, results_file, false);

		return true;
	}

	m_search_space_DFS.push(initial);
	visited_states.insert(initial);

	while (true) {
		m_search_space_DFS.push(initial);
		maxDepth += step;
		visited_states.clear();
		visited_states.insert(initial);

		while (!m_search_space_DFS.empty()) {
			popped_state = m_search_space_DFS.top();
			m_search_space_DFS.pop();
			for (it_acset = actions.begin(); it_acset != actions.end(); it_acset++) {
				tmp_action = *it_acset;
				if (popped_state.is_executable(tmp_action)) {
					tmp_state = popped_state.compute_succ(tmp_action);
					//tmp_state.print();
					if (bisimulation) {
						tmp_state.calc_min_bisimilar();
					}
					if (tmp_state.is_goal()) {
						end_timing = std::chrono::system_clock::now();
						elapsed_seconds = end_timing - start_timing;
						print_results(elapsed_seconds, tmp_state, results_file, false);
						return true;
					}

					if (visited_states.insert(tmp_state).second) {
						if (tmp_state.get_plan_length() < maxDepth) {
							m_search_space_DFS.push(tmp_state);
						}
					}
				}
			}

		}
	}
	//anche qui non ci arrivo mai con il while true
	std::cout << "\nNo plan found for this goal.\n";
	return false;
}

template <class T>
bool planner<T>::search_DFS(bool results_file)
{
	T initial;

	bool bisimulation = false;
	if (domain::get_instance().get_bisimulation() != BIS_NONE) {
		bisimulation = true;
	}
	bisimulation = false;
	std::set<T> visited_states;

	auto start_timing = std::chrono::system_clock::now();
	initial.build_initial();
	if (bisimulation) {
		initial.calc_min_bisimilar();
	}

	auto end_timing = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end_timing - start_timing;

	std::cout << "\nInitial Built in " << elapsed_seconds.count() << " seconds\n";

	action_set actions = domain::get_instance().get_actions();
	action_set::const_iterator it_acset;
	T popped_state, popped_state2;
	T tmp_state;
	action tmp_action;

	start_timing = std::chrono::system_clock::now();
	if (initial.is_goal()) {
		end_timing = std::chrono::system_clock::now();
		elapsed_seconds = end_timing - start_timing;
		print_results(elapsed_seconds, initial, results_file, false);

		return true;
	}

	m_search_space_DFS.push(initial);
	visited_states.insert(initial);
	while (!m_search_space_DFS.empty()) {
		popped_state = m_search_space_DFS.top();
		m_search_space_DFS.pop();

		//esecuzione azioni
		for (it_acset = actions.begin(); it_acset != actions.end(); it_acset++) {
			tmp_action = *it_acset;
			if (popped_state.is_executable(tmp_action)) {
				tmp_state = popped_state.compute_succ(tmp_action);
				//tmp_state.print();
				if (bisimulation) {
					tmp_state.calc_min_bisimilar();
				}
				if (tmp_state.is_goal()) {
					end_timing = std::chrono::system_clock::now();
					elapsed_seconds = end_timing - start_timing;
					print_results(elapsed_seconds, tmp_state, results_file, false);
					return true;
				}

				if (visited_states.insert(tmp_state).second) {
					m_search_space_DFS.push(tmp_state);
				}
			}

		}
	}
	std::cout << "\nNo plan found for this goal.\n";
	return false;
}

template <class T>
bool planner<T>::search_heur(bool results_file, heuristics used_heur)
{
	T initial;
	bool check_visited = domain::get_instance().check_visited();
	std::set<T> visited_states;
	bool bisimulation = false;
	if (domain::get_instance().get_bisimulation() != BIS_NONE) {
		bisimulation = true;
	}

	auto start_timing = std::chrono::system_clock::now();
	initial.build_initial();
	if (bisimulation) initial.calc_min_bisimilar();
	auto end_timing = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end_timing - start_timing;

	std::cout << "\nInitial Built in " << elapsed_seconds.count() << " seconds\n";

	start_timing = std::chrono::system_clock::now();
	heuristics_manager h_manager(used_heur, initial);
	end_timing = std::chrono::system_clock::now();
	elapsed_seconds = end_timing - start_timing;
	std::cout << "\nHeuristic Built in " << elapsed_seconds.count() << " seconds\n";


	action_set actions = domain::get_instance().get_actions();
	action_set::const_iterator it_acset;
	T popped_state;
	T tmp_state;
	action tmp_action;

	start_timing = std::chrono::system_clock::now();
	if (initial.is_goal()) {
		end_timing = std::chrono::system_clock::now();
		elapsed_seconds = end_timing - start_timing;
		print_results(elapsed_seconds, initial, results_file, false);
		return true;
	}

	if (check_visited) {
		visited_states.insert(initial);
	}
	m_heur_search_space.push(initial);
	while (!m_heur_search_space.empty()) {
		popped_state = m_heur_search_space.top();
		//std::cerr << "\nDEBUG: Picked the state with heur = " << popped_state.get_heuristic_value() << "\n\n\n";
		m_heur_search_space.pop();

		for (it_acset = actions.begin(); it_acset != actions.end(); it_acset++) {
			tmp_action = *it_acset;
			if (popped_state.is_executable(tmp_action)) {
				tmp_state = popped_state.compute_succ(tmp_action);
				if (bisimulation) {
					tmp_state.calc_min_bisimilar();
				}
				if (tmp_state.is_goal()) {
					end_timing = std::chrono::system_clock::now();
					elapsed_seconds = end_timing - start_timing;
					print_results(elapsed_seconds, tmp_state, results_file, false);
					return true;
				}
				if (!check_visited || visited_states.insert(tmp_state).second) {
					h_manager.set_heuristic_value(tmp_state);

					if ((tmp_state.get_heuristic_value() >= 0) || (used_heur == C_PG)) {
						//std::cerr << "\nDEBUG: Generated a state with heur = " << tmp_state.get_heuristic_value();
						m_heur_search_space.push(tmp_state);
					}
				}
			}
		}
	}
	std::cout << "\n\nIt does not exists any Plan for this domain instance:(\n";
	return false;
}

template <class T>
void planner<T>::execute_given_actions(std::vector<std::string>& act_name)
{
	check_actions_names(act_name);
	// DEBUG
	std::set<T> visited_states;

	bool bisimulation = false;
	if (domain::get_instance().get_bisimulation() != BIS_NONE) {
		bisimulation = true;
	}
	T state;
	state.build_initial();

	if (state.is_goal()) {
		std::cout << "\nInitial was Goal:)\n";
	} else {
		std::cout << "\n\n";
	}

	std::string bis_postfix = "";
	if (bisimulation) {
		state.calc_min_bisimilar();
		bis_postfix = "__b";
	}
	if (domain::get_instance().get_debug()) {
		state.print_graphviz(bis_postfix);

	}
	// DEBUG
	visited_states.insert(state);

	std::vector<std::string>::const_iterator it_stset;
	std::vector<std::string>::const_iterator it_stset2;

	action_set::const_iterator it_acset;
	for (it_stset = act_name.begin(); it_stset != act_name.end(); it_stset++) {
		for (it_acset = domain::get_instance().get_actions().begin(); it_acset != domain::get_instance().get_actions().end(); it_acset++) {
			if ((*it_acset).get_name().compare(*it_stset) == 0) {

				/*auto attitudes = state.get_F_attitudes(*(domain::get_instance().get_agents().begin()));
				auto attitudes_it = attitudes.begin();

				std::cout << "\n\nF table\n";
				for (; attitudes_it != attitudes.end(); attitudes_it++) {
					std::cout << "Agent " << domain::get_instance().get_grounder().deground_agent(attitudes_it->first) << " has attitude " << attitudes_it->second;
					std::cout << std::endl;
				}*/
				if (state.is_executable(*it_acset)) {
					state = state.compute_succ(*it_acset);
					if (bisimulation) {
						state.calc_min_bisimilar();
					}
					if (domain::get_instance().get_debug()) {
						state.print_graphviz(bis_postfix);
					}

					// DEBUG
					if (!visited_states.insert(state).second) {
						for (T tmp : visited_states) {
							if (!(tmp < state) && !(state < tmp) && !domain::get_instance().get_debug()) {
								state.min_with_print(tmp);
							}

							//std::cerr << "\nDEBUG: reached already visited state with action " << (*it_acset).get_name() << "\n";

							// if ((*it_acset).get_name() == "shout_8") {
							// 	state.print_graphviz(bis_postfix);
							// }
						}
					}

					if (state.is_goal()) {
						std::cout << "\n\nWell Done, Goal found after the execution of ";
						for (it_stset2 = act_name.begin(); it_stset2 != it_stset; it_stset2++) {
							std::cout << *it_stset2 << ", ";
						}
						std::cout << *it_stset << " :)\n\n\n";
					}
				} else {
					std::cout << "The action " << (*it_acset).get_name() << " was not executable\n";
					return;
				}
			}
		}
	}

	if (domain::get_instance().get_debug()) {
		std::cout << "\nGenerating the graphical representation of the states ...\n";

		std::string name_folder_graphviz = "out/state/";
		name_folder_graphviz += domain::get_instance().get_name();
		switch ( domain::get_instance().get_stype() ) {
		case KRIPKE:
			name_folder_graphviz += "_kripke";
			if (domain::get_instance().get_k_optimized()) {
				name_folder_graphviz += "_opt";
			}
			break;
		case POSSIBILITIES:
			name_folder_graphviz += "_poss";
			break;
		default:
			name_folder_graphviz += "_unknown";
			break;
		}
		system(("sh scripts/generate_pdf.sh " + name_folder_graphviz).c_str());
	}

	return;
}

template <class T>
/**\todo just for confrontation with old*/
void planner<T>::execute_given_actions_timed(std::vector<std::string>& act_name)
{
	check_actions_names(act_name);

	T state;
	state.build_initial();

	std::vector<std::string>::const_iterator it_stset;
	action_set::const_iterator it_acset;

	auto start_timing = std::chrono::system_clock::now();

	for (it_stset = act_name.begin(); it_stset != act_name.end(); it_stset++) {
		for (it_acset = domain::get_instance().get_actions().begin(); it_acset != domain::get_instance().get_actions().end(); it_acset++) {
			if ((*it_acset).get_name().compare(*it_stset) == 0) {
				//std::cout << "\n\nTrying action " << (*it_acset).get_name() << "\n";
				if (state.is_executable(*it_acset)) {
					state = state.compute_succ(*it_acset);
				}
			}
		}
	}

	auto end_timing = std::chrono::system_clock::now();
	std::chrono::duration<double> elapsed_seconds = end_timing - start_timing;

	print_results(elapsed_seconds, state, true, true);

	return;
}

template <class T>
/**\todo just for confrontation with old*/
void planner<T>::check_actions_names(std::vector<std::string>& act_name)
{

	string_set domain_act;
	action_set::const_iterator it_acset;

	std::vector<std::string>::iterator it_stset;

	for (it_acset = domain::get_instance().get_actions().begin(); it_acset != domain::get_instance().get_actions().end(); it_acset++) {
		domain_act.insert(it_acset->get_name());
	}

	for (it_stset = act_name.begin(); it_stset != act_name.end(); it_stset++) {

		(*it_stset).erase(std::remove((*it_stset).begin(), (*it_stset).end(), ','), (*it_stset).end());

		if (domain_act.find(*it_stset) == domain_act.end()) {
			std::cerr << "\nERROR in giving the action list: the action " << *it_stset << " does not exist.\n";
			exit(1);
		}
	}
}

/*\ IMPLEMENTATION OF OTHER TEMPLATIC FUNCTIONS INSTANCIATED WITH A TEMPLATIC STATE*/
#include "../heuristics/heuristics_template.ipp"