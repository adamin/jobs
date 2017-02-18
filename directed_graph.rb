require_relative 'graph'
require_relative 'vertex'

# Represents directed graph data structure -
# a graph where edges can be traversed in one direction only.
#
# Extends Graph class.
#
class DirectedGraph < Graph

  def initialize()
    super()
  end

  # Public: finds source vertices - those that don't have any incoming edges
  def find_indexes_of_source_vertices
    indexes = []
    @vertices.each_index do |index|
      indexes << index;
    end
    @vertices.each do |vertex|
      vertex.neighbours.each_with_index do |value, neighbour_index|
        if (value == true)
          indexes = indexes - [neighbour_index]
        end
      end
    end

    indexes
  end

  # Public: Adds a new edge to the graph. Overrides method from the parent.
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

    self
  end

  # Public: removes an edge from the graph. Overrides method of the parent.
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

    self
  end

end