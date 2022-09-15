/*
 * \brief Implementation of \ref pstate.h
 *
 * \copyright GNU Public License.
 *
 * \author Francesco Fabiano.
 * \date September 16, 2019
 */

#include <iostream>
#include <tuple>
#include <boost/dynamic_bitset.hpp>

#include "pstate.h"
#include "../../domain/domain.h"
#include "../../utilities/helper.h"

void pstate::set_worlds(const pworld_ptr_set & to_set)
{
	m_worlds = to_set;
}

void pstate::set_pointed(const pworld_ptr & to_set)
{
	m_pointed = to_set;
}

void pstate::set_beliefs(const pworld_transitive_map & to_set)
{
	m_beliefs = to_set;
}

void pstate::set_max_depth(unsigned int to_set)
{
	if (m_max_depth < to_set) m_max_depth = to_set;
}

const pworld_ptr_set & pstate::get_worlds() const
{
	return m_worlds;
}

const pworld_ptr & pstate::get_pointed() const
{
	return m_pointed;
}

const pworld_transitive_map & pstate::get_beliefs() const
{
	return m_beliefs;
}

unsigned int pstate::get_max_depth() const
{
	return m_max_depth;
}

bool pstate::operator=(const pstate & to_copy)
{
	set_worlds(to_copy.get_worlds());
	set_beliefs(to_copy.get_beliefs());
	m_max_depth = to_copy.get_max_depth();
	set_pointed(to_copy.get_pointed());
	//std::cerr << "\nDEBUG: eq ";
	return true;
}

bool pstate::operator<(const pstate & to_compare) const
{

	/*if (m_max_depth < to_compare.get_max_depth()) {
		return true;
	} else if (m_max_depth > to_compare.get_max_depth()) {
		return false;
	}*/

	if (m_pointed < to_compare.get_pointed()) {
		return true;
	} else if (m_pointed > to_compare.get_pointed()) {
		return false;
	}

	if (m_worlds < to_compare.get_worlds()) {
		return true;
	} else if (m_worlds > to_compare.get_worlds()) {
		return false;
	}

	pworld_transitive_map::const_iterator it_tramap1;
	pworld_transitive_map::const_iterator it_tramap2 = to_compare.get_beliefs().begin();

	pworld_map tmp_pwmap1, tmp_pwmap2;
	pworld_map::const_iterator it_pwmap1, it_pwmap2;
	//The same size is assured by the same size of m_worlds
	for (it_tramap1 = m_beliefs.begin(); it_tramap1 != m_beliefs.end(); it_tramap1++) {
		if (it_tramap1->first < it_tramap2->first) {
			return true;
		} else if (it_tramap1->first > it_tramap2->first) {
			return false;
		}

		tmp_pwmap1 = it_tramap1->second;
		tmp_pwmap2 = it_tramap2->second;
		if (tmp_pwmap1.size() < tmp_pwmap2.size()) {
			return true;
		} else if (tmp_pwmap1.size() > tmp_pwmap2.size()) {
			return false;
		}
		it_pwmap2 = tmp_pwmap2.begin();
		for (it_pwmap1 = tmp_pwmap1.begin(); it_pwmap1 != tmp_pwmap1.end(); it_pwmap1++) {
			if (it_pwmap1->first < it_pwmap2->first) {
				return true;
			} else if (it_pwmap1->first > it_pwmap2->first) {
				return false;
			}

			if (it_pwmap1->second < it_pwmap2->second) {
				return true;
			} else if (it_pwmap1->second > it_pwmap2->second) {
				return false;
			}
			it_pwmap2++;
		}
		it_tramap2++;
	}
	return false;
}

bool pstate::entails(fluent f) const
{
	return entails(f, m_pointed);
}

bool pstate::entails(fluent f, const pworld_ptr & world) const
{
	return world.get_ptr()->entails(f);
}

bool pstate::entails(const fluent_set & fl) const
{
	return entails(fl, m_pointed);
}

bool pstate::entails(const fluent_set & fl, const pworld_ptr & world) const
{
	return world.get_ptr()->entails(fl);
}

bool pstate::entails(const fluent_formula & ff) const
{
	return entails(ff, m_pointed);
}

bool pstate::entails(const fluent_formula & ff, const pworld_ptr & world) const
{
	return world.get_ptr()->entails(ff);
}

bool pstate::entails(const belief_formula & bf) const
{
	return entails(bf, m_pointed);
}

bool pstate::entails(const belief_formula & to_check, const pworld_ptr_set & reachable) const
{
	pworld_ptr_set::const_iterator it_pws;
	for (it_pws = reachable.begin(); it_pws != reachable.end(); it_pws++) {
		if (!entails(to_check, *it_pws))
			return false;
	}
	return true;
}

bool pstate::entails(const belief_formula & bf, const pworld_ptr & world) const
{
	/*
	 The entailment of a \ref belief_formula just call recursively the entailment on all the reachable world with that formula.
	 */
	pworld_ptr_set D_reachable;
	switch ( bf.get_formula_type() ) {

	case FLUENT_FORMULA:
	{
		/** \todo Make sure its grounded. Maybe add to \ref belief_formula a bool that store if grounded or not or maybe ground
		 * when \ref domain created.
		 * @see belief_formula::ground(const grounder &).*/
		return entails(bf.get_fluent_formula(), world);
		break;
	}

	case BELIEF_FORMULA:

		/** \todo what was the at_lest_one of the previous version?*/
		return entails(bf.get_bf1(), get_B_reachable_worlds(bf.get_agent(), world));
		break;

	case PROPOSITIONAL_FORMULA:
		switch ( bf.get_operator() ) {
		case BF_NOT:
			return !entails(bf.get_bf1(), world);
			break;
		case BF_OR:
			return entails(bf.get_bf1(), world) || entails(bf.get_bf2(), world);
			break;
		case BF_AND:
			return entails(bf.get_bf1(), world) && entails(bf.get_bf2(), world);
			break;
		case BF_FAIL:
		default:
			std::cerr << "Something went wrong in checking entailment for Propositional formula";
			exit(1);
		}
		break;

	case E_FORMULA:
		//Check the entails on the E-reachable worlds
		return entails(bf.get_bf1(), get_E_reachable_worlds(bf.get_group_agents(), world));
		break;
		//Check the entails on the D-reachable worlds
	case D_FORMULA:
		D_reachable = get_D_reachable_worlds(bf.get_group_agents(), world);
		if (D_reachable.size() > 0) {
			return entails(bf.get_bf1(), D_reachable);
		} else {
			return false;
		}
		break;
		//Check the entails on the C-reachable worlds
	case C_FORMULA:
		return entails(bf.get_bf1(), get_C_reachable_worlds(bf.get_group_agents(), world));
		break;
	case BF_EMPTY:
	{

		return true;
		break;
	}
	case BF_TYPE_FAIL:
	default:
		std::cerr << "Something went wrong in checking entailment for Belief formula";
		exit(1);
	}

	return false;
}

//bool pstate::entails(const formula_list & to_check, const pworld_ptr & world) const
//{
//	//formula_list expresses CNF formula
//	formula_list::const_iterator it_fl;
//	for (it_fl = to_check.begin(); it_fl != to_check.end(); it_fl++) {
//		if (!entails(*it_fl, world)) {
//			return false;
//		}
//	}
//	return true;
//}

const pworld_ptr_set pstate::get_B_reachable_worlds(agent ag, const pworld_ptr & world) const
{
	pworld_ptr_set ret;
	auto pw_map = m_beliefs.find(world);

	if (pw_map != m_beliefs.end()) {
		auto pw_set = pw_map->second.find(ag);
		if (pw_set != pw_map->second.end()) {
			sum_set(ret, pw_set->second);
		}
	}
	return ret;
}

bool pstate::get_B_reachable_worlds_recoursive(agent ag, const pworld_ptr & world, pworld_ptr_set& ret) const
{
	/** \todo check: If a--i-->b, b--i-->c then a--i-->c must be there*/
	auto pw_map = m_beliefs.find(world);

	if (pw_map != m_beliefs.end()) {
		auto pw_set = pw_map->second.find(ag);
		if (pw_set != pw_map->second.end()) {
			unsigned long previous_size = ret.size();
			sum_set(ret, pw_set->second);
			unsigned long current_size = ret.size();

			return previous_size == current_size;
		}
		/**@bug: We don't know why sometimes is outside the two if cases.*/
	}
	return true;
}

const pworld_ptr_set pstate::get_E_reachable_worlds(const agent_set & ags, const pworld_ptr & world) const
{
	/*The K^0 call of this function*/
	pworld_ptr_set ret;
	agent_set::const_iterator it_agset;
	for (it_agset = ags.begin(); it_agset != ags.end(); it_agset++) {
		sum_set(ret, get_B_reachable_worlds(*it_agset, world));
	}

	return ret;
}

bool pstate::get_E_reachable_worlds_recoursive(const agent_set & ags, const pworld_ptr_set & worlds, pworld_ptr_set & ret) const
{
	/*The K^i (recoursive) call of this function*/

	bool is_fixed_point = true;
	pworld_ptr_set::const_iterator it_pwptr;
	agent_set::const_iterator it_agset;
	for (it_pwptr = worlds.begin(); it_pwptr != worlds.end(); it_pwptr++) {
		for (it_agset = ags.begin(); it_agset != ags.end(); it_agset++) {
			if (!get_B_reachable_worlds_recoursive(*it_agset, *it_pwptr, ret)) {
				is_fixed_point = false;
			}
		}
	}
	return is_fixed_point;

}

const pworld_ptr_set pstate::get_C_reachable_worlds(const agent_set & ags, const pworld_ptr & world) const
{
	//Use of fixed point to stop.
	bool is_fixed_point = false;
	pworld_ptr_set newly_reached = get_E_reachable_worlds(ags, world);
	pworld_ptr_set already_reached;
	pworld_ptr_set ret;
	while (!is_fixed_point) {
		sum_set(newly_reached, ret);
		minus_set(newly_reached, already_reached);
		is_fixed_point = get_E_reachable_worlds_recoursive(ags, newly_reached, ret);
		already_reached = newly_reached;
	}
	return ret;
}

const pworld_ptr_set pstate::get_D_reachable_worlds(const agent_set & ags, const pworld_ptr & world) const
{
	/**@bug: Notion of D-Reachable is correct (page 24 of Reasoning about Knowledge)*/
	agent_set::const_iterator it_agset = ags.begin();
	pworld_ptr_set ret = get_B_reachable_worlds((*it_agset), world);
	it_agset++;

	for (; it_agset != ags.end(); it_agset++) {

		pworld_ptr_set::iterator it_pwset1 = ret.begin();
		pworld_ptr_set to_intersect = get_B_reachable_worlds((*it_agset), world);
		pworld_ptr_set::const_iterator it_pwset2 = to_intersect.begin();
		while ((it_pwset1 != ret.end()) && (it_pwset2 != to_intersect.end())) {

			if ((*it_pwset1 < *it_pwset2) && (((*it_pwset1).get_fluent_based_id()) == ((*it_pwset2).get_fluent_based_id()))) {
				ret.erase(it_pwset1++);
			} else if ((*it_pwset2 < *it_pwset1) && ((((*it_pwset1).get_fluent_based_id()) == ((*it_pwset2).get_fluent_based_id())))) {
				++it_pwset2;
			} else { // *it_pwset1 == *it_pwset2
				++it_pwset1;
				++it_pwset2;
			}
		}

		// Anything left in ret from here on did not appear in to_intersect,
		// so we remove it.
		ret.erase(it_pwset1, ret.end());

	}
	std::cerr << "\nERROR: D_REACHABLILITY not yet Implemented correctly\n";
	exit(1);
	return ret;
}

void pstate::add_world(const pworld & world)
{

	m_worlds.insert(pstore::get_instance().add_world(world));
}

pworld_ptr pstate::add_rep_world(const pworld & world, unsigned short repetition, bool& is_new)
{
	pworld_ptr tmp = pstore::get_instance().add_world(world);
	tmp.set_repetition(repetition);
	is_new = std::get<1>(m_worlds.insert(tmp));

	return tmp;
}

pworld_ptr pstate::add_rep_world(const pworld & world, unsigned short old_repetition)
{
	bool tmp = false;

	return add_rep_world(world, get_max_depth() + old_repetition, tmp);
}

