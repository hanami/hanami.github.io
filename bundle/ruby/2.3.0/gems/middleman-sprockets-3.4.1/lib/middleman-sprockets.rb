require "middleman-core"

params = [:sprockets]

# If we're in v4
params << { auto_activate: :before_configuration } if Middleman::Extensions.method(:register).arity != -1

Middleman::Extensions.register(*params) do
  require "middleman-sprockets/extension"
  Middleman::SprocketsExtension
end