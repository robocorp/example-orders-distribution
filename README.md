# Order in bulk the total number of requested robot parts

This is a 3-Step Process which takes a list of orders and computes the total number of
heads, bodies and legs that we have to order.

### Tasks

1. `Read And Split Orders`: Splits a list of orders from **robotsparebin-orders** input
   Work Item into individual output ones.
2. `Compute Number Of Parts`: Computes a total for every requested part type: heads,
   bodies and legs. Then creates an output Work Item with the total.
3. `Order The Parts In Bulk`: Logs the total number of parts we have to order for each
   type.


### Notes

- For the first task (#1) select the already present input Work Item to run with:
  **robotsparebin-orders**
- For every subsequent task (#2, #3) select as input the last output obtained from the
  previous step. Example:
  - Task #1: robotsparebin-orders
  - Task #2: run-2
  - Task #3: run-3
