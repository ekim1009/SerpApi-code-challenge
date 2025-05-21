require 'nokogiri'
require 'base64'

class CarouselParser
  attr_reader :root, :image_fn_strings

  def initialize
    @root = nil
    @image_fn_strings = []
  end

  def parse(html)
    @root = Nokogiri::HTML(html)

    anchors = []
    carousel = @root.at_css('g-scrolling-carousel')
  
    if carousel
      # anchors = carousel.css('a')
      # images = carousel.css('img')
      anchors = (carousel.css('a'))
      # puts "Found #{anchors.size} <a> tags inside g-scrolling-carousel"
    else
      # puts "No g-scrolling-carousel found, falling back to all <a> tags"
      anchors = @root.css('a').select do |a|
        href = a['href']
        href&.start_with?('/search?sca_esv=') && a.at_css('img') # Also ensure it contains an <img>
      end
      # puts "Found #{anchors.size} <a> tags"
    end
  
    return [] if anchors.empty?
  
    extract_image_scripts
  
    anchors.map { |anchor| parse_carousel_item(anchor) }.compact.select { |i| i[:name] }
  end
  

  private

  def parse_carousel_item(anchor)
    name = anchor['aria-label']

    if name.nil?
      img = anchor.at_css('img')
      name = img['alt'] if img && img['alt']
    end
  
    title = anchor['title']
    href = anchor['href']
    return nil unless href

    text = anchor.at_css('.cxzHyb')&.text
    extensions = [text] if text

    if extensions.nil?
      klmeta_elements = anchor.css('.klmeta')
      extensions = klmeta_elements.map(&:text) unless klmeta_elements.empty?
    end
  
    link = "https://www.google.com#{href}"
  
    {
      name: name,
      extensions: extensions,
      link: link,
      image: extract_image(anchor)
    }.compact
  end
  
  def extract_image(anchor)
    img = anchor.at_css('img')
    unless img
      puts "No <img> found inside anchor"
      return nil
    end
  
    data_src = img['data-src']
    return data_src if data_src && !data_src.empty?
  
    src = img['src']
    return src if src && !src.empty?
  
    puts "No data-src or src found inside <img>"
    nil
  end
  
  
  

#   def extract_image(anchor)

#     img = anchor.at_css('img')
#     puts "No <img> found inside anchor" unless img
#     return nil unless img
# puts img
#     src = img['src']
#     puts "No <src> found inside anchor" unless src
#     return src if src&.start_with?('data:image/jpeg;base64') && src.length > 100

#     img_id = img['id']
#     puts "No <id> found inside anchor" unless img_id
#     return nil unless img_id

#     image_fn_str = @image_fn_strings.find { |str| str.include?("ii=['#{img_id}']") }
#     puts "No <string> found inside anchor" unless image_fn_str
#     return nil unless image_fn_str

#     base64_match = image_fn_str.match(/data:image\/jpeg;base64,(.*?[^';])'/i)
#     base64 = base64_match ? base64_match[0] : nil
#     return nil unless base64

#     base64.gsub(/\\x/, 'x').gsub(/'$/, '')
#   end

  def extract_image_scripts
    scripts = @root.css('script').select { |tag| tag.text.include?('_setImagesSrc') }
    all_script_content = scripts.map(&:text).join
    @image_fn_strings = all_script_content.split('_setImagesSrc(ii,s)')
  end

  def extract_bracketed_text(text)
    match = text.match(/\(([^)]+)\)/)
    match ? match[1] : nil
  end
end

# Example usage:
# parser = GoogleCarouselParser.new
# result = parser.parse(File.read("example.html"))
# puts result
