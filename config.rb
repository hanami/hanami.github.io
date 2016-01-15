require 'rack/utils'
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

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

set :url_root, 'http://hanami.io'
activate :search_engine_sitemap

# Methods defined in the helpers block are available in templates
helpers do
  #
  # BLOG
  #

  def articles(limit = 5)
    blog.articles[0...limit]
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
      %(<img src="#{ article_image_url(article) }" class="img-rounded img-responsive">)
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
  # GUIDES
  #

  GUIDES_ROOT     = 'source/guides'.freeze
  GUIDES_EDIT_URL = 'https://github.com/hanami/hanami.github.io/edit/build/'.freeze

  def guides_navigation
    result = ''

    Dir.glob("#{ GUIDES_ROOT }/*").each do |section|
      next unless ::File.directory?(section)
      result << guides_section(section)
    end

    result
  end

  def guides_section(section)
    title = section.sub("#{ GUIDES_ROOT }/", '').titleize

    %(<li>
  <span class="heading">#{ title }</span>
  <ul class="nav">
    #{ guides_section_articles(section) }
  </ul>
</li>)
  end

  def guides_section_articles(section)
    result = ''
    Dir.glob("#{ section }/*").each do |article|
      article = article.gsub("#{ section }/", '').gsub(/\.md\z/, '')
      url     = section.sub("#{ GUIDES_ROOT }", '') + article

      result << %(<li class="active"><a href="#{ url }">#{ article.titleize }</a></li>)
    end

    result
  end

  def guides_edit_article(source)
    url = GUIDES_EDIT_URL + source.gsub("#{ Dir.pwd }/", '')
    %(<span class="icon icon-pencil" id="edit-guides-article" title="Edit this article"><a href="#{ url }" target="_blank"></a></span>)
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

    "http://hanami.io#{ url }"
  end

  def encode_text(text)
   ::Rack::Utils.escape(text)
  end

  def hanami_version
    '0.6.0'
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
