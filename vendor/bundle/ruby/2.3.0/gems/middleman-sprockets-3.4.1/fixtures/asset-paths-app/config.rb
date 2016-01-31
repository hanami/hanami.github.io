# Until Middleman is fixed to load Sprockets before config.rb, we have to do this
after_configuration do
  sprockets.append_path "#{root}/derp/javascripts/"
end
