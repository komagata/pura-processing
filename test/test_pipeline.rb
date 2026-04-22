# frozen_string_literal: true

require_relative "test_helper"

class PipelineTest < Minitest::Test
  def test_destination_format_detects_from_destination_extension
    pipeline = Pura::Processing::Pipeline.new(
      source: "a.jpg",
      loader: {},
      saver: {},
      format: nil,
      operations: [],
      processor: DummyProcessor,
      destination: "out.png"
    )
    assert_equal "png", pipeline.destination_format
  end

  def test_destination_format_falls_back_to_source_extension
    pipeline = Pura::Processing::Pipeline.new(
      source: "photo.gif",
      loader: {},
      saver: {},
      format: nil,
      operations: [],
      processor: DummyProcessor,
      destination: nil
    )
    assert_equal "gif", pipeline.destination_format
  end

  def test_destination_format_defaults_to_jpg_when_unknown
    pipeline = Pura::Processing::Pipeline.new(
      source: "no_extension",
      loader: {},
      saver: {},
      format: nil,
      operations: [],
      processor: DummyProcessor,
      destination: nil
    )
    assert_equal "jpg", pipeline.destination_format
  end

  def test_call_without_destination_returns_tempfile
    src = Tempfile.new(%w[pp_src .txt]).tap do |f|
      f.write("x")
      f.close
    end

    result = DummyDSL.source(src.path).resize_to_limit(4, 4).call
    assert File.exist?(result.path)
    assert_equal "x[resized:4x4]", File.read(result.path)
  ensure
    src&.unlink
    result&.close!
  end

  def test_call_with_save_false_returns_accumulator_without_writing
    src = Tempfile.new(%w[pp_src .txt]).tap do |f|
      f.write("abc")
      f.close
    end

    result = DummyDSL.source(src.path).uppercase.call(save: false)
    assert_equal "ABC", result
  ensure
    src&.unlink
  end
end