pworld_ptr pstate::add_rep_world(const pworld & world)
{
	bool tmp = false;

	return add_rep_world(world, get_max_depth(), tmp);
}

void pstate::add_edge(const pworld_ptr &from, const pworld_ptr &to, agent ag)
{
	pworld_transitive_map::iterator from_beliefs = m_beliefs.find(from);

	if (from_beliefs != m_beliefs.end()) {
		pworld_map::iterator ag_beliefs = from_beliefs->second.find(ag);

		if (ag_beliefs != from_beliefs->second.end()) {
			ag_beliefs->second.insert(to);
		} else {
			from_beliefs->second.insert(pworld_map::value_type(ag,{to}));
		}
	} else {

		pworld_map pwm;
		pwm.insert(pworld_map::value_type(ag,{to}));
		m_beliefs.insert(pworld_transitive_map::value_type(from, pwm));
	}
}

void pstate::add_pworld_beliefs(const pworld_ptr & world, const pworld_map & beliefs)
{

	m_beliefs[world] = beliefs;
}

void pstate::build_initial()
{

	/** \todo for now prune building.*/
	std::cout << "\nBuilding initial possibility...\n";
	build_initial_prune();
}

void pstate::build_initial_structural()
{

}

void pstate::build_initial_prune()
{

	/*Building of all the possible consistent \ref pworld and setting the pointed world.
	 * Creation of all the \ref fluent combinations. All the consistent ones are added to \ref pstore.*/
	fluent_set permutation;
	initially ini_conditions = domain::get_instance().get_initial_description();
	//	std::cerr << "\nDEBUG: Initially known fluents: ";
	//	printer::get_instance().print_list(domain::get_instance().get_grounder().deground_fluent(ini_conditions.get_initially_known_fluents()));
	generate_initial_pworlds(permutation, 0, ini_conditions.get_initially_known_fluents());


	/*Building of all the consistent edges.*/
	generate_initial_pedges();
}

/*From https://www.geeksforgeeks.org/generate-all-the-binary-strings-of-n-bits/ since is like generating all the binary numbers.*/
void pstate::generate_initial_pworlds(fluent_set& permutation, int index, const fluent_set & initially_known)
{
	//todo non usare indici ma bitset prima positivo fluent poi negativo
	int fluent_number = domain::get_instance().get_fluent_number();

	int bit_size = (domain::get_instance().get_size_fluent());

	if (index == fluent_number) {
		pworld to_add(permutation);
		add_initial_pworld(to_add);

		return;
	}

	fluent_set permutation_2 = permutation;
	//Add the \ref fluent in positive version
	boost::dynamic_bitset<> bitSetToFindPositve(bit_size, index);
	boost::dynamic_bitset<> bitSetToFindNegative(bit_size, index);
	bitSetToFindNegative.set(bitSetToFindPositve.size() - 1, 1);
	bitSetToFindPositve.set(bitSetToFindPositve.size() - 1, 0);


	if (initially_known.find(bitSetToFindNegative) == initially_known.end()) {
		permutation.insert(bitSetToFindPositve);
		generate_initial_pworlds(permutation, index + 1, initially_known);
	}
	if (initially_known.find(bitSetToFindPositve) == initially_known.end()) {
		permutation_2.insert(bitSetToFindNegative);
		generate_initial_pworlds(permutation_2, index + 1, initially_known);
	}

}

void pstate::add_initial_pworld(const pworld & possible_add)
{
	initially ini_conditions = domain::get_instance().get_initial_description();

	switch ( ini_conditions.get_ini_restriction() ) {
	case S5:
	{
		/* Since the common knowledge is on all the agent it means that every possible \ref pworld
		 * in the initial state must entail *phi* where C(*phi*) is an initial condition.*/

		//Already setted in \ref domain::build_initially(bool).
		if (possible_add.entails(ini_conditions.get_ff_forS5())) {
			add_world(possible_add);
			if (possible_add.entails(ini_conditions.get_pointed_world_conditions())) {
				m_pointed = pworld_ptr(possible_add);
				/*std::cout << "pointed world: ";
				printer::get_instance().print_list(possible_add.get_fluent_set());
				std::cout << std::endl;*/
			}
		} else {
			//std::cout << "error non generata una permeutazione uguale ad un altra" << std::endl;
			//Already generated so we save it on pstore
			pstore::get_instance().add_world(possible_add);
		}
		break;
	}
	case K45:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);
		break;
	}
	case NONE:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);
		break;
	}
	default:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);

		break;
	}
	}
}

void pstate::generate_initial_pedges()
{
	pworld_ptr_set::const_iterator it_pwps_1, it_pwps_2;

	pworld_ptr pwptr_tmp1, pwptr_tmp2;

	/*This for add to *this* all the possible edges.*/
	for (it_pwps_1 = m_worlds.begin(); it_pwps_1 != m_worlds.end(); it_pwps_1++) {
		for (it_pwps_2 = it_pwps_1; it_pwps_2 != m_worlds.end(); it_pwps_2++) {
			for (auto agent : domain::get_instance().get_agents()) {
				pwptr_tmp1 = *it_pwps_1;
				pwptr_tmp2 = *it_pwps_2;
				add_edge(pwptr_tmp1, pwptr_tmp2, agent);
				add_edge(pwptr_tmp2, pwptr_tmp1, agent);

			}
		}
	}

	//std::cout << "Tot edges: " << m_edges.size() << std::endl;

	initially ini_conditions = domain::get_instance().get_initial_description();

	formula_list::const_iterator it_fl;
	for (it_fl = ini_conditions.get_initial_conditions().begin(); it_fl != ini_conditions.get_initial_conditions().end(); it_fl++) {

		remove_initial_pedge_bf(*it_fl);
	}
	//std::cout << "Removed edges: " << count << std::endl;

	//std::cout << "Final edges: " << m_edges.size() << std::endl;

}

void pstate::remove_edge(pworld_ptr &from, const pworld &to, const agent ag)
{
	auto from_beliefs = m_beliefs.find(from);

	if (from_beliefs != m_beliefs.end()) {
		auto ag_beliefs = from_beliefs->second.find(ag);

		if (ag_beliefs != from_beliefs->second.end()) {

			ag_beliefs->second.erase(to);
		}
	}
}

void pstate::remove_initial_pedge(const fluent_formula &known_ff, agent ag)
{
	pworld_ptr_set::const_iterator it_pwps_1, it_pwps_2;

	pworld_ptr pwptr_tmp1, pwptr_tmp2;

	/** \todo maybe don't loop twice on the world but exploit using it_pwps_2 = it_pwps_1:
	 * - remove (_1, _2).
	 * - remove (_2, _1).*/
	for (it_pwps_1 = m_worlds.begin(); it_pwps_1 != m_worlds.end(); it_pwps_1++) {
		for (it_pwps_2 = it_pwps_1; it_pwps_2 != m_worlds.end(); it_pwps_2++) {
			/** \todo or entails(-known_ff)?*/
			pwptr_tmp1 = *it_pwps_1;
			pwptr_tmp2 = *it_pwps_2;
			if (pwptr_tmp1.get_ptr()->entails(known_ff) && !pwptr_tmp2.get_ptr()->entails(known_ff)) {
				remove_edge(pwptr_tmp1, *pwptr_tmp2.get_ptr(), ag);
				remove_edge(pwptr_tmp2, *pwptr_tmp1.get_ptr(), ag);
			} else if (pwptr_tmp2.get_ptr()->entails(known_ff) && !pwptr_tmp1.get_ptr()->entails(known_ff)) {

				remove_edge(pwptr_tmp2, *pwptr_tmp1.get_ptr(), ag);
				remove_edge(pwptr_tmp1, *pwptr_tmp2.get_ptr(), ag);
			}
		}
	}
}

void pstate::remove_initial_pedge_bf(const belief_formula & to_check)
{
	switch ( domain::get_instance().get_initial_description().get_ini_restriction() ) {
	case S5:
	{
		/* Just check whenever is B(--) \/ B(--) and remove that edge*/
		if (to_check.get_formula_type() == C_FORMULA) {

			belief_formula tmp = to_check.get_bf1();

			switch ( tmp.get_formula_type() ) {

				//Only one for edges -- expresses that someone is ignorant.
			case PROPOSITIONAL_FORMULA:
			{
				//We remove all the check on the formula since they have already been controlled when ini_conditions has been created
				if (tmp.get_operator() == BF_OR) {

					//fluent_formula known_ff;
					auto known_ff_ptr = std::make_shared<fluent_formula>();
					helper::check_Bff_notBff(tmp.get_bf1(), tmp.get_bf2(), known_ff_ptr);
					if (known_ff_ptr != nullptr) {
						//printer::get_instance().print_list(*known_ff_ptr);
						remove_initial_pedge(*known_ff_ptr, tmp.get_bf2().get_agent());
					}
					return;

				} else if (tmp.get_operator() == BF_AND) {
					//This case doesn't add knowledge.
					return;

				} else {
					std::cerr << "\nError in the type of initial formulae (FIFTH).\n";
					exit(1);
				}
				return;
				break;
			}
			case FLUENT_FORMULA:
			case BELIEF_FORMULA:
			{
				return;
				break;
			}
			case BF_EMPTY:
			{
				return;
				break;
			}

			default:
			{
				std::cerr << "\nError in the type of initial formulae (SIXTH).\n";
				exit(1);
				break;
			}
			}
		} else {
			std::cerr << "\nError in the type of initial formulae (SEVENTH).\n";
			exit(1);
		}

		return;
		break;
	}

	case K45:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);
		break;
	}
	case NONE:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);
		break;
	}
	default:
	{
		std::cerr << "\nNot implemented yet\n";
		exit(1);

		break;
	}
	}
}

/** \warning executability should be check in \ref state (or \ref planner).*/
pstate pstate::compute_succ(const action & act) const
{
	//std::cerr << "\nDEBUG: Executing " << act.get_name();
	switch ( act.get_type() ) {
	case ONTIC:
	{
		return execute_ontic(act);
		break;
	}
	case SENSING:
	{
		if (domain::get_instance().has_attitudes()) {
			return execute_sensing_att(act);
		} else {
			return execute_sensing(act);
		}
		break;
	}
	case ANNOUNCEMENT:
	{
		if (domain::get_instance().has_attitudes()) {
			return execute_announcement_att(act);
		} else {
			return execute_announcement(act);
		}
		break;
	}
	case LIES:
	{
		return execute_announcement_dox(act);
		break;
	}
	default:
	{
		std::cerr << "Error in executing an action: " << act.get_name();
		std::cerr << " the type of the action is not defined correctly1";
		std::cerr << std::endl;
		exit(1);

		break;
	}
	}
}

void pstate::maintain_oblivious_believed_pworlds(pstate &ret, const agent_set & oblivious_obs_agents) const
{
	agent_set::const_iterator it_agset;
	pworld_ptr_set world_oblivious;
	pworld_ptr_set tmp_world_set;

	pworld_ptr_set::const_iterator it_wo_ob;

	if (!oblivious_obs_agents.empty()) {
		tmp_world_set = get_E_reachable_worlds(oblivious_obs_agents, get_pointed());
		for (it_agset = domain::get_instance().get_agents().begin(); it_agset != domain::get_instance().get_agents().end(); it_agset++) {
			for (it_wo_ob = tmp_world_set.begin(); it_wo_ob != tmp_world_set.end(); it_wo_ob++) {
				sum_set(world_oblivious, get_B_reachable_worlds(*it_agset, *it_wo_ob));
			}
		}
		sum_set(world_oblivious, tmp_world_set);
		ret.set_max_depth(get_max_depth() + 1);
		ret.set_worlds(world_oblivious);

		for (it_wo_ob = world_oblivious.begin(); it_wo_ob != world_oblivious.end(); it_wo_ob++) {
			auto it_pwmap = m_beliefs.find(*it_wo_ob);

			if (it_pwmap != m_beliefs.end()) {

				ret.add_pworld_beliefs(*it_wo_ob, it_pwmap->second);
			}
		}
	}
}

