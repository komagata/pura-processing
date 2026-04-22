# frozen_string_literal: true

# A minimal backend-less processor used only for exercising the pipeline layer
# without any real image decoding/encoding. The accumulator is a plain String
# so each operation simply transforms text — which is enough to verify the
# load -> operations -> save flow, Builder immutability, and method_missing
# forwarding.
class DummyProcessor < Pura::Processing::Processor
  accumulator :image, String

  def self.load_image(source, **_options)
    File.binread(source)
  end

  def self.save_image(image, destination, **_options)
    File.binwrite(destination, image)
  end

  def resize_to_limit(width, height, **_options)
    "#{image}[resized:#{width}x#{height}]"
  end

  def uppercase
    image.upcase
  end
end

module DummyDSL
  extend Pura::Processing::Chainable

  class Processor < DummyProcessor
  end
end
