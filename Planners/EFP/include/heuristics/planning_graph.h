/**
 * \class planning_graph
 * \brief Class that implements the epistemic planning graph data structure for heuristics extrapolation.
 *
 * \details An e-Planning graph is a structure introduced in <https://aaai.org/ocs/index.php/ICAPS/ICAPS18/paper/view/17733>
 *  that, as the planning graph from the classical planning environment, it is used to extrapolate
 * qualitative value for the states.
 * 
 *
 * \copyright GNU Public License.
 * 
 * \author Francesco Fabiano.
 * \date September 24, 2019
 */

#pragma once

#include "../utilities/define.h"
#include "../actions/action.h"
#include "../states/state_T.h"
#include "../states/kripke/kstate.h"
#include "../states/possibilities/pstate.h"
#include "../formulae/belief_formula.h"
#include "../domain/domain.h"
#include <utility>
#include <boost/dynamic_bitset.hpp>
/**
 * \class pg_action_level
 * \brief Class that implements an action level of the planning graph.
 *
 * 
 *
 * \copyright GNU Public License.
 * 
 * \author Francesco Fabiano.
 * \date September 24, 2019
 */



class pg_action_level
{
protected:
    //Waste memory
    //Use ptr
    /*\brief The set of executable actions in the relative \ref pg_state_level*/
    action_set m_actions;

    /*\brief The depth of the action level*/
    unsigned short m_depth = 0;

public:
    /*Constructor of this that calls the standard constructors for each field and set the depth to 0*/

    pg_action_level();
    /*Constructor of this that set the depth to 0 and m_actions
     *
     * @param[in] actions: the value to assign to m_actions. 
     */
    pg_action_level(const action_set & actions);
    /*Constructor of this that set the depth and m_actions
     *
     * @param[in] actions: the value to assign to m_actions. 
     * @param[in] depth: the value to assign to m_depth. 
     */
    pg_action_level(const action_set & actions, unsigned short depth);

    /*Setter of the field m_depth
     *
     * @param[in] depth: the value to assign to m_depth. 
     */
    void set_depth(unsigned short depth);
    /*Getter of the field m_depth
     *
     * @return: the value to assign to m_depth. 
     */
    unsigned short get_depth() const;

    /*Setter of the field m_actions
     *
     * @param[in] actions: the value to assign to m_actions. 
     */
    void set_actions(const action_set & actions);
    /*Function that add a single \ref action to *this*
     *
     * @param[in] act: the \ref action to add to m_actions if not present.
     */
    void add_action(const action & act);

    /*Getter of the field m_actions
     *
     * @return: the value to assign to m_actions. 
     */
    const action_set & get_actions() const;
    /*The = operator
     * 
     * @param[in]to_assign: The object to copy in *this* */
    bool operator=(const pg_action_level& to_assign);

    //printing
    /* A printing function
     */
    void print() const;
};

/**
 * \class pg_state_level
 * \brief Class that implements a state layer of the epistemic planning graph data structure
 * 
 * \details In this implementation the state layer contains complete e-state in order to have a complete planning graph
 * 
 *
 * \copyright GNU Public License.
 * 
 * \author Francesco Fabiano.
 * \date September 24, 2019
 */

template <class T>
class pg_state_level
{
private:
    //Is a class of pointer, not much memory required
    //Maybe make it templatic
    /*\brief The set of the e-States contained in *this**/
    std::set<T> m_eStates;
    std::set<fluent> m_fluentSet;
    std::map<belief_formula,bool> m_pairBeliefBool;

    /*\brief The depth of *this*, which state layer is*/
    unsigned short m_depth = 0;

    /*Function that checks satisfaction of a belief formula given an epistemic state level's eStates.
     *
     * A belief formula is entailed when is entailed by at least one eState in the level.
     * 
     * @param[in] eStates: The eState of the level where to check for the belief formula entailment.
     * @param[in] bf: The belief formula to check for entailment.
     */

    bool pg_entailment( const std::map<belief_formula,bool> & pairBeliefBool, const belief_formula & bf) const;

