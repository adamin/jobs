require_relative 'vertex'

# Represents graph data structure.
#
class Graph

  # Public: flag if cycles are allowed for the graph
  attr_accessor :allow_cycles

  # Public: array of graph's vertices
  attr_accessor :vertices

  def initialize
    @allow_cycles = true
    @vertices = []
  end

  # Public: Adds a new vertex to the graph.
  #
  # vertex  - instance of Vertex class to add
  #
  def add_vertex(vertex)

    self
  end

  # Public: Finds a vertex by its name.
  #
  # name  - name of the vertex to find
  #
  def find_vertex(name)

  end

  # Public: Adds a new edge to the graph
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def add_edge(start_vertex_name, end_vertex_name)
    self
  end

end