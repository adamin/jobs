# Represents graph's vertex.
#
class Vertex

  # Public: name of the vertex
  attr_accessor :name
  # Public: array of vertex's neighbours
  attr_accessor :neighbours

  def initialize(name)
    @name = name
    @neighbours = []
  end

end