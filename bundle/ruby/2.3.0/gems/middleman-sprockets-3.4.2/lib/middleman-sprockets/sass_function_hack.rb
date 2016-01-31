if defined?(Sass)
  module Sass::Script::Functions
    # Override generated_image_url to use Sprockets
    # a la https://github.com/Compass/compass-rails/blob/master/lib/compass-rails/patches/4_0.rb
    def generated_image_url(path, only_path = nil)
      asset_url(path, Sass::Script::String.new("image"))
    end
  end
end
