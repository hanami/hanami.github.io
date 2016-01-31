set :js_dir, "library/js"
set :css_dir, "library/css"

after_configuration do
  sprockets.import_asset "vendored.css"
  sprockets.import_asset "coffee.js"
end