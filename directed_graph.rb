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

  # Public: Adds a new edge to the graph by their indexes. Overrides method from the parent.
  #
  # start_vertex_name   - name of the starting vertex
  # end_vertex_name     - name of the ending vertex
  #
  def add_edge_by_indexes(start_vertex_index, end_vertex_index)

    if (@allow_cycles == false && start_vertex_index == end_vertex_index)
      raise GraphError.new('Edge cannot be added. Allowing cycles is disabled and edge would create a self-dependency', GraphError::ERROR_DEPENDENCY_ON_ITSELF)
    end

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

  # Public: checks if a vertex with specified index doesn't have any incoming edges
  #
  # vertex_index  - index of the vertex to search for
  #
  def check_if_vertex_is_source(vertex_index)

    # Return false if vertex does not exist
    return false unless !@vertices[vertex_index].nil?

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

  # Public: performs topological sort of the graph using Kahn's algorithm.
  # If the graph is not a directed acyclic graph
  # then it can't be topologically sorted and therefore an error is thrown.
  #
  def perform_topological_sort
    result = []
    # Copy the graph
    graph = self
    sources = self.find_indexes_of_source_vertices

    while sources.length > 0 do
      # Grab an item from sources
      item = sources.pop
      # and add it to the result array
      result << item

      # for each vertex with an edge from the item to the vertex
      # remove this edge from the graph
      graph.vertices[item].neighbours.each_with_index do |value, index|
        if (value == true)
          graph.remove_edge_by_indexes(item, index)

          # If the vertex has now become a source, push it to the sources array
          if (graph.check_if_vertex_is_source(index))
          sources << index
          end
        end
      end
    end

    raise GraphError.new('Topological sort could not be performed. Graph has at least one cycle', GraphError::ERROR_UNEXPECTED_CYCLE) unless !graph.has_edges()

    result
  end

end