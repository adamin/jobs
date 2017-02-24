require_relative 'vertex'
require_relative 'graph_error'

# Represents graph data structure.
#
class Graph

  # Public: array of graph's vertices
  attr_accessor :vertices

  def initialize
    @vertices = []
  end

  # Public: creates a string representation of the graph
  def to_s
    result = ''

    # Return an empty string for an empty graph
    return result unless @vertices.length > 0

    @vertices.each do |vertex|
      added = false
      vertex.neighbours.each_with_index do |value, neighbour_index|
        if (value == true)
          added = true
          result << vertex.name << '=>' << @vertices[neighbour_index].name << ','
        end
      end
      # if there has been no edges for the vertex
      result << vertex.name << '=>,' unless added
    end

    # remove trailing comma
    result.chop
  end

  # Public: builds a graph according to data provided
  #
  # data  - representation of a graph, supported types are: hash and string
  #
  def build(data)
    case data
    when String
      build_from_string(data)
    when Hash
      build_from_hash(data)
    else
      raise TypeError, 'Unsupported data type for build function'
    end
  end

  # Public: Adds a new vertex to the graph.
  #
  # vertex  - instance of Vertex class to add
  #
  def add_vertex(vertex)
    raise TypeError, 'Argument is not an instance of Vertex' unless vertex.instance_of? Vertex
    raise GraphError.new('Vertex with this name already exists in the graph', GraphError::ERROR_DUPLICATE_VERTEX) unless find_index_for_vertex(vertex.name) == nil

    @vertices << vertex

    self
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
      raise GraphError.new('No edges can be added to an empty graph', GraphError::ERROR_ADD_EDGE_FAILURE)
    end

    first_vertex_index = find_index_for_vertex(start_vertex_name)
    second_vertex_index = find_index_for_vertex(end_vertex_name)

    if (first_vertex_index == nil)
      raise GraphError.new('Edge cannot be added. First vertex could not be found', GraphError::ERROR_ADD_EDGE_FAILURE)
    end

    if (second_vertex_index == nil)
      raise GraphError.new('Edge cannot be added. Second vertex could not be found', GraphError::ERROR_ADD_EDGE_FAILURE)
    end

    add_edge_by_indexes(first_vertex_index,second_vertex_index)
  end

  # Public: removes an edge from the graph
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def remove_edge(start_vertex_name, end_vertex_name)

    first_vertex_index = find_index_for_vertex(start_vertex_name)
    second_vertex_index = find_index_for_vertex(end_vertex_name)

    if (first_vertex_index == nil)
      raise GraphError.new('Edge removal error. First vertex could not be found', GraphError::ERROR_REMOVE_EDGE_FAILURE)
    end

    if (second_vertex_index == nil)
      raise GraphError.new('Edge removal error. Second vertex could not be found', GraphError::ERROR_REMOVE_EDGE_FAILURE)
    end

    remove_edge_by_indexes(first_vertex_index, second_vertex_index)
  end

  # Public: performs a check to see if the graph has a specified edge
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def has_edge(start_vertex_name, end_vertex_name)
    first_vertex_index = find_index_for_vertex(start_vertex_name)
    second_vertex_index = find_index_for_vertex(end_vertex_name)

    return false unless (!first_vertex_index.nil? && !second_vertex_index.nil?)

    return @vertices[first_vertex_index].neighbours[second_vertex_index] == true
  end

  # Public: performs a check to see if the graph has at least one edge
  def has_edges
    return false unless @vertices.length > 0

    @vertices.each do |vertex|
      vertex.neighbours.each do |neighbour|
        if (neighbour == true)
          return true
        end
      end
    end

    return false
  end

  # Public: checks if a vertex with specified index doesn't have any incoming edges
  #
  # vertex_name  - name of the vertex to search for
  #
  def check_if_vertex_is_source(vertex_name)

    vertex_index = find_index_for_vertex(vertex_name)

    # Return false if vertex does not exist
    return false unless !vertex_index.nil?

    @vertices.each do |vertex|
      vertex.neighbours.each_with_index do |value, neighbour_index|
        if (neighbour_index == vertex_index && value == true)
          # An edge has been found that leads to the vertex therefore it is not a source
          return false
        end
      end
    end

    # No edges leading to the vertex have been found - it is a source
    return true
  end

  private

  # Private: Returns index in the vertices array for a vertex
  #
  # name  - name of the vertex to search for
  #
  def find_index_for_vertex(name)
    result = @vertices.index { |v| v.name == name }
  end

  # Private: adds an edge to the graph by their indexes.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def add_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = true
    @vertices[end_vertex_index].neighbours[start_vertex_index] = true

    self
  end

  # Private: removes an edge from the graph by their indexes.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def remove_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = nil
    @vertices[end_vertex_index].neighbours[start_vertex_index] = nil

    self
  end

  # Private: converts a collection of vertices' indexes to a collection of their names
  #
  # indexes  - collection of vertices' indexes to convert
  #
  def convert_indexes_to_names(indexes)
    result = []
    indexes.each do |index|
      result << @vertices[index].name
    end

    result
  end

  # Private: finds source vertices - those that don't have any incoming edges
  def find_indexes_of_source_vertices
    # start with all vertices' indexes
    indexes = [*0..@vertices.length-1]

    @vertices.each do |vertex|
      vertex.neighbours.each_with_index do |value, neighbour_index|
        if (value == true)
          indexes = indexes - [neighbour_index]
        end
      end
    end

    indexes
  end

  # Private: builds a graph from a string provided
  #
  # data  - string representation of a graph
  #
  def build_from_string(data)

    # Check if string representation of the graph is valid
    raise ArgumentError, 'String representation of the graph is invalid' unless data =~ /\A(|([a-z0-0A-Z]+=>[a-z0-0A-Z]*)(,[a-z0-0A-Z]+=>[a-z0-0A-Z]*)*)\z/

    pairs = data.split(',')

    pairs.each do |value|
      items = value.split('=>')
      self.add_vertex(Vertex.new(items[0])) unless find_index_for_vertex(items[0]) != nil

      if (items.length == 2)
        self.add_vertex(Vertex.new(items[1])) unless find_index_for_vertex(items[1]) != nil
        self.add_edge(items[0],items[1])
      end
    end
  end

  # Private: builds a graph from a hash provided
  #
  # data  - hash representation of a graph
  #
  def build_from_hash(data)
    data.each do |start_vertex_name, end_vertex_name|
      # check if vertex is not already in the graph
      if (find_index_for_vertex(start_vertex_name) == nil )
        self.add_vertex(Vertex.new(start_vertex_name))
      end

      # if end vertex is specified
      if (end_vertex_name != nil)
        # and is not already in the graph
        if (find_index_for_vertex(end_vertex_name) == nil)
          self.add_vertex(Vertex.new(end_vertex_name))
        end

        # add an edge between vertices
        self.add_edge(start_vertex_name, end_vertex_name)
      end
    end

    self
  end

end
