require 'test/unit'

require_relative '../directed_acyclic_graph'
require_relative '../vertex'
require_relative '../graph_error'

class TestDirectedAcyclicGraph < Test::Unit::TestCase
  # Let's create a directed graph instance for our tests
  def setup
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    @dgraph = DirectedAcyclicGraph.new
    @dgraph.add_vertex(vertex_a)
    @dgraph.add_vertex(vertex_b)
  end

  # Tests performing topological sort for the graph
  def test_topological_sort
    @dgraph = DirectedAcyclicGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @dgraph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c).add_vertex(vertex_d)
    @dgraph.add_edge('a', 'd').add_edge('d', 'c')

    assert(@dgraph.perform_topological_sort() == ['b','a','d','c'])
  end

  # Tests performing topological sort for the graph when there is a cycle
  def test_topological_sort_cycle
    @dgraph = DirectedAcyclicGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')

    exception = assert_raises GraphError do
      @dgraph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c).add_vertex(vertex_d)
      @dgraph.add_edge('a', 'b').add_edge('b', 'c').add_edge('c', 'a').add_edge('a', 'd');

      @dgraph.perform_topological_sort()
    end

    assert_equal('Topological sort could not be performed. Graph has at least one cycle', exception.message)
  end
end
