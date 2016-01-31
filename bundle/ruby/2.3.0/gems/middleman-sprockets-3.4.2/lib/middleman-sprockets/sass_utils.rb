if defined?(Sass)

  module Sass::Script::Functions

    ##
    # A reference to the Middleman::Application object.
    #
    def middleman_app
      options[:custom][:sprockets_context].app
    end

  end

end
