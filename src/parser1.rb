require 'nokogiri'

# parser for van-gogh-paintings.html
class Parser1
  def self.process(html)
    doc = Nokogiri::HTML(html)
    
    result = { "artworks" => [] }
    carousel = doc.at_css('.wDYxhc')
    return result unless carousel

    carousel.css('a').each do |a|
      href = a['href']
      alt = a.at_css('img')['alt']
      extension = a.at_css('div.cxzHyb')&.text&.strip
      image = a.at_css('img')['src']

      artwork = {
        "name" => alt,
        "link" => "https://www.google.com/#{href}",
        "image" => image
      }

      artwork["extensions"] = [extension] if extension && !extension.empty?

      result["artworks"] << artwork
    end
    result
  end
end