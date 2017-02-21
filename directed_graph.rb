require_relative 'graph'
require_relative 'vertex'
require_relative 'graph_error'

# Represents directed graph data structure -
# a graph where edges can be traversed in one direction only.
#
# Extends Graph class.
#
class DirectedGraph < Graph

  def initialize()
    super()
  end

  private

  # Private: Adds a new edge to the graph by their indexes. Overrides method from the parent.
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def add_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = true

    self
  end

  # Private: removes an edge from the graph by their indexes. Overrides method of the parent.
  #
  # start_vertex_index   - index of the starting vertex
  # end_vertex_index     - index of the ending vertex
  #
  def remove_edge_by_indexes(start_vertex_index, end_vertex_index)

    @vertices[start_vertex_index].neighbours[end_vertex_index] = nil

    self
  end

end
