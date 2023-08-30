# Metacognitive Epistemic Planning

## Description

### Summary
The main objective is to implement an architecture, called SOFAI x Planning, that is able to decide which type of planning process is more appropriate given a certain problem. SOFAI will be selecting between these strategies:
* System-1: A strategy that relies on experience to quickly find solution to new problems. This approach usually gets solutions very quickly but is prone to errors and imprecisions. 
* System-2: This strategy envisioned the use of state-of-the-art planners that solve problems by using search techniques. This approach is slower and its performances depends on the problem complexity but is way less prone to error w.r.t. System-1 
Let us note that System-1 and System-2 represent two different class of planners rather than two specific approaches. This means that SOFAI can be equipped with different S1 and S2 and can be configured to use any combination of the two.

While we envisioned SOFAI to be able to reason within various planning settings (e.g., classical, epistemic and so on) and to automatically select the best strategy to solve the incoming problem, in the current status the architecture is not able to automatically discern between different planning settings.
This means that, for example, SOFAI must be configured to adopt classical solving techniques when a classical planning problem is given as input.
The selection of solving techniques (that is the System-1 ans System-2) can be easily done with execution parameters. 

### Planning Domains
SOFAI x Planning aims to become an approach general enough to tackle all the planning problems by adopting already exiting techniques in the literature and exploiting them in their filed of comptence.
While at the moment the architecture is not able to automatically discern which type of planning setting we are reasoning one, we still allow for two differet setting to be solved thanks to SOFAI.
* As first type of setting we decided to embed in SOFAI the capabilities to solve classical planning problems
* Secondly we include in SOFAI the capabilities to tackle Multi-Agent Epistemic Planning problems

Let us note that while System-2 planners are ad-hoc solution for their specific setting, usually System-1 solvers can be adopted in different settings as they only rely on experience.
We hope that any interested planning researcher would embed in SOFAI their tool to increase its capability:)

### The Pipeline
While the description of the Architecture has been formalized in a scientific works (yet to be published) we can give an high level description of this process.
* Input: a problem instance and meta-data, e.g. resources availability, accuracy required, to emulate the limits represented by various situations (file called context).
* Procedure:
	* System-1 Metacognitive-Agent:
		* Checks whether there is enough experience to retrieve a plan from past instances, using System-1, that solves respecting the given constraints (input) and returns it if exist.
		* If there is not than System-2 Metacognitive-Agent is adopted
	* System-2 Metacognitive-Agent:
		* Analyze problem and select the best System-2 planner based on some factors
		* Evaluate problem difficulty and derive expected resource consumption from that (w.r.t. to the selected planner)
		* Checks if the solving process is within the constraints (if not adopt S1 solution)
		* If within constraints check if the extra resources are worth the extra accuracy (w.r.t. System-1 Planner solution) using precise formula introduce by the metacognitive workstream
		* If it is worth then solve the problem and then validate and save the solution; otherwise use S1-solution

### Adopted Techniques

#### Input Definition and Parsing for Epistemic Planning
This part of the process is tackled by the E-PDDL parser found in <https://github.com/FrancescoFabiano/E-PDDL>. For further information on this topic we then address the reader to the README that can be found in <https://github.com/FrancescoFabiano/E-PDDL>.
The only file with different structure is the one that symbolizes context. An example can be found in "Input/context/contextEx.epddl".

#### System-1 Planners
This part of the process is completely addressed by Planners/CaseBasedS1 and  <https://github.com/VishalPallagani/plansformer>.

#### FastDownward -- System 2 for Classical Planning
This part of the process is completely addressed by <https://www.fast-downward.org/ObtainingAndRunningFastDownward>.

#### LPG (-LT) -- System 2 for Classical Planning
This part of the process is completely addressed by <https://lpg.unibs.it/lpg/>.

#### PDKB -- System 2 for Epistemic Planning
This part of the process is completely addressed by <https://github.com/QuMuLab/pdkb-planning>.

