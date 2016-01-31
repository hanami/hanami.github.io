require "sprockets"
require "sprockets-sass"
require "middleman-sprockets/asset"
require "middleman-sprockets/imported_asset"
require "middleman-sprockets/config_only_environment"
require "middleman-sprockets/environment"
require "middleman-sprockets/asset_tag_helpers"

class Sprockets::Sass::SassTemplate
  # Get the default, global Sass options. Start with Compass's
  # options, if it's available.
  def default_sass_options
    if defined?(Compass) && defined?(Compass.configuration)
      merge_sass_options Compass.configuration.to_sass_engine_options.dup, Sprockets::Sass.options
    else
      Sprockets::Sass.options.dup
    end
  end
end

# Sprockets extension
module Middleman
  class SprocketsExtension < Extension
    option :debug_assets, false, 'Split up each required asset into its own script/style tag instead of combining them (development only)'

    attr_reader :environment

    # This module gets mixed into both the Middleman instance and the Middleman class,
    # so that it's available in config.rb
    module SprocketsAccessor
      # The sprockets environment
      # @return [Middleman::MiddlemanSprocketsEnvironment]
      def sprockets
        extensions[:sprockets].environment
      end
    end

    def initialize(app, options_hash={}, &block)
      require "middleman-sprockets/sass_function_hack"
      require "middleman-sprockets/sass_utils"

      super

      # Start out with a stub environment that can only be configured (paths and such)
      @environment = ::Middleman::Sprockets::ConfigOnlyEnvironment.new

      # v4
      if app.respond_to? :add_to_config_context
        app.add_to_config_context :sprockets, &method(:environment)
      else
        app.send :include, SprocketsAccessor
      end
    end

    helpers do
      include SprocketsAccessor
      include ::Middleman::Sprockets::AssetTagHelpers
    end

    def after_configuration
      ::Tilt.register ::Sprockets::EjsTemplate, 'ejs'
      ::Tilt.register ::Sprockets::EcoTemplate, 'eco'
      ::Tilt.register ::Sprockets::JstProcessor, 'jst'

      if app.respond_to?(:template_extensions)
        app.template_extensions :jst => :js, :eco => :js, :ejs => :js
      end

      if app.config.defines_setting?(:debug_assets) && !options.setting(:debug_assets).value_set?
        options[:debug_assets] = app.config[:debug_assets]
      end

      config_environment = @environment
      debug_assets = !app.build? && options[:debug_assets]
      @environment = ::Middleman::Sprockets::Environment.new(app, :debug_assets => debug_assets)
      config_environment.apply_to_environment(@environment)

      append_paths_from_gems
      import_images_and_fonts_from_gems

      # Setup Sprockets Sass options
      if app.config.defines_setting?(:sass)
        app.config[:sass].each { |k, v| ::Sprockets::Sass.options[k] = v }
      end

      # Intercept requests to /javascripts and /stylesheets and pass to sprockets
      our_sprockets = self.environment

      [app.config[:js_dir], app.config[:css_dir], app.config[:images_dir], app.config[:fonts_dir]].each do |dir|
        app.map("/#{dir}") { run our_sprockets }
      end
    end

    # Add sitemap resource for every image in the sprockets load path
    def manipulate_resource_list(resources)
      resources_list = []

      environment.imported_assets.each do |imported_asset|
        asset = Middleman::Sprockets::Asset.new @app, imported_asset.logical_path, environment
        if imported_asset.output_path
          destination = imported_asset.output_path
        else
          destination = @app.sitemap.extensionless_path( asset.destination_path.to_s )
        end

        next if @app.sitemap.find_resource_by_destination_path destination.to_s

        resource = ::Middleman::Sitemap::Resource.new( @app.sitemap, destination.to_s, asset.source_path.to_s )
        resource.add_metadata options: { sprockets: { logical_path: imported_asset.logical_path }}

        resources_list << resource
      end

      resources + resources_list
    end

    private

    # Add any directories from gems with Rails-like paths to sprockets load path
    def append_paths_from_gems
      root_paths = rubygems_latest_specs.map(&:full_gem_path) << app.root
      base_paths = %w[assets app app/assets vendor vendor/assets lib lib/assets]
      asset_dirs = %w[javascripts js stylesheets css images img fonts]

      root_paths.product(base_paths.product(asset_dirs)).each do |root, (base, asset)|
        path = File.join(root, base, asset)
        environment.append_path(path) if File.directory?(path)
      end
    end

    # Backwards compatible means of finding all the latest gemspecs
    # available on the system
    #
    # @private
    # @return [Array] Array of latest Gem::Specification
    def rubygems_latest_specs
      # If newer Rubygems
      if ::Gem::Specification.respond_to? :latest_specs
        ::Gem::Specification.latest_specs(true)
      else
        ::Gem.source_index.latest_specs
      end
    end

    def import_images_and_fonts_from_gems
      trusted_paths = environment.paths.select { |p| p.end_with?('images') || p.end_with?('fonts') }
      trusted_paths.each do |load_path|
        environment.each_entry(load_path) do |path|
          if path.file? && !path.basename.to_s.start_with?('_')
            logical_path = path.sub /^#{load_path}/, ''
            environment.imported_assets << Middleman::Sprockets::ImportedAsset.new(logical_path)
          end
        end
      end
    end
  end
end