pworld_ptr pstate::execute_ontic_helper(const action &act, pstate &ret, const pworld_ptr &current_pw, transition_map &calculated, agent_set & oblivious_obs_agents) const
{
	// Execute the all the effects
	fluent_formula current_pw_effects = get_effects_if_entailed(act.get_effects(), current_pw);
	fluent_set world_description = current_pw.get_fluent_set();
	fluent_formula::const_iterator it_eff;

	for (it_eff = current_pw_effects.begin(); it_eff != current_pw_effects.end(); it_eff++) {
		helper::apply_effect(*it_eff, world_description);
		//		if (act.get_name().compare("distract_c_a") == 0) {
		//			std::cerr << "\nDEBUG: Inside the first ONTIC loop " << act.get_name();
		//		}
	}

	//	if (act.get_name().compare("distract_c_a") == 0) {
	//		std::cerr << "\nDEBUG: Out the first ONTIC loop " << act.get_name();
	//	}

	pworld_ptr new_pw = ret.add_rep_world(pworld(world_description), current_pw.get_repetition()); // We add the corresponding pworld in ret
	calculated.insert(transition_map::value_type(current_pw, new_pw)); // And we update the calculated map

	auto it_pwtm = get_beliefs().find(current_pw);

	if (it_pwtm != get_beliefs().end()) {
		pworld_map::const_iterator it_pwm;
		pworld_ptr_set::const_iterator it_pws;

		for (it_pwm = it_pwtm->second.begin(); it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;

			//			if (act.get_name().compare("distract_c_a") == 0) {
			//				std::cerr << "\nDEBUG: Inside the SECOND ONTIC loop " << act.get_name();
			//			}

			bool is_oblivious_obs = oblivious_obs_agents.find(ag) != oblivious_obs_agents.end();

			for (it_pws = it_pwm->second.begin(); it_pws != it_pwm->second.end(); it_pws++) {

				//				if (act.get_name().compare("distract_c_a") == 0) {
				//					std::cerr << "\nDEBUG: Inside the Third ONTIC loop " << act.get_name();
				//				}

				if (is_oblivious_obs) { // If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					auto maintained_pworld = ret.get_worlds().find(*it_pws);

					if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
					}
				} else { // Otherwise, if we have a FULLY OBS agent
					auto calculated_pworld = calculated.find(*it_pws);

					if (calculated_pworld != calculated.end()) { // If we already calculated the transition function for this pworld
						ret.add_edge(new_pw, calculated_pworld->second, ag); // Then we update agents' beliefs
					} else {

						pworld_ptr believed_pw = execute_ontic_helper(act, ret, *it_pws, calculated, oblivious_obs_agents);
						ret.add_edge(new_pw, believed_pw, ag);

						ret.set_max_depth(ret.get_max_depth() + 1 + current_pw.get_repetition());
					}
				}
			}
			//			if (act.get_name().compare("distract_c_a") == 0) {
			//				std::cerr << "\nDEBUG: Out the Second ONTIC loop " << act.get_name();
			//			}
		}
		//std::cerr << "\nDEBUG: Out the THIRD ONTIC loop " << act.get_name();

	}
	//std::cerr << "\nDEBUG: RETURN TO " << act.get_name();

	return new_pw;
}

pstate pstate::execute_ontic(const action & act) const
{
	pstate ret;

	//This finds all the worlds that are reachable from the initial state following
	//the edges labeled with fully observant agents.
	agent_set agents = domain::get_instance().get_agents();
	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());

	agent_set oblivious_obs_agents = agents;
	minus_set(oblivious_obs_agents, fully_obs_agents);

	transition_map calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);

	pworld_ptr new_pointed = execute_ontic_helper(act, ret, get_pointed(), calculated, oblivious_obs_agents);
	ret.set_pointed(new_pointed); // Updating the pointed world
	//std::cerr << "\nDEBUG: Out ONTIC " << act.get_name();

	return ret;
}

pworld_ptr pstate::execute_sensing_announcement_helper(const fluent_formula &effects, pstate &ret, const pworld_ptr &current_pw, transition_map &calculated, agent_set &partially_obs_agents, agent_set &oblivious_obs_agents, bool previous_entailment) const
{
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition()); // We add the corresponding pworld in ret
	calculated.insert(transition_map::value_type(current_pw, new_pw)); // And we update the calculated map

	auto it_pwtm = get_beliefs().find(current_pw);

	if (it_pwtm != get_beliefs().end()) {
		pworld_map::const_iterator it_pwm;
		pworld_ptr_set::const_iterator it_pws;

		for (it_pwm = it_pwtm->second.begin(); it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;

			bool is_oblivious_obs = oblivious_obs_agents.find(ag) != oblivious_obs_agents.end();
			bool is_partially_obs = partially_obs_agents.find(ag) != partially_obs_agents.end();
			bool is_fully_obs = !is_oblivious_obs && !is_partially_obs;

			for (it_pws = it_pwm->second.begin(); it_pws != it_pwm->second.end(); it_pws++) {
				if (is_oblivious_obs) { // If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					auto maintained_pworld = ret.get_worlds().find(*it_pws);

					if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
					}
				} else { // Otherwise, if we have a FULLY/PARTIALLY observant agent
					auto calculated_pworld = calculated.find(*it_pws);
					//fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());
					//bool ent = act.get_type() == SENSING ? entails(effects, *it_pws) == entails(effects, get_pointed()) : entails(effects, *it_pws);
					bool ent = entails(effects, *it_pws); // == entails(effects, get_pointed());


					bool is_consistent_belief = is_partially_obs || // If "ag" is PARTIALLY OBS, we always add an edge; If "ag" is FULLY OBS, we add an edge if he believes that "calculated" may be true (i.e., when "ent" holds) XOR
						(is_fully_obs && (ent == previous_entailment)); // if a PARTIALLY OBS agent believes that "ag" thinks that "calculated" may be true (i.e., when "previous_entailment" holds)

					if (calculated_pworld != calculated.end()) { // If we already calculated the transition function for this pworld
						if (is_consistent_belief) {
							ret.add_edge(new_pw, calculated_pworld->second, ag);
						}
					} else { // If we did not already calculate the transition function
						if (is_consistent_belief) { // We calculate it if it would result in a consistent belief...

							pworld_ptr believed_pw = execute_sensing_announcement_helper(effects, ret, *it_pws, calculated, partially_obs_agents, oblivious_obs_agents, ent);
							ret.add_edge(new_pw, believed_pw, ag);
						}
						//						else if (is_partially_obs && (ent != previous_entailment)) { // ...and when it does not entail the action effects, but a PARTIALLY OBS agent believes that it may be true
						//							pworld_ptr believed_pw_neg = execute_sensing_announcement_helper(act, ret, *it_pws, calculated, partially_obs_agents, oblivious_obs_agents, ent);
						//							ret.add_edge(new_pw, believed_pw_neg, ag);
						//						}
					}
				}
			}
		}
	}
	return new_pw;
}

pstate pstate::execute_sensing(const action & act) const
{
	pstate ret;

	//This finds all the worlds that are reachable from the initial state following
	//the edges labeled with fully observant agents.
	agent_set agents = domain::get_instance().get_agents();
	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());
	agent_set partially_obs_agents = get_agents_if_entailed(act.get_partially_observants(), get_pointed());

	agent_set oblivious_obs_agents = agents;
	minus_set(oblivious_obs_agents, fully_obs_agents);
	minus_set(oblivious_obs_agents, partially_obs_agents);

	if (!oblivious_obs_agents.empty()) {
		ret.set_max_depth(get_max_depth() + 1);
	}

	transition_map calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);

	fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());

	pworld_ptr new_pointed = execute_sensing_announcement_helper(effects, ret, get_pointed(), calculated, partially_obs_agents, oblivious_obs_agents, entails(effects));
	ret.set_pointed(new_pointed); // Updating the pointed world

	/*if (!check_properties(fully_obs_agents, partially_obs_agents, effects, ret)) {
		std::cerr << "\nDEBUG: Some properties are not respected\n\n";
		exit(1);
	}*/

	return ret;
}

pstate pstate::execute_announcement(const action & act) const
{
	//	pstate ret;
	//
	//	//This finds all the worlds that are reachable from the initial state following
	//	//the edges labeled with fully observant agents.
	//	agent_set agents = domain::get_instance().get_agents();
	//	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());
	//	agent_set partially_obs_agents = get_agents_if_entailed(act.get_partially_observants(), get_pointed());
	//
	//	agent_set oblivious_obs_agents = agents;
	//	minus_set(oblivious_obs_agents, fully_obs_agents);
	//	minus_set(oblivious_obs_agents, partially_obs_agents);
	//
	//	if (!oblivious_obs_agents.empty()) {
	//		ret.set_max_depth(get_max_depth() + 1);
	//	}
	//
	//	transition_map calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	//	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);
	//
	//	fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());
	//
	//	pworld_ptr new_pointed = execute_sensing_announcement_helper(act, ret, get_pointed(), calculated, partially_obs_agents, oblivious_obs_agents, entails(effects));
	//	ret.set_pointed(new_pointed); // Updating the pointed world
	//
	//	return ret;

	return execute_sensing(act);
}

bool pstate::check_properties(const agent_set & fully, const agent_set & partially, const fluent_formula & effects, const pstate & updated) const
{

	if (fully.size() > 0) {
		/************Formulae Building************/
		/******Formulae containing the effects of the sensing******/
		belief_formula effects_formula;
		effects_formula.set_formula_type(FLUENT_FORMULA);
		effects_formula.set_fluent_formula(effects);
		effects_formula.set_is_grounded(true);
		effects_formula.deground();


		/******First Property C(Fully, eff)******/
		belief_formula property1;
		property1.set_group_agents(fully);
		property1.set_formula_type(C_FORMULA);
		property1.set_bf1(effects_formula);
		property1.set_is_grounded(true);
		property1.deground();



		if (!updated.entails(property1)) {
			std::cerr << "\nDEBUG: First property not respected";
			return false;
		}



		if (partially.size() > 0) {
			/******Second Property C(P, (C(Fully,eff) | C(Fully, -eff)))******/
			belief_formula inner_nested2, nested2, disjunction, property2;
			//First nested formula is equal to First Property C(Fully, eff)
			//Second nested formula C(Fully, -f) is comprised of two layer (the NOT and C)
			inner_nested2.set_group_agents(fully);
			inner_nested2.set_formula_type(C_FORMULA);
			inner_nested2.set_bf1(effects_formula);
			inner_nested2.set_is_grounded(true);
			inner_nested2.deground();


			nested2.set_formula_type(PROPOSITIONAL_FORMULA);
			nested2.set_operator(BF_NOT);
			nested2.set_bf1(inner_nested2);
			nested2.set_is_grounded(true);
			nested2.deground();


			//The disjunction (C(Fully,eff) | C(Fully, -eff)) is made with property1 and nested2
			disjunction.set_formula_type(PROPOSITIONAL_FORMULA);
			disjunction.set_operator(BF_OR);
			disjunction.set_bf1(property1);
			disjunction.set_bf2(nested2);
			disjunction.set_is_grounded(true);
			disjunction.deground();


			//Finally we can construct the second property
			property2.set_group_agents(partially);
			property2.set_formula_type(C_FORMULA);
			property2.set_bf1(disjunction);
			property2.set_is_grounded(true);
			property2.deground();




			/******Third Property C(F, C(P, (C(Fully,eff) | C(Fully, -eff))))******/
			//This formula is just C(Fully, property2)
			belief_formula property3;
			property3.set_group_agents(fully);
			property3.set_formula_type(C_FORMULA);
			property3.set_bf1(property2);

			property3.set_is_grounded(true);

			property3.deground();


			if (!updated.entails(property2)) {
				std::cerr << "\nDEBUG: Second property not respected in the formula: ";
				property2.print_deground();
				return false;
			}

			if (!updated.entails(property3)) {
				std::cerr << "\nDEBUG: Third property not respected in the formula: ";
				property3.print_deground();
				return false;
			}
		}
	}

	return true;
}

