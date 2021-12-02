# Metacognitive Epistemic Planning

## Description

### Summary
The main objective is to implement an epistemic-cognitive-agent. That is, an agent that decides which type of epistemic reasoning is more appropriate given a certain problem. This agent will be selecting between several strategies:
* Planner-Sys1: A solver that relies on experience (neural based solver)
* Planner-1: A planner that grounds the epistemic-planning into a classical one and then exploits state-of-the-art classical solving techniques (PDKB)
* Planner-2: A full-fledged epistemic planner that solves epistemic problems by reasoning on actual epistemic states (EFP)
While the last two planners can solve the same families of problems, except for the ones that requires Dynamic Common Knowledge/Belief (only solvable by the Planner-2), their differences are reflected in the use of resources. In particular, Planner-1 is very fast whenever the problem to be solved does not require an high level of nesting in the belief formulae (usually < 3) but it is outperformed by Planner-2 in the other cases.
Therefore, the idea is to devise a framework---representing the epistemic-cognitive-agent---that taken as input a problem specified in a unique format is able to select the best solving process.

### The Pipeline
While the description of the meatcognitive reasoning has been formalized in a scientific work (yet to be published) we can give an high level description of this process.
* Input: a problem instance in EPDDL (input format for epistemic planning) and meta-data, e.g. resources availability, accuracy required, to emulate the limits represented by various situations (file called context).
* Procedure:
	* System-1 Metacognitive-Agent:
		* Checks whether there is enough experience to retrieve a plan from past instances that solves respecting the given constraints (input) and returns it if exist.
		* If there is not than System-2 Metacognitive-Agent is adopted
	* System-2 Metacognitive-Agent:
		* Analyze problem and select if best Planner-1 or Planner-2 based on some factors (depth and presence of dynamic common knowledge)
		* Evaluate problem difficulty and derive expected resource consumption from that (w.r.t to the selected planner)
		* Checks if the solving process is within the constraints (if not adopt S1 solution)
		* If within constraints check if the extra resources are worth the extra accuracy (w.r.t. Planner-Sys1 solution) using precise formula introduce by the metacognitive workstream
		* If it is worth then solve the problem and then validate and save the solution; otherwise use S1-solution

### Adopted Techniques

#### Input Definition and Parsing
This part of the process is tackled by the E-PDDL parser found in <https://github.com/FrancescoFabiano/E-PDDL>. For further information on this topic we then address the reader to the README that can be found in <https://github.com/FrancescoFabiano/E-PDDL>.
The only file with different structure is the one that symbolizes context. An example can be found in "Input/context/contextEx.epddl".

#### Planner-Sys1
This part of the process is completely addressed by <https://github.com/FrancescoFabiano/E-PDDL>.

#### Planner-1
This part of the process is completely addressed by <https://github.com/QuMuLab/pdkb-planning>.

#### Planner-2
This part of the process is completely addressed by <https://github.com/FrancescoFabiano/EFP>.

### Example of Execution
Let us rember that before eecuting the overall architecture each part must be prepared. Please follow the instructions for Planner-1 and Planner-2 to prepare the enviroment (found in the respective repos)
An example of execution is as follows: (from the main folder)
* "python architecture.py Input/coininthebox/coininthebox.epddl Input/coininthebox/pb2.epddl Input/context/contextEx.epddl"

Where:
	- Input/coininthebox/coininthebox.epddl represents the domain file
	- Input/coininthebox/pb1.epddl represents the problem file
	- Input/context/context1 represents the context file

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
* [ ] Make EFP, PDKB, and EPPDL submodules
* [ ] Make scripts that automaically prepare the environment
* [ ] Only generate a new domain file for PDKB from EPDDL if does not exist already
