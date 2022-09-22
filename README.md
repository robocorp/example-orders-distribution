# Order in bulk the total number of requested robot parts

This is a 3-Step Process which takes a list of orders and computes the total number of
heads, bodies and legs that we have to order.

This is a funny practical approach of the
[SplitCombine](https://github.com/robocorp/example-workitems-splitcombine) pattern:
- Problem: Having to process multiple input Work Items before being able to create just
  one output Work Item with the final result at the end of the iteration.
- Solution: Creating an empty output Work Item attached to the initial input one, then
  saving later on the final result data into it.

![Process diagram](https://github.com/robocorp/example-orders-distribution/blob/master/devdata/example-orders-distribution.jpg)


## Tasks

1. `Read And Split Orders`: Splits a list of orders from **robotsparebin-orders** input
   Work Item into individual output ones.
2. `Compute Number Of Parts`: Computes a total for every requested part type: heads,
   bodies and legs. Then creates an output Work Item with the total.
3. `Order The Parts In Bulk`: Generates an invoice with the total number of body parts
   we have to order.


### Notes

- For the first task (#1) select the already present input Work Item to run with:
  **robotsparebin-orders**
- For every subsequent task (#2, #3) select as input the last output obtained from the
  previous step. Example:
  - Task #1: robotsparebin-orders
  - Task #2: run-2
  - Task #3: run-3