void pstate::print() const
{
	int counter = 1;
	std::cout << std::endl;
	std::cout << "The Pointed World has id ";
	printer::get_instance().print_list(get_pointed().get_fluent_set());
	std::cout << "-" << get_pointed().get_repetition();
	std::cout << std::endl;
	std::cout << "*******************************************************************" << std::endl;

	pworld_ptr_set::const_iterator it_pwset;
	std::cout << "World List:" << std::endl;

	for (it_pwset = get_worlds().begin(); it_pwset != get_worlds().end(); it_pwset++) {
		std::cout << "W-" << counter << ": ";
		printer::get_instance().print_list(it_pwset->get_fluent_set());
		std::cout << " rep:" << it_pwset->get_repetition();
		std::cout << std::endl;
		counter++;
	}
	counter = 1;
	std::cout << std::endl;
	std::cout << "*******************************************************************" << std::endl;
	pworld_transitive_map::const_iterator it_pwtm;
	pworld_map::const_iterator it_pwm;
	std::cout << "Edge List:" << std::endl;
	for (it_pwtm = get_beliefs().begin(); it_pwtm != get_beliefs().end(); it_pwtm++) {
		pworld_ptr from = it_pwtm->first;
		pworld_map from_map = it_pwtm->second;

		for (it_pwm = from_map.begin(); it_pwm != from_map.end(); it_pwm++) {
			agent ag = it_pwm->first;
			pworld_ptr_set to_set = it_pwm->second;

			for (it_pwset = to_set.begin(); it_pwset != to_set.end(); it_pwset++) {

				pworld_ptr to = *it_pwset;

				std::cout << "E-" << counter << ": (";
				printer::get_instance().print_list(from.get_fluent_set());
				std::cout << "," << from.get_repetition();
				std::cout << ") - (";
				printer::get_instance().print_list(to.get_fluent_set());
				std::cout << "," << to.get_repetition();
				std::cout << ") ag:" << domain::get_instance().get_grounder().deground_agent(ag);
				std::cout << std::endl;
				counter++;
			}
		}
	}
	std::cout << "*******************************************************************" << std::endl;
}

void pstate::print_graphviz(std::ostream & graphviz) const
{
	string_set::const_iterator it_st_set;
	fluent_set::const_iterator it_fs;


	graphviz << "//WORLDS List:" << std::endl;
	std::map<fluent_set, int> map_world_to_index;
	std::map<unsigned short, char> map_rep_to_name;
	char found_rep = (char) ((char) domain::get_instance().get_agents().size() + 'A');
	int found_fs = 0;
	fluent_set tmp_fs;
	char tmp_unsh;
	string_set tmp_stset;
	bool print_first;
	pworld_ptr_set::const_iterator it_pwset;
	for (it_pwset = get_worlds().begin(); it_pwset != get_worlds().end(); it_pwset++) {
		if (*it_pwset == get_pointed())
			graphviz << "	node [shape = doublecircle] ";
		else
			graphviz << "	node [shape = circle] ";

		print_first = false;
		tmp_fs = it_pwset->get_fluent_set();
		if (map_world_to_index.count(tmp_fs) == 0) {
			map_world_to_index[tmp_fs] = found_fs;
			found_fs++;
		}
		tmp_unsh = it_pwset->get_repetition();
		if (map_rep_to_name.count(tmp_unsh) == 0) {
			map_rep_to_name[tmp_unsh] = found_rep;
			found_rep++;
		}
		graphviz << "\"" << map_rep_to_name[tmp_unsh] << "_" << map_world_to_index[tmp_fs] << "\";";
		graphviz << "// (";
		tmp_stset = domain::get_instance().get_grounder().deground_fluent(tmp_fs);
		for (it_st_set = tmp_stset.begin(); it_st_set != tmp_stset.end(); it_st_set++) {
			if (print_first) {
				graphviz << ",";
			}
			print_first = true;
			graphviz << *it_st_set;
		}
		graphviz << ")\n";
	}

	graphviz << "\n\n";
	graphviz << "//RANKS List:" << std::endl;

	std::map<int, pworld_ptr_set> for_rank_print;
	for (it_pwset = get_worlds().begin(); it_pwset != get_worlds().end(); it_pwset++) {
		for_rank_print[it_pwset->get_repetition()].insert(*it_pwset);
	}

	std::map<int, pworld_ptr_set>::const_iterator it_map_rank;
	for (it_map_rank = for_rank_print.begin(); it_map_rank != for_rank_print.end(); it_map_rank++) {
		graphviz << "	{rank = same; ";
		for (it_pwset = it_map_rank->second.begin(); it_pwset != it_map_rank->second.end(); it_pwset++) {
			graphviz << "\"" << map_rep_to_name[it_pwset->get_repetition()] << "_" << map_world_to_index[it_pwset->get_fluent_set()] << "\"; ";
		}
		graphviz << "}\n";
	}


	graphviz << "\n\n";
	graphviz << "//EDGES List:" << std::endl;

	std::map < std::tuple<std::string, std::string>, std::set<std::string> > edges;

	pworld_transitive_map::const_iterator it_pwtm;
	pworld_map::const_iterator it_pwm;
	std::tuple<std::string, std::string> tmp_tuple;
	std::string tmp_string = "";

	for (it_pwtm = get_beliefs().begin(); it_pwtm != get_beliefs().end(); it_pwtm++) {
		pworld_ptr from = it_pwtm->first;
		pworld_map from_map = it_pwtm->second;

		for (it_pwm = from_map.begin(); it_pwm != from_map.end(); it_pwm++) {
			agent ag = it_pwm->first;
			pworld_ptr_set to_set = it_pwm->second;

			for (it_pwset = to_set.begin(); it_pwset != to_set.end(); it_pwset++) {
				pworld_ptr to = *it_pwset;

				tmp_string = "_" + std::to_string(map_world_to_index[from.get_fluent_set()]);
				tmp_string.insert(0, 1, map_rep_to_name[from.get_repetition()]);
				std::get<0>(tmp_tuple) = tmp_string;

				tmp_string = "_" + std::to_string(map_world_to_index[to.get_fluent_set()]);
				tmp_string.insert(0, 1, map_rep_to_name[to.get_repetition()]);
				std::get<1>(tmp_tuple) = tmp_string;

				edges[tmp_tuple].insert(domain::get_instance().get_grounder().deground_agent(ag));

			}
		}
	}

	std::map < std::tuple<std::string, std::string>, std::set < std::string>>::iterator it_map;
	std::map < std::tuple<std::string, std::string>, std::set < std::string>>::const_iterator it_map_2;

	std::map < std::tuple<std::string, std::string>, std::set < std::string>> to_print_double;
	for (it_map = edges.begin(); it_map != edges.end(); it_map++) {
		for (it_map_2 = it_map; it_map_2 != edges.end(); it_map_2++) {
			if (std::get<0>(it_map->first).compare(std::get<1>(it_map_2->first)) == 0) {
				if (std::get<1>(it_map->first).compare(std::get<0>(it_map_2->first)) == 0) {
					if (it_map->second == it_map_2->second) {
						if (std::get<0>(it_map->first).compare(std::get<1>(it_map->first)) != 0) {
							to_print_double[it_map->first] = it_map->second;
							//std::cerr << std::get<0>(it_map->first) << " " << std::get<0>(it_map_2->first) << "\n";
							it_map_2 = edges.erase(it_map_2);
							it_map = edges.erase(it_map);
						}
					}
				}
			}
		}
	}

	std::set<std::string>::const_iterator it_stset;
	for (it_map = edges.begin(); it_map != edges.end(); it_map++) {
		graphviz << "	\"";
		graphviz << std::get<0>(it_map->first);
		graphviz << "\" -> \"";
		graphviz << std::get<1>(it_map->first);
		graphviz << "\" ";
		graphviz << "[ label = \"";
		tmp_string = "";
		for (it_stset = it_map->second.begin(); it_stset != it_map->second.end(); it_stset++) {
			tmp_string += *it_stset;
			tmp_string += ",";
		}
		tmp_string.pop_back();
		graphviz << tmp_string;
		graphviz << "\" ];\n";
	}

	for (it_map = to_print_double.begin(); it_map != to_print_double.end(); it_map++) {
		graphviz << "	\"";
		graphviz << std::get<0>(it_map->first);
		graphviz << "\" -> \"";
		graphviz << std::get<1>(it_map->first);
		graphviz << "\" ";
		graphviz << "[ dir=both label = \"";
		tmp_string = "";
		for (it_stset = it_map->second.begin(); it_stset != it_map->second.end(); it_stset++) {

			tmp_string += *it_stset;
			tmp_string += ",";
		}
		tmp_string.pop_back();
		graphviz << tmp_string;
		graphviz << "\" ];\n";
	}

	std::string color = "<font color=\"#ffffff\">";
	graphviz << "\n\n//WORLDS description Table:" << std::endl;
	graphviz << "	node [shape = plain]\n\n";
	graphviz << "	description[label=<\n";
	graphviz << "	<table border = \"0\" cellborder = \"1\" cellspacing = \"0\" >\n";
	for (it_pwset = get_worlds().begin(); it_pwset != get_worlds().end(); it_pwset++) {
		tmp_fs = it_pwset->get_fluent_set();
		print_first = false;
		graphviz << "		<tr><td>" << map_rep_to_name[it_pwset->get_repetition()] << "_" << map_world_to_index[tmp_fs] << "</td> <td>";
		for (it_fs = tmp_fs.begin(); it_fs != tmp_fs.end(); it_fs++) {
			if (print_first) {

				graphviz << ", ";
			}
			print_first = true;
			if (helper::is_negate(*it_fs)) color = "<font color=\"#0000ff\"> ";
			else color = "<font color=\"#ff1020\">";
			graphviz << color << domain::get_instance().get_grounder().deground_fluent(*it_fs) << "</font>";
		}
		graphviz << "</td></tr>\n";
	}
	graphviz << "	</table>>]\n";
	graphviz << "	{rank = max; description};\n";

}

/***************ATTITUDES REASONING***************/
agents_attitudes pstate::get_attitude(agent m_agent, agent executor, const complete_attitudes_map & table, bool is_fully) const
{
	if (m_agent == executor) {
		return executor_att;
	}

	auto it_ext = table.find(m_agent);
	if (it_ext != table.end()) {
		auto it_mid = it_ext->second.find(executor);
		if (it_mid != it_ext->second.end()) {
			auto it_int = it_mid->second.begin();
			for (; it_int != it_mid->second.end(); it_int++) {
				//Check if this work.
				if (entails(it_int->second)) {
					return it_int->first;
				}
			}
		}
	}
	if (is_fully) {
		return F_TRUSTY;
	}
	return P_KEEPER;

	//	std::cerr << "\nError: Some attitude declaration is missing, the agent has not any attitude specified.";
	//	exit(1);

}

single_attitudes_map pstate::get_attitudes(agent executor, const agent_set & agents, const complete_attitudes_map & table, bool is_fully) const
{
	//agent_set tot_ags = domain::get_instance().get_agents();
	agent_set::const_iterator it_ag;


	single_attitudes_map ret;
	for (it_ag = agents.begin(); it_ag != agents.end(); it_ag++) {
		//if (*it_ag != executor) {
		ret.insert(std::pair<agent, agents_attitudes>(*it_ag, get_attitude(*it_ag, executor, table, is_fully)));
		//}
	}

	return ret;
}

single_attitudes_map pstate::get_F_attitudes(agent executor, const agent_set & fully_observant) const
{
	return get_attitudes(executor, fully_observant, domain::get_instance().get_attitudes().get_F_attitudes(), true);
}

single_attitudes_map pstate::get_P_attitudes(agent executor, const agent_set & partially_observant) const
{
	return get_attitudes(executor, partially_observant, domain::get_instance().get_attitudes().get_P_attitudes(), false);
}

