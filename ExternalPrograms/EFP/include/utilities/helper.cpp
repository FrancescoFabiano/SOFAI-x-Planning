/* \brief Implementation of helper.h
 *
 * \copyright GNU Public License.
 *
 * \author Francesco Fabiano.
 * \date April 7, 2019
 */

#include "helper.h"
#include  <math.h>

fluent helper::negate_fluent(const fluent f)
{
	fluent fluent_negated = f;

	if (f[f.size() - 1] == 0) {
		fluent_negated.set(f.size() - 1, 1);
	} else {
		fluent_negated.set(f.size() - 1, 0);
	}
	return fluent_negated;
}

/** \brief Function that returns the positive version of a given \ref fluent.
 * 
 * @param[in] to_normalize: the \ref fluent to normalize
 * 
 * @return the normalized of fluent.*/
fluent helper::normalize_fluent(const fluent to_normalize)
{
	if (is_negate(to_normalize)) {
		return negate_fluent(to_normalize);
	} else {
		return to_normalize;
	}
}

bool helper::is_negate(const fluent f)
{
	if (f[f.size() - 1] == 0) {
		return false;
	} else {
		return true;
	}
}

bool helper::is_consistent(const fluent_set &fl1, const fluent_set& fl2)
{

	//@TODO: Add static_laws
	fluent_set::iterator it_fl;

	for (it_fl = fl2.begin(); it_fl != fl2.end(); it_fl++) {

		if (fl1.find(negate_fluent(*it_fl)) != fl1.end())
			return false;
	}

	return true;
}

fluent_set helper::and_ff(const fluent_set& fl1, const fluent_set& fl2)
{
	///\todo The return should be const fluent_set & for efficency? Or move?

	fluent_set ret;
	if (!fl1.empty() && !fl2.empty()) {

		if (is_consistent(fl1, fl2)) {
			ret = fl1;
			ret.insert(fl2.begin(), fl2.end());
		}

	} else if (fl1.empty()) {
		return fl2;
	} else if (fl2.empty()) {
		return fl1;
	} else {
		std::cerr << "Bad formula declaration." << std::endl;
	}

	return ret;
}

fluent_formula helper::and_ff(const fluent_formula& ff1, const fluent_formula& ff2)
{
	///\todo The return should be const fluent_formula & for efficency? Or move?

	fluent_formula::iterator it_ff1;
	fluent_formula::iterator it_ff2;
	fluent_formula ret;
	if (!ff1.empty() && !ff2.empty()) {
		for (it_ff2 = ff1.begin(); it_ff2 != ff1.end(); it_ff2++) {
			for (it_ff1 = ff2.begin(); it_ff1 != ff2.end(); it_ff1++) {
				ret.insert(and_ff(*it_ff2, *it_ff1));
			}
		}
	} else if (ff1.empty()) {
		return ff2;
	} else if (ff2.empty()) {
		return ff1;
	} else {
		std::cerr << "Bad formula declaration." << std::endl;
		exit(1);
	}
	return ret;
}

bool helper::check_Bff_notBff(const belief_formula& to_check_1, const belief_formula& to_check_2, std::shared_ptr<fluent_formula> ret)
{
	/*GENERIC, to much
	if (to_check_1.m_operator == BF_NOT) {
		std::cout << "\nVado 1NOT check\n";
		return *(to_check_1.m_bf1) == to_check_2;
	} else if (to_check_2.m_operator == BF_NOT) {
		std::cout << "\nVado 2NOT check\n";
		return *(to_check_2.m_bf1) == to_check_1;
	}*/
	/**\todo For now just fluent check. Maybe add some kind of formula normalization and then with \ref fluent_formula.
	 * \todo we assume that the fluent_formula has just one element (the fluent).
	 */

	if (to_check_1.get_formula_type() == BELIEF_FORMULA && to_check_2.get_formula_type() == BELIEF_FORMULA) {
		belief_formula to_check_nested_1 = to_check_1.get_bf1();
		belief_formula to_check_nested_2 = to_check_2.get_bf1();

		if (to_check_nested_1.get_formula_type() == FLUENT_FORMULA && to_check_nested_2.get_formula_type() == PROPOSITIONAL_FORMULA) {
			if (to_check_nested_2.get_operator() == BF_NOT) {
				fluent_set tmp = *((to_check_nested_1.get_fluent_formula()).begin());
				fluent f_to_check_1 = *(tmp.begin());
				tmp = *((to_check_nested_2.get_bf1().get_fluent_formula()).begin());
				fluent f_to_check_2 = *(tmp.begin());
				if (f_to_check_1 == f_to_check_2) {

					if (ret != nullptr) {
						ret->insert(tmp);
					}
					return true;
				}
			}
		} else if (to_check_nested_2.get_formula_type() == FLUENT_FORMULA && to_check_nested_1.get_formula_type() == PROPOSITIONAL_FORMULA) {
			if (to_check_nested_1.get_operator() == BF_NOT) {
				fluent_set tmp = *((to_check_nested_1.get_bf1().get_fluent_formula()).begin());
				fluent f_to_check_1 = *(tmp.begin());
				tmp = *((to_check_nested_2.get_fluent_formula()).begin());
				fluent f_to_check_2 = *(tmp.begin());
				if (f_to_check_1 == f_to_check_2) {

					if (ret != nullptr) {
						ret->insert(tmp);
					}
					return true;
				}
			}
		}

	}
	return false;
}

void helper::apply_effect(fluent effect, fluent_set& world_description)
{

	world_description.erase(negate_fluent(effect));
	world_description.insert(effect);

}

void helper::apply_effect(const fluent_set& effect, fluent_set& world_description)
{
	fluent_set::const_iterator it_fs;
	for (it_fs = effect.begin(); it_fs != effect.end(); it_fs++) {
		apply_effect(*it_fs, world_description);
	}
}

void helper::apply_effect(const fluent_formula& effect, fluent_set& world_description)
{
	//Because of non_determinism
	if (effect.size() != 1) {
		return apply_effect(*(effect.begin()), world_description);

	} else {
		if (effect.size() > 1) {
			std::cerr << "\nNon determinism in action effect is not supported.\n";
			exit(1);
		}
		std::cerr << "\nEmpty action effect.\n";
		exit(1);
	}
}

int helper::lenght_to_power_two(int length)
{
	return ceil(log2(length));
}

/* Using the std::set == operator
static bool helper::is_the_same_ff(const fluent_set& to_check_1, const fluent_set& to_check_2)
{
	//If the size is the same we just need to check all the element in to_check_1 because they are sets
	//and there aren't repetitions on the elements.
	if (to_check_1.size() == to_check_2.size()) {
		fluent_set::conts_iterator it_fs;
		for (it_fs = to_check_1.begin(); it_fs != to_check_1.end(); it_fs++) {
			if (to_check_2.find(*it_fs) == to_check_2.end()) {
				return false;
			}
		}
		return true;
	}
	return false;
}

static bool helper::is_the_same_ff(const fluent_formula& to_check_1, const fluent_formula& to_check_2)
{
	//If the size is the same we just need to check all the element in to_check_1 because they are sets
	//and there aren't repetitions on the elements.
	if (to_check_1.size() == to_check_2.size()) {
		fluent_formula::conts_iterator it_ff;
		for (it_ff = to_check_1.begin(); it_ff != to_check_1.end(); it_ff++) {
		}
		return true;
	}
	return false;
}*/