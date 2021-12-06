### CASES Library

1. Cases are stored here in cases.json. The json  has two types of information:
  - Metadata about the case library: example - size_limit. Initial, this is set to 100 cases.
  - A list of cases. Each case is a tuple containing:
    - planning domain
    - list of goals
    - list of initial state
    - index to file with plan


2. Each sub-dir has plans that the case libray refers to.

3. Current, we support:
   1. blockworld-plans: consists of the plans generated for the blockworld domain (in examples directory)
   2. coin-in-the-box: TODO
