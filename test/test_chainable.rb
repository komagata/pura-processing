# frozen_string_literal: true

require_relative "test_helper"

class ChainableTest < Minitest::Test
  def setup
    @source = Tempfile.new(%w[pura_processing_src .txt]).tap do |f|
      f.write("hello")
      f.close
    end
    @destination = Tempfile.new(%w[pura_processing_dst .txt]).tap(&:close)
  end

  def teardown
    @source.unlink
    @destination.unlink
  end

  def test_source_resize_call_chain_runs_end_to_end
    DummyDSL.source(@source.path)
            .resize_to_limit(32, 32)
            .call(destination: @destination.path)

    assert_equal "hello[resized:32x32]", File.read(@destination.path)
  end

  def test_method_missing_forwards_unknown_operation_to_processor
    DummyDSL.source(@source.path)
            .uppercase
            .call(destination: @destination.path)

    assert_equal "HELLO", File.read(@destination.path)
  end

  def test_builder_is_immutable_so_branching_does_not_affect_siblings
    base = DummyDSL.source(@source.path)

    resized = base.resize_to_limit(10, 10)
    upper   = base.uppercase

    resized_dst = Tempfile.new(%w[r .txt]).tap(&:close)
    upper_dst   = Tempfile.new(%w[u .txt]).tap(&:close)

    resized.call(destination: resized_dst.path)
    upper.call(destination: upper_dst.path)

    assert_equal "hello[resized:10x10]", File.read(resized_dst.path)
    assert_equal "HELLO", File.read(upper_dst.path)
  ensure
    resized_dst&.unlink
    upper_dst&.unlink
  end

  def test_apply_expands_hash_of_operations
    DummyDSL.source(@source.path)
            .apply(resize_to_limit: [16, 16], uppercase: true)
            .call(destination: @destination.path)

    assert_equal "hello[resized:16x16]".upcase, File.read(@destination.path)
  end

  def test_call_accepts_source_as_positional_arg
    DummyDSL.resize_to_limit(8, 8).call(@source.path, destination: @destination.path)

    assert_equal "hello[resized:8x8]", File.read(@destination.path)
  end

  def test_pipeline_raises_when_source_is_missing
    error = assert_raises(Pura::Processing::Error) do
      DummyDSL.resize_to_limit(8, 8).call!
    end
    assert_match(/source file is not provided/, error.message)
  end
end
