# encoding: utf-8
module Middleman
  module Sprockets
    # ImportedAsset
    class ImportedAsset
      attr_reader :logical_path, :output_path

      # Create instance
      #
      # @param [Pathname] logical_path
      #   The logical path to the asset given in config.rb
      #
      # @param [proc] output_dir
      #   An individual output directory for that particular asset
      def initialize logical_path, output_path = nil
        @logical_path = Pathname.new logical_path

        if output_path.respond_to? :call
          if output_path.arity.abs == 1
            output_path = output_path.call(@logical_path)
          else
            output_path = output_path.call
          end
        end

        @output_path = Pathname.new output_path if output_path
      end
    end
  end
end
