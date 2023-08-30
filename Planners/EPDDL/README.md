# E-PDDL

E-PDDL is an extension of the well know PDDL for epistemic planning.
The repository contains the initial version of a parser that converts E-PDDL doamains in mAp (Fabiano et al. 2019), the input language of EFP 2.0 (Fabiano et al. 2020), an epistemic planner.

As future steps we plan to add a conversion also for PDKB-PDDL, the input language for another epistemic planner: PDKB (Muise et al. 2015).

## Acknowledgements
The planner inherits its basic structure from the parser in: https://github.com/pucrs-automated-planning/pddl-parser

## How to Run
To run this simple instance simply call the program giving it the name of the domain and of the problem as input.
The program will generate the input file for EFP 2.0 in the 'out' folder.
The file will be named following this pattern: "domain_file_name" + "_" + "problem_file_name" + ".txt".

For example executing: ```python -B EPDDL.py examples/coin_in_the_box/coininthebox.epddl examples/coin_in_the_box/pb1.epddl``` will generate the file 'out/coin_in_the_box_pb1.txt'

#### Bibliography
Fabiano, F.; Burigana, A.; Dovier, A.; and Pontelli, E. 2020.
EFP 2.0: A Multi-Agent Epistemic Solver with Multiple e-State Representations.
Under Review at the 30th International Conference on Automated Planning and Scheduling.


Fabiano, F.; Riouak, I.; Dovier, A.; and Pontelli, E. 2019.
Non-well-founded set based multi-agent epistemic action language.
In Proceedings of the 34th Italian Conference on Computational Logic, volume 2396 of CEUR Workshop Proceedings, 242–259.

Muise, C. J.; Belle, V.; Felli, P.; McIlraith, S. A.; Miller, T.; Pearce, A. R.; and Sonenberg, L. 2015.
Planning over multi-agent epistemic states: A classical planning  approach.
In Proceedings of AAAI, 3327–3334.
