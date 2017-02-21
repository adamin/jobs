require_relative 'directed_acyclic_graph'

# Represents a collection of jobs and dependencies between them.
#
# Extends DirectedGraph class.
class JobsCollection < DirectedAcyclicGraph

  # Public: Initialises the collection with data about jobs and their dependencies
  #
  # data - contains jobs and their dependencies
  #
  def initialize(data)
    super()
    begin
      self.build(data)
    rescue GraphError => e
      case e.code
      when GraphError::ERROR_UNEXPECTED_CYCLE
        raise ArgumentError,'Jobs must not create circular dependencies'
      when GraphError::ERROR_DEPENDENCY_ON_ITSELF
        raise ArgumentError,'Jobs must not depend on themselves'
      else
        raise ArgumentError, e.message
      end
    end

  end

  # Public: Generates desired sequence in which the jobs should be completed
  def get_sequence()
    result = []
    begin
      result = self.perform_topological_sort
    rescue GraphError => e
      case e.code
      when GraphError::ERROR_UNEXPECTED_CYCLE
        raise ArgumentError,'Jobs must not create circular dependencies'
      else
        raise ArgumentError, e.message
      end
    end

    # Reverts the sequence
    result.reverse
  end
end
