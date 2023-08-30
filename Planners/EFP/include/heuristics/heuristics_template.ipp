
#include <map>

#include "heuristics_manager.h"

//OTHER CLASSES' IMPLEMENTATIONS

template <class T>
heuristics_manager::heuristics_manager(heuristics used_heur, const T & ini_eState)
{
	set_used_h(used_heur);
	m_goals = domain::get_instance().get_goal_description();
	switch ( m_used_heur ) {
	case L_PG:
	case S_PG:
	{
		expand_goals();
		break;

	}
	case C_PG:
	{
		planning_graph<T> pg(ini_eState, m_goals, true);
		if (pg.is_satisfiable()) {
			m_bf_score = pg.get_bfs_score();
		} else {
			std::cout << "\n\nIt does not exists any Plan for this domain instance:(\n";
			exit(1);
		}
		break;
	}
	case SUBGOALS:
	{
		expand_goals();
		satisfied_goals::get_instance().set(m_goals);
		break;
	}
	default:
	{
		std::cerr << "\nWrong Heuristic Selection\n";
		exit(1);
	}

	}
}

template <class T>
void heuristics_manager::set_heuristic_value(T & eState)
{

	switch ( m_used_heur ) {
	case L_PG:
	{
		planning_graph<T> pg(eState, m_goals);
		if (pg.is_satisfiable()) {
			eState.set_heuristic_value(pg.get_length());
		} else {
			eState.set_heuristic_value(-1);
		}
		break;
	}
	case S_PG:
	{
		planning_graph<T> pg(eState, m_goals);
		if (pg.is_satisfiable()) {
			eState.set_heuristic_value(pg.get_sum());
		} else {
			eState.set_heuristic_value(-1);
		}
		break;
	}
	case C_PG:
	{
		pg_bfs_score::const_iterator it_pgbf;
		short h_value = 0;
		for (it_pgbf = m_bf_score.begin(); it_pgbf != m_bf_score.end(); ++it_pgbf) {
			if (eState.entails(it_pgbf->first)) {
				h_value += it_pgbf->second;
			}
		}
		eState.set_heuristic_value(-h_value);
		break;
	}
	case SUBGOALS:
	{
		eState.set_heuristic_value(satisfied_goals::get_instance().get_unsatisfied_goals(eState));
		break;
	}
	default:
	{
		std::cerr << "\nWrong Heuristic Selection\n";
		exit(1);
	}

	}
}

template <class T>
unsigned short satisfied_goals::get_unsatisfied_goals(const T & eState) const
{
	unsigned short ret = m_goals_number;

	formula_list::const_iterator it_fl;
	for (it_fl = m_goals.begin(); it_fl != m_goals.end(); it_fl++) {
		if (eState.entails(*it_fl)) {
			ret--;
		}
	}
	return ret;

}

template <class T>
unsigned short satisfied_goals::get_satisfied_goals(const T & eState) const
{
	unsigned short ret = 0;

	formula_list::const_iterator it_fl;
	for (it_fl = m_goals.begin(); it_fl != m_goals.end(); it_fl++) {
		if (eState.entails(*it_fl)) {
			ret++;
		}
	}
	return ret;
}
