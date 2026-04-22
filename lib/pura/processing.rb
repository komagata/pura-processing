# frozen_string_literal: true

require_relative "processing/version"
require_relative "processing/chainable"
require_relative "processing/builder"
require_relative "processing/pipeline"
require_relative "processing/processor"

module Pura
  module Processing
    Error = Class.new(StandardError)
  end
end
