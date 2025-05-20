require 'nokogiri'

class Parser1
  def self.process(html)
    doc = Nokogiri::HTML(html)
    
    result = { "artworks" => [] }
    carousel = doc.at_css('.wDYxhc')
    return result unless carousel

    carousel.css('a').each do |a|
      href = a['href']
      alt = a.at_css('img')['alt']
      extension = a.at_css('div.cxzHyb')&.text
      image = a.at_css('img')['src']
puts a.at_css('img')
      result["artworks"] << {
        "name" => alt,
        "extension" => [extension],
        "link" => "www.google.com/#{href}",
        "image" => image
      }
    end
    result
  end
end