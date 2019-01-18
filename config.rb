ENV['SITE_ENV'] ||= 'development'

Bundler.require(:default, ENV['SITE_ENV']) if defined?(Bundler)

require 'yaml'
require 'ostruct'
require 'rack/utils'
require 'middleman-syntax'
require 'lib/github_style_titles'
require File.expand_path('../extensions/build_cleaner.rb', __FILE__)

activate :search do |search|
  search.fields = {
    title:   { boost: 100, store: true, required: true },
    content: { boost: 50, store: true },
    url:     { index: false, store: true }
  }
end

activate :breadcrumbs

###
# Page options, layouts, aliases and proxies
###

page '/',         layout: 'home'
page '/atom.xml', layout: false
page '/ml/*',     layout: false

###
# Helpers
###

activate :directory_indexes
activate :syntax, css_class: 'language-ruby'

activate :blog do |blog|
  blog.prefix    = 'blog'
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.layout    = :blog
  blog.paginate  = true
  blog.per_page  = 5
end

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload if defined?(::Middleman::LiveReloadExtension)
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

set :url_root, 'http://hanamirb.org'
activate :search_engine_sitemap

# Methods defined in the helpers block are available in templates
helpers do
  #
  # BLOG
  #

  def articles(limit = 5)
    blog.articles.first(limit)
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
    article.data.excerpt
  end

  def article_image(article)
    if article.data.image
      %(<img src="#{ article_image_url(article) }">)
    end
  end

  def article_image_url(article)
    path = if article.data.image
      article.url.gsub(/\.html/, '')
    else
      "/images"
    end

    "#{ path }/cover.jpg"
  end

  #
  # UTILS
  #

  def absolute_url(page)
    url = if page.respond_to?(:url)
            page.url
          else
            page
          end

    "http://hanamirb.org#{ url }"
  end

  def encode_text(text)
   ::Rack::Utils.escape(text)
  end

  def hanami_version
    '1.3.1'
  end

  def hanami_release_date
    Date.parse("2019-01-18").strftime("%B %-d, %Y")
  end
end

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, renderer: GithubStyleTitles

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
  activate :build_cleaner
end
