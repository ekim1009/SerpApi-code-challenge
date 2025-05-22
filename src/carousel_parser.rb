require 'nokogiri'
require 'base64'

class CarouselParser
  attr_reader :root

  def initialize
    @root = nil
  end

  def parse(html)
    @root = Nokogiri::HTML(html)

    anchors = []
    carousel = @root.at_css('g-scrolling-carousel')
  
    if carousel
      anchors = (carousel.css('a'))
    else
      anchors = @root.css('a').select do |a|
        href = a['href']
        href&.start_with?('/search?sca_esv=') && a.at_css('img')
      end
    end
  
    return [] if anchors.empty?
  
    artworks = anchors.map { |anchor| parse_carousel_item(anchor) }.compact.select { |i| i[:name] }

    { 'artworks' => artworks }
  end
  
  private

  def parse_carousel_item(anchor)
    name = anchor['aria-label']
  
    if name.nil? || name.strip.empty?
      img = anchor.at_css('img')
      name = img['alt'] if img && img['alt'] && !img['alt'].strip.empty?
    end
  
    if name.nil? || name.strip.empty?
      heading = anchor.at_css('[role="heading"]')
      name = heading.text.strip if heading
    end
  
    title = anchor['title']
    href = anchor['href']
    return nil unless href
  
    text = anchor.at_css('.cxzHyb')&.text&.strip
    extensions = text && !text.empty? ? [text] : nil
  
    link = "https://www.google.com#{href}"
  
    {
      name: name,
      extensions: extensions,
      link: link,
      image: get_image(anchor)
    }.compact
  end
  
  def get_image(anchor)
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
end
