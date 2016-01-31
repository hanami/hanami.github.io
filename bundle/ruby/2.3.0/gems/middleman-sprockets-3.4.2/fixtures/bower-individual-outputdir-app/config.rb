sprockets.append_path File.join(root, 'bower_components')

sprockets.append_path File.join(root, 'vendor/assets/components')
sprockets.import_asset('underscore/underscore.js') { 'underscore.js' }
sprockets.import_asset('lightbox2/img/close.png') { |logical_path| Pathname.new('hello_world') + logical_path }
sprockets.import_asset('lightbox2/js/lightbox.js')
