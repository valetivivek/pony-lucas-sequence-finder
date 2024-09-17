# DOSP Project-1 (COP5615) - Lukas Problem Solver

## Group 054 Team Members:
- Kommineni Srinivas  
- Valeti Vishnu Vivek 

## Problem Statement

Develop a Pony program using the actor model to find all sequences of k consecutive integers starting between 1 and N, where the sum of their squares is a perfect square. The program should take N and k as command-line inputs, utilize multi-core processing effectively, and output the starting number of each valid sequence on separate lines. The implementation must use Pony's actor model for parallelism, with worker actors solving subproblems and a manager actor coordinating the work.

## Methodology

The program is structured using Pony's actor model to solve the problem efficiently:

- Two main actors are used: a Manager and multiple Processors.
- The Manager oversees the operation, taking input, breaking work into chunks, and assigning to Processors.
- Each Processor checks its assigned range of numbers for valid sequences and reports back to the Manager.
- Multiple Processors work in parallel to utilize multi-core capabilities.
- The work division is optimized to balance between creating too many small tasks and too few large ones.
- Efficient algorithms are used for calculations, including an optimized method to check for perfect squares.
- The Manager collects, sorts, and outputs the results when all Processors finish.

## Code Structure

The main components of the code are:

1. Main: Initializes the program and creates the Manager.
2. Manager: Coordinates the overall computation, distributing work to Processor actors.
3. Processor: Performs the actual computation for a given range of numbers.

## Work Unit Size

A dynamic chunk sizing strategy is implemented to efficiently divide the workload:

- The "determine_task_size()" function calculates an optimal chunk size based on the input range.
- It aims for about 100 chunks with a minimum size of 1000.
- This approach adapts to different input sizes and system configurations.
- For small inputs, it creates fewer, larger chunks; for large inputs, it creates more chunks for better parallelization.
- The Pony runtime handles scheduling of actors across available CPU cores, maximizing parallel processing.

## Results for lukas 1000000 4

For the input 1000000 4, there is no sequence that follows the mentioned criteria.

System Specifications:
- CPU: Ryzen 7 6000 series, 16 core CPU
- GPU: RTX 3050ti 4gb
- RAM: 16gb

Performance Metrics:
- Real Time: 2.7656934 seconds
- User Time: 13.703125 seconds
- System Time: 0.0625 seconds
- Cores Used: 4

The ratio of CPU time (User + System) to Real Time is approximately 4.98, indicating excellent utilization of the available cores.

## Largest Problem Solved

We weren't able to push it beyond 10000000 as the input size increases, the memory required to store intermediate results and manage the actor system also increases, eventually hitting the limitations of our available RAM.

## Conclusion

This Pony implementation effectively utilizes the actor model for parallel processing of the Lukas problem. The dynamic work unit sizing and efficient use of multi-core capabilities allow for scalable performance across different input sizes and system configurations.
