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
    raise TypeError, 'Argument is not an instance of Vertex' unless vertex.instance_of? Vertex
    raise ArgumentError, 'Vertex with this name already exists in the graph' unless self.find_index_for_vertex(vertex.name) == nil

    @vertices << vertex

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

    self.add_edge_by_indexes(first_vertex_index,second_vertex_index)
  end

  # Public: adds an edge to the graph by their indexes.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def add_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = true
    @vertices[end_vertex_index].neighbours[start_vertex_index] = true

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

    self.remove_edge_by_indexes(first_vertex_index, second_vertex_index)
  end

  # Public: removes an edge from the graph by their indexes.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def remove_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = nil
    @vertices[end_vertex_index].neighbours[start_vertex_index] = nil

    self
  end

end