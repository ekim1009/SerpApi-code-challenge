require 'spec_helper'
require 'json'
require 'fileutils'
require_relative '../src/parser1'
require_relative '../src/parser2'
require_relative '../main'

RSpec.describe 'Parsers' do
    let(:filename) { 'van-gogh-paintings.html' }
    let(:html_path) { Pathname.new(__dir__).join('../files', filename) }
    let(:expected_json_path) { Pathname.new(__dir__).join('../files/expected-array.json') }
    let(:html_content) { File.read(html_path) }
    let(:artworks) { Parser1.process(html_content)['artworks'] }
    let(:expected_json) { JSON.parse(File.read(expected_json_path)) }
  
    describe 'van_gogh_parser' do
      it 'returns a hash with a videos key' do
        html = File.read('files/van-gogh-paintings.html')
        result = Parser1.process(html)
        expect(result).to be_a(Hash)
        expect(result).to have_key('artworks')
      end
    end

    describe 'Reading HTML file' do
      it 'reads HTML content successfully' do
        expect(html_content).not_to be_nil
        expect(html_content.length).to be > 0
      end
    end
  
    describe 'Parsing HTML content' do
      it 'returns at least one artwork' do
        expect(artworks.length).to be > 0
      end
  
      it 'ensures all artworks have names' do
        artworks.each do |artwork|
          expect(artwork['name']).not_to be_nil
          expect(artwork['name'].length).to be > 0
        end
      end
  
      it 'ensures all artworks have links' do
        artworks.each do |artwork|
          expect(artwork['link']).not_to be_nil
          expect(artwork['link'].length).to be > 0
        end
      end
  
      it 'ensures some artworks have images' do
        expect(artworks.any? { |artwork| artwork['image'] }).to be true
      end
  
      it 'ensures extensions are an array of strings' do
        artworks.each do |artwork|
          if artwork['extensions']
            expect(artwork['extensions']).to be_an(Array)
            artwork['extensions'].each do |ext|
              expect(ext).to be_a(String)
            end
          end
        end
      end
  
      it 'ensures all links are valid Google links' do
        artworks.each do |artwork|
          expect(artwork['link']).to start_with('https://www.google.com')
        end
      end      
  
      it 'ensures all images are valid data URIs or null' do
        artworks.each do |artwork|
          image = artwork['image']
          expect(image.nil? || image.start_with?('data:image')).to be true
        end
      end
    end
  
    describe 'Comparison with Expected JSON' do
      it 'has the same number of artworks' do
        expect(artworks.length).to eq(expected_json['artworks'].length)
      end
  
      it 'matches artwork names with expected' do
        artworks.each_with_index do |artwork, i|
          expect(artwork['name']).to eq(expected_json['artworks'][i]['name'])
        end
      end

      it 'matches first extension with expected when present' do
        artworks.each_with_index do |artwork, i|
          actual_extensions = artwork['extensions']
          expected_extensions = expected_json['artworks'][i]['extensions']
      
          if actual_extensions&.any? && expected_extensions&.any?
            expect(actual_extensions[0]).to eq(expected_extensions[0])
          else
            expect(actual_extensions).to be_nil.or match([a_string_matching(/^$/)])
            expect(expected_extensions).to be_nil.or match([a_string_matching(/^$/)])
          end
        end
      end
    end
  end

  describe 'tie_parser' do
    it 'returns a hash with a videos key' do
      html = File.read('files/how-to-tie-a-tie.html')
      result = Parser2.process(html)
      expect(result).to be_a(Hash)
      expect(result).to have_key('videos')
    end
  end

  describe 'recipe_parser' do
    it 'returns a hash with a videos key' do
      html = File.read('files/pasta-recipes.html')
      result = Parser2.process(html)
      expect(result).to be_a(Hash)
      expect(result).to have_key('videos')
    end
  end
# end

RSpec.describe 'Output File Creation' do
  let(:output_dir) { Pathname.new(__dir__).join('../output') }
  let(:output_file) { output_dir.join('van-gogh-paintings.json') }

  before(:each) do
    FileUtils.mkdir_p(output_dir)
    FileUtils.rm_f(output_file)
  end

  it 'creates the output file when processing' do
    process_html_files
    expect(File.exist?(output_file)).to be true
  end

  it 'output file is not empty' do
    process_html_files
    content = File.read(output_file)
    expect(content.strip.length).to be > 0
  end

  it 'output contains valid JSON' do
    process_html_files
    content = File.read(output_file)
    parsed = JSON.parse(content)
    expect(parsed).to be_a(Hash)
    expect(parsed).to have_key('artworks')
  end
end