pworld_ptr pstate::phi_attitudes(fluent announced_f, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes, agent executor) const
{
	//Phi does not change the value of the fluent (In theory only pointed world)
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition()); // We add the corresponding pworld in ret

	//We use this for the lies
	single_attitudes_map modified_diagonal_table = attitudes;
	transition_map_att::const_iterator calculated_pworld;
	agents_attitudes curr_att;
	pworld_ptr to_add;

	bool f_truth_value = !(helper::is_negate(announced_f));
	announced_f = helper::normalize_fluent(announced_f);

	sub_functionIndex sf_i;

	auto it_pwtm = get_beliefs().find(current_pw);
	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;
			auto it_pws = it_pwm->second.begin();


			if (ag == executor) {
				curr_att = F_UNTRUSTY;
			} else {
				curr_att = attitudes.find(ag) -> second;
			}

			//auto it_checkk = domain::get_instance().get_agents().begin();
			//it_checkk = std::next(it_checkk, 3);
			//auto it_checkk3 = std::next(it_checkk, 3);
			//auto it_checkk4 = std::next(it_checkk, 4);
			//if (ag != *it_checkk3) 
			{
				switch ( curr_att ) {

				case P_KEEPER:
				{
					for (; it_pws != it_pwm->second.end(); it_pws++) {
						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), K_func));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = I_attitudes(announced_f, ret, *it_pws, calculated, attitudes);
						}
						ret.add_edge(new_pw, to_add, ag);
					}
					break;
				}
				case P_INSECURE:
				{
					for (; it_pws != it_pwm->second.end(); it_pws++) {
						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), I_func));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = I_attitudes(announced_f, ret, *it_pws, calculated, attitudes);
						}
						ret.add_edge(new_pw, to_add, ag);
					}
					break;
				}
				case F_TRUSTY:
				{

					/*calculated_pworld = calculated.find(std::make_pair(current_pw, T_func));
					if (calculated_pworld == calculated.end()) {
						to_add = T_attitudes(announced_f, ret, current_pw, calculated, attitudes, true);
					}
					ret.add_edge(new_pw, to_add, ag);
					break;*/
					if (f_truth_value) {
						sf_i = TRUE_CHI_func;
					} else {
						sf_i = FALSE_CHI_func;
					}
					for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, true, 1);
						}
						ret.add_edge(new_pw, to_add, ag);

					}
					break;

				}
				case F_MISTRUSTY:
				{
					/*calculated_pworld = calculated.find(std::make_pair(current_pw, M_func));
					if (calculated_pworld == calculated.end()) {
						to_add = T_attitudes(helper::negate_fluent(announced_f), ret, current_pw, calculated, attitudes, false);
					}
					ret.add_edge(new_pw, to_add, ag);*/
					if (!f_truth_value) {
						sf_i = TRUE_CHI_func;
					} else {
						sf_i = FALSE_CHI_func;
					}
					for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, false, 1);
						}
						ret.add_edge(new_pw, to_add, ag);
					}
					break;

				}
				case executor_att:
				case F_UNTRUSTY:
				{
					if (ag == executor) {

						for (; it_pws != it_pwm->second.end(); it_pws++) {
							calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), exec_FUNC));
							if (calculated_pworld != calculated.end()) {
								to_add = calculated_pworld->second;
							} else {
								to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, modified_diagonal_table, 0, executor);
							}
							ret.add_edge(new_pw, to_add, ag);
						}


					} else {

						if (f_truth_value) {
							sf_i = TRUE_U_func;
						} else {
							sf_i = FALSE_U_func;
						}

						for (; it_pws != it_pwm->second.end(); it_pws++) {
							calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), sf_i));
							if (calculated_pworld != calculated.end()) {
								to_add = calculated_pworld->second;
							} else {
								to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, modified_diagonal_table, 3);
							}
							ret.add_edge(new_pw, to_add, ag);
						}
					}
					break;
				}
				case F_STUBBORN:
				{
					break;
				} /* Oblivious Agents.*/
				case oblivious_att:
				default:
				{

					for (; it_pws != it_pwm->second.end(); it_pws++) {
						// If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
						//auto maintained_pworld = ret.get_worlds().find(*it_pws);

						//if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
						//}
					}
					break;
				}
				}

			}

		}
	}

	return new_pw;
}

pworld_ptr pstate::K_attitudes(fluent announced_f, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes) const
{
	unsigned short increase_rep = 2;

	//K does not change the value of the fluent (In theory only pointed world)
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition() + increase_rep); // We add the corresponding pworld in ret
	calculated.insert(transition_map_att::value_type(std::make_pair(std::make_pair(current_pw, increase_rep), K_func), new_pw)); // And we update the calculated map


	transition_map_att::const_iterator calculated_pworld;
	pworld_ptr to_add;

	auto it_pwtm = get_beliefs().find(current_pw);
	bool f_truth_value;
	sub_functionIndex sf_i;
	agents_attitudes curr_attitude;

	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;
			auto it_pws = it_pwm->second.begin();


			curr_attitude = attitudes.find(ag)->second;

			switch ( curr_attitude ) {
			case P_KEEPER:
			{
				for (; it_pws != it_pwm->second.end(); it_pws++) {
					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), K_func));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						to_add = K_attitudes(announced_f, ret, *it_pws, calculated, attitudes);
					}
					ret.add_edge(new_pw, to_add, ag);
				}
				break;
			}
			case P_INSECURE:
			{
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), I_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = I_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);

				break;
			}
			case executor_att:
			case F_TRUSTY:
			case F_MISTRUSTY:
			{

				f_truth_value = current_pw.entails(announced_f);
				if (f_truth_value) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = chi_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, curr_attitude != F_MISTRUSTY, increase_rep);
				}
				//ret.add_edge(new_pw, to_add, ag);
				break;
			}
			case F_UNTRUSTY:
			{
				f_truth_value = current_pw.entails(announced_f);
				if (f_truth_value) {
					sf_i = TRUE_U_func;
				} else {
					sf_i = FALSE_U_func;
				}
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = U_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, increase_rep);
				}
				//ret.add_edge(new_pw, to_add, ag);

				break;
			}
			case F_STUBBORN:
			{
				std::cerr << "\n\nStubborn agents not implemented yet\n";
				exit(1);
				break;
			} // Oblivious Agents.
			case oblivious_att:
			default:
			{
				for (; it_pws != it_pwm->second.end(); it_pws++) {
					// If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					//auto maintained_pworld = ret.get_worlds().find(*it_pws);

					//if (maintained_pworld != ret.get_worlds().end()) {
					ret.add_edge(new_pw, *it_pws, ag);
					//}
				}
				break;
			}
			}
		}
	}
	return new_pw;

}

pworld_ptr pstate::I_attitudes(fluent announced_f, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes) const
{
	unsigned short increase_rep = 2;


	//K does not change the value of the fluent (In theory only pointed world)
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition() + increase_rep); // We add the corresponding pworld in ret
	calculated.insert(transition_map_att::value_type(std::make_pair(std::make_pair(current_pw, increase_rep), I_func), new_pw)); // And we update the calculated map

	pworld_ptr to_add, to_add2;
	bool f_truth_value;
	sub_functionIndex sf_i;
	agents_attitudes curr_attitude;
	transition_map_att::const_iterator calculated_pworld;

	auto it_pwtm = get_beliefs().find(current_pw);

	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;
			auto it_pws = it_pwm->second.begin();

			curr_attitude = attitudes.find(ag)->second;
			switch ( curr_attitude ) {
			case P_KEEPER:
			{
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), K_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = K_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);
				break;
			}
			case P_INSECURE:
			{
				for (; it_pws != it_pwm->second.end(); it_pws++) {

					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), TRUE_CHI_func));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;

					} else {
						to_add = chi_attitudes(announced_f, true, ret, *it_pws, calculated, attitudes, true, increase_rep);
					}

					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), FALSE_CHI_func));
					if (calculated_pworld != calculated.end()) {
						to_add2 = calculated_pworld->second;
					} else {
						to_add2 = chi_attitudes(announced_f, false, ret, *it_pws, calculated, attitudes, true, increase_rep);
					}

					ret.add_edge(new_pw, to_add, ag);
					ret.add_edge(new_pw, to_add2, ag);

					ret.add_edge(to_add, to_add, ag);
					ret.add_edge(to_add2, to_add2, ag);

					ret.add_edge(to_add, to_add2, ag);
					ret.add_edge(to_add2, to_add, ag);
				}
				break;
			}
			case executor_att:
			case F_TRUSTY:
			case F_MISTRUSTY:
			{

				f_truth_value = current_pw.entails(announced_f);
				if (f_truth_value) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = chi_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, curr_attitude != F_MISTRUSTY, increase_rep);
				}
				//ret.add_edge(new_pw, to_add, ag);

				break;
			}
			case F_UNTRUSTY:
			{
				f_truth_value = current_pw.entails(announced_f);
				if (f_truth_value) {
					sf_i = TRUE_U_func;
				} else {
					sf_i = FALSE_U_func;
				}
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = U_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, increase_rep);
				}
				//ret.add_edge(new_pw, to_add, ag);
				break;
			}
			case F_STUBBORN:
			{
				std::cerr << "\n\nStubborn agents not implemented yet\n";
				exit(1);
				break;
			} // Oblivious Agents.
			case oblivious_att:
			default:
			{
				for (; it_pws != it_pwm->second.end(); it_pws++) {
					// If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					//auto maintained_pworld = ret.get_worlds().find(*it_pws);

					//if (maintained_pworld != ret.get_worlds().end()) {
					ret.add_edge(new_pw, *it_pws, ag);
					//}
				}
				break;
			}
			}
		}
	}
	return new_pw;

}

/*pworld_ptr pstate::T_attitudes(fluent announced_f, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes, bool is_trusty) const
{
	unsigned short increase_rep = 1;

	//K does not change the value of the fluent (In theory only pointed world)
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition() + increase_rep); // We add the corresponding pworld in ret
	sub_functionIndex sf_i = T_func;

	if (!is_trusty) {
		sf_i = M_func;
	}
	calculated.insert(transition_map_att::value_type(std::make_pair(current_pw, T_func), new_pw)); // And we update the calculated map

	bool f_truth_value = !(helper::is_negate(announced_f));
	announced_f = helper::normalize_fluent(announced_f);

	pworld_ptr to_add;
	transition_map_att::const_iterator calculated_pworld;

	auto it_pwtm = get_beliefs().find(current_pw);
	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;
			auto it_pws = it_pwm->second.begin();

			agents_attitudes curr_attitude = attitudes.find(ag)->second;

			//We use an if then else to reuse this function for both trusty and mistrusty
			if (curr_attitude == P_KEEPER) {
				calculated_pworld = calculated.find(std::make_pair(current_pw, K_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = K_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);
			} else if (curr_attitude == P_INSECURE) {
				calculated_pworld = calculated.find(std::make_pair(current_pw, I_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = I_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);
			} else if (curr_attitude == F_TRUSTY || (curr_attitude == executor_att && is_trusty)) {
				if (f_truth_value == is_trusty) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				calculated_pworld = calculated.find(std::make_pair(current_pw, sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					if (is_trusty) {
						to_add = chi_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, true);
					} else {
						to_add = chi_attitudes(announced_f, !f_truth_value, ret, current_pw, calculated, attitudes, true);
					}
				}
				//ret.add_edge(new_pw, to_add, ag);
//				for (; it_pws != it_pwm->second.end(); it_pws++) {
//					calculated_pworld = calculated.find(std::make_pair(*it_pws, sf_i));
//					if (calculated_pworld != calculated.end()) {
//						to_add = calculated_pworld->second;
//					} else {
//						if (is_trusty) {
//							to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, true);
//						} else {
//							to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, true);
//
//						}
//					}
//					//ret.add_edge(new_pw, to_add, ag);
//				}
			} else if (curr_attitude == F_MISTRUSTY || (curr_attitude == executor_att && !is_trusty)) {

				if (f_truth_value == is_trusty) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				calculated_pworld = calculated.find(std::make_pair(current_pw, sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					if (!is_trusty) {
						to_add = chi_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, false);
					} else {
						to_add = chi_attitudes(announced_f, !f_truth_value, ret, current_pw, calculated, attitudes, false);
					}
				}
				//ret.add_edge(new_pw, to_add, ag);

			} else if (curr_attitude == F_UNTRUSTY) {

				//f_truth_value = current_pw.entails(announced_f);
				if (f_truth_value == is_trusty) {
					sf_i = TRUE_U_func;
				} else {
					sf_i = FALSE_U_func;
				}
				calculated_pworld = calculated.find(std::make_pair(current_pw, sf_i));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					if (is_trusty) {
						to_add = U_attitudes(announced_f, f_truth_value, ret, current_pw, calculated, attitudes, is_trusty);
					} else {
						to_add = U_attitudes(announced_f, !f_truth_value, ret, current_pw, calculated, attitudes, is_trusty);
					}
				}
				ret.add_edge(new_pw, to_add, ag);


//				if (f_truth_value == is_trusty) {
//					sf_i = TRUE_CHI_func;
//				} else {
//					sf_i = FALSE_CHI_func;
//				}
//				for (; it_pws != it_pwm->second.end(); it_pws++) {
//					calculated_pworld = calculated.find(std::make_pair(*it_pws, sf_i));
//					if (calculated_pworld != calculated.end()) {
//						to_add = calculated_pworld->second;
//					} else {
//						if (is_trusty) {
//							to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, is_trusty);
//						} else {
//							to_add = U_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, is_trusty);
//						}
//					}
//					ret.add_edge(new_pw, to_add, ag);
//				}
			} else if (curr_attitude == F_STUBBORN) {
				exit(1);
			}// Oblivious Agents.
			else {
				for (; it_pws != it_pwm->second.end(); it_pws++) {
					// If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					auto maintained_pworld = ret.get_worlds().find(*it_pws);

					if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
					}
				}
			}

		}
	}
	return new_pw;

}*/

