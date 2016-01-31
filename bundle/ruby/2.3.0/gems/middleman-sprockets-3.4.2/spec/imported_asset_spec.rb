# encoding: utf-8
RSpec.describe Middleman::Sprockets::ImportedAsset do

  describe "#initialize" do
    it "sets #logical_path to a pathname based on given path" do
      subject = described_class.new "logical"
      expect( subject.logical_path ).to eq Pathname.new("logical")
    end

    it "sets #output_path to nil if no block given" do
      subject = described_class.new "logical"
      expect( subject.output_path ).to be_nil
    end

    it "sets #output_path based on return of passed block" do
      subject = described_class.new "logical", -> { "hello" }
      expect( subject.output_path ).to eq Pathname.new("hello")
    end

    it "passes #logical_path to the output_path block if it accepts an argument" do
      output_double = proc { |arg| "hello" }
      expect( output_double ).to receive(:call).with(Pathname.new("logical"))

      described_class.new "logical", output_double
    end

    it "passes #logical_path to the output_path block if it accepts an argument and has a default", skip: '1.9' do
      output_double = lambda { |arg=3| "hello" }
      expect( output_double ).to receive(:call).with(Pathname.new("logical"))

      described_class.new "logical", output_double
    end

    it "calls output_path block with no args it it accepts none" do
      output_double = -> { "hello" }
      expect( output_double ).to receive(:call).with no_args()

      described_class.new "logical", output_double
    end
  end

end
