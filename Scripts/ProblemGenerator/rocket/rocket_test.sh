#!/bin/bash
# Usage from the "Scripts/ProblemGenerator" folder execute "./rocket_test.sh"

max_tokens=512
prompt=$(python plansformer_prompt_generator.py rocket/rockets-s.pddl rocket/rockets-3s.pddl)
token_count=$(python count_512subset.py "$prompt")
echo "token is $token_count"