    /*Function that checks satisfaction of a CNF of belief_formula given an epistemic state level's eStates.
     *
     * A formula_list formula is entailed all its component are entailed by at least one eState in the level.
     * 
     * @param[in] eStates: The eState of the level where to check for the formula entailment.
     * @param[in] fl: The CNF of belief_formula to check for entailment.
     */
    bool pg_entailment(const std::map<belief_formula,bool> & pairBeliefBool, const formula_list & fl) const;


public:
    /*Constructor that sets the depth to 0 and call the standard constructor for the other fields
     */
    pg_state_level();
    /*Constructor of this that set the depth = 0 and m_eStates.
     *
     * @param[in] eStates: the value to assign to m_eStates. 
     * @param[in] depth: the value to assign to m_depth. 
     */
    pg_state_level(const std::set<T> & eStates);
    /*Constructor of this that set the depth and m_eStates
     *
     * @param[in] eStates: the value to assign to m_eStates. 
     * @param[in] depth: the value to assign to m_depth. 
     */
    pg_state_level(const std::set<T> & eStates, unsigned short depth);

    pg_state_level(const std::map<belief_formula,bool> & pairBeliefBool, const std::set<fluent> & fluentSet);

    pg_state_level(const std::map<belief_formula,bool> & pairBeliefBool, const std::set<fluent> & fluentSet, unsigned short depth);
    /*Setter of the field m_eStates
     *
     * @param[in] eStates: the value to assign to m_eStates. 
     */
    void set_eStates(const std::set<T> & eStates);
    /*Getter of the field m_eStates
     *
     * @return: the value to assign to m_eStates. 
     */
    const std::set<T>& get_eStates() const;

    void set_pair_belief_bool(const std::map<belief_formula,bool> & pairBeliefBool);
    void set_fluent_set(const std::set<fluent> & fluentSet);

    /*Function that add a single eState to *this*
     *
     * @param[in] eState: the eState to add to m_eStates if not present.
     */
    bool add_eState(const T & eState);

    bool add_fluent(const fluent & fluent);
    /*Setter of the field m_depth
     *
     * @param[in] depth: the value to assign to m_depth. 
     */
    void set_depth(unsigned short depth);
    /*Getter of the field m_depth
     *
     * @return: the value to assign to m_depth. 
     */
    unsigned short get_depth() const;

    const std::map<belief_formula,bool> & get_pair_belief_bool() const;

    const std::set<fluent> & get_fluent_set() const;

    /*Function that checks satisfaction of a belief_formula on *this*.
     * 
     * @param[in] bf: The belief_formula to check for entailment.
     * 
     * @return: true if the formula is entailed.
     * @return: false otherwise.
     */
    bool pg_entailment(const belief_formula & bf) const;
    /*Function that checks satisfaction of a CNF of belief_formula on *this*.
     * 
     * @param[in] fl: The CNF of belief_formula to check for entailment.
     * @return: true if the formula is entailed.
     * @return: false otherwise.
     */
    bool pg_entailment(const formula_list & fl) const;

    /*Function that checks if an action is executable on *this*.
     * 
     * @param[in] act: The act which we need to check for executability on *this*.
     * @return: true if the action's executability conditions are entailed.
     * @return: false otherwise.
     */
    bool pg_executable(const action & act) const;

    /*The = operator
     * 
     * @param[in]to_assign: The object to copy in *this* */
    bool operator=(const pg_state_level& to_assign);
};

/*\**********************************************************************
 class: planning_graph
 ************************************************************************/
//typedef std::map<fluent_set, unsigned short> pg_worlds_score; FOR FUTURE USE

template <class T>
class planning_graph
{
private:
    /*\brief The list of \ref pg_state_level that represents the state levels of the planning_graph*/
    std::vector< pg_state_level<T> > m_state_levels;
    /*\brief The list of \ref pg_action_level that represents the action levels of the planning_graph*/
    std::vector<pg_action_level> m_action_levels;

    /*\brief The length of the planning_graph -- used after the goal is reached*/
    unsigned short m_pg_length = 0;
    /*\brief The sum of the depths of the levels that contain a subgoal*/
    unsigned short m_pg_sum = 0;
    /*\brief If the planning graph can find a solution*/
    bool m_satisfiable;

    /*\brief The list of the subgoals (possibly enanched by \ref heuristics_manager)*/
    formula_list m_goal;
    //pg_worlds_score m_worlds_score; FOR FUTURE USE
    /*\brief A map that contains the first level of encounter (if any) of a belief formula calculated by list_bf_classical*/
    pg_bfs_score m_bfs_score;
    /*\brief The set of action never executed in the planning_graph for optimization*/
    action_set m_never_executed;


    std::set<belief_formula> m_belief_formula_false;

