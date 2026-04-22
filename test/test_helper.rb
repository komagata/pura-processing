# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pura/processing"
require "minitest/autorun"
require "tempfile"
require_relative "fixtures/dummy_processor"
