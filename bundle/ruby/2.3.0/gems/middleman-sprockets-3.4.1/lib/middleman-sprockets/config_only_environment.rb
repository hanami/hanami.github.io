module Middleman
  module Sprockets
    # A fake Sprockets environment that just exposes the
    # waits to create the environment until asked, but can still
    # service most of the interesting configuration methods. This
    # allows sprockets to be configured any time in config.rb, rather
    # than having to use an after_configuration block.
    class ConfigOnlyEnvironment
      attr_reader :imported_assets
      attr_reader :appended_paths
      attr_reader :prepended_paths

      def initialize(options={})
        @imported_assets = []
        @appended_paths = []
        @prepended_paths = []
      end

      def method_missing?(method)
        raise NoMethodError, "The Sprockets environment is not ready yet, so you can't call #{method} on it. If you need to call this method do it in a 'ready' block."
      end

      def apply_to_environment(environment)
        @imported_assets.each do |(path, directory)|
          environment.import_asset path, &directory
        end

        @appended_paths.each do |path|
          environment.append_path path
        end

        @prepended_paths.each do |path|
          environment.prepend_path path
        end
      end

      def import_asset(asset_logical_path, &output_directory)
        @imported_assets << [asset_logical_path, output_directory]
      end

      def append_path(path)
        @appended_paths << path
      end

      def prepend_path(path)
        @prepended_paths << path
      end
    end
  end
end
