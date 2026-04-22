# frozen_string_literal: true
#
# Adapted from image_processing 1.14.0 (MIT, © 2015 Janko Marohnić)
# https://github.com/janko/image_processing
# See NOTICE for attribution details.

module Pura
  module Processing
    class Builder
      include Chainable

      attr_reader :options

      def initialize(options)
        @options = options
      end

      # Calls the pipeline to perform the processing from built options.
      def call!(**call_options)
        instrument do
          Pipeline.new(pipeline_options).call(**call_options)
        end
      end

      private

      def instrument
        return yield unless options[:instrumenter]

        result = nil
        options[:instrumenter].call(**pipeline_options) { result = yield }
        result
      end

      def pipeline_options
        options.reject { |key, _| key == :instrumenter }
      end
    end
  end
end
