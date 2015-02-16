require 'middleman-syntax'
require 'bootstrap-sass'
require 'compass/import-once/activate'

###
# Compass
###

compass_config do |config|
  config.output_style    = :compact
  config.http_path       = '/'
  config.css_dir         = 'source/stylesheets'
  config.sass_dir        = 'source/sass'
  config.images_dir      = 'source/images'
  config.javascripts_dir = 'source/javascripts'
end

###
# Page options, layouts, aliases and proxies
###

page '/',         layout: 'home'
page '/atom.xml', layout: false
page '/ml/*',     layout: false

with_layout :guides do
  page '/guides/*'
end

with_layout :blog do
  page '/blog/*'
end

###
# Helpers
###

activate :directory_indexes
activate :syntax, css_class: 'language-ruby'

activate :blog do |blog|
  blog.prefix    = 'blog'
  blog.permalink = '{year}/{month}/{day}/{title}.html'
end

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def articles(limit = 5)
    blog.articles[0..limit]
  end

  def article_title(article)
    article.data.title
  end

  def article_author(article)
    article.data.author
  end

  def article_date(article)
    date = article.date
    date.strftime('%B %d, %Y')
  end

  def article_summary(article)
    article.data.excerpt.gsub("\n", '<br>')
  end
end

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
