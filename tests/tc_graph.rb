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

  # Tests adding a new edge to the graph
  def test_add_edge
    @graph.add_edge('a', 'b');

    vertex_a = @graph.find_index_for_vertex('a')
    vertex_b = @graph.find_index_for_vertex('b')

    assert(@graph.vertices[vertex_a].neighbours[vertex_b] == true && @graph.vertices[vertex_b].neighbours[vertex_a] == true)
  end

  # Tests adding a new edge to itself
  def test_add_edge_to_itself_no_cycles
    exception = assert_raises ArgumentError do
      @graph.add_edge('b', 'b');
    end

    assert_equal('Attempt to create a cycle in a cycleless graph', exception.message)
  end

  # Tests adding a new edge to a cycleless graph
  def test_add_edge_no_cycles
    @graph.add_edge('a', 'b');
    @graph.add_edge('b', 'c');

    exception = assert_raises ArgumentError do
      @graph.add_edge('c', 'a');
    end

    assert_equal('Attempt to create a cycle in a cycleless graph', exception.message)
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

end