pworld_ptr pstate::U_attitudes(fluent announced_f, bool f_truth_value, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes, unsigned short increase_rep, agent executor) const
{
	//K does not change the value of the fluent (In theory only pointed world)

	sub_functionIndex sf_i;

	if (!executor.empty()) {
		sf_i = exec_FUNC;
	} else if (f_truth_value) {
		sf_i = TRUE_U_func;
	} else {
		sf_i = FALSE_U_func;
	}
	
	
	


	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition() + increase_rep); // We add the corresponding pworld in ret
	calculated.insert(transition_map_att::value_type(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i), new_pw)); // And we update the calculated map

	if (increase_rep == 0)
	{
		increase_rep = 1;
	}
		unsigned short incr_arg = increase_rep;

	
	/*if (!executor.empty()) {
		increase_rep = 1;
	}*/

	auto it_pwtm = get_beliefs().find(current_pw);

	pworld_ptr to_add;
	transition_map_att::const_iterator calculated_pworld;

	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;
			auto it_pws = it_pwm->second.begin();
			agents_attitudes curr_att;
			//	if (!executor.empty()) {
			if (ag == executor) {
				//increase_rep = 0;
				sf_i = exec_FUNC;
				for (; it_pws != it_pwm->second.end(); it_pws++) {

					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, 0), sf_i));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, 0, executor);
					}
					ret.add_edge(new_pw, to_add, ag);
				}
				//	}
			} else {

				curr_att = attitudes.find(ag) -> second;

				switch ( curr_att ) {
				case P_KEEPER:
				{
					calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), K_func));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						to_add = K_attitudes(announced_f, ret, current_pw, calculated, attitudes);
					}
					ret.add_edge(new_pw, to_add, ag);
					break;
				}
				case P_INSECURE:
				{
					calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), I_func));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						to_add = I_attitudes(announced_f, ret, current_pw, calculated, attitudes);
					}
					ret.add_edge(new_pw, to_add, ag);
					break;
				}
				case executor_att:
				case F_TRUSTY:
				{
					if (f_truth_value) {
						sf_i = TRUE_CHI_func;
					} else {
						sf_i = FALSE_CHI_func;
					}
					if (increase_rep != 2) {
						incr_arg = 1;
					}
					for (; it_pws != it_pwm->second.end(); it_pws++) {
						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, incr_arg), sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, true, incr_arg);
						}
						if (increase_rep != 2) {
							ret.add_edge(new_pw, to_add, ag);
						}
					}
					break;

				}
					/*for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(*it_pws, sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							if (is_trusty) {
								to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, true);
							} else {
								to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, true);
							}
						}
						ret.add_edge(new_pw, to_add, ag);
					}*/


				case F_MISTRUSTY:
				{
					if (!f_truth_value) {
						sf_i = TRUE_CHI_func;
					} else {
						sf_i = FALSE_CHI_func;
					}

					if (increase_rep != 2) {
						incr_arg = 1;
					}
					for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, incr_arg), sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, false, incr_arg);
						}

						if (increase_rep != 2) {
							ret.add_edge(new_pw, to_add, ag);
						}
					}
					break;
				}

					/*for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(*it_pws, sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							if (!is_trusty) {
								to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, false);
							} else {
								to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, false);
							}
						}
						ret.add_edge(new_pw, to_add, ag);
					}*/

				case F_UNTRUSTY:
				{
					if (f_truth_value) {
						sf_i = TRUE_U_func;
					} else {
						sf_i = FALSE_U_func;
					}
					for (; it_pws != it_pwm->second.end(); it_pws++) {

						calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), sf_i));
						if (calculated_pworld != calculated.end()) {
							to_add = calculated_pworld->second;
						} else {
							to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, increase_rep);

						}
						ret.add_edge(new_pw, to_add, ag);
					}
					break;
				}
				case F_STUBBORN:
				{
					std::cerr << "\n\nStubborn agents not implemented yet\n";
					exit(1);
					break;
				} // Oblivious Agents.
				case oblivious_att:
				default:
				{
					for (; it_pws != it_pwm->second.end(); it_pws++) {
						// If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
						//auto maintained_pworld = ret.get_worlds().find(*it_pws);

						//if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
						//}
					}
					break;
				}
				}
			}
		}
	}
	return new_pw;
}

pworld_ptr pstate::chi_attitudes(fluent announced_f, bool f_truth_value, pstate &ret, const pworld_ptr &current_pw, transition_map_att &calculated, const single_attitudes_map & attitudes, bool is_trusty, unsigned short increase_rep) const
{
	//Chi changes the value of the fluent
	fluent_set updated_pwfs = current_pw.get_fluent_set();

	unsigned short incr_arg = increase_rep;

	fluent to_apply;
	sub_functionIndex sf_i;
	if (f_truth_value) {
		to_apply = announced_f;
		sf_i = TRUE_CHI_func;
	} else {
		to_apply = helper::negate_fluent(announced_f);
		sf_i = FALSE_CHI_func;

	}

	helper::apply_effect(to_apply, updated_pwfs);

	pworld_ptr new_pw = ret.add_rep_world(pworld(updated_pwfs), current_pw.get_repetition() + increase_rep); // We add the corresponding pworld in ret
	calculated.insert(transition_map_att::value_type(std::make_pair(std::make_pair(current_pw, increase_rep), sf_i), new_pw)); // And we update the calculated map


	auto it_pwtm = get_beliefs().find(current_pw);

	pworld_ptr to_add;
	transition_map_att::const_iterator calculated_pworld;

	if (it_pwtm != get_beliefs().end()) {
		auto it_pwm = it_pwtm->second.begin();

		for (; it_pwm != it_pwtm->second.end(); it_pwm++) {

			auto it_pws = it_pwm->second.begin();

			agent ag = it_pwm->first;
			agents_attitudes curr_attitude = attitudes.find(ag)->second;


			if (curr_attitude == P_KEEPER) {
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), K_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = K_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);


			} else if (curr_attitude == P_INSECURE) {
				calculated_pworld = calculated.find(std::make_pair(std::make_pair(current_pw, increase_rep), I_func));
				if (calculated_pworld != calculated.end()) {
					to_add = calculated_pworld->second;
				} else {
					to_add = I_attitudes(announced_f, ret, current_pw, calculated, attitudes);
				}
				ret.add_edge(new_pw, to_add, ag);

			} else if (curr_attitude == F_TRUSTY || (curr_attitude == executor_att && is_trusty) || (curr_attitude == F_MISTRUSTY && increase_rep == 2)) {
				if (f_truth_value == is_trusty) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				for (; it_pws != it_pwm->second.end(); it_pws++) {

					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), sf_i));

					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						if (is_trusty) {
							to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, true, increase_rep);
						} else {
							to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, true, increase_rep);
						}
					}
					ret.add_edge(new_pw, to_add, ag);
				}

			} else if (curr_attitude == F_MISTRUSTY || (curr_attitude == executor_att && !is_trusty)) {
				if (f_truth_value != is_trusty) {
					sf_i = TRUE_CHI_func;
				} else {
					sf_i = FALSE_CHI_func;
				}
				for (; it_pws != it_pwm->second.end(); it_pws++) {

					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, increase_rep), sf_i));

					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;

					} else {
						if (!is_trusty) {
							to_add = chi_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, false, increase_rep);
						} else {
							to_add = chi_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, false, increase_rep);
						}
					}
					ret.add_edge(new_pw, to_add, ag);
				}
			} else if (curr_attitude == F_UNTRUSTY) {
				if (f_truth_value == is_trusty) {
					sf_i = TRUE_U_func;
				} else {
					sf_i = FALSE_U_func;
				}
				//for (; it_pws != it_pwm->second.end(); it_pws++) {
				if (increase_rep != 2) {
					incr_arg = 3;
				}

				for (; it_pws != it_pwm->second.end(); it_pws++) {
					calculated_pworld = calculated.find(std::make_pair(std::make_pair(*it_pws, incr_arg), sf_i));
					if (calculated_pworld != calculated.end()) {
						to_add = calculated_pworld->second;
					} else {
						if (is_trusty) {
							to_add = U_attitudes(announced_f, f_truth_value, ret, *it_pws, calculated, attitudes, incr_arg);
						} else {
							to_add = U_attitudes(announced_f, !f_truth_value, ret, *it_pws, calculated, attitudes, incr_arg);
						}
					}
					if (increase_rep != 2) {
						ret.add_edge(new_pw, to_add, ag);
					}
				}
				//}
			} else if (curr_attitude == F_STUBBORN) {
				std::cerr << "\n\nStubborn agents not implemented yet\n";
				exit(1);
			}/* Oblivious Agents.*/
			else {
				//std::cerr << "\nDEBUG: Reached CHI 9 with ag: " << domain::get_instance().get_grounder().deground_agent(ag) << "\n";
				//				belief_formula bf, ext_bf;
				//				fluent_formula ff;
				//				fluent_set fs;
				//				fluent f;
				//				bool changed_belief = (f_truth_value != current_pw.entails(announced_f));
				for (; it_pws != it_pwm->second.end(); it_pws++) {

					//					if (changed_belief) {
					//						//	if (it_pws->entails(announced_f) != current_pw.entails(announced_f))
					//
					//
					//						if (!f_truth_value) {
					//							f = announced_f;
					//						} else {
					//							f = helper::negate_fluent(announced_f);
					//						}
					//
					//						fs.insert(f);
					//						ff.insert(fs);
					//
					//						bf.set_formula_type(FLUENT_FORMULA);
					//						bf.set_fluent_formula(ff);
					//						bf.set_is_grounded(true);
					//						bf.deground();
					//
					//						ext_bf.set_formula_type(BELIEF_FORMULA);
					//						ext_bf.set_agent(ag);
					//						ext_bf.set_bf1(bf);
					//						ext_bf.set_is_grounded(true);
					//						ext_bf.deground();
					//
					//
					//						auto tmp_pworld = new_pw;
					//						tmp_pworld.set_repetition(current_pw.get_repetition());
					//						auto find_pworld = m_worlds.find(tmp_pworld);
					//						if (find_pworld != m_worlds.end()) {
					//							if (!entails(ext_bf, *find_pworld)) {
					//								//	ret.add_edge(new_pw, *it_pws, ag);
					//								ret.add_edge(new_pw, *it_pws, ag);
					//							}
					//						} else {
					//							ret.add_edge(new_pw, *it_pws, ag);
					//						}
					//						
					//						auto tmpSet = get_B_reachable_worlds(ag, current_pw);
					//						auto tmpSet_it = tmpSet.find(current_pw);
					//						if (tmpSet_it != tmpSet.end())
					//						{
					//							if
					//						}
					//						//
					//
					//					} else if (!changed_belief){
					ret.add_edge(new_pw, *it_pws, ag);
					//}
					//}
				}
			}
		}
	}
	return new_pw;

}