#### EFP -- System 2 for Epistemic Planning
This part of the process is completely addressed by <https://github.com/FrancescoFabiano/EFP>.

### Execution
Let us member that before executing the overall architecture each part must be prepared. Please follow the instructions to prepare the environment (found in the respective repos)

The architecture should be called following the following scheme:
- ``python3 sofai_cl_pl.py <domain_file> <instance_file> <context_file> <threshold_file> <type_of_S2> <type_of_S1> (<planformerV2.0_mode>) (<training_size>)``
where:
	- <type_of_S2> can be:
		- 1 to indicate FastDownward
        - 2 to indicate LPG
        - 3 to indicate LPG with the possibility of replanning from S1 solutions when this is "acceptable"
        - 4 to indicate FastDownard + the LPG replanning capabilities when S1 solution is "acceptable"
	- <type_of_S1>:
		- 0 to indicate that the architecture should just use System 2 (for comparison purposes)
		- 1 to indicate the case-based solver with the concept of Levenshtein Distance
		- 2 to indicate the case-based solver with the concept of Jaccard Distance
		- 3 to indicate the case-based solver that selects randomly the solution (for comparison purposes)
		- 4 to indicate the case-based solver that selects a the best solution among Levenshtein and Jaccard (based on the reward) 
		- 5 to indicate the Plansformer (v1.0) solver
		- 6 to indicate the combination of the Jaccard and the Plansformer (v1.0) solvers
		- 7 to indicate the Plansformer (v2.0) solver: in this case we can further select among <planformer_mode>
			- 1 to use pretrained Plansformer (v2.0) withOUT continual learning
			- 2 to use pretrained Plansformer (v2.0) WITH continual learning
			- 3 to use Plansformer (v2.0) WITH continual learning and without initial experience
				- If 2 or 3 are selected it is necessary to provide also the <training_size>

Examples of execution are as follows: (from the main folder)
- ``python sofai_cl_pl.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 1 4``
- ``python sofai_cl_pl.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 1 7 1``
- ``python sofai_cl_pl.py Input/blocksworld/domain/domain.pddl Input/blocksworld/instances/problem_04_300.pddl Input/contexts/contextEx.epddl Input/thresholds/thresholdEx.epddl 1 7 2 201``

Where:
- *Input/blocksworld/domain/domain.pddl* represents the domain file
- *Input/blocksworld/instances/problem_04_300.pddl* represents the problem file
- *Input/contexts/contextEx.epddl* represents the context file
- *Input/thresholds/thresholdEx.epddl* represents the thresholds file
- *1* represents the type of System2
- *4*/*7*/*7* represent the type of System1
- *1*/*2* represent the modality of Plansformer (v2.0)
- *201* represents the training size

## Repository Management

### Adjustments of the External Repositories
* EFP
	- Modified output printed after solving an instance -- class include/states/state_T.ipp (look for "@MOD" in code's comment)
	- Modified path of the file where the execution results are stored -- class include/search/planner.ipp (look for "@MOD" in code's comment)
	- Unecessary files (e.g., experiments and scripts) have been removed

* PDKB
	- Modified output printed after solving an instance -- files pdkb/planner.py and pdkb/problems.py (look for "@MOD" in code's comment)
	- Allowed spaces in problem and domain path -- files pdkb/planners/staged_bfws.py and pdkb/problems.py (look for "@MOD" in code's comment)
	- Unecessary files (e.g., experiments and scripts) have been removed

* EPDDL
	- This version of the repo is actually an upgraded version w.r.t. one in the EPDDL repo.

## TODO
* [ ] Clean Memory
* [ ] Make EFP, PDKB, PLANSFORMER, and EPPDL submodules
* [ ] Make scripts that automatically prepare the environment
* [ ] Only generate a new domain file for PDKB from EPDDL if does not exist already
