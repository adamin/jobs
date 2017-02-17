require 'test/unit'
require './jobs_collection.rb'

class TestJobsCollection < Test::Unit::TestCase
  # Tests empty jobs collection
  def test_empty
    collection = JobsCollection.new ''
    sequence = collection.getSequence()

    assert_equal '', sequence
  end

  # Tests handling of self dependent jobs
  # expects ArgumentError to be thrown
  def test_self_dependency
    collection = JobsCollection.new({'a'=>nil, 'b'=>nil, 'c'=>'c'})

    exception = assert_raises ArgumentError do
      collection.getSequence()
    end
    assert_equal('Jobs must not depend on themselves', exception.message)
  end

  # Tests handling of circular dependencies
  # expects ArgumentError to be thrown
  def test_cycle
    collection = JobsCollection.new({'a'=>'b', 'b'=>'c', 'c'=>'a', 'd'=>'b'})

    exception = assert_raises ArgumentError do
      collection.getSequence()
    end

    assert_equal('Jobs must not create circular dependencies', exception.message)
  end
end