pstate pstate::execute_sensing_att(const action & act) const
{
	////std::cerr << "\n\nDEBUG: Reached Sensing 1\n";
	pstate ret;

	//This finds all the worlds that are reachable from the initial state following
	//the edges labeled with fully observant agents.
	agent_set agents = domain::get_instance().get_agents();
	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());
	agent_set partially_obs_agents = get_agents_if_entailed(act.get_partially_observants(), get_pointed());

	agent_set oblivious_obs_agents = agents;
	minus_set(oblivious_obs_agents, fully_obs_agents);
	minus_set(oblivious_obs_agents, partially_obs_agents);

	//agent executor = act.get_executor();
	single_attitudes_map attitudes;

	auto it_ags = fully_obs_agents.begin();
	//We set all the fully observant to be trusty
	for (; it_ags != fully_obs_agents.end(); it_ags++) {
		//	//std::cerr << "\nDEBUG: Reached Sensing F\n";

		attitudes.insert(std::make_pair(*it_ags, F_TRUSTY));
	}
	//attitudes.insert(std::make_pair(executor, F_TRUSTY));

	//We set all the partially observant to be keeper
	it_ags = partially_obs_agents.begin();
	for (; it_ags != partially_obs_agents.end(); it_ags++) {
		attitudes.insert(std::make_pair(*it_ags, P_KEEPER));
	}

	if (!oblivious_obs_agents.empty()) {
		ret.set_max_depth(get_max_depth() + 1);
		auto it_obl = oblivious_obs_agents.begin();
		for (; it_obl != oblivious_obs_agents.end(); it_obl++) {
			//		//std::cerr << "\nDEBUG: Reached Sensing O\n";

			//We use "oblivious_att" to encode the oblivious agents
			attitudes.insert(std::make_pair(*it_obl, oblivious_att));
		}
	}

	transition_map_att calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);

	fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());

	////std::cerr << "\nDEBUG: Reached Sensing 2\n";


	if (effects.size() == 1) {
		if (effects.begin()->size() == 1) {
			//	//std::cerr << "\nDEBUG: Reached Sensing 3\n";

			fluent single_eff = *(effects.begin()->begin());
			//	//std::cerr << "\nDEBUG: Reached Sensing 4\n";

			//pworld_ptr new_pointed = phi_attitudes(*(fully_obs_agents.begin()), single_eff, ret, get_pointed(), calculated, attitudes, false);
			pworld_ptr new_pointed = phi_attitudes(single_eff, ret, get_pointed(), calculated, attitudes);

			//	//std::cerr << "\nDEBUG: Reached Sensing 5\n";

			ret.set_pointed(new_pointed); // Updating the pointed world


			return ret;
		}
	}

	std::cerr << "\n\nAttitudes-based sensing only allows for single fluent effects.";
	std::cerr << "\nThe action " << act.get_name() << " has the following effects: ";
	printer::get_instance().print_list(effects);
	std::cerr << std::endl;

	exit(1);
}

pstate pstate::execute_announcement_att(const action & act) const
{
	pstate ret;

	//This finds all the worlds that are reachable from the initial state following
	//the edges labeled with fully observant agents.
	agent_set agents = domain::get_instance().get_agents();
	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());
	agent_set partially_obs_agents = get_agents_if_entailed(act.get_partially_observants(), get_pointed());

	agent_set oblivious_obs_agents = agents;
	minus_set(oblivious_obs_agents, fully_obs_agents);
	minus_set(oblivious_obs_agents, partially_obs_agents);

	agent executor = act.get_executor();
	single_attitudes_map attitudes = get_P_attitudes(executor, partially_obs_agents);
	single_attitudes_map F_attitudes = get_F_attitudes(executor, fully_obs_agents);

	//bool ag_trusty = false;
	//bool ag_mistrusty = false;


	auto it_att = F_attitudes.begin();
	//agents_attitudes tmp_att;
	for (; it_att != F_attitudes.end(); it_att++) {
		//tmp_att = it_att->second;
		attitudes.insert(std::make_pair(it_att->first, it_att->second));
	//	std::cerr << "\nDEBUG: Agent " << domain::get_instance().get_grounder().deground_agent(it_att->first) << " has attitude " << it_att->second << " wrt " << domain::get_instance().get_grounder().deground_agent(executor);
		/*switch ( tmp_att ) {

		case F_TRUSTY:
			ag_trusty = true;
			break;
		case F_MISTRUSTY:
			ag_mistrusty = true;
			break;
		default:
			break;

		}*/
	}

	if (!oblivious_obs_agents.empty()) {
		ret.set_max_depth(get_max_depth() + 1);
		auto it_obl = oblivious_obs_agents.begin();
		for (; it_obl != oblivious_obs_agents.end(); it_obl++) {
			//We use "oblivious_att" to encode the oblivious agents
			attitudes.insert(std::make_pair(*it_obl, oblivious_att));
		}
	}

	transition_map_att calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);

	fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());

	if (effects.size() == 1) {
		if (effects.begin()->size() == 1) {

			fluent single_eff = *(effects.begin()->begin());

			//pworld_ptr new_pointed = phi_attitudes(executor, single_eff, ret, get_pointed(), calculated, attitudes, (ag_trusty && ag_mistrusty));
			pworld_ptr new_pointed = phi_attitudes(single_eff, ret, get_pointed(), calculated, attitudes, executor);

			ret.set_pointed(new_pointed); // Updating the pointed world

			/*if (!check_properties(fully_obs_agents, partially_obs_agents, effects, ret)) {
				std::cerr << "\nDEBUG: Some properties are not respected\n\n";
				exit(1);
			}*/

			return ret;
		}
	}

	std::cerr << "\n\nAttitudes-based announcement only allows for single fluent effects";
	exit(1);
}

/***************END ATTITUDES REASONING***************/

/***************DOXASTIC REASONING***************/

pworld_ptr pstate::execute_announcement_helper_dox(const fluent_formula &effects, pstate &ret, const pworld_ptr &current_pw, transition_map &calculated, agent_set &partially_obs_agents, agent_set &oblivious_obs_agents, bool reached_by_fully, bool & implications) const
{
	pworld_ptr new_pw = ret.add_rep_world(pworld(current_pw.get_fluent_set()), current_pw.get_repetition()); // We add the corresponding pworld in ret
	calculated.insert(transition_map::value_type(current_pw, new_pw)); // And we update the calculated map

	auto it_pwtm = get_beliefs().find(current_pw);

	if (it_pwtm != get_beliefs().end()) {
		pworld_map::const_iterator it_pwm;
		pworld_ptr_set::const_iterator it_pws;

		for (it_pwm = it_pwtm->second.begin(); it_pwm != it_pwtm->second.end(); it_pwm++) {
			agent ag = it_pwm->first;

			bool is_oblivious_obs = oblivious_obs_agents.find(ag) != oblivious_obs_agents.end();
			bool is_partially_obs = partially_obs_agents.find(ag) != partially_obs_agents.end();
			bool is_fully_obs = !is_oblivious_obs && !is_partially_obs;

			for (it_pws = it_pwm->second.begin(); it_pws != it_pwm->second.end(); it_pws++) {

				if (is_partially_obs) {
					pworld_ptr_set tmp_set = get_B_reachable_worlds(ag, *it_pws);
					pworld_ptr_set::const_iterator it_tmp;
					bool tmp_ent1 = false;
					bool tmp_ent2 = false;

					for (it_tmp = tmp_set.begin(); it_tmp != tmp_set.end();) {
						if (entails(effects, *it_tmp)) {
							tmp_ent1 = true;
						} else {
							tmp_ent2 = true;
						}

						if (tmp_ent1 && tmp_ent2) {
							is_fully_obs = true;
							implications = true;
							is_partially_obs = false;
							it_tmp = tmp_set.end();
						} else {
							it_tmp++;
						}
					}
				}

				if (is_oblivious_obs) { // If we are dealing with an OBLIVIOUS agent we maintain its beliefs as they were
					auto maintained_pworld = ret.get_worlds().find(*it_pws);

					if (maintained_pworld != ret.get_worlds().end()) {
						ret.add_edge(new_pw, *it_pws, ag);
					}
				} else { // Otherwise, if we have a FULLY/PARTIALLY observant agent
					auto calculated_pworld = calculated.find(*it_pws);
					//fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());
					//bool ent = act.get_type() == SENSING ? entails(effects, *it_pws) == entails(effects, get_pointed()) : entails(effects, *it_pws);


					bool is_consistent_belief = ((!reached_by_fully && is_partially_obs) ||
						(reached_by_fully && is_partially_obs && (entails(effects, *it_pws))) ||
						(is_fully_obs && (entails(effects, *it_pws)))); // if a PARTIALLY OBS agent believes that "ag" thinks that "calculated" may be true (i.e., when "previous_entailment" holds)

					if (calculated_pworld != calculated.end()) { // If we already calculated the transition function for this pworld
						if (is_consistent_belief) {
							ret.add_edge(new_pw, calculated_pworld->second, ag);
						}
					} else { // If we did not already calculate the transition function
						if (is_consistent_belief) { // We calculate it if it would result in a consistent belief...
							pworld_ptr believed_pw = execute_announcement_helper_dox(effects, ret, *it_pws, calculated, partially_obs_agents, oblivious_obs_agents, (reached_by_fully || is_fully_obs), implications);
							ret.add_edge(new_pw, believed_pw, ag);
						}
					}
				}
			}
		}
	}
	return new_pw;
}

pstate pstate::execute_announcement_dox(const action & act) const
{
	pstate ret;

	//This finds all the worlds that are reachable from the initial state following
	//the edges labeled with fully observant agents.
	agent_set agents = domain::get_instance().get_agents();
	agent_set fully_obs_agents = get_agents_if_entailed(act.get_fully_observants(), get_pointed());
	agent_set partially_obs_agents = get_agents_if_entailed(act.get_partially_observants(), get_pointed());

	agent_set oblivious_obs_agents = agents;
	minus_set(oblivious_obs_agents, fully_obs_agents);
	minus_set(oblivious_obs_agents, partially_obs_agents);

	if (!oblivious_obs_agents.empty()) {
		ret.set_max_depth(get_max_depth() + 1);
	}

	transition_map calculated; // A map that links the pworlds of *this* to the corresponding ones of ret
	maintain_oblivious_believed_pworlds(ret, oblivious_obs_agents);

	fluent_formula effects = get_effects_if_entailed(act.get_effects(), get_pointed());

	bool implications = true;
	if (fully_obs_agents.size() == 0) {
		implications = false;
	}

	pworld_ptr new_pointed = execute_announcement_helper_dox(effects, ret, get_pointed(), calculated, partially_obs_agents, oblivious_obs_agents, false, implications);
	ret.set_pointed(new_pointed); // Updating the pointed world

	if (!implications) {
		ret = *this;
	}

	return ret;
}

/***************END DOXASTIC***************/

/****************BISIMULATION********************/
void pstate::get_all_reachable_worlds(const pworld_ptr & pw, pworld_ptr_set & reached_worlds, pworld_transitive_map & reached_edges) const
{

	//std::cerr << "\nDEBUG: QUI 1\n" << std::flush;

	pworld_ptr_set::const_iterator it_pwps;
	pworld_ptr_set pw_list;

	//reached_worlds.insert(kw);
	auto ag_set = domain::get_instance().get_agents();
	auto ag_it = ag_set.begin();
	for (; ag_it != ag_set.end(); ag_it++) {
		//std::cerr << "\nDEBUG: QUI 2\n" << std::flush;

		pw_list = m_beliefs.at(pw).at(*ag_it);
		//std::cerr << "\nDEBUG: QUI 3\n" << std::flush;

		for (it_pwps = pw_list.begin(); it_pwps != pw_list.end(); it_pwps++) {
			if (reached_worlds.insert(*it_pwps).second) {
				//std::cerr << "\nDEBUG: QUI 4\n" << std::flush;

				get_all_reachable_worlds(*it_pwps, reached_worlds, reached_edges);
				reached_edges.insert(std::make_pair(*it_pwps, m_beliefs.at(*it_pwps)));
			}
		}
	}
}

void pstate::clean_unreachable_pworlds()
{
	//std::cerr << "\nDEBUG: INIZIO CLEAN EXTRA PSTATE\n" << std::flush;

	pworld_ptr_set reached_worlds;
	pworld_transitive_map reached_edges;

	reached_worlds.insert(get_pointed());
	reached_edges.insert(std::make_pair(get_pointed(), m_beliefs.at(get_pointed())));
	//std::cerr << "\nDEBUG: CLEAN 1 EXTRA PSTATE\n" << std::flush;

	get_all_reachable_worlds(get_pointed(), reached_worlds, reached_edges);

	//std::cerr << "\nDEBUG: CLEAN 2 EXTRA PSTATE\n" << std::flush;

	set_worlds(reached_worlds);
	set_beliefs(reached_edges);

	//std::cerr << "\nDEBUG: FINE CLEAN EXTRA PSTATE\n" << std::flush;
}

