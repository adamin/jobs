require 'test/unit'

require_relative '../graph'
require_relative '../vertex'
require_relative '../graph_error'

class TestGraph < Test::Unit::TestCase
  # Let's create a graph with a vertex named 'a'
  def setup
    vertex_a = Vertex.new('a')
    vertex_b = Vertex.new('b')
    vertex_c = Vertex.new('c')
    vertex_d = Vertex.new('d')
    @graph = Graph.new()
    @graph.vertices = [vertex_a, vertex_b, vertex_c, vertex_d]
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

    exception = assert_raises GraphError do
      @graph.add_vertex(vertex)
    end

    assert_equal('Vertex with this name already exists in the graph', exception.message)
  end

  # Tests checking if there is a specified edge in the graph
  def test_has_edge
    @graph.add_edge('a', 'b');

    assert(@graph.has_edge('a', 'b') == true)
  end

  # Tests checking if there is a specified edge in the graph when there is no such edge
  def test_has_edge_no_edge
    assert(@graph.has_edge('b', 'd') == false)
  end

  # Tests checking if there is a specified edge in the graph when vertices specified do not exist in the graph
  def test_has_edge_no_vertices
    assert(@graph.has_edge('vertex1', 'vertex2') == false)
  end

  # Tests adding a new edge to the graph
  def test_add_edge
    @graph.add_edge('a', 'b');
    vertex_a = @graph.find_vertex('a')
    vertex_b = @graph.find_vertex('b')

    # 0 and 1 are indexes of vertex a and vertex b respectively
    assert(@graph.vertices[0].neighbours[1] == true && @graph.vertices[1].neighbours[0] == true)
  end

  # Tests adding a new cycle to the graph
  def test_add_edge_with_cycles
    @graph.add_edge('a', 'b');
    @graph.add_edge('b', 'c');
    @graph.add_edge('c', 'a');

    # 0 and 2 are indexes of vertex a and vertex c respectively
    assert(@graph.vertices[0].neighbours[2] == true && @graph.vertices[2].neighbours[0] == true)
  end

  # Test add edge attempt when graph is empty
  def test_add_edge_no_vertices
    graph = Graph.new

    exception = assert_raises GraphError do
      graph.add_edge('a','b')
    end

    assert_equal('No edges can be added to an empty graph', exception.message)
  end

  # Test add edge attempt when first of the vertices is missing
  def test_add_edge_first_vertex_missing
    exception = assert_raises GraphError do
      @graph.add_edge('z','b')
    end

    assert_equal('Edge cannot be added. First vertex could not be found', exception.message)
  end

  # Test add edge attempt when second of the vertices is missing
  def test_add_edge_second_vertex_missing

    exception = assert_raises GraphError do
      @graph.add_edge('a','z')
    end

    assert_equal('Edge cannot be added. Second vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph
  def test_remove_edge
    @graph.remove_edge('a','b')

    # 0 and 1 are indexes of vertex a and vertex b respectively
    assert(@graph.vertices[0].neighbours[1] == nil && @graph.vertices[1].neighbours[0] == nil)
  end

  # Tests removing an edge from the graph when first vertex is missing
  def test_remove_edge_first_vertex_missing

    exception = assert_raises GraphError do
      @graph.remove_edge('z','a')
    end

    assert_equal('Edge removal error. First vertex could not be found', exception.message)
  end

  # Tests removing an edge from the graph when second vertex is missing
  def test_remove_edge_second_vertex_missing

    exception = assert_raises GraphError do
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

  # Tests building a graph from string
  def test_build_from_string2
    graph = Graph.new
    graph.build('a=>b')

    assert(graph.to_s == 'a=>b,b=>a')
  end

  # Tests building a graph from string
  def test_build_from_string3
    graph = Graph.new
    graph.build('a=>,c=>b')

    assert(graph.to_s == 'a=>,c=>b,b=>c')
  end

  # Tests building a graph from string when string is invalid
  def test_build_from_string_invalid
    graph = Graph.new

    exception = assert_raises ArgumentError do
      graph.build('a=>c=>b')
    end

    assert_equal('String representation of the graph is invalid', exception.message)
  end

  # Tests building a graph from string when string is invalid
  def test_build_from_string_invalid2
    graph = Graph.new

    exception = assert_raises ArgumentError do
      graph.build('a=>b,=>b')
    end

    assert_equal('String representation of the graph is invalid', exception.message)
  end

  # Tests unsupported data type for graph build function
  def test_build_from_integer
    graph = Graph.new

    exception = assert_raises TypeError do
      graph.build(1)
    end

    assert_equal('Unsupported data type for build function', exception.message)
  end

end
