set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

sprockets.append_path File.join(root, 'vendor/assets/components')
sprockets.import_asset 'lightbox2/img/close.png'
sprockets.import_asset 'lightbox2/js/lightbox.js'