const automa pstate::pstate_to_automaton(std::vector<pworld_ptr> & pworld_vec, const std::map<agent, bis_label> & agent_to_label) const
{

	std::map<int, int> compact_indices;
	std::map<pworld_ptr, int> index_map;
	pbislabel_map label_map; // Map: from -> (to -> ag_set)

	automa *a;
	int Nvertex = get_worlds().size();
	int ag_set_size = domain::get_instance().get_agents().size();
	//BIS_ADAPTATION For the loop that identifies the id (We add one edge for each node)
	v_elem *Vertex;

	Vertex = (v_elem *) malloc(sizeof(v_elem) * Nvertex);

	// Initializating vertices
	pworld_ptr_set::const_iterator it_pwps;
	pworld_transitive_map::const_iterator it_peps;
	pbislabel_map::const_iterator it_plm;
	bis_label_set::const_iterator it_bislab;
	std::map<pworld_ptr, bis_label_set>::const_iterator it_pw_bislab;

	//std::cerr << "\nDEBUG: Inizializzazione Edges\n";

	// The pointed world is set to the index 0. This ensures that, when deleting the bisimilar nodes, the pointed pworld
	// is always chosen as the first of its block. Therefore, we do not need to update it when converting back to a kstate
	index_map[get_pointed()] = 0;
	pworld_vec.push_back(get_pointed());
	compact_indices[get_pointed().get_numerical_id()] = 0;

	//For the loop that identifies the id
	//BIS_ADAPTATION For the loop that identifies the id (+1)
	///@bug: If the pointed has no self-loop to add
	//pworld_ptr_set pointed_adj = adj_list.at(get_pointed());

	Vertex[0].ne = 0; // pointed_adj.size(); // edge_counter[get_pointed()];
	//	if (pointed_adj.find(get_pointed()) == pointed_adj.end()) {
	//		Vertex[0].ne++;
	//	}
	//	Vertex[0].e = (e_elem *) malloc(sizeof(e_elem) * Vertex[0].ne);

	int i = 1, c = 1;

	//std::cerr << "\nDEBUG: Inizializzazione Vertex\n";

	for (it_pwps = m_worlds.begin(); it_pwps != m_worlds.end(); it_pwps++) {
		if (!(*it_pwps == get_pointed())) {
			index_map[*it_pwps] = i;
			pworld_vec.push_back(*it_pwps);

			// if (compact_indices.find(it_pwps->get_numerical_id()) == compact_indices.end()) {
			if (compact_indices.insert({it_pwps->get_numerical_id(), c}).second) {
				// compact_indices[it_pwps->get_numerical_id()] = c;
				c++;
				//std::cerr << "\nDEBUG: Added:" << it_pwps->get_id() << "\n";
			}
			Vertex[i].ne = 0;
			i++;
		}
		//BIS_ADAPTATION (Added self-loop)
		label_map[*it_pwps][*it_pwps].insert(compact_indices[it_pwps->get_numerical_id()] + ag_set_size);
		//std::cerr << "\nDEBUG: Added to " << it_pwps->get_numerical_id() << " the label " << compact_indices[it_pwps->get_numerical_id()] + ag_set_size << std::endl;
	}


	//BIS_ADAPTATION For the loop that identifies the id (We add one potential label for each node)
	int bhtabSize = ag_set_size + c;

	//std::cerr << "\nDEBUG: Inizializzazione Behavs\n";

	//BIS_ADAPTATION (Moved down here)

	for (it_peps = m_beliefs.begin(); it_peps != m_beliefs.end(); it_peps++) {

		for (auto it_mid_bel = it_peps->second.begin(); it_mid_bel != it_peps->second.end(); it_mid_bel++) {
			for (auto it_int_ed = it_mid_bel->second.begin(); it_int_ed != it_mid_bel->second.end(); it_int_ed++) {
				label_map[it_peps->first][*it_int_ed].insert(agent_to_label.at(it_mid_bel->first));
				Vertex[index_map[it_peps->first]].ne++;
			}
		}
	}

	i = 0;
	for (it_pwps = m_worlds.begin(); it_pwps != m_worlds.end(); it_pwps++) {
		Vertex[i].ne++; //Self loop bisimulation
		Vertex[i].e = (e_elem *) malloc(sizeof(e_elem) * Vertex[i].ne);
		i++;
	}

	//std::cerr << "\nDEBUG: Fine Inizializzazione Vertex\n";


	int from, to, j = 0; //, k = 0, nbh;

	//std::cerr << "\nDEBUG: Inizializzazione Mappa\n";
	for (it_plm = label_map.begin(); it_plm != label_map.end(); it_plm++) {
		from = index_map[it_plm->first]; // For each pworld 'from'

		//std::cerr << "\nDEBUG: Inizializzazione K\n";

		for (it_pw_bislab = it_plm->second.begin(); it_pw_bislab != it_plm->second.end(); it_pw_bislab++) { // For each edge that reaches the pworld 'to'
			to = index_map[it_pw_bislab->first];
			//nbh = it_pw_bislab->second.size();

			for (it_bislab = it_pw_bislab->second.begin(); it_bislab != it_pw_bislab->second.end(); it_bislab++) { // For each agent 'ag' in the label of the kedge
				//std::cerr << "\nDEBUG: j is: " << j << " and k is: " << k << "\n";
				//nbh = 1;
				Vertex[from].e[j].nbh = 1; // Let j be the index of the adjacency list of from that stores the kedge (from, to)
				Vertex[from].e[j].bh = (int *) malloc(sizeof(int)); // Let nbh be the number of agents in such kedge
				Vertex[from].e[j].tv = to; // Update the value of the reache pworld
				Vertex[from].e[j].bh[0] = *it_bislab; // Update the value of the label at index k to 'ag'
				//std::cerr << "\nDEBUG: j is: " << j << " and k is: " << k << "\n";

				j++; // Update the value of the index j
			}


		}

		j = 0; // Reset j
	}

	int Nbehavs = bhtabSize;
	a = (automa *) malloc(sizeof(automa));
	a->Nvertex = Nvertex;
	a->Nbehavs = Nbehavs;
	a->Vertex = Vertex;

	//	std::cerr << "\nDEBUG: \n\tNvertex = " << Nvertex << std::endl;
	//	std::cerr << "\tNbehavs = " << Nbehavs << std::endl;

	return *a;
}

void pstate::automaton_to_pstate(const automa & a, const std::vector<pworld_ptr> & pworld_vec, const std::map<bis_label, agent> & label_to_agent)
{
	//std::cerr << "\nDEBUG: INIZIO BISIMULATION TO PSTATE\n" << std::flush;

	pworld_ptr_set worlds;
	m_beliefs.clear();
	// The pointed world does not change when we calculate the minimum bisimilar state
	// Hence we do not need to update it

	int i, j, k, label, agents_size = domain::get_instance().get_agents().size();

	for (i = 0; i < a.Nvertex; i++) {
		if (a.Vertex[i].ne > 0) {
			worlds.insert(pworld_vec[i]);
			for (j = 0; j < a.Vertex[i].ne; j++) {
				for (k = 0; k < a.Vertex[i].e[j].nbh; k++) {
					label = a.Vertex[i].e[j].bh[k];
					if (label < agents_size) {
						add_edge(pworld_vec[i], pworld_vec[a.Vertex[i].e[j].tv], label_to_agent.at(label));
					}
				}
			}
		}

	}


	set_worlds(worlds);
	//std::cerr << "\nDEBUG: FINE BISIMULATION TO PSTATE\n" << std::flush;

	//set_edges(edges);
}

void pstate::calc_min_bisimilar()
{
	//std::cerr << "\nDEBUG: INIZIO BISIMULATION IN PSTATE\n" << std::flush;

	// ************* Cleaning unreachable pworlds *************

	clean_unreachable_pworlds();

	std::vector<pworld_ptr> pworld_vec; // Vector of all pworld_ptr
	//std::cerr << "\nDEBUG: PRE-ALLOCAZIONE AUTOMA\n" << std::flush;


	//	std::cerr << "\nDEBUG: \n\tNvertex_before = " << m_worlds.size() << std::endl;
	//	std::cerr << "\tNbehavs_before = " << m_edges.size() << std::endl;

	automa a;
	pworld_vec.reserve(get_worlds().size());

	std::map<bis_label, agent> label_to_agent;
	std::map<agent, bis_label> agent_to_label;


	auto agents = domain::get_instance().get_agents();
	auto it_ag = agents.begin();
	bis_label ag_label = 0;
	agent lab_agent;
	for (; it_ag != agents.end(); it_ag++) {
		lab_agent = *it_ag;
		label_to_agent.insert(std::make_pair(ag_label, lab_agent));
		agent_to_label.insert(std::make_pair(lab_agent, ag_label));
		ag_label++;

	}

	a = pstate_to_automaton(pworld_vec, agent_to_label);

	bisimulation b;
	//std::cout << "\nDEBUG: Printing automa pre-Bisimulation\n";
	//b.VisAutoma(&a);

	if (domain::get_instance().get_bisimulation() == PaigeTarjan) {
		if (b.MinimizeAutomaPT(&a)) {
			//VisAutoma(a);

			//std::cout << "\nDEBUG: Printing automa post-Bisimulation\n";
			//b.VisAutoma(&a);
			//std::cout << "Done\n";
			automaton_to_pstate(a, pworld_vec, label_to_agent);

			//b.DisposeAutoma(&a);
		}
	} else {
		if (b.MinimizeAutomaFB(&a)) {

			//std::cerr << "\nDEBUG: Printing automa post-Bisimulation\n";
			//b.VisAutoma(&a);
			//std::cerr << "Done\n";
			automaton_to_pstate(a, pworld_vec, label_to_agent);
			//b.DisposeAutoma(&a);
		}
	}

	//std::cerr << "\nDEBUG: PRe Clean" << std::endl;

}
/*********************END BISIMILUATION***********************/

/******************************MOVE TO HELPER*********************************/

template <class T>
void pstate::sum_set(std::set<T> & to_modify, const std::set<T> & factor2) const
{
	/**\todo move to helper*/
	typename std::set<T>::const_iterator it_pwset;
	for (it_pwset = factor2.begin(); it_pwset != factor2.end(); it_pwset++) {

		to_modify.insert(*it_pwset);
	}
}

template <class T>
void pstate::minus_set(std::set<T> & to_modify, const std::set<T> & factor2) const
{ /**\todo move to helper*/

	typename std::set<T>::const_iterator it_pwset;
	for (it_pwset = factor2.begin(); it_pwset != factor2.end(); it_pwset++) {

		to_modify.erase(*it_pwset);
	}
}

agent_set pstate::get_agents_if_entailed(const observability_map& map, const pworld_ptr & start) const
{ /**\todo move to helper*/

	agent_set ret;
	observability_map::const_iterator it_map;
	for (it_map = map.begin(); it_map != map.end(); it_map++) {
		if (entails(it_map->second, start)) {

			ret.insert(it_map->first);
		}
	}
	return ret;
}

fluent_formula pstate::get_effects_if_entailed(const effects_map & map, const pworld_ptr & start) const
{ /**\todo move to helper*/

	fluent_formula ret;
	effects_map::const_iterator it_map;
	for (it_map = map.begin(); it_map != map.end(); it_map++) {
		if (entails(it_map->second, start)) {
			ret = helper::and_ff(ret, it_map->first);
		}
	}
	if (ret.size() > 1) {

		std::cerr << "\nNon determinism in action effect is not supported-1.\n";
		exit(1);
	}
	return ret;
}

/******************************END MOVE TO HELPER*********************************/


int pstate::get_edges() const
{
	std::cerr << "\nYou are playing with debug only options-1.\n";
	exit(1);
}

void pstate::debug_print(pstate tmp)
{
	std::cerr << "\nYou are playing with debug only options-2.\n";
	exit(1);
}


