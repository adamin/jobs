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

    vertex_a = @dgraph.find_index_for_vertex('a')
    vertex_b = @dgraph.find_index_for_vertex('b')

    assert(@dgraph.vertices[vertex_a].neighbours[vertex_b] == true && @dgraph.vertices[vertex_b].neighbours[vertex_a] == nil)
  end

  # Tests removing an edge from the graph
  def test_remove_edge
    @dgraph.add_edge('a', 'b');
    @dgraph.remove_edge('a','b')

    vertex_a = @dgraph.find_index_for_vertex('a')
    vertex_b = @dgraph.find_index_for_vertex('b')

    assert(@dgraph.vertices[vertex_a].neighbours[vertex_b] == nil)
  end

  # Tests removing an edge from the graph when first vertex is missing
  def test_remove_edge_first_vertex_missing

    exception = assert_raises ArgumentError do
      @dgraph.remove_edge('z','a')
    end

    assert_equal('Edge removal error. First vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph when second vertex is missing
  def test_remove_edge_second_vertex_missing

    exception = assert_raises ArgumentError do
      @dgraph.remove_edge('a','z')
    end

    assert_equal('Edge removal error. Second vertex could not be found', exception.message)
  end

  # Tests finding source vertices
  def test_find_indexes_of_source_vertices
    @dgraph.add_edge('a', 'b');

    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @dgraph.add_vertex(vertex_c)
    @dgraph.add_vertex(vertex_d)

    assert(@dgraph.find_indexes_of_source_vertices == [0,2,3])
  end
end