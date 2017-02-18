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

end