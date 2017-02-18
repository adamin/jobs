require 'test/unit'

require_relative '../directed_graph.rb'
require_relative '../vertex.rb'

class TestDirectedGraph < Test::Unit::TestCase
  # Let's create a directed graph instance for our tests
  def setup
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    @dgraph = DirectedGraph.new
    @dgraph.add_vertex(vertex_a)
    @dgraph.add_vertex(vertex_b)
  end

  # Tests adding a new edge to a directed graph
  def test_add_edge
    @dgraph.add_edge('a', 'b');

    vertex_a = @dgraph.find_vertex('a')
    vertex_b = @dgraph.find_vertex('b')

    assert(@dgraph.vertices[vertex_a].neighbors[vertex_b] == true && @dgraph.vertices[vertex_b].neighbors[vertex_a] == nil)
  end
end