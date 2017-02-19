# Represents error specific to graphs
class GraphError < StandardError

  # Constants defining error codes
  ERROR_GENERAL = 1
  ERROR_UNEXPECTED_CYCLE = 10
  ERROR_DUPLICATE_VERTEX = 20
  ERROR_ADD_EDGE_FAILURE = 30
  ERROR_REMOVE_EDGE_FAILURE = 40
  ERROR_DEPENDENCY_ON_ITSELF = 50

  attr_reader :code

  def initialize(message, code = ERROR_GENERAL)
    super(message)
    @code = code
  end
end