    /*Setter of the field m_satisfiable
     *
     * @param[in] sat: the value to assign to m_satisfiable. 
     */
    void set_satisfiable(bool sat);
    /*The main function that build the planning_graph layer by layer until the goal is found or the planning_graph is saturated*/
    void pg_build();
    /*The main function that build the planning_graph layer by layer until the goal is found or the planning_graph is saturated
     *
     * This function also check for every level which fluents or belief formula are entailed.
     * It is a sort of conversion to classical planning with grounding of finite nesting belief formula and common knowledge
     * 
     * @param[out] converted_bf: The (converted) fluents to yet be entailed by the planning graph.
     */
    void pg_build_classical(std::vector<belief_formula> & converted_bf);

    //planning graph epistemic new implementation
    void pg_build_initially(std::list<belief_formula> & goal);
    void pg_build_grounded();

    void list_bf_grounded(const belief_formula & belief_forms, std::list<belief_formula> & ret) const;
    //std::list<belief_formula> list_bf_grounded(unsigned short nesting=1); //,const std::list<belief_formula>& goal_formula);
    void make_nested_bf_classical2(unsigned short nesting, unsigned short depth,const belief_formula & to_explore, std::list<belief_formula> & ret);
    //
    bool check_belief_formula(const belief_formula & belief_form_to_check, const belief_formula & belief_initially,  agent_set & agents) const;

    bool check_goal() const;//pg_state_level<T> current_state);

    /*Function that returns the list of fluents and belief formulae that represent the fluent of the conversion to classical planning
     * 
     * @param[in] nesting: the max depth of belief_formula to consider fluents in the conversion to classical planning (1 as default).
     * @return: A vector (not a set to avoid unnecessary sorting and comparison) that contains all the belief_formulae as fluents.
     */
    std::vector<belief_formula> list_bf_classical(unsigned short nesting = 1);

    /**The recursive function to generate the various nested fluents for classical conversion
     *
     * @param[in] nesting: The max_depth of the generated subgoals.
     * @param[in] depth: The depth of the currently generating subgoal.
     * @param[in] to_explore: The belief formula from which generate the next fluents.
     * @param[out] ret: The list of already generated fluents in which to add the new ones. 
     */
    void make_nested_bf_classical(unsigned short nesting, unsigned short depth, belief_formula & to_explore, std::vector<belief_formula> & ret);

    /*Function add the next (depth + 1) state layer to m_state_levels
     *
     * @param[in] s_level: The level to add to m_state_levels.
     */
    void add_state_level(const pg_state_level<T> & s_level);
    /*Function add the next (depth + 1) action layer to m_actions_levels
     * 
     * @param[in] a_level: The level to add to m_action_levels.
     */
    void add_action_level(const pg_action_level & a_level);


    bool check_action(const action & act, agent_set & agents) const;

    bool check_ontic_action(const action & act, agent_set & agents) const;
    bool check_sensing_announcement_action(const action & act, agent_set & agents) const;

public:

    /*Constructor of *this* that set the intial state level and the goal from the domain
     *
     * @param[in] pg_init: the initial state to set as initial level (Only one because no conformant at the moment). 
     * @param[in] goal: the (possibly enhanced) goal description to set in m_goal.
     * @param[in] is_single: if the planning graph is constructed for each state (false) or just once to extrapolate info (true).
     */
    planning_graph(const T& pg_init, const formula_list & goal, bool is_single = false);

    /*Setter of the field m_length
     *
     * @param[in] length: the value to assign to m_length. 
     */
    void set_length(unsigned short length);
    /*Setter of the field m_sum
     *
     * @param[in] sum: the value to assign to m_sum. 
     */
    void set_sum(unsigned short sum);
    /*Setter of the field m_goal
     *
     * @param[in] goal: the value to assign to m_goal. 
     */
    void set_goal(const formula_list & goal);

    /*Function that tells if the planning graph can satisfy the domain.
     *
     * @return: True if a solution is found with the planning graph. 
     * @return: False otherwise. 
     */
    bool is_satisfiable();

    /*Getter of the field m_length
     *
     * @return: the value to assigned to m_length. 
     */
    unsigned short get_length();
    /*Getter of the field m_sum
     *
     * @return: the value to assigned to m_sum. 
     */
    unsigned short get_sum();

    /*Getter of the field m_bfs_score
     *
     * @return: the value to assigned to m_bfs_score. 
     */
    const pg_bfs_score & get_bfs_score();

    void add_belief_false(belief_formula & formula);
    void remove_belief_formula_false(const belief_formula & formula);

    const belief_formula & get_fluent_from_formula(const belief_formula & belief_forms) const;


    /*const pg_worlds_score & get_worlds_score();
    const pg_bfs_score & get_bfs_score(); FOR FUTURE USE*/
};