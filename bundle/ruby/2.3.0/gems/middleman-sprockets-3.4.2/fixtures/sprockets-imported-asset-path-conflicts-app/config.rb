set :css_dir, "assets/css"

sprockets.append_path File.join(root, 'resources/assets')
sprockets.import_asset "stylesheets/test"