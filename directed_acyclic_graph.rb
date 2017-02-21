require_relative 'directed_graph'
require_relative 'vertex'
require_relative 'graph_error'

# Represents directed acyclic graph data structure -
# a graph where edges can be traversed in one direction only and cycles are not allowed.
#
# Extends DirectedGraph class.
#
class DirectedAcyclicGraph < DirectedGraph

  def initialize()
    super()
  end

  # Public: performs topological sort of the graph using Kahn's algorithm.
  # If the graph is not a directed acyclic graph
  # then it can't be topologically sorted and therefore an error is thrown.
  #
  def perform_topological_sort
    result = []
    # perform a deep copy of the graph
    graph = Marshal::load(Marshal.dump(self))
    sources = find_indexes_of_source_vertices

    while sources.length > 0 do
        # Grab an item from sources
        item = sources.pop
        # and add it to the result array
        result << item

        # for each vertex with an edge from the item to the vertex
        # remove this edge from the graph
        graph.vertices[item].neighbours.each_with_index do |value, index|
          if (value == true)
            graph.remove_edge(graph.vertices[item].name, graph.vertices[index].name)

            # If the vertex has now become a source, push it to the sources array
            if (graph.check_if_vertex_is_source(graph.vertices[index].name))
              sources << index
            end
          end
        end
      end

      raise GraphError.new('Topological sort could not be performed. Graph has at least one cycle', GraphError::ERROR_UNEXPECTED_CYCLE) unless !graph.has_edges()

      convert_indexes_to_names(result)
    end

    private

    # Private: Adds a new edge to the graph by their indexes. Overrides method from the parent.
    #
    # start_vertex_name   - name of the starting vertex
    # end_vertex_name     - name of the ending vertex
    #
    def add_edge_by_indexes(start_vertex_index, end_vertex_index)

      if (start_vertex_index == end_vertex_index)
        raise GraphError.new('Edge cannot be added as it would create a self-dependency', GraphError::ERROR_DEPENDENCY_ON_ITSELF)
      end

      @vertices[start_vertex_index].neighbours[end_vertex_index] = true

      # check if we haven't created a cycle
      begin
        self.perform_topological_sort
      rescue GraphError => e
        case e.code
        when GraphError::ERROR_UNEXPECTED_CYCLE
          # remove previously added edge
          @vertices[start_vertex_index].neighbours[end_vertex_index] = nil
          raise e
        end
      end

      self
    end

  end
