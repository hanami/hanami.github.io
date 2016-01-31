set :css_dir, "assets/css"

sprockets.append_path File.join(root, 'vendor/assets')
sprockets.import_asset "css/test"