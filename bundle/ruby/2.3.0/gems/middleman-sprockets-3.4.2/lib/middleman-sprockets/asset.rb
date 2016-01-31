# encoding: utf-8
module Middleman
  module Sprockets

    class Asset

      attr_reader :app, :sprockets, :asset

      def initialize app, lookup_path, sprockets = app.sprockets
        @app       = app
        @sprockets = sprockets
        @asset     = sprockets[ sprockets.resolve(lookup_path) ]

        raise ::Sprockets::FileNotFound, "Couldn't find asset '#{lookup_path}'" if @asset.nil?
      end

      def destination_path
        case type
        when :image then
          Pathname.new(app.config[:images_dir]) + remove_asset_dir(asset.logical_path, image_paths)
        when :script then
          Pathname.new(app.config[:js_dir]) + remove_asset_dir(asset.logical_path, script_paths)
        when :font then
          Pathname.new(app.config[:fonts_dir]) + remove_asset_dir(asset.logical_path, font_paths)
        when :stylesheet then
          Pathname.new(app.config[:css_dir]) + remove_asset_dir(asset.logical_path, stylesheet_paths)
        else
          asset.logical_path
        end
      end

      def source_dir
        @source_dir ||= source_path.sub /\/?#{asset.logical_path}$/, ''
      end

      def source_path
        asset.pathname
      end

      def type
        @type ||= if is_image?
                    :image
                  elsif is_script?
                    :script
                  elsif is_stylesheet?
                    :stylesheet
                  elsif is_font?
                    :font
                  else
                    :unknown
                  end
      end

      private

      def has_extname? *exts
        !(exts & asset.pathname.to_s.scan(/(\.[^.]+)/).flatten).empty?
      end

      def remove_asset_dir pathname, asset_dir_paths
        pathname.sub(/^(#{asset_dir_paths.map { |p| Regexp.new(p) }.join('|')})\/?/, '')
      end

      def is_image?
        is_image_by_path? || (is_image_by_extension? && !is_font_by_path?)
      end

      def is_image_by_path?
        image_paths.include?(source_path.dirname.basename.to_s) ||
        image_paths.include?(File.basename(source_dir.to_s))
      end
      alias_method :is_in_images_directory?, :is_image_by_path?

      def is_image_by_extension?
        has_extname?(*%w(.gif .png .jpg .jpeg .webp .svg .svgz))
      end

      def image_paths
        %w( images img )
      end

      def is_stylesheet?
        is_stylesheet_by_path? || is_stylesheet_by_extension?
      end

      def is_stylesheet_by_path?
        stylesheet_paths.include?(source_path.dirname.basename.to_s) ||
        stylesheet_paths.include?(File.basename(source_dir.to_s))
      end
      alias_method :is_in_stylesheet_directory?, :is_stylesheet_by_path?

      def is_stylesheet_by_extension?
        has_extname?(*%w(.css .sass .scss .styl .less))
      end

      def stylesheet_paths
        %w( stylesheets css )
      end

      def is_font?
        is_font_by_path? || is_font_by_extension?
      end

      def is_font_by_path?
        font_paths.include?(source_path.dirname.basename.to_s) ||
        font_paths.include?(File.basename(source_dir.to_s))
      end
      alias_method :is_in_fonts_directory?, :is_font_by_path?

      def is_font_by_extension?
        has_extname?(*%w(.ttf .woff .woff2 .eot .otf .svg .svgz))
      end

      def font_paths
        %w( fonts )
      end

      def is_script?
        is_script_by_path? || is_script_by_extension?
      end

      def is_script_by_path?
        script_paths.include?(source_path.dirname.basename.to_s) ||
        script_paths.include?(File.basename(source_dir.to_s))
      end
      alias_method :is_in_scripts_directory?, :is_script_by_path?

      def is_script_by_extension?
        has_extname?(*%w(.js .coffee))
      end

      def script_paths
        %w( javascripts js )
      end

    end
  end
end
