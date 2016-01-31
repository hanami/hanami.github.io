module Middleman
  module Sprockets
    module AssetTagHelpers

      # extend padrinos javascript_include_tag with debug functionality
      # splits up script dependencies in individual files when
      # configuration variable :debug_assets is set to true
      def javascript_include_tag(*sources)
        if sprockets.debug_assets
          options = sources.extract_options!.symbolize_keys
          sources.map do |source|
            super(dependencies_paths('.js', source), options)
          end.join("").gsub("body=1.js", "body=1")
        else
          super
        end
      end

      # extend padrinos stylesheet_link_tag with debug functionality
      # splits up stylesheets dependencies in individual files when
      # configuration variable :debug_assets is set to true
      def stylesheet_link_tag(*sources)
        if sprockets.debug_assets
          options = sources.extract_options!.symbolize_keys
          sources.map do |source|
            super(dependencies_paths('.css', source), options)
          end.join("").gsub("body=1.css", "body=1")
        else
          super
        end
      end

      private

      # Find the paths for all the dependencies of a given source file.
      def dependencies_paths(extension, source)
        source_file_name = source.to_s

        if source_file_name.start_with?('//', 'http')
          # Don't touch external sources
          source_file_name
        else
          source_file_name << extension unless source_file_name.end_with?(extension)

          dependencies_paths = sprockets[source_file_name].to_a.map do |dependency|
            # if sprockets sees "?body=1" it only gives back the body
            # of the script without the dependencies included
            dependency.logical_path + "?body=1"
          end
        end
      end
    end
  end
end
