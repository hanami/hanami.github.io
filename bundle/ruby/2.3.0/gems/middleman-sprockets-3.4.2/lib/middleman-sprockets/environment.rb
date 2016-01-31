module Middleman
  module Sprockets
    # Generic Middleman Sprockets env
    class Environment < ::Sprockets::Environment
      # Whether or not we should debug assets by splitting them all out into individual includes
      attr_reader :debug_assets

      # A list of Sprockets logical paths for assets that should be brought into the
      # Middleman application and built.
      attr_reader :imported_assets

      # The current path, useful when inside helper methods
      attr_reader :last_request_path

      # Setup
      def initialize(app, options={})
        @imported_assets = []
        @app = app
        @debug_assets = options.fetch(:debug_assets, false)

        super app.source_dir

        # By default, sprockets has no cache! Give it an in-memory one using a Hash
        # There is also a Sprockets::Cache::FileStore option, but it is fraught with cache-invalidation
        # peril, so we choose not to use it.
        @cache = {}

        enhance_context_class!

        # Remove compressors, we handle these with middleware
        unregister_bundle_processor 'application/javascript', :js_compressor
        unregister_bundle_processor 'text/css', :css_compressor

        # configure search paths
        append_path app.config[:js_dir]
        append_path app.config[:css_dir]
        append_path app.config[:images_dir]
        append_path app.config[:fonts_dir]

        if app.config.respond_to?(:bower_dir)
          warn ":bower_dir is deprecated. Call sprockets.append_path from a 'ready' block instead."
          append_path app.config[:bower_dir]
        end

        # add custom assets paths to the scope
        app.config[:js_assets_paths].each do |p|
          warn ":js_assets_paths is deprecated. Call sprockets.append_path from a 'ready' block instead."
          append_path p
        end if app.config.respond_to?(:js_assets_paths)

        # Stylus support
        if defined?(::Stylus)
          require 'stylus/sprockets'
          ::Stylus.setup(self, app.config[:styl])
        end
      end

      # Add our own customizations to the Sprockets context class
      def enhance_context_class!
        app = @app
        env = self

        # Make the app context available to Sprockets
        context_class.send(:define_method, :app) { app }
        context_class.send(:define_method, :env) { env }

        context_class.class_eval do
          def asset_path(path, options={})
            # Handle people calling with the Middleman/Padrino asset path signature
            if path.is_a?(::Symbol) && !options.is_a?(::Hash)
              kind = path
              path = options
            else

            kind = case options[:type]
                   when :image then :images
                   when :font then :fonts
                   when :javascript then :js
                   when :stylesheet then :css
                   else options[:type]
                   end
            end

            # If Middleman v4, we don't have a global for current path, so pass it in.
            if self.env.last_request_path
              app.asset_path(kind, path, {
                :current_resource => app.sitemap.find_resource_by_destination_path(
                  self.env.last_request_path
                )
              })
            else 
              app.asset_path(kind, path)
            end
          end

          # These helpers are already defined in later versions of Sprockets, but we define
          # them ourself to help older versions and to provide extra options that Sass wants.

          # Expand logical image asset path.
          def image_path(path, options={})
            asset_path(path, :type => :image)
          end

          # Expand logical font asset path.
          def font_path(path, options={})
            # Knock .fonts off the end, because Middleman < 3.1 doesn't handle fonts
            # in asset_path
            asset_path(path, :type => :font).sub(/\.fonts$/, '')
          end

          # Expand logical javascript asset path.
          def javascript_path(path, options={})
            asset_path(path, :type => :javascript)
          end

          # Expand logical stylesheet asset path.
          def stylesheet_path(path, options={})
            asset_path(path, :type => :stylesheet)
          end

          def method_missing(*args)
            name = args.first
            if app.respond_to?(name)
              app.send(*args)
            else
              super
            end
          end

          # Needed so that method_missing makes sense
          def respond_to?(method, include_private = false)
            super || app.respond_to?(method, include_private)
          end
        end
      end
      private :enhance_context_class!

      # Override Sprockets' default digest function to *not*
      # change depending on the exact Sprockets version. It still takes
      # into account "version" which is a user-suppliable version
      # number that can be used to force assets to have a new
      # hash.
      def digest
        @digest ||= Digest::SHA1.new.update(version.to_s)
        @digest.dup
      end

      # Strip our custom 8-char hex/sha
      def path_fingerprint(path)
        path[/-([0-9a-f]{8})\.[^.]+$/, 1]
      end

      # Invalidate sitemap when users mess with the sprockets load paths
      def append_path(path)
        @app.sitemap.rebuild_resource_list!(:sprockets_paths)

        super
      end

      def prepend_path(path)
        @app.sitemap.rebuild_resource_list!(:sprockets_paths)

        super
      end

      def clear_paths
        @app.sitemap.rebuild_resource_list!(:sprockets_paths)
        super
      end

      def css_exception_response(exception)
        raise exception if @app.build?
        super
      end

      def javascript_exception_response(exception)
        raise exception if @app.build?
        super
      end

      # Never return 304s, downstream may want to manipulate data.
      def etag_match?(asset, env)
        false
      end

      def call(env)
        # Set the app current path based on the full URL so that helpers work
        script_name = env['SCRIPT_NAME'].dup
        script_name.gsub!(/^#{@app.config[:http_prefix]}/i, '') if @app.config[:http_prefix]
        request_path = URI.decode(File.join(script_name, env['PATH_INFO']))
        if request_path.respond_to? :force_encoding
          request_path.force_encoding('UTF-8')
        end
        resource = @app.sitemap.find_resource_by_destination_path(request_path)

        if !resource && !debug_assets
          response = ::Rack::Response.new
          response.status = 404
          response.write """<html><body><h1>File Not Found</h1><p>#{request_path}</p>
        <p>If this is an an asset from a gem, add <tt>sprockets.import_asset '#{File.basename(request_path)}'</tt>
        to your <tt>config.rb</tt>.</body>"""
          return response.finish
        end

        if @app.respond_to?(:current_path=)
          @app.current_path = request_path
        else
          @last_request_path = request_path
        end

        # Fix https://github.com/sstephenson/sprockets/issues/533
        if resource && File.basename(resource.path) == 'bower.json'
          file = ::Rack::File.new nil
          file.path = resource.source_file
          response = file.serving({})
          response[1]['Content-Type'] = resource.content_type
          return response
        end

        if resource
          # incase the path has been rewrite, let sprockets know the original so it can find it
          logical_path = resource.metadata.fetch(:options, {})
                                          .fetch(:sprockets, {})
                                          .fetch(:logical_path, nil)
          env['PATH_INFO'] = logical_path.to_s if logical_path
        end

        super
      end

      # Tell Middleman to build this asset, referenced as a logical path.
      def import_asset(asset_logical_path, &determine_output_dir)
        args = []
        args << asset_logical_path
        args << determine_output_dir if block_given?

        imported_assets << ImportedAsset.new(*args)

        @app.sitemap.rebuild_resource_list!(:sprockets_import_asset)
      end
    end
  end
end
