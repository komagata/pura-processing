# pura-processing

Pure-Ruby, zero-dependency base layer for pipeline-style image processing.

Provides the `Chainable` DSL, `Builder`, `Pipeline`, and abstract `Processor` classes — the image-backend-agnostic foundation that originated in the excellent [image_processing](https://github.com/janko/image_processing) gem by Janko Marohnić, repackaged without any runtime dependency on `ruby-vips` or `mini_magick`.

## Why this exists

`image_processing` ties its chainable DSL to two backend gems (`ruby-vips` and `mini_magick`) as runtime dependencies. Any downstream gem that just wants the abstraction (but ships its own backend) is forced to drag in C extensions transitively.

`pura-processing` extracts the backend-agnostic layer so that gems like [pura-image](https://github.com/komagata/pura-image) can offer a drop-in `ImageProcessing`-compatible API with zero C compiler requirements.

## Installation

```ruby
# Gemfile
gem "pura-processing"
```

```sh
gem install pura-processing
```

No system libraries. No compiler. Works on CRuby, JRuby, TruffleRuby, and ruby.wasm.

## Usage

`pura-processing` does not perform image I/O on its own — it provides the abstract pipeline. You subclass `Pura::Processing::Processor` and implement `load_image` / `save_image` / any operation macros:

```ruby
require "pura/processing"

class MyProcessor < Pura::Processing::Processor
  accumulator :image, MyImageClass

  def self.load_image(source, **_options)
    MyImageClass.open(source)
  end

  def self.save_image(image, destination, **_options)
    image.write(destination)
  end

  def resize_to_limit(width, height, **_options)
    image.resize(width, height)
  end
end

module MyApp
  extend Pura::Processing::Chainable

  class Processor < MyProcessor
  end
end

MyApp.source("photo.jpg")
     .resize_to_limit(400, 400)
     .call(destination: "out.jpg")
```

The chainable API matches `image_processing`: `source`, `convert`, `loader`, `saver`, `apply`, `operation`, `call`, and any unknown method is interpreted as a processor operation (`method_missing` forwarding).

## Attribution

The pipeline layer is adapted from `image_processing` 1.14.0 under the MIT License. See [`NOTICE`](NOTICE) for the upstream copyright and license text. Each source file in `lib/pura/processing/` carries a header pointing to the upstream file it was adapted from.

## License

MIT. See [`LICENSE`](LICENSE).
