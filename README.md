General steps taken to complete the task:
1. Decided how to represent the jobs data. From the task description it was
quite clear that it needs to be a directed acyclic graph.
2. Implemented tests based on examples provided in the task description.
3. Implemented the Graph class as a base class for DirectedGraph
and DirectedAcyclicGraph later on.
4. Implemented tests for all functionality related to building a graph -
adding vertices, edges etc. and then implemented the functionality itself.
Kept this TDD approach throughout the whole implementation process.
5. Format of the input data for the jobs was not specified therefore I have
implemented a generic build function that decides how to build the graph
depending on the type of the data passed to it. It supports data passed as
a hash or a string in a specific format.
6. The last part of the task was implementing a function that performs the
topological sort of the graph and all helper functions that it needed. As jobs
data is reversed in terms of dependencies direction, the result of the sort had
to be reversed as well.

Note: I have changed my approach during development when it comes to checking
if the graph is acyclic. Firstly I was checking this at the point of sorting
the graph (for performance reasons) but I have changed my mind and decided to
check this whenever a new edge is added. This is based on an assumption that
my code would be used as a part of a task management system, therefore a user
should get informed about an incorrect relation at the time when it is being
added to the system.
I am aware that DirectedGraph class is useless at its current state (it has got
only private functions at the moment). I wanted to show my understanding of
basic concepts of object oriented programming. Further development of this class
would include public functionality that is specific to a directed graph.
