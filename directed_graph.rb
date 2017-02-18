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

  # Public: Adds a new edge to the graph by their indexes. Overrides method from the parent.
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def add_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = true

    self
  end

  # Public: removes an edge from the graph by their indexes. Overrides method of the parent.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def remove_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = nil

    self
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

  # Public: performs topological sort of the graph using Kahn's algorithm.
  # If the graph is not a directed acyclic
  # graph then it can't be topologically sorted and therefore an error is thrown.
  #
  def perform_topological_sort

  end

end