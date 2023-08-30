# Cased Based Solver as System1

## Description

### Summary
This directory contains the implementation of a solver that, exploiting the accumulated experience, can solve planning problems.
The main idea is that this solver, employed as System-1, in the overall architecture, analyzes the incoming problem and try to match it with already solved ones making use of various notion of distances.
Once the solver identifies the most similar already-solved problem it uses its solution to try and solve the incoming problem.
At the moment the solver admits two different notion of distance:
* The first measure of distance considers the problems as a set of formulae, i.e., the ones that comprise the initial and goal states, and adopts the well-known Jaccard Similarity (Rinartha, Suryasa, and Kartika 2018), that is the ratio between the union and the intersection of the two sets we are considering, as a metric for finding similarity between the input problem and the instances existing in the case library.
* The second metric is calculated by transforming the two instances into two distinct strings, once again comprised of all the initial and goal states information (separated by the special characters “|”), that are then compared using the Levenshtein distance (Haldar and Mukhopadhyay 2011) to determine the actual distance measure.

### The Pipeline
This solver has devised as module for our overall architecture and cannot be executed singularly.
That is, the solver is component of SOFAI x Planning and it is adopted by it.


## References
* Haldar, R.; and Mukhopadhyay, D. 2011. Levenshtein distance technique in dictionary lookup methods: An improved approach. arXiv preprint arXiv:1101.1232.
* Rinartha, K.; Suryasa,W.; and Kartika, L. G. S. 2018. Comparative Analysis of String Similarity on Dynamic Query Suggestions. In 2018 Electrical Power, Electronics, Communications, Controls and Informatics Seminar (EECCIS), 399–404.