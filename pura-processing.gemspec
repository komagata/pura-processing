# frozen_string_literal: true

require_relative "lib/pura/processing/version"

Gem::Specification.new do |spec|
  spec.name = "pura-processing"
  spec.version = Pura::Processing::VERSION
  spec.authors = ["komagata"]
  spec.email = ["komagata@gmail.com"]

  spec.summary = "Pure-Ruby, zero-dependency base layer for pipeline-style image processing"
  spec.description = "Chainable DSL and Pipeline orchestration extracted from the " \
                     "image_processing gem (MIT, (c) Janko Marohnic), repackaged without " \
                     "runtime dependencies on ruby-vips or mini_magick. Used as the " \
                     "foundation for pura-image."
  spec.homepage = "https://github.com/komagata/pura-processing"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["lib/**/*.rb"] + %w[LICENSE NOTICE README.md pura-processing.gemspec]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
