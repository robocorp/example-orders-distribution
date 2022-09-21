# Create output Work Item with result from all the released inputs

MapReduce-like pattern for generating one final output Work Item from multiple input
ones.

This illustrates a simplified pattern of working with Work Items in a way where you
need to collect and process multiple input items before being able to create a final
result with data coming from all the previous items.

And since you can't create an output Work Item without linking it to an input (parent),
we decided in this example to use the initial input item as parent for the single
output one we're going to create. But we don't know what data to put in this output
during the creation of it (because we haven't traversed all the input items until the
end), so we just save it empty and then come back on it later on to put inside of it
the finally computed result from all the about-to-process input items.

## How it works

1. `Number To Sequence`: Takes a variable `number` from one input Work Item and creates
   a sequence of numbers (1, 2, ..., N) where every sub-number is saved into an
   individual output Work Item under the variable `nr`.
2. `Sequence To Total`: Receives as inputs all the numbers above (previous step output
   items) and adds their squares into a total. Example: 1^2 + 2^2 + 3^2 = 1+4+9 = 14.
   The final sum is saved into a single output Work Item under the variable `total`.
   The trick is that even if we traverse all the inputs with a helper looping keyword
   (and they get released into the process one by one), we still manage to save the
   final result in a previously created output Work Item, whose parent is the initial
   input one.
3. `Process Total`: Just retrieves the total computed above and logs it.

### Notes

- For the first task (#1) select the already present input Work Item to run with:
  **sum-of-squares**
- For every subsequent task (#2, #3) select as input the last output obtained from the
  previous step. Example:
  - Task #1: sum-of-squares
  - Task #2: run-2
  - Task #3: run-3
