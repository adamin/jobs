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
    result = result.chop unless result.length == 0

    result
  end

  # Public: builds a graph according to data provided
  #
  # data  - representation of a graph, supported types are: hash and string
  #
  def build(data)
    case data
    when String
      self.build_from_string(data)
    when Hash
      self.build_from_hash(data)
    else
      raise TypeError, 'Unsupported data type for build function'
    end
  end

  # Public: builds a graph from a string provided
  #
  # data  - string representation of a graph
  #
  def build_from_string(data)
    # convert the string to a hash and build from it
    hash = {}
    pairs = data.split(',')

    pairs.each do |value|
      items = value.split('=>')

      if (items.length == 1)
        hash[items[0]] = nil
      else
        hash[items[0]] = items[1]
      end
    end

    self.build_from_hash(hash)
  end

  # Public: builds a graph from a hash provided
  #
  # data  - hash representation of a graph
  #
  def build_from_hash(data)
    data.each do |start_vertex_name, end_vertex_name|
    # check if vertex is not already in the graph
      if (self.find_index_for_vertex(start_vertex_name) == nil )
        start_vertex = Vertex.new(start_vertex_name)
        self.add_vertex(start_vertex)
      end

      # if end vertex is specified
      if (end_vertex_name != nil)
        # and is not already in the graph
        if (self.find_index_for_vertex(end_vertex_name) == nil)
          end_vertex = Vertex.new(end_vertex_name)
          self.add_vertex(end_vertex)
        end

        # add an edge between vertices
        self.add_edge(start_vertex_name, end_vertex_name)
      end
    end

    self
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

end