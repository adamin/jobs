require 'test/unit'

require_relative '../directed_graph'
require_relative '../vertex'
require_relative '../graph_error'

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

    exception = assert_raises GraphError do
      @dgraph.remove_edge('z','a')
    end

    assert_equal('Edge removal error. First vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph when second vertex is missing
  def test_remove_edge_second_vertex_missing

    exception = assert_raises GraphError do
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

  # Tests performing topological sort for the graph
  def test_topological_sort
    @dgraph = DirectedGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @dgraph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c).add_vertex(vertex_d)
    @dgraph.add_edge('a', 'd').add_edge('d', 'c')

    assert(@dgraph.perform_topological_sort() == [1,0,3,2])
  end

  # Tests performing topological sort for the graph when there is a cycle
  def test_topological_sort_cycle
    @dgraph = DirectedGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @dgraph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c).add_vertex(vertex_d)
    @dgraph.add_edge('a', 'b').add_edge('b', 'c').add_edge('c', 'a').add_edge('a', 'd');

    exception = assert_raises GraphError do
      @dgraph.perform_topological_sort()
    end

    assert_equal('Topological sort could not be performed. Graph has at least one cycle', exception.message)
  end

  # Tests performing check if vertex is a source
  def test_check_if_vertex_is_source
    @dgraph = DirectedGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @dgraph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c).add_vertex(vertex_d)
    @dgraph.add_edge('a', 'd').add_edge('d', 'c')

    assert(@dgraph.check_if_vertex_is_source(0) == true && @dgraph.check_if_vertex_is_source(1) == true)
  end

  # Tests performing check if vertex is a source when it's not
  # depends on setup from previous test
  def test_check_if_vertex_is_source_when_not_source
    assert(@dgraph.check_if_vertex_is_source(2) == false && @dgraph.check_if_vertex_is_source(3) == false)
  end

  # Tests performing check if vertex is a source when it doesn't exist
  # depends on setup from previous test
  def test_check_if_vertex_is_source_when_it_doesnt_exist
    assert(@dgraph.check_if_vertex_is_source(100) == false)
  end

  # Tests building string representation of a graph
  def test_to_s
    graph = DirectedGraph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    graph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c)
    graph.add_edge('a','b').add_edge('c','b')

    assert(graph.to_s == 'a=>b,b=>,c=>b')
  end

  # Tests building a graph from hash
  def test_build_from_hash
    graph = DirectedGraph.new
    graph.build({'a'=>nil,'b'=>'c','c'=>nil})

    assert(graph.to_s == 'a=>,b=>c,c=>')
  end

  # Tests building a graph from string
  def test_build_from_string
    graph = DirectedGraph.new
    graph.build('a=>,b=>c,c=>')

    assert(graph.to_s == 'a=>,b=>c,c=>')
  end
end