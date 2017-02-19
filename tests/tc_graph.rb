require 'test/unit'

require_relative '../graph.rb'
require_relative '../vertex.rb'
class TestGraph < Test::Unit::TestCase
  # Let's create a graph with a vertex named 'a'
  def setup
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @graph = Graph.new()
    @graph.vertices = [vertex_a, vertex_b, vertex_c, vertex_d]
    @graph.allow_cycles = false
  end

  # Tests finding a vertex in the graph with specified name
  def test_find_vertex
    found_vertex = @graph.find_vertex('a')

    assert(found_vertex != nil && found_vertex.name == 'a')
  end

  # Tests adding a new vertex to the graph
  def test_add_vertex
    vertex = Vertex.new('e')
    @graph.add_vertex(vertex)

    found_vertex = @graph.find_vertex('e')

    assert(found_vertex.name == 'e')
  end

  # Tests adding the same vertex twice to the graph
  def test_add_vertex_twice
    vertex = Vertex.new('x')
    @graph.add_vertex(vertex)

    exception = assert_raises ArgumentError do
      @graph.add_vertex(vertex)
    end

    assert_equal('Vertex with this name already exists in the graph', exception.message)
  end

  # Tests adding a new edge to the graph
  def test_add_edge
    @graph.add_edge('a', 'b');

    vertex_a = @graph.find_index_for_vertex('a')
    vertex_b = @graph.find_index_for_vertex('b')

    assert(@graph.vertices[vertex_a].neighbours[vertex_b] == true && @graph.vertices[vertex_b].neighbours[vertex_a] == true)
  end

  # Tests adding a new cycle to the graph
  def test_add_edge_with_cycles
    @graph.allow_cycles = true;
    @graph.add_edge('a', 'b');
    @graph.add_edge('b', 'c');
    @graph.add_edge('c', 'a');

    vertex_a = @graph.find_index_for_vertex('a')
    vertex_c = @graph.find_index_for_vertex('c')

    assert(@graph.vertices[vertex_a].neighbours[vertex_c] == true && @graph.vertices[vertex_c].neighbours[vertex_a] == true)
  end

  # Test add edge attempt when graph is empty
  def test_add_edge_no_vertices
    graph = Graph.new

    exception = assert_raises ArgumentError do
      graph.add_edge('a','b')
    end

    assert_equal('No edges can be added to an empty graph', exception.message)
  end

  # Test add edge attempt when first of the vertices is missing
  def test_add_edge_first_vertex_missing
    exception = assert_raises ArgumentError do
      @graph.add_edge('z','b')
    end

    assert_equal('Edge cannot be added. First vertex could not be found', exception.message)
  end

  # Test add edge attempt when second of the vertices is missing
  def test_add_edge_second_vertex_missing

    exception = assert_raises ArgumentError do
      @graph.add_edge('a','z')
    end

    assert_equal('Edge cannot be added. Second vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph
  def test_remove_edge
    @graph.remove_edge('a','b')

    vertex_a = @graph.find_index_for_vertex('a')
    vertex_b = @graph.find_index_for_vertex('b')

    assert(@graph.vertices[vertex_a].neighbours[vertex_b] == nil && @graph.vertices[vertex_b].neighbours[vertex_a] == nil)
  end

  # Tests removing an edge from the graph when first vertex is missing
  def test_remove_edge_first_vertex_missing

    exception = assert_raises ArgumentError do
      @graph.remove_edge('z','a')
    end

    assert_equal('Edge removal error. First vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph when second vertex is missing
  def test_remove_edge_second_vertex_missing

    exception = assert_raises ArgumentError do
      @graph.remove_edge('a','z')
    end

    assert_equal('Edge removal error. Second vertex could not be found', exception.message)
  end

  # Tests checking if there are edges in the graph
  def test_has_edges
    graph = Graph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    graph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c)
    graph.add_edge('b','c')

    assert(graph.has_edges() == true)
  end

  # Tests checking if there are edges in the graph with vertices only
  def test_has_edges_vertices_only
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    graph = Graph.new
    graph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c)

    assert(graph.has_edges() == false)
  end

  # Tests checking if there are edges in the graph while the graph is empty
  def test_has_edges_when_empty
    graph = Graph.new

    assert(graph.has_edges() == false)
  end

  # Tests building string representation of a graph
  def test_to_s
    graph = Graph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    graph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c)
    graph.add_edge('a','b').add_edge('c','b')

    assert(graph.to_s == 'a=>b,b=>a,b=>c,c=>b')
  end

  # Tests building string representation of an empty graph
  def test_to_s_empty_graph
    graph = Graph.new

    assert(graph.to_s == '')
  end

  # Tests building string representation of a graph with no edges
  def test_to_s_only_vertices
    graph = Graph.new
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    graph.add_vertex(vertex_a).add_vertex(vertex_b).add_vertex(vertex_c)

    assert(graph.to_s == 'a=>,b=>,c=>')
  end

  # Tests building a graph from hash
  def test_build_from_hash
    graph = Graph.new
    graph.build({'a'=>'b','c'=>'b'})

    assert(graph.to_s == 'a=>b,b=>a,b=>c,c=>b')
  end

  # Tests building a graph from string
  def test_build_from_string
    graph = Graph.new
    graph.build('a=>b,c=>b')

    assert(graph.to_s == 'a=>b,b=>a,b=>c,c=>b')
  end

  def test_build_from_integer
    graph = Graph.new

    exception = assert_raises TypeError do
      graph.build(1)
    end

    assert_equal('Unsupported data type for build function', exception.message)
  end

end