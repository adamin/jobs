require 'test/unit'
require_relative '../jobs_collection.rb'

class TestJobsCollection < Test::Unit::TestCase
  # Tests empty jobs collection
  def test_empty
    collection = JobsCollection.new ''
    sequence = collection.get_sequence()

    assert_equal [], sequence
  end

  # Tests handling of self dependent jobs
  # expects ArgumentError to be thrown
  def test_self_dependency
    exception = assert_raises ArgumentError do
      collection = JobsCollection.new({'a'=>nil, 'b'=>nil, 'c'=>'c'})
    end
    assert_equal('Jobs must not depend on themselves', exception.message)
  end

  # Tests handling of circular dependencies
  # expects ArgumentError to be thrown
  def test_cycle
    exception = assert_raises ArgumentError do
      collection = JobsCollection.new({'a'=>'b', 'b'=>'c', 'c'=>'a', 'd'=>'b'})
      collection.get_sequence()
    end

    assert_equal('Jobs must not create circular dependencies', exception.message)
  end

  # Test scenario where only one job is provided
  def test_single
    collection = JobsCollection.new({'a'=>nil})
    sequence = collection.get_sequence()

    assert_equal ['a'], sequence
  end

  # Test scenario where multiple jobs are provided with no dependencies between them
  def test_no_dependencies
    collection = JobsCollection.new({'a'=>nil, 'b'=>nil, 'c'=>nil})
    sequence = collection.get_sequence()

    assert(sequence.is_a?(Array) && ['a','b','c'] == sequence.sort)
  end

  # Test scenario where multiple jobs are provided with one dependency
  def test_one_dependency
    collection = JobsCollection.new({'a'=>nil, 'b'=>'c', 'c'=>nil})
    sequence = collection.get_sequence()

    assert(['a','c','b'] == sequence || ['c','b','a'] == sequence || ['c','a','b'] == sequence)
  end

  # Test scenario where multiple jobs are provided with multiple dependencies
  def test_multiple_dependencies
    collection = JobsCollection.new({'a'=>nil, 'b'=>'c', 'c'=>'f', 'd'=>'a', 'e'=>'b', 'f'=>nil})
    sequence = collection.get_sequence()

    assert(['a','d','f','c','b','e'] == sequence ||
           ['a','f','d','c','b','e'] == sequence ||
           ['a','f','c','d','b','e'] == sequence ||
           ['a','f','c','b','d','e'] == sequence ||
           ['a','f','c','b','e','d'] == sequence ||

           ['f','a','d','c','b','e'] == sequence ||
           ['f','a','c','d','b','e'] == sequence ||
           ['f','a','c','b','d','e'] == sequence ||
           ['f','a','c','b','e','d'] == sequence ||

           ['f','c','a','d','b','e'] == sequence ||
           ['f','c','a','b','d','e'] == sequence ||
           ['f','c','a','b','e','d'] == sequence ||

           ['f','c','b','a','d','e'] == sequence ||
           ['f','c','b','a','e','d'] == sequence ||

           ['f','c','b','e','a','d'] == sequence)
  end
end
