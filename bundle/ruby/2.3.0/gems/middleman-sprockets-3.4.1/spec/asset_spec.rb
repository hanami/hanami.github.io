# encoding: utf-8
RSpec.describe Middleman::Sprockets::Asset do

  def build_subject_asset logical_path, source_dir
    source_path = File.join source_dir, logical_path
    @sprockets_double = instance_double("Middleman::Sprockets::Environment")
    @app_double = double("Middleman::Application",
                         sprockets: @sprockets_double,
                         config: ::Middleman::Util.recursively_enhance(images_dir: 'images'))
    @asset_double = instance_double("Sprockets::BundledAsset",
                                    pathname: Pathname.new(source_path),
                                    logical_path: logical_path)
    allow( @sprockets_double ).to receive(:resolve).with(source_path)
                                                  .and_return("anything")
    allow( @sprockets_double ).to receive(:[]).with("anything")
                                              .and_return(@asset_double)

    return described_class.new @app_double, source_path
  end

  describe "#initialize" do
    it "raises Sprockets::FileNotFound if sprockets can't find the asset" do
      source_path = "/path/to/nowhere.jpg"

      @sprockets_double = instance_double("Middleman::Sprockets::Environment")
      @app_double = double("Middleman::Application",
                           sprockets: @sprockets_double)
      allow( @sprockets_double ).to receive(:resolve).with(source_path)
                                                    .and_return("anything")

      # mimic sprockets unable to find an asset
      allow( @sprockets_double ).to receive(:[]).with("anything")
                                                .and_return(nil)

      expect {
        described_class.new @app_double, source_path
      }.to raise_error Sprockets::FileNotFound
    end
  end

  describe "#type" do

    it 'finds type by extension' do
      image = build_subject_asset 'path/to/image.png', 'source'
      expect( image.type ).to eq :image

      stylesheet = build_subject_asset 'path/to/stylesheet.css', 'source'
      expect( stylesheet.type ).to eq :stylesheet

      script = build_subject_asset 'path/to/script.js', 'source'
      expect( script.type ).to eq :script

      font = build_subject_asset 'path/to/font.ttf', 'source'
      expect( font.type ).to eq :font
    end

    it 'finds type by path' do
      image = build_subject_asset 'path/to/images/image.foo', 'source'
      expect( image.type ).to eq :image
      image = build_subject_asset 'path/to/image.foo', 'images'
      expect( image.type ).to eq :image

      stylesheet = build_subject_asset 'path/to/css/stylesheet.foo', 'source'
      expect( stylesheet.type ).to eq :stylesheet
      image = build_subject_asset 'path/to/stylesheet.foo', 'css'
      expect( image.type ).to eq :stylesheet

      script = build_subject_asset 'path/to/javascripts/script.foo', 'source'
      expect( script.type ).to eq :script
      image = build_subject_asset 'path/to/script.foo', 'javascripts'
      expect( image.type ).to eq :script

      font = build_subject_asset 'path/to/fonts/font.foo', 'source'
      expect( font.type ).to eq :font
      font = build_subject_asset 'path/to/font.foo', 'fonts'
      expect( font.type ).to eq :font
    end

    it 'finds type by double extension' do
      image = build_subject_asset 'path/to/image.svg.erb', 'source'
      expect( image.type ).to eq :image

      stylesheet = build_subject_asset 'path/to/stylesheet.css.scss', 'source'
      expect( stylesheet.type ).to eq :stylesheet

      script = build_subject_asset 'path/to/script.js.coffee', 'source'
      expect( script.type ).to eq :script
    end

    it 'finds type in an unlimited number of extensions' do
      asset = script = build_subject_asset 'path/to/image.asdf.png.asdf.xz', 'source'
      expect( asset.type ).to eq :image
    end
  end

  describe "#source_path" do
    it "returns pathname from sprockets asset" do
      asset = build_subject_asset 'path/to/asset.css', 'source'
      expect( @asset_double ).to receive(:pathname)
                             .and_return("sprockets/pathname")

      expect( asset.source_path ).to eq "sprockets/pathname"
    end
  end

  describe "#destination_path" do
    it "builds path based on asset type" do
      asset = build_subject_asset 'path/to/image.png', 'source'
      expect( asset.destination_path.to_s ).to eq 'images/path/to/image.png'
    end

    it "strips asset type directory from logical path and uses apps asset directory" do
      asset = build_subject_asset 'img/path/to/image.png', 'source'
      expect( asset.destination_path.to_s ).to eq 'images/path/to/image.png'
    end
  end

end
