require 'spec_helper'
require_relative '../src/parser1'
require_relative '../src/parser2'

RSpec.describe 'Parsers' do
  describe 'van_gogh_parser' do
    it 'returns a hash with a videos key' do
      html = File.read('files/van-gogh-paintings.html')
      result = Parser1.process(html)
      expect(result).to be_a(Hash)
      expect(result).to have_key('artworks')
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
end

