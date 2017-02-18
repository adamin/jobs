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
    if (vertex.instance_of? Vertex)
    @vertices << vertex
    else
      raise ArgumentError, 'Argument is not an instance of Vertex'
    end

    self
  end

  # Public: Returns index in the vertices array for a vertex
  #
  # name  - name of the vertex to search for
  #
  def find_index_for_vertex(name)
    result = @vertices.index { |v| v.name == name }
  end

  # Public: Finds a vertex by its name.
  #
  # name  - name of the vertex to find
  #
  def find_vertex(name)
    result = nil

    @vertices.each do |v|
      result = v if v.name == name
    end

    result
  end

  # Public: Adds a new edge to the graph
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def add_edge(start_vertex_name, end_vertex_name)

    # Check if graph is not empty
    if (@vertices.length == 0)
      raise ArgumentError, 'No edges can be added to an empty graph'
    end

    first_vertex_index = self.find_index_for_vertex(start_vertex_name)
    second_vertex_index = self.find_index_for_vertex(end_vertex_name)

    if (first_vertex_index == nil)
      raise ArgumentError, 'Edge cannot be added. First vertex could not be found'
    end

    if (second_vertex_index == nil)
      raise ArgumentError, 'Edge cannot be added. Second vertex could not be found'
    end

    @vertices[first_vertex_index].neighbours[second_vertex_index] = true
    @vertices[second_vertex_index].neighbours[first_vertex_index] = true

    self
  end

  # Public: removes an edge from the graph
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def remove_edge(start_vertex_name, end_vertex_name)

    first_vertex_index = self.find_index_for_vertex(start_vertex_name)
    second_vertex_index = self.find_index_for_vertex(end_vertex_name)

    if (first_vertex_index == nil)
      raise ArgumentError, 'Edge removal error. First vertex could not be found'
    end

    if (second_vertex_index == nil)
      raise ArgumentError, 'Edge removal error. Second vertex could not be found'
    end

    @vertices[first_vertex_index].neighbours[second_vertex_index] = nil
    @vertices[second_vertex_index].neighbours[first_vertex_index] = nil

    self
  